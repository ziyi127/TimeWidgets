import '../logging/enhanced_logger.dart';
import '../logging/log_level.dart';
import 'error_classifier.dart';
import 'error_context.dart';
import 'error_types.dart';

/// 增强的错误处理器
class EnhancedErrorHandler {
  factory EnhancedErrorHandler() => _instance;

  EnhancedErrorHandler._internal();

  static final EnhancedErrorHandler _instance =
      EnhancedErrorHandler._internal();

  final EnhancedLogger _logger = EnhancedLogger();
  final Map<String, EnhancedAppError> _errorHistory = {};
  final Map<String, int> _errorCounts = {};

  /// 处理错误
  EnhancedAppError handleError(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    String? currentScreen,
    String? lastAction,
  }) {
    // 分类错误
    final appError = ErrorClassifier.classify(
      error,
      stackTrace: stackTrace,
      context: context,
    );

    // 收集完整上下文
    final fullContext = ErrorContext.merge([
      if (context != null) context,
      ErrorContext.collectAppState(
        currentScreen: currentScreen,
        lastAction: lastAction,
      ),
      ErrorContext.collectSystemInfo(),
    ]);

    // 更新错误历史
    _errorHistory[appError.code] = appError;
    _errorCounts[appError.code] = (_errorCounts[appError.code] ?? 0) + 1;

    // 评估严重性
    final severity = ErrorClassifier.assessSeverity(appError);

    // 记录日志
    _logError(appError, fullContext, severity);

    return appError;
  }

  /// 处理网络错误
  EnhancedAppError handleNetworkError(
    dynamic error, {
    required String url,
    required String method,
    Map<String, String>? headers,
    int? statusCode,
    String? responseBody,
    StackTrace? stackTrace,
  }) {
    final context = ErrorContext.collectNetworkContext(
      url: url,
      method: method,
      headers: headers,
      statusCode: statusCode,
      responseBody: responseBody,
    );

    return handleError(
      error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 处理存储错误
  EnhancedAppError handleStorageError(
    dynamic error, {
    required String path,
    required String operation,
    int? fileSize,
    bool? fileExists,
    StackTrace? stackTrace,
  }) {
    final context = ErrorContext.collectStorageContext(
      path: path,
      operation: operation,
      fileSize: fileSize,
      fileExists: fileExists,
    );

    return handleError(
      error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 处理验证错误
  EnhancedAppError handleValidationError({
    required String fieldName,
    required dynamic value,
    required String rule,
    String? message,
  }) {
    final context = ErrorContext.collectValidationContext(
      fieldName: fieldName,
      value: value,
      rule: rule,
    );

    final error = EnhancedAppError.validation(
      code: 'VALIDATION_ERROR',
      message: message ?? 'Validation failed for $fieldName',
      userMessage: message ?? '输入验证失败',
      resolution: '请检查输入数据格式',
      context: context,
    );

    _logError(error, context, error.severity);

    return error;
  }

  /// 处理 JSON 解析错误
  EnhancedAppError handleJsonError(
    dynamic error, {
    String? jsonString,
    StackTrace? stackTrace,
  }) {
    final context = <String, dynamic>{
      if (jsonString != null) 'jsonPreview': jsonString.substring(0, 100),
    };

    return handleError(
      error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 记录错误恢复尝试
  void logRecoveryAttempt({
    required EnhancedAppError error,
    required String strategy,
    required bool success,
    String? details,
  }) {
    _logger.info(
      'Error recovery ${success ? "succeeded" : "failed"}: ${error.code}',
      metadata: {
        'errorCode': error.code,
        'errorType': error.type.code,
        'strategy': strategy,
        'success': success,
        'recoveryAttempts': error.recoveryAttempts,
        if (details != null) 'details': details,
      },
    );

    if (!success) {
      // 更新错误的恢复尝试次数
      final updatedError = error.withRecoveryAttempt();
      _errorHistory[error.code] = updatedError;

      // 如果恢复失败次数过多，记录致命错误
      if (updatedError.recoveryAttempts >= 3) {
        _logger.fatal(
          'Error recovery failed after ${updatedError.recoveryAttempts} attempts',
          metadata: {
            'errorCode': error.code,
            'errorType': error.type.code,
          },
        );
      }
    }
  }

  /// 记录错误日志
  void _logError(
    EnhancedAppError error,
    Map<String, dynamic> context,
    ErrorSeverity severity,
  ) {
    final metadata = {
      'errorCode': error.code,
      'errorType': error.type.code,
      'severity': severity.name,
      'recoveryAttempts': error.recoveryAttempts,
      'isRecoverable': error.isRecoverable,
      if (error.originalError != null)
        'originalError': error.originalError.toString(),
    };

    switch (severity) {
      case ErrorSeverity.info:
        _logger.info(
          error.message,
          category: _getLogCategory(error.type),
          metadata: metadata,
          context: context,
        );
        break;
      case ErrorSeverity.warning:
        _logger.warning(
          error.message,
          category: _getLogCategory(error.type),
          metadata: metadata,
          context: context,
        );
        break;
      case ErrorSeverity.error:
        _logger.error(
          error.message,
          category: _getLogCategory(error.type),
          metadata: metadata,
          context: context,
          error: error.originalError,
          stackTrace: error.stackTrace,
        );
        break;
      case ErrorSeverity.fatal:
        _logger.fatal(
          error.message,
          category: _getLogCategory(error.type),
          metadata: metadata,
          context: context,
          error: error.originalError,
          stackTrace: error.stackTrace,
        );
        break;
    }
  }

  /// 获取日志分类
  LogCategory _getLogCategory(ErrorType type) {
    switch (type) {
      case ErrorType.network:
      case ErrorType.timeout:
        return LogCategory.network;
      case ErrorType.storage:
      case ErrorType.permission:
        return LogCategory.storage;
      case ErrorType.validation:
        return LogCategory.validation;
      case ErrorType.parse:
        return LogCategory.parse;
      case ErrorType.state:
        return LogCategory.state;
      case ErrorType.unknown:
        return LogCategory.general;
    }
  }

  /// 获取用户友好的错误信息
  String getUserMessage(EnhancedAppError error) {
    return error.userMessage ?? error.message;
  }

  /// 获取错误解决建议
  String getResolution(EnhancedAppError error) {
    return error.resolution ?? '请重试';
  }

  /// 获取错误历史
  Map<String, EnhancedAppError> getErrorHistory() {
    return Map.unmodifiable(_errorHistory);
  }

  /// 获取错误统计
  Map<String, int> getErrorCounts() {
    return Map.unmodifiable(_errorCounts);
  }

  /// 清除错误历史
  void clearHistory() {
    _errorHistory.clear();
    _errorCounts.clear();
  }
}
