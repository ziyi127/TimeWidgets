import 'package:flutter/foundation.dart';
import 'logging/enhanced_logger.dart';
import 'logging/log_config.dart';

/// 日志系统初始化工具
class LoggingInit {
  /// 初始化日志系统
  static Future<void> initialize({
    bool isProduction = kReleaseMode,
  }) async {
    final logger = EnhancedLogger();

    LogConfig config;
    if (isProduction) {
      config = LogConfig.production();
    } else if (kDebugMode) {
      config = LogConfig.debug();
    } else {
      config = LogConfig.development();
    }

    await logger.initialize(config);

    logger.info(
      'Logging system initialized',
      metadata: {
        'environment': isProduction ? 'production' : 'development',
        'minLevel': config.minLevel.name,
        'fileOutput': config.enableFileOutput,
        'consoleOutput': config.enableConsoleOutput,
      },
    );
  }

  /// 使用自定义配置初始化
  static Future<void> initializeWithConfig(LogConfig config) async {
    final logger = EnhancedLogger();
    await logger.initialize(config);

    logger.info(
      'Logging system initialized with custom config',
      metadata: {
        'minLevel': config.minLevel.name,
        'fileOutput': config.enableFileOutput,
        'consoleOutput': config.enableConsoleOutput,
      },
    );
  }

  /// 关闭日志系统
  static Future<void> dispose() async {
    final logger = EnhancedLogger();
    await logger.dispose();
  }
}
