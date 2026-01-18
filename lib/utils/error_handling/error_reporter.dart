import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../logging/enhanced_logger.dart';
import '../logging/sensitive_data_filter.dart';
import 'error_context.dart';
import 'error_types.dart';

/// 错误报告模型
class ErrorReport {
  ErrorReport({
    required this.reportId,
    required this.timestamp,
    required this.appVersion,
    required this.error,
    required this.systemInfo,
    required this.recentLogs,
    this.additionalInfo,
  });

  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      reportId: json['reportId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      appVersion: json['appVersion'] as String,
      error: json['error'] as Map<String, dynamic>,
      systemInfo: json['systemInfo'] as Map<String, dynamic>,
      recentLogs: (json['recentLogs'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  final String reportId;
  final DateTime timestamp;
  final String appVersion;
  final Map<String, dynamic> error;
  final Map<String, dynamic> systemInfo;
  final List<Map<String, dynamic>> recentLogs;
  final Map<String, dynamic>? additionalInfo;

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'timestamp': timestamp.toIso8601String(),
      'appVersion': appVersion,
      'error': error,
      'systemInfo': systemInfo,
      'recentLogs': recentLogs,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
    };
  }

  String toJsonString({bool pretty = false}) {
    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(toJson());
    }
    return jsonEncode(toJson());
  }

  String toTextReport() {
    final buffer = StringBuffer();

    buffer.writeln('=' * 80);
    buffer.writeln('ERROR REPORT');
    buffer.writeln('=' * 80);
    buffer.writeln();

    buffer.writeln('Report ID: $reportId');
    buffer.writeln('Timestamp: ${timestamp.toIso8601String()}');
    buffer.writeln('App Version: $appVersion');
    buffer.writeln();

    buffer.writeln('-' * 80);
    buffer.writeln('ERROR DETAILS');
    buffer.writeln('-' * 80);
    error.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln();

    buffer.writeln('-' * 80);
    buffer.writeln('SYSTEM INFORMATION');
    buffer.writeln('-' * 80);
    systemInfo.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln();

    if (additionalInfo != null && additionalInfo!.isNotEmpty) {
      buffer.writeln('-' * 80);
      buffer.writeln('ADDITIONAL INFORMATION');
      buffer.writeln('-' * 80);
      additionalInfo!.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
      buffer.writeln();
    }

    buffer.writeln('-' * 80);
    buffer.writeln('RECENT LOGS (${recentLogs.length} entries)');
    buffer.writeln('-' * 80);
    for (final log in recentLogs) {
      buffer
          .writeln('[${log['level']}] ${log['timestamp']} - ${log['message']}');
      if (log['metadata'] != null) {
        buffer.writeln('  Metadata: ${log['metadata']}');
      }
    }
    buffer.writeln();

    buffer.writeln('=' * 80);
    buffer.writeln('END OF REPORT');
    buffer.writeln('=' * 80);

    return buffer.toString();
  }
}

/// 错误报告生成器
class ErrorReporter {
  ErrorReporter({
    required this.appVersion,
    this.reportsDirectory = 'error_reports',
  });

  final String appVersion;
  final String reportsDirectory;
  final EnhancedLogger _logger = EnhancedLogger();

  /// 生成错误报告
  Future<ErrorReport> generateReport({
    required EnhancedAppError error,
    Map<String, dynamic>? additionalInfo,
    int recentLogsCount = 50,
  }) async {
    final reportId = _generateReportId();

    // 收集系统信息
    final systemInfo = ErrorContext.collectSystemInfo();

    // 获取最近的日志
    final recentLogs = await _getRecentLogs(recentLogsCount);

    // 过滤敏感数据
    final filteredError = SensitiveDataFilter.filterMap(error.toJson());
    final filteredSystemInfo = SensitiveDataFilter.filterMap(systemInfo);
    final filteredAdditionalInfo = additionalInfo != null
        ? SensitiveDataFilter.filterMap(additionalInfo)
        : null;

    return ErrorReport(
      reportId: reportId,
      timestamp: DateTime.now(),
      appVersion: appVersion,
      error: filteredError,
      systemInfo: filteredSystemInfo,
      recentLogs: recentLogs,
      additionalInfo: filteredAdditionalInfo,
    );
  }

  /// 导出报告为 JSON 文件
  Future<File> exportAsJson(ErrorReport report, {bool pretty = true}) async {
    await _ensureReportsDirectory();

    final fileName = 'error_report_${report.reportId}.json';
    final filePath = path.join(reportsDirectory, fileName);
    final file = File(filePath);

    await file.writeAsString(report.toJsonString(pretty: pretty));

    _logger.info(
      'Error report exported as JSON',
      metadata: {
        'reportId': report.reportId,
        'filePath': filePath,
      },
    );

    return file;
  }

  /// 导出报告为文本文件
  Future<File> exportAsText(ErrorReport report) async {
    await _ensureReportsDirectory();

    final fileName = 'error_report_${report.reportId}.txt';
    final filePath = path.join(reportsDirectory, fileName);
    final file = File(filePath);

    await file.writeAsString(report.toTextReport());

    _logger.info(
      'Error report exported as text',
      metadata: {
        'reportId': report.reportId,
        'filePath': filePath,
      },
    );

    return file;
  }

  /// 生成并导出报告
  Future<File> generateAndExport({
    required EnhancedAppError error,
    Map<String, dynamic>? additionalInfo,
    bool asJson = true,
    bool pretty = true,
  }) async {
    final report = await generateReport(
      error: error,
      additionalInfo: additionalInfo,
    );

    if (asJson) {
      return exportAsJson(report, pretty: pretty);
    } else {
      return exportAsText(report);
    }
  }

  /// 获取最近的日志
  Future<List<Map<String, dynamic>>> _getRecentLogs(int count) async {
    try {
      final logs = await _logger.getRecentLogs(count);
      return logs.map((log) => log.toJson()).toList();
    } catch (e) {
      return [];
    }
  }

  /// 确保报告目录存在
  Future<void> _ensureReportsDirectory() async {
    final dir = Directory(reportsDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// 生成报告 ID
  String _generateReportId() {
    final now = DateTime.now();
    return '${now.year}${_pad(now.month)}${_pad(now.day)}_'
        '${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}_'
        '${now.millisecond}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

  /// 列出所有错误报告
  Future<List<File>> listReports() async {
    final reports = <File>[];

    try {
      final dir = Directory(reportsDirectory);
      if (!await dir.exists()) return reports;

      await for (final entity in dir.list()) {
        if (entity is File &&
            (entity.path.endsWith('.json') || entity.path.endsWith('.txt'))) {
          reports.add(entity);
        }
      }

      // 按修改时间排序
      reports.sort((a, b) => b.path.compareTo(a.path));
    } catch (e) {
      _logger.error(
        'Failed to list error reports',
        error: e,
      );
    }

    return reports;
  }

  /// 清理旧报告
  Future<void> cleanOldReports({int maxAgeDays = 30}) async {
    try {
      final dir = Directory(reportsDirectory);
      if (!await dir.exists()) return;

      final cutoffDate = DateTime.now().subtract(Duration(days: maxAgeDays));
      var deletedCount = 0;

      await for (final entity in dir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
            deletedCount++;
          }
        }
      }

      _logger.info(
        'Cleaned old error reports',
        metadata: {
          'deletedCount': deletedCount,
          'maxAgeDays': maxAgeDays,
        },
      );
    } catch (e) {
      _logger.error(
        'Failed to clean old error reports',
        error: e,
      );
    }
  }
}
