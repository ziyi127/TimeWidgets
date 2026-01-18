/// 日志级别枚举
enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warning(2, 'WARNING'),
  error(3, 'ERROR'),
  fatal(4, 'FATAL');

  const LogLevel(this.value, this.name);

  final int value;
  final String name;

  bool operator >=(LogLevel other) => value >= other.value;
  bool operator <=(LogLevel other) => value <= other.value;
  bool operator >(LogLevel other) => value > other.value;
  bool operator <(LogLevel other) => value < other.value;
}

/// 日志分类
enum LogCategory {
  general('GENERAL'),
  network('NETWORK'),
  storage('STORAGE'),
  validation('VALIDATION'),
  parse('PARSE'),
  state('STATE'),
  performance('PERFORMANCE'),
  userAction('USER_ACTION'),
  system('SYSTEM');

  const LogCategory(this.name);

  final String name;
}
