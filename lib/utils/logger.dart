import 'logging/enhanced_logger.dart';

/// Simple logger utility class (向后兼容包装器)
///
/// 此类保持原有 API 不变，内部委托给增强的日志系统
class Logger {
  static const int levelDebug = 0;
  static const int levelInfo = 1;
  static const int levelWarning = 2;
  static const int levelError = 3;

  /// Current log level
  static int logLevel = levelDebug;

  static final EnhancedLogger _enhancedLogger = EnhancedLogger();

  /// Debug log
  static void d(String message) {
    if (logLevel <= levelDebug) {
      _enhancedLogger.debug(message);
    }
  }

  /// Info log
  static void i(String message) {
    if (logLevel <= levelInfo) {
      _enhancedLogger.info(message);
    }
  }

  /// Warning log
  static void w(String message) {
    if (logLevel <= levelWarning) {
      _enhancedLogger.warning(message);
    }
  }

  /// Error log with stack trace support
  static void e(String message, [dynamic err, StackTrace? stackTrace]) {
    if (logLevel <= levelError) {
      _enhancedLogger.error(
        message,
        error: err,
        stackTrace: stackTrace,
      );
    }
  }
}
