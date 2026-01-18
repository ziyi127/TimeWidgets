import '../logging/enhanced_logger.dart';
import '../logging/log_level.dart';

/// 性能日志记录器
class PerformanceLogger {
  factory PerformanceLogger() => _instance;

  PerformanceLogger._internal();

  static final PerformanceLogger _instance = PerformanceLogger._internal();

  final EnhancedLogger _logger = EnhancedLogger();
  final Map<String, DateTime> _startTimes = {};
  final Map<String, int> _rebuildCounts = {};
  final Map<String, DateTime> _lastRebuildTimes = {};

  /// 记录屏幕加载开始
  void startScreenLoad(String screenName) {
    final operationId = 'screen_load_$screenName';
    _startTimes[operationId] = DateTime.now();

    _logger.debug(
      'Screen load started: $screenName',
      category: LogCategory.performance,
      metadata: {
        'screenName': screenName,
        'operationId': operationId,
      },
    );
  }

  /// 记录屏幕加载完成
  void endScreenLoad(String screenName) {
    final operationId = 'screen_load_$screenName';
    final startTime = _startTimes.remove(operationId);

    if (startTime == null) {
      _logger.warning(
        'Screen load end called without start: $screenName',
        category: LogCategory.performance,
      );
      return;
    }

    final duration = DateTime.now().difference(startTime);

    _logger.info(
      'Screen loaded: $screenName (${duration.inMilliseconds}ms)',
      category: LogCategory.performance,
      metadata: {
        'screenName': screenName,
        'duration': duration.inMilliseconds,
        'operationId': operationId,
      },
    );

    // 如果加载时间过长，记录警告
    if (duration.inMilliseconds > 1000) {
      _logger.warning(
        'Slow screen load detected: $screenName',
        category: LogCategory.performance,
        metadata: {
          'screenName': screenName,
          'duration': duration.inMilliseconds,
          'threshold': 1000,
        },
      );
    }
  }

  /// 记录网络请求性能
  void logNetworkPerformance({
    required String url,
    required String method,
    required Duration duration,
    required int statusCode,
    int? requestSize,
    required int? responseSize,
  }) {
    _logger.info(
      'Network request completed: $method $url (${duration.inMilliseconds}ms)',
      category: LogCategory.performance,
      metadata: {
        'url': url,
        'method': method,
        'duration': duration.inMilliseconds,
        'statusCode': statusCode,
        if (requestSize != null) 'requestSize': requestSize,
        if (responseSize != null) 'responseSize': responseSize,
      },
    );

    if (duration.inMilliseconds > 3000) {
      _logger.warning(
        'Slow network request detected: $method $url',
        category: LogCategory.performance,
        metadata: {
          'url': url,
          'method': method,
          'duration': duration.inMilliseconds,
          'threshold': 3000,
        },
      );
    }
  }

  /// 记录数据库查询性能
  void logDatabaseQuery({
    required String queryType,
    required Duration duration,
    int? resultCount,
    Map<String, dynamic>? parameters,
  }) {
    _logger.info(
      'Database query completed: $queryType (${duration.inMilliseconds}ms)',
      category: LogCategory.performance,
      metadata: {
        'queryType': queryType,
        'duration': duration.inMilliseconds,
        if (resultCount != null) 'resultCount': resultCount,
        if (parameters != null) 'parameters': parameters,
      },
    );

    if (duration.inMilliseconds > 500) {
      _logger.warning(
        'Slow database query detected: $queryType',
        category: LogCategory.performance,
        metadata: {
          'queryType': queryType,
          'duration': duration.inMilliseconds,
          'threshold': 500,
        },
      );
    }
  }

  /// 记录 Widget 重建
  void logWidgetRebuild(String widgetName) {
    final now = DateTime.now();
    final lastRebuild = _lastRebuildTimes[widgetName];

    _rebuildCounts[widgetName] = (_rebuildCounts[widgetName] ?? 0) + 1;
    _lastRebuildTimes[widgetName] = now;

    // 检测过度重建
    if (lastRebuild != null) {
      final timeSinceLastRebuild = now.difference(lastRebuild);

      // 如果在1秒内重建超过10次，记录警告
      if (timeSinceLastRebuild.inSeconds <= 1) {
        final count = _rebuildCounts[widgetName]!;
        if (count > 10) {
          _logger.warning(
            'Excessive widget rebuilds detected: $widgetName',
            category: LogCategory.performance,
            metadata: {
              'widgetName': widgetName,
              'rebuildCount': count,
              'timeWindow': '1 second',
            },
          );

          // 重置计数器
          _rebuildCounts[widgetName] = 0;
        }
      } else {
        // 超过1秒，重置计数器
        _rebuildCounts[widgetName] = 1;
      }
    }
  }

  /// 记录文件操作性能
  void logFileOperation({
    required String operation,
    required String path,
    required Duration duration,
    int? fileSize,
  }) {
    _logger.info(
      'File operation completed: $operation on $path (${duration.inMilliseconds}ms)',
      category: LogCategory.performance,
      metadata: {
        'operation': operation,
        'path': path,
        'duration': duration.inMilliseconds,
        if (fileSize != null) 'fileSize': fileSize,
      },
    );

    if (duration.inMilliseconds > 1000) {
      _logger.warning(
        'Slow file operation detected: $operation',
        category: LogCategory.performance,
        metadata: {
          'operation': operation,
          'path': path,
          'duration': duration.inMilliseconds,
          'threshold': 1000,
        },
      );
    }
  }

  /// 记录内存使用
  void logMemoryUsage({
    required int usedMemoryMB,
    required int totalMemoryMB,
  }) {
    final usagePercent = (usedMemoryMB / totalMemoryMB * 100).toInt();

    _logger.info(
      'Memory usage: ${usedMemoryMB}MB / ${totalMemoryMB}MB ($usagePercent%)',
      category: LogCategory.performance,
      metadata: {
        'usedMemoryMB': usedMemoryMB,
        'totalMemoryMB': totalMemoryMB,
        'usagePercent': usagePercent,
      },
    );

    if (usagePercent > 80) {
      _logger.warning(
        'High memory usage detected',
        category: LogCategory.performance,
        metadata: {
          'usagePercent': usagePercent,
          'threshold': 80,
        },
      );
    }
  }

  /// 开始自定义性能追踪
  void startTrace(String traceId, {Map<String, dynamic>? metadata}) {
    _startTimes[traceId] = DateTime.now();
    _logger.startPerformanceTrace(traceId);

    _logger.debug(
      'Performance trace started: $traceId',
      category: LogCategory.performance,
      metadata: metadata,
    );
  }

  /// 结束自定义性能追踪
  void endTrace(String traceId, {Map<String, dynamic>? metadata}) {
    final startTime = _startTimes.remove(traceId);

    if (startTime == null) {
      _logger.warning(
        'Performance trace end called without start: $traceId',
        category: LogCategory.performance,
      );
      return;
    }

    final duration = DateTime.now().difference(startTime);

    _logger.endPerformanceTrace(
      traceId,
      description: traceId,
      metadata: {
        'duration': duration.inMilliseconds,
        ...?metadata,
      },
    );
  }

  /// 清除性能数据
  void clear() {
    _startTimes.clear();
    _rebuildCounts.clear();
    _lastRebuildTimes.clear();
  }
}
