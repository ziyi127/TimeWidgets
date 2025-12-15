import 'dart:io';
import '../utils/logger.dart';

/// 应用错误�?class AppError {
  final String code;
  final String message;
  final String? userMessage;
  final String? resolution;
  final dynamic originalError;

  AppError({
    required this.code,
    required this.message,
    this.userMessage,
    this.resolution,
    this.originalError,
  });

  @override
  String toString() => 'AppError($code): $message';
}

/// 错误处理工具�?class ErrorHandler {
  /// 处理网络错误
  static AppError handleNetworkError(dynamic error) {
    String code = 'NETWORK_ERROR';
    String message = error.toString();
    String userMessage = '网络连接失败';
    String resolution = '请检查网络连接后重试';

    if (error is SocketException) {
      code = 'NO_INTERNET';
      userMessage = '无法连接到网�?;
      resolution = '请检查网络设�?;
    } else if (error.toString().contains('timeout')) {
      code = 'TIMEOUT';
      userMessage = '网络连接超时';
      resolution = '请检查网络连接后重试';
    } else if (error.toString().contains('404')) {
      code = 'NOT_FOUND';
      userMessage = '请求的资源不存在';
      resolution = '请检查请求地址是否正确';
    } else if (error.toString().contains('500')) {
      code = 'SERVER_ERROR';
      userMessage = '服务器内部错�?;
      resolution = '请稍后重�?;
    } else if (error.toString().contains('503')) {
      code = 'SERVICE_UNAVAILABLE';
      userMessage = '服务暂时不可�?;
      resolution = '请稍后重�?;
    }

    return AppError(
      code: code,
      message: message,
      userMessage: userMessage,
      resolution: resolution,
      originalError: error,
    );
  }

  /// 处理存储错误
  static AppError handleStorageError(dynamic error) {
    String code = 'STORAGE_ERROR';
    String message = error.toString();
    String userMessage = '数据存储失败';
    String resolution = '请重�?;

    if (error.toString().contains('permission')) {
      code = 'PERMISSION_DENIED';
      userMessage = '没有文件访问权限';
      resolution = '请授予应用文件访问权�?;
    } else if (error.toString().contains('space') || error.toString().contains('full')) {
      code = 'STORAGE_FULL';
      userMessage = '存储空间不足';
      resolution = '请清理存储空间后重试';
    } else if (error.toString().contains('not found') || error.toString().contains('exist')) {
      code = 'FILE_NOT_FOUND';
      userMessage = '文件不存�?;
      resolution = '请检查文件路径是否正�?;
    }

    return AppError(
      code: code,
      message: message,
      userMessage: userMessage,
      resolution: resolution,
      originalError: error,
    );
  }

  /// 处理验证错误
  static AppError handleValidationError(String message) {
    return AppError(
      code: 'VALIDATION_ERROR',
      message: message,
      userMessage: message,
      resolution: '请检查输入数据格�?,
    );
  }

  /// 处理 JSON 解析错误
  static AppError handleJsonError(dynamic error) {
    return AppError(
      code: 'JSON_ERROR',
      message: error.toString(),
      userMessage: '文件格式无效',
      resolution: '请确保文件是有效�?JSON 格式',
      originalError: error,
    );
  }

  /// 处理未知错误
  static AppError handleUnknownError(dynamic error) {
    return AppError(
      code: 'UNKNOWN_ERROR',
      message: error.toString(),
      userMessage: '发生未知错误',
      resolution: '请重试或联系支持',
      originalError: error,
    );
  }

  /// 记录错误日志
  static void logError(AppError error) {
    Logger.e('${error.code}: ${error.message}', error.originalError);
  }

  /// 获取用户友好的错误信�?  static String getUserMessage(AppError error) {
    return error.userMessage ?? error.message;
  }

  /// 获取错误解决建议
  static String getResolution(AppError error) {
    return error.resolution ?? '请重�?;
  }
}
