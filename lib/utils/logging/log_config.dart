import 'log_level.dart';

/// 日志配置
class LogConfig {
  LogConfig({
    this.minLevel = LogLevel.debug,
    this.enableConsoleOutput = true,
    this.enableFileOutput = true,
    this.enableStructuredFormat = true,
    this.maxFileSizeBytes = 10 * 1024 * 1024, // 10 MB
    this.maxFileAgeDays = 7,
    this.logDirectory = 'logs',
    this.enableSensitiveDataFiltering = true,
    this.enablePerformanceLogging = true,
    this.bufferSize = 100,
  });

  /// 最小日志级别
  final LogLevel minLevel;

  /// 是否启用控制台输出
  final bool enableConsoleOutput;

  /// 是否启用文件输出
  final bool enableFileOutput;

  /// 是否使用结构化格式（JSON）
  final bool enableStructuredFormat;

  /// 最大文件大小（字节）
  final int maxFileSizeBytes;

  /// 日志文件最大保留天数
  final int maxFileAgeDays;

  /// 日志目录
  final String logDirectory;

  /// 是否启用敏感数据过滤
  final bool enableSensitiveDataFiltering;

  /// 是否启用性能日志
  final bool enablePerformanceLogging;

  /// 缓冲区大小
  final int bufferSize;

  /// 生产环境配置
  static LogConfig production() {
    return LogConfig(
      minLevel: LogLevel.info,
      enableConsoleOutput: false,
    );
  }

  /// 开发环境配置
  static LogConfig development() {
    return LogConfig(
      enableStructuredFormat: false,
    );
  }

  /// 调试环境配置
  static LogConfig debug() {
    return LogConfig(
      enableStructuredFormat: false,
    );
  }

  LogConfig copyWith({
    LogLevel? minLevel,
    bool? enableConsoleOutput,
    bool? enableFileOutput,
    bool? enableStructuredFormat,
    int? maxFileSizeBytes,
    int? maxFileAgeDays,
    String? logDirectory,
    bool? enableSensitiveDataFiltering,
    bool? enablePerformanceLogging,
    int? bufferSize,
  }) {
    return LogConfig(
      minLevel: minLevel ?? this.minLevel,
      enableConsoleOutput: enableConsoleOutput ?? this.enableConsoleOutput,
      enableFileOutput: enableFileOutput ?? this.enableFileOutput,
      enableStructuredFormat:
          enableStructuredFormat ?? this.enableStructuredFormat,
      maxFileSizeBytes: maxFileSizeBytes ?? this.maxFileSizeBytes,
      maxFileAgeDays: maxFileAgeDays ?? this.maxFileAgeDays,
      logDirectory: logDirectory ?? this.logDirectory,
      enableSensitiveDataFiltering:
          enableSensitiveDataFiltering ?? this.enableSensitiveDataFiltering,
      enablePerformanceLogging:
          enablePerformanceLogging ?? this.enablePerformanceLogging,
      bufferSize: bufferSize ?? this.bufferSize,
    );
  }
}
