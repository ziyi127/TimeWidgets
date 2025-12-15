/// 日志工具类
class Logger {
  /// 日志级别
  static const int debug = 0;
  static const int info = 1;
  static const int warning = 2;
  static const int error = 3;

  /// 当前日志级别
  static int logLevel = debug;

  /// 调试日志
  static void d(String message) {
    if (logLevel <= debug) {
      _log('DEBUG', message);
    }
  }

  /// 信息日志
  static void i(String message) {
    if (logLevel <= info) {
      _log('INFO', message);
    }
  }

  /// 警告日志
  static void w(String message) {
    if (logLevel <= warning) {
      _log('WARNING', message);
    }
  }

  /// 错误日志
  static void e(String message, [dynamic error]) {
    if (logLevel <= error) {
      _log('ERROR', message);
      if (error != null) {
        _log('ERROR', error.toString());
      }
    }
  }

  /// 日志格式化
  static void _log(String level, String message) {
    print('[$level] ${DateTime.now().toIso8601String()}: $message');
  }
}
