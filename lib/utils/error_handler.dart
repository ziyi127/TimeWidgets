import '../utils/logger.dart';
import 'error_handling/enhanced_error_handler.dart';
import 'error_handling/error_types.dart';

/// 应用错误类 (向后兼容包装器)
class AppError {
  AppError({
    required this.code,
    required this.message,
    this.userMessage,
    this.resolution,
    this.originalError,
  });

  /// 从增强错误创建
  factory AppError.fromEnhanced(EnhancedAppError enhanced) {
    return AppError(
      code: enhanced.code,
      message: enhanced.message,
      userMessage: enhanced.userMessage,
      resolution: enhanced.resolution,
      originalError: enhanced.originalError,
    );
  }

  final String code;
  final String message;
  final String? userMessage;
  final String? resolution;
  final dynamic originalError;

  @override
  String toString() => 'AppError($code): $message';
}

/// 错误处理工具类 (向后兼容包装器)
///
/// 此类保持原有 API 不变，内部委托给增强的错误处理系统
class ErrorHandler {
  static final EnhancedErrorHandler _enhancedHandler = EnhancedErrorHandler();

  /// 处理网络错误
  static AppError handleNetworkError(dynamic error) {
    final enhanced = _enhancedHandler.handleError(error);
    return AppError.fromEnhanced(enhanced);
  }

  /// 处理存储错误
  static AppError handleStorageError(dynamic error) {
    final enhanced = _enhancedHandler.handleError(error);
    return AppError.fromEnhanced(enhanced);
  }

  /// 处理验证错误
  static AppError handleValidationError(String message) {
    final enhanced = _enhancedHandler.handleValidationError(
      fieldName: 'unknown',
      value: null,
      rule: 'unknown',
      message: message,
    );
    return AppError.fromEnhanced(enhanced);
  }

  /// 处理 JSON 解析错误
  static AppError handleJsonError(dynamic error) {
    final enhanced = _enhancedHandler.handleJsonError(error);
    return AppError.fromEnhanced(enhanced);
  }

  /// 处理未知错误
  static AppError handleUnknownError(dynamic error) {
    final enhanced = _enhancedHandler.handleError(error);
    return AppError.fromEnhanced(enhanced);
  }

  /// 记录错误日志
  static void logError(AppError error) {
    Logger.e('${error.code}: ${error.message}', error.originalError);
  }

  /// 获取用户友好的错误信息
  static String getUserMessage(AppError error) {
    return error.userMessage ?? error.message;
  }

  /// 获取错误解决建议
  static String getResolution(AppError error) {
    return error.resolution ?? '请重试';
  }
}
