import 'dart:io';
import 'error_types.dart';

/// 错误分类器
class ErrorClassifier {
  /// 分类错误
  static EnhancedAppError classify(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (error is EnhancedAppError) {
      return error;
    }

    // 网络错误
    if (_isNetworkError(error)) {
      return _classifyNetworkError(error, stackTrace, context);
    }

    // 存储错误
    if (_isStorageError(error)) {
      return _classifyStorageError(error, stackTrace, context);
    }

    // 格式错误
    if (_isFormatError(error)) {
      return _classifyFormatError(error, stackTrace, context);
    }

    // 状态错误
    if (_isStateError(error)) {
      return _classifyStateError(error, stackTrace, context);
    }

    // 未知错误
    return _classifyUnknownError(error, stackTrace, context);
  }

  /// 判断是否为网络错误
  static bool _isNetworkError(dynamic error) {
    if (error is SocketException) return true;
    if (error is HttpException) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout') ||
        errorStr.contains('socket') ||
        errorStr.contains('http');
  }

  /// 判断是否为存储错误
  static bool _isStorageError(dynamic error) {
    if (error is FileSystemException) return true;
    if (error is PathNotFoundException) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('file') ||
        errorStr.contains('directory') ||
        errorStr.contains('storage') ||
        errorStr.contains('permission') ||
        errorStr.contains('access denied');
  }

  /// 判断是否为格式错误
  static bool _isFormatError(dynamic error) {
    if (error is FormatException) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('format') ||
        errorStr.contains('parse') ||
        errorStr.contains('json') ||
        errorStr.contains('invalid');
  }

  /// 判断是否为状态错误
  static bool _isStateError(dynamic error) {
    if (error is StateError) return true;
    
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('state') ||
        errorStr.contains('disposed') ||
        errorStr.contains('mounted');
  }

  /// 分类网络错误
  static EnhancedAppError _classifyNetworkError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    String code = 'NETWORK_ERROR';
    String userMessage = '网络连接失败';
    String resolution = '请检查网络连接后重试';
    ErrorSeverity severity = ErrorSeverity.error;

    if (error is SocketException) {
      code = 'NO_INTERNET';
      userMessage = '无法连接到网络';
      resolution = '请检查网络设置';
    } else {
      final errorStr = error.toString().toLowerCase();
      
      if (errorStr.contains('timeout')) {
        code = 'TIMEOUT';
        userMessage = '网络连接超时';
        resolution = '请检查网络连接后重试';
      } else if (errorStr.contains('404')) {
        code = 'NOT_FOUND';
        userMessage = '请求的资源不存在';
        resolution = '请检查请求地址是否正确';
        severity = ErrorSeverity.warning;
      } else if (errorStr.contains('500')) {
        code = 'SERVER_ERROR';
        userMessage = '服务器内部错误';
        resolution = '请稍后重试';
      } else if (errorStr.contains('503')) {
        code = 'SERVICE_UNAVAILABLE';
        userMessage = '服务暂时不可用';
        resolution = '请稍后重试';
      }
    }

    return EnhancedAppError.network(
      code: code,
      message: error.toString(),
      userMessage: userMessage,
      resolution: resolution,
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 分类存储错误
  static EnhancedAppError _classifyStorageError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    String code = 'STORAGE_ERROR';
    String userMessage = '数据存储失败';
    String resolution = '请重试';
    ErrorSeverity severity = ErrorSeverity.error;

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('permission') || errorStr.contains('access denied')) {
      code = 'PERMISSION_DENIED';
      userMessage = '没有文件访问权限';
      resolution = '请授予应用文件访问权限';
    } else if (errorStr.contains('space') || errorStr.contains('full')) {
      code = 'STORAGE_FULL';
      userMessage = '存储空间不足';
      resolution = '请清理存储空间后重试';
    } else if (errorStr.contains('not found') || errorStr.contains('exist')) {
      code = 'FILE_NOT_FOUND';
      userMessage = '文件不存在';
      resolution = '请检查文件路径是否正确';
      severity = ErrorSeverity.warning;
    }

    return EnhancedAppError.storage(
      code: code,
      message: error.toString(),
      userMessage: userMessage,
      resolution: resolution,
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 分类格式错误
  static EnhancedAppError _classifyFormatError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    String code = 'PARSE_ERROR';
    String userMessage = '数据格式错误';
    String resolution = '请检查数据格式';

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('json')) {
      code = 'JSON_ERROR';
      userMessage = 'JSON 格式无效';
      resolution = '请确保文件是有效的 JSON 格式';
    }

    return EnhancedAppError.parse(
      code: code,
      message: error.toString(),
      userMessage: userMessage,
      resolution: resolution,
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 分类状态错误
  static EnhancedAppError _classifyStateError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    return EnhancedAppError(
      type: ErrorType.state,
      code: 'STATE_ERROR',
      message: error.toString(),
      severity: ErrorSeverity.warning,
      userMessage: '应用状态异常',
      resolution: '请重启应用',
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 分类未知错误
  static EnhancedAppError _classifyUnknownError(
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ) {
    return EnhancedAppError(
      type: ErrorType.unknown,
      code: 'UNKNOWN_ERROR',
      message: error.toString(),
      userMessage: '发生未知错误',
      resolution: '请重试或联系支持',
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 评估错误严重性
  static ErrorSeverity assessSeverity(EnhancedAppError error) {
    // 如果已经是致命错误，保持不变
    if (error.severity == ErrorSeverity.fatal) {
      return ErrorSeverity.fatal;
    }

    // 根据恢复尝试次数提升严重性
    if (error.recoveryAttempts >= 3) {
      return ErrorSeverity.fatal;
    } else if (error.recoveryAttempts >= 2) {
      return ErrorSeverity.error;
    }

    // 某些类型的错误默认更严重
    if (error.type == ErrorType.permission || 
        error.type == ErrorType.storage && error.code == 'STORAGE_FULL') {
      return ErrorSeverity.fatal;
    }

    return error.severity;
  }
}
