/// Simple logger utility class
class Logger {
  static const int levelDebug = 0;
  static const int levelInfo = 1;
  static const int levelWarning = 2;
  static const int levelError = 3;

  /// Current log level
  static int logLevel = levelDebug;

  /// Debug log
  static void d(String message) {
    if (logLevel <= levelDebug) {
      _log('DEBUG', message);
    }
  }

  /// Info log
  static void i(String message) {
    if (logLevel <= levelInfo) {
      _log('INFO', message);
    }
  }

  /// Warning log
  static void w(String message) {
    if (logLevel <= levelWarning) {
      _log('WARNING', message);
    }
  }

  /// Error log
  static void e(String message, [dynamic err]) {
    if (logLevel <= levelError) {
      _log('ERROR', message);
      if (err != null) {
        _log('ERROR', err.toString());
      }
    }
  }

  /// Internal log method
  static void _log(String level, String message) {
    // ignore: avoid_print
    print('[$level] ${DateTime.now().toIso8601String()}: $message');
  }
}
