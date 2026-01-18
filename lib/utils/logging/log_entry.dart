import 'dart:convert';
import 'log_level.dart';

/// 日志条目模型
class LogEntry {
  LogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.metadata,
    this.stackTrace,
    this.context,
    this.operationId,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: LogLevel.values.firstWhere(
        (l) => l.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      category: LogCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => LogCategory.general,
      ),
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      stackTrace: json['stackTrace'] as String?,
      context: json['context'] as Map<String, dynamic>?,
      operationId: json['operationId'] as String?,
    );
  }

  final DateTime timestamp;
  final LogLevel level;
  final LogCategory category;
  final String message;
  final Map<String, dynamic>? metadata;
  final String? stackTrace;
  final Map<String, dynamic>? context;
  final String? operationId;

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'category': category.name,
      'message': message,
      if (metadata != null) 'metadata': metadata,
      if (stackTrace != null) 'stackTrace': stackTrace,
      if (context != null) 'context': context,
      if (operationId != null) 'operationId': operationId,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.write('[${level.name}] ');
    buffer.write('${timestamp.toIso8601String()} ');
    buffer.write('[${category.name}] ');
    if (operationId != null) {
      buffer.write('[$operationId] ');
    }
    buffer.write(message);
    
    if (metadata != null && metadata!.isNotEmpty) {
      buffer.write(' | Metadata: ${jsonEncode(metadata)}');
    }
    
    if (context != null && context!.isNotEmpty) {
      buffer.write(' | Context: ${jsonEncode(context)}');
    }
    
    if (stackTrace != null) {
      buffer.write('\nStack Trace:\n$stackTrace');
    }
    
    return buffer.toString();
  }

  @override
  String toString() => toFormattedString();
}
