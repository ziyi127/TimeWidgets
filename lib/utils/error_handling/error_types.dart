import '../logging/log_level.dart';

/// 错误类型枚举
enum ErrorType {
  network('NETWORK', LogLevel.error),
  storage('STORAGE', LogLevel.error),
  validation('VALIDATION', LogLevel.warning),
  parse('PARSE', LogLevel.error),
  state('STATE', LogLevel.warning),
  permission('PERMISSION', LogLevel.error),
  timeout('TIMEOUT', LogLevel.error),
  unknown('UNKNOWN', LogLevel.error);

  const ErrorType(this.code, this.defaultLevel);

  final String code;
  final LogLevel defaultLevel;
}

/// 错误严重级别
enum ErrorSeverity {
  info('INFO', LogLevel.info),
  warning('WARNING', LogLevel.warning),
  error('ERROR', LogLevel.error),
  fatal('FATAL', LogLevel.fatal);

  const ErrorSeverity(this.name, this.logLevel);

  final String name;
  final LogLevel logLevel;
}

/// 增强的应用错误类
class EnhancedAppError {
  EnhancedAppError({
    required this.type,
    required this.code,
    required this.message,
    this.severity = ErrorSeverity.error,
    this.userMessage,
    this.resolution,
    this.originalError,
    this.stackTrace,
    this.context,
    DateTime? timestamp,
    this.recoveryAttempts = 0,
    this.isRecoverable = true,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 创建网络错误
  factory EnhancedAppError.network({
    required String code,
    required String message,
    String? userMessage,
    String? resolution,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return EnhancedAppError(
      type: ErrorType.network,
      code: code,
      message: message,
      userMessage: userMessage,
      resolution: resolution,
      originalError: originalError,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 创建存储错误
  factory EnhancedAppError.storage({
    required String code,
    required String message,
    String? userMessage,
    String? resolution,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return EnhancedAppError(
      type: ErrorType.storage,
      code: code,
      message: message,
      userMessage: userMessage,
      resolution: resolution,
      originalError: originalError,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// 创建验证错误
  factory EnhancedAppError.validation({
    required String code,
    required String message,
    String? userMessage,
    String? resolution,
    Map<String, dynamic>? context,
  }) {
    return EnhancedAppError(
      type: ErrorType.validation,
      code: code,
      message: message,
      severity: ErrorSeverity.warning,
      userMessage: userMessage,
      resolution: resolution,
      context: context,
    );
  }

  /// 创建解析错误
  factory EnhancedAppError.parse({
    required String code,
    required String message,
    String? userMessage,
    String? resolution,
    dynamic originalError,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return EnhancedAppError(
      type: ErrorType.parse,
      code: code,
      message: message,
      userMessage: userMessage,
      resolution: resolution,
      originalError: originalError,
      stackTrace: stackTrace,
      context: context,
    );
  }

  final ErrorType type;
  final String code;
  final String message;
  final ErrorSeverity severity;
  final String? userMessage;
  final String? resolution;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;
  final DateTime timestamp;
  final int recoveryAttempts;
  final bool isRecoverable;

  /// 复制并增加恢复尝试次数
  EnhancedAppError withRecoveryAttempt() {
    return EnhancedAppError(
      type: type,
      code: code,
      message: message,
      severity: severity,
      userMessage: userMessage,
      resolution: resolution,
      originalError: originalError,
      stackTrace: stackTrace,
      context: context,
      timestamp: timestamp,
      recoveryAttempts: recoveryAttempts + 1,
      isRecoverable: isRecoverable,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toJson() {
    return {
      'type': type.code,
      'code': code,
      'message': message,
      'severity': severity.name,
      if (userMessage != null) 'userMessage': userMessage,
      if (resolution != null) 'resolution': resolution,
      if (originalError != null) 'originalError': originalError.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      if (context != null) 'context': context,
      'timestamp': timestamp.toIso8601String(),
      'recoveryAttempts': recoveryAttempts,
      'isRecoverable': isRecoverable,
    };
  }

  @override
  String toString() {
    return 'EnhancedAppError(${type.code}:$code): $message';
  }
}
