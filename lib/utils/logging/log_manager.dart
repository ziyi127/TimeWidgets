import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'log_config.dart';
import 'log_entry.dart';
import 'log_level.dart';

/// 日志文件管理器
class LogManager {
  LogManager(this.config) {
    _initializeLogDirectory();
  }

  final LogConfig config;
  final List<LogEntry> _buffer = [];
  Timer? _flushTimer;
  File? _currentLogFile;
  int _currentFileSize = 0;

  /// 初始化日志目录
  Future<void> _initializeLogDirectory() async {
    try {
      final dir = Directory(config.logDirectory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      
      // 清理过期日志
      await _cleanOldLogs();
      
      // 启动定时刷新
      _startFlushTimer();
    } catch (e) {
      // ignore: avoid_print
      print('Failed to initialize log directory: $e');
    }
  }

  /// 写入日志条目
  Future<void> writeLog(LogEntry entry) async {
    if (!config.enableFileOutput) return;

    _buffer.add(entry);

    if (_buffer.length >= config.bufferSize) {
      await flush();
    }
  }

  /// 刷新缓冲区
  Future<void> flush() async {
    if (_buffer.isEmpty) return;

    try {
      final file = await _getCurrentLogFile();
      final entries = List<LogEntry>.from(_buffer);
      _buffer.clear();

      final content = StringBuffer();
      for (final entry in entries) {
        if (config.enableStructuredFormat) {
          content.writeln(entry.toJsonString());
        } else {
          content.writeln(entry.toFormattedString());
        }
      }

      await file.writeAsString(
        content.toString(),
        mode: FileMode.append,
        flush: true,
      );

      _currentFileSize += content.length;

      // 检查是否需要轮转
      if (_currentFileSize >= config.maxFileSizeBytes) {
        await _rotateLogFile();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to flush logs: $e');
    }
  }

  /// 获取当前日志文件
  Future<File> _getCurrentLogFile() async {
    if (_currentLogFile != null && await _currentLogFile!.exists()) {
      return _currentLogFile!;
    }

    final now = DateTime.now();
    final fileName = 'app_${now.year}${_pad(now.month)}${_pad(now.day)}.log';
    final filePath = path.join(config.logDirectory, fileName);
    
    _currentLogFile = File(filePath);
    
    if (await _currentLogFile!.exists()) {
      _currentFileSize = await _currentLogFile!.length();
    } else {
      _currentFileSize = 0;
    }

    return _currentLogFile!;
  }

  /// 轮转日志文件
  Future<void> _rotateLogFile() async {
    if (_currentLogFile == null) return;

    try {
      final now = DateTime.now();
      final timestamp = '${now.year}${_pad(now.month)}${_pad(now.day)}_'
          '${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}';
      
      final baseName = path.basenameWithoutExtension(_currentLogFile!.path);
      final newName = '${baseName}_$timestamp.log';
      final newPath = path.join(config.logDirectory, newName);

      await _currentLogFile!.rename(newPath);
      
      _currentLogFile = null;
      _currentFileSize = 0;
    } catch (e) {
      // ignore: avoid_print
      print('Failed to rotate log file: $e');
    }
  }

  /// 清理过期日志
  Future<void> _cleanOldLogs() async {
    try {
      final dir = Directory(config.logDirectory);
      if (!await dir.exists()) return;

      final cutoffDate = DateTime.now().subtract(
        Duration(days: config.maxFileAgeDays),
      );

      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.log')) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to clean old logs: $e');
    }
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
    final results = <LogEntry>[];

    try {
      final dir = Directory(config.logDirectory);
      if (!await dir.exists()) return results;

      final files = <File>[];
      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.log')) {
          files.add(entity);
        }
      }

      // 按修改时间排序
      files.sort((a, b) => b.path.compareTo(a.path));

      for (final file in files) {
        final lines = await file.readAsLines();
        
        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          try {
            LogEntry entry;
            if (config.enableStructuredFormat) {
              final json = jsonDecode(line) as Map<String, dynamic>;
              entry = LogEntry.fromJson(json);
            } else {
              // 简单解析格式化字符串（仅用于基本过滤）
              continue;
            }

            // 应用过滤器
            if (startTime != null && entry.timestamp.isBefore(startTime)) {
              continue;
            }
            if (endTime != null && entry.timestamp.isAfter(endTime)) {
              continue;
            }
            if (minLevel != null && entry.level < minLevel) {
              continue;
            }
            if (category != null && entry.category != category) {
              continue;
            }
            if (searchText != null && 
                !entry.message.toLowerCase().contains(searchText.toLowerCase())) {
              continue;
            }

            results.add(entry);

            if (limit != null && results.length >= limit) {
              return results;
            }
          } catch (e) {
            // 跳过无法解析的行
            continue;
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to query logs: $e');
    }

    return results;
  }

  /// 获取最近的日志
  Future<List<LogEntry>> getRecentLogs(int count) async {
    return queryLogs(limit: count);
  }

  /// 启动定时刷新
  void _startFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      flush();
    });
  }

  /// 清理资源
  Future<void> dispose() async {
    _flushTimer?.cancel();
    await flush();
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}
