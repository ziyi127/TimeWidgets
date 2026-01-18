import 'dart:async';

import 'log_config.dart';
import 'log_entry.dart';
import 'log_level.dart';
import 'log_manager.dart';
import 'sensitive_data_filter.dart';

/// 增强的日志记录器
class EnhancedLogger {
  factory EnhancedLogger() => _instance;

  EnhancedLogger._internal();

  static final EnhancedLogger _instance = EnhancedLogger._internal();

  LogConfig _config = LogConfig.development();
  LogManager? _logManager;
  final Map<String, DateTime> _operationStartTimes = {};

  /// 初始化日志系统
  Future<void> initialize(LogConfig config) async {
    _config = config;
    if (config.enableFileOutput) {
      _logManager = LogManager(config);
    }
  }

  /// 更新配置
  Future<void> updateConfig(LogConfig config) async {
    await _logManager?.dispose();
    await initialize(config);
  }

  /// 记录调试日志
  void debug(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.debug,
      category: category,
      message: message,
      metadata: metadata,
      context: context,
    );
  }

  /// 记录信息日志
  void info(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.info,
      category: category,
      message: message,
      metadata: metadata,
      context: context,
    );
  }

  /// 记录警告日志
  void warning(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.warning,
      category: category,
      message: message,
      metadata: metadata,
      context: context,
    );
  }

  /// 记录错误日志
  void error(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final enhancedMetadata = <String, dynamic>{
      ...?metadata,
      if (error != null) 'error': error.toString(),
    };

    _log(
      level: LogLevel.error,
      category: category,
      message: message,
      metadata: enhancedMetadata,
      context: context,
      stackTrace: stackTrace?.toString(),
    );
  }

  /// 记录致命错误日志
  void fatal(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final enhancedMetadata = <String, dynamic>{
      ...?metadata,
      if (error != null) 'error': error.toString(),
    };

    _log(
      level: LogLevel.fatal,
      category: category,
      message: message,
      metadata: enhancedMetadata,
      context: context,
      stackTrace: stackTrace?.toString(),
    );
  }

  /// 记录网络请求
  void logNetworkRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? context,
  }) {
    final filteredUrl = _config.enableSensitiveDataFiltering
        ? SensitiveDataFilter.filterUrl(url)
        : url;

    final filteredHeaders = _config.enableSensitiveDataFiltering && headers != null
        ? SensitiveDataFilter.filterMap(headers.cast<String, dynamic>())
        : headers;

    _log(
      level: LogLevel.info,
      category: LogCategory.network,
      message: 'Network request: $method $filteredUrl',
      metadata: {
        'url': filteredUrl,
        'method': method,
        if (filteredHeaders != null) 'headers': filteredHeaders,
        if (body != null) 'body': body.toString(),
      },
      context: context,
    );
  }

  /// 记录网络响应
  void logNetworkResponse({
    required String url,
    required String method,
    required int statusCode,
    dynamic body,
    required Duration duration,
    Map<String, dynamic>? context,
  }) {
    final filteredUrl = _config.enableSensitiveDataFiltering
        ? SensitiveDataFilter.filterUrl(url)
        : url;

    _log(
      level: statusCode >= 400 ? LogLevel.error : LogLevel.info,
      category: LogCategory.network,
      message: 'Network response: $method $filteredUrl - $statusCode (${duration.inMilliseconds}ms)',
      metadata: {
        'url': filteredUrl,
        'method': method,
        'statusCode': statusCode,
        'duration': duration.inMilliseconds,
        if (body != null) 'body': body.toString(),
      },
      context: context,
    );
  }

  /// 记录存储操作
  void logStorageOperation({
    required String operation,
    required String path,
    int? dataSize,
    bool? success,
    String? error,
    Map<String, dynamic>? context,
  }) {
    final filteredPath = _config.enableSensitiveDataFiltering
        ? SensitiveDataFilter.filterFilePath(path)
        : path;

    _log(
      level: success == false ? LogLevel.error : LogLevel.info,
      category: LogCategory.storage,
      message: 'Storage operation: $operation on $filteredPath',
      metadata: {
        'operation': operation,
        'path': filteredPath,
        if (dataSize != null) 'dataSize': dataSize,
        if (success != null) 'success': success,
        if (error != null) 'error': error,
      },
      context: context,
    );
  }

  /// 记录用户操作
  void logUserAction({
    required String action,
    String? target,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? context,
  }) {
    _log(
      level: LogLevel.info,
      category: LogCategory.userAction,
      message: 'User action: $action${target != null ? " on $target" : ""}',
      metadata: {
        'action': action,
        if (target != null) 'target': target,
        if (parameters != null) 'parameters': parameters,
      },
      context: context,
    );
  }

  /// 开始性能追踪
  void startPerformanceTrace(String operationId) {
    if (!_config.enablePerformanceLogging) return;
    _operationStartTimes[operationId] = DateTime.now();
  }

  /// 结束性能追踪
  void endPerformanceTrace(
    String operationId, {
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    if (!_config.enablePerformanceLogging) return;

    final startTime = _operationStartTimes.remove(operationId);
    if (startTime == null) return;

    final duration = DateTime.now().difference(startTime);

    _log(
      level: LogLevel.info,
      category: LogCategory.performance,
      message: 'Performance: ${description ?? operationId} completed in ${duration.inMilliseconds}ms',
      metadata: {
        'operationId': operationId,
        'duration': duration.inMilliseconds,
        ...?metadata,
      },
      operationId: operationId,
    );
  }

  /// 记录异步操作开始
  void logAsyncOperationStart(
    String operationId,
    String operationType, {
    Map<String, dynamic>? metadata,
  }) {
    _log(
      level: LogLevel.debug,
      category: LogCategory.general,
      message: 'Async operation started: $operationType',
      metadata: {
        'operationType': operationType,
        ...?metadata,
      },
      operationId: operationId,
    );
  }

  /// 记录异步操作完成
  void logAsyncOperationComplete(
    String operationId,
    String operationType, {
    bool success = true,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      level: success ? LogLevel.debug : LogLevel.error,
      category: LogCategory.general,
      message: 'Async operation ${success ? "completed" : "failed"}: $operationType',
      metadata: {
        'operationType': operationType,
        'success': success,
        if (error != null) 'error': error,
        ...?metadata,
      },
      operationId: operationId,
    );
  }

  /// 内部日志方法
  void _log({
    required LogLevel level,
    required LogCategory category,
    required String message,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? context,
    String? stackTrace,
    String? operationId,
  }) {
    if (level < _config.minLevel) return;

    // 过滤敏感数据
    final filteredMetadata = _config.enableSensitiveDataFiltering && metadata != null
        ? SensitiveDataFilter.filterMap(metadata)
        : metadata;

    final filteredContext = _config.enableSensitiveDataFiltering && context != null
        ? SensitiveDataFilter.filterMap(context)
        : context;

    final filteredMessage = _config.enableSensitiveDataFiltering
        ? SensitiveDataFilter.filterString(message)
        : message;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: filteredMessage,
      metadata: filteredMetadata,
      context: filteredContext,
      stackTrace: stackTrace,
      operationId: operationId,
    );

    // 控制台输出
    if (_config.enableConsoleOutput) {
      _printToConsole(entry);
    }

    // 文件输出
    if (_config.enableFileOutput && _logManager != null) {
      _logManager!.writeLog(entry);
    }
  }

  /// 打印到控制台
  void _printToConsole(LogEntry entry) {
    // ignore: avoid_print
    print(entry.toFormattedString());
  }

  /// 查询日志
  Future<List<LogEntry>> queryLogs({
    DateTime? startTime,
    DateTime? endTime,
    LogLevel? minLevel,
    LogCategory? category,
    String? searchText,
    int? limit,
  }) async {
    if (_logManager == null) return [];

    return _logManager!.queryLogs(
      startTime: startTime,
      endTime: endTime,
      minLevel: minLevel,
      category: category,
      searchText: searchText,
      limit: limit,
    );
  }

  /// 获取最近的日志
  Future<List<LogEntry>> getRecentLogs(int count) async {
    if (_logManager == null) return [];
    return _logManager!.getRecentLogs(count);
  }

  /// 刷新日志
  Future<void> flush() async {
    await _logManager?.flush();
  }

  /// 清理资源
  Future<void> dispose() async {
    await _logManager?.dispose();
  }
}
