import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/enhanced_layout_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:time_widgets/utils/logger.dart';

/// 错误恢复服务
/// 提供布局数据验证、自动修复和多级回退策略
class ErrorRecoveryService {
  static const String _backupKey = 'layout_backup';
  static const String _errorLogKey = 'error_log';
  static const int _maxBackups = 5;
  static const int _maxErrorLogs = 20;

  /// 验证并修复布局数据
  static Future<LayoutRecoveryResult> validateAndRecoverLayout({
    required Size screenSize,
    Map<WidgetType, WidgetPosition>? currentLayout,
  }) async {
    try {
      final containerSize = Size(screenSize.width / 4, screenSize.height);
      
      // 如果没有当前布局，尝试加载保存的布局
      if (currentLayout == null) {
        final loadResult = await _loadSavedLayout(containerSize);
        if (loadResult.isSuccess) {
          return LayoutRecoveryResult(
            layout: loadResult.layout!,
            recoveryLevel: RecoveryLevel.loadedFromStorage,
            message: '已从存储加载布局',
            wasRecovered: false,
          );
        }
        currentLayout = loadResult.layout ?? {};
      }

      // 验证当前布局
      final validationResult = _validateLayout(currentLayout, containerSize);
      
      if (validationResult.isValid) {
        // 布局有效，创建备�?
        await _createBackup(currentLayout);
        return LayoutRecoveryResult(
          layout: currentLayout,
          recoveryLevel: RecoveryLevel.valid,
          message: '布局验证通过',
          wasRecovered: false,
        );
      }

      // 布局无效，尝试修�?
      final repairResult = await _repairLayout(
        currentLayout, 
        containerSize, 
        validationResult.issues
      );

      if (repairResult.isSuccess) {
        await _createBackup(repairResult.layout!);
        return LayoutRecoveryResult(
          layout: repairResult.layout!,
          recoveryLevel: RecoveryLevel.repaired,
          message: '布局已自动修�? ${repairResult.message}',
          wasRecovered: true,
          issues: validationResult.issues,
        );
      }

      // 修复失败，尝试从备份恢复
      final backupResult = await _restoreFromBackup(containerSize);
      if (backupResult.isSuccess) {
        return LayoutRecoveryResult(
          layout: backupResult.layout!,
          recoveryLevel: RecoveryLevel.restoredFromBackup,
          message: '已从备份恢复布局',
          wasRecovered: true,
          issues: validationResult.issues,
        );
      }

      // 所有恢复方法都失败，使用默认布局
      final defaultLayout = _createSafeDefaultLayout(containerSize);
      await _logError('All recovery methods failed, using default layout', {
        'original_issues': validationResult.issues,
        'repair_error': repairResult.message,
        'backup_error': backupResult.message,
      });

      return LayoutRecoveryResult(
        layout: defaultLayout,
        recoveryLevel: RecoveryLevel.defaultLayout,
        message: '已重置为默认布局',
        wasRecovered: true,
        issues: validationResult.issues,
      );

    } catch (e) {
      // 发生异常，记录错误并返回安全的默认布局
      await _logError('Exception in layout recovery', {'error': e.toString()});
      
      final containerSize = Size(screenSize.width / 4, screenSize.height);
      final safeLayout = _createSafeDefaultLayout(containerSize);
      
      return LayoutRecoveryResult(
        layout: safeLayout,
        recoveryLevel: RecoveryLevel.emergency,
        message: '发生错误，已使用紧急布局',
        wasRecovered: true,
        issues: ['系统异常: $e'],
      );
    }
  }

  /// 创建布局备份
  static Future<void> _createBackup(Map<WidgetType, WidgetPosition> layout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 获取现有备份
      final backupsJson = prefs.getString(_backupKey);
      List<Map<String, dynamic>> backups = [];
      
      if (backupsJson != null) {
        final decoded = json.decode(backupsJson) as List;
        backups = decoded.cast<Map<String, dynamic>>();
      }

      // 添加新备�?
      final newBackup = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'layout': layout.map((key, value) => MapEntry(key.name, value.toJson())),
      };
      
      backups.insert(0, newBackup);
      
      // 保持最大备份数�?
      if (backups.length > _maxBackups) {
        backups = backups.take(_maxBackups).toList();
      }
      
      // 保存备份
      await prefs.setString(_backupKey, json.encode(backups));
      
    } catch (e) {
      Logger.e('Failed to create backup: $e');
    }
  }

  /// 从备份恢�?
  static Future<RecoveryAttemptResult> _restoreFromBackup(Size containerSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupsJson = prefs.getString(_backupKey);
      
      if (backupsJson == null) {
        return RecoveryAttemptResult(
          isSuccess: false,
          message: '没有可用的备�?,
        );
      }

      final backups = json.decode(backupsJson) as List;
      
      // 尝试每个备份，从最新的开�?
      for (final backup in backups) {
        try {
          final layoutData = backup['layout'] as Map<String, dynamic>;
          final layout = <WidgetType, WidgetPosition>{};
          
          for (final entry in layoutData.entries) {
            final type = WidgetType.values.firstWhere(
              (e) => e.name == entry.key,
              orElse: () => WidgetType.time,
            );
            layout[type] = WidgetPosition.fromJson(entry.value);
          }
          
          // 验证备份布局
          final validation = _validateLayout(layout, containerSize);
          if (validation.isValid) {
            return RecoveryAttemptResult(
              isSuccess: true,
              layout: layout,
              message: '从备份恢复成�?,
            );
          }
        } catch (e) {
          continue; // 尝试下一个备�?
        }
      }
      
      return RecoveryAttemptResult(
        isSuccess: false,
        message: '所有备份都无效',
      );
      
    } catch (e) {
      return RecoveryAttemptResult(
        isSuccess: false,
        message: '备份恢复失败: $e',
      );
    }
  }

  /// 加载保存的布局
  static Future<RecoveryAttemptResult> _loadSavedLayout(Size containerSize) async {
    try {
      final layout = await DesktopWidgetService.loadWidgetPositions(
        Size(containerSize.width * 4, containerSize.height)
      );
      
      return RecoveryAttemptResult(
        isSuccess: true,
        layout: layout,
        message: '加载保存的布局成功',
      );
    } catch (e) {
      return RecoveryAttemptResult(
        isSuccess: false,
        message: '加载保存的布局失败: $e',
      );
    }
  }

  /// 修复布局
  static Future<RecoveryAttemptResult> _repairLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
    List<String> issues,
  ) async {
    try {
      final layoutEngine = EnhancedLayoutEngine();
      
      // 尝试使用布局引擎修复
      final repairedLayout = layoutEngine.calculateOptimalLayout(containerSize, layout);
      
      // 验证修复结果
      final validation = _validateLayout(repairedLayout, containerSize);
      if (validation.isValid) {
        return RecoveryAttemptResult(
          isSuccess: true,
          layout: repairedLayout,
          message: '布局引擎修复成功',
        );
      }

      // 如果布局引擎修复失败，尝试手动修�?
      final manuallyRepaired = _manualRepair(layout, containerSize, issues);
      final manualValidation = _validateLayout(manuallyRepaired, containerSize);
      
      if (manualValidation.isValid) {
        return RecoveryAttemptResult(
          isSuccess: true,
          layout: manuallyRepaired,
          message: '手动修复成功',
        );
      }

      return RecoveryAttemptResult(
        isSuccess: false,
        message: '修复失败，所有修复方法都无效',
      );
      
    } catch (e) {
      return RecoveryAttemptResult(
        isSuccess: false,
        message: '修复过程中发生错�? $e',
      );
    }
  }

  /// 手动修复布局
  static Map<WidgetType, WidgetPosition> _manualRepair(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
    List<String> issues,
  ) {
    final repairedLayout = Map<WidgetType, WidgetPosition>.from(layout);
    
    // 修复超出边界的组�?
    for (final entry in repairedLayout.entries) {
      final position = entry.value;
      
      if (position.x + position.width > containerSize.width ||
          position.y + position.height > containerSize.height) {
        
        final adjustedX = (position.x).clamp(0.0, containerSize.width - position.width);
        final adjustedY = (position.y).clamp(0.0, containerSize.height - position.height);
        
        repairedLayout[entry.key] = WidgetPosition(
          type: position.type,
          x: adjustedX,
          y: adjustedY,
          width: position.width.clamp(50.0, containerSize.width),
          height: position.height.clamp(50.0, containerSize.height),
          isVisible: position.isVisible,
        );
      }
    }
    
    // 解决重叠问题 - 使用简单的垂直排列
    final sortedTypes = [
      WidgetType.time,
      WidgetType.date,
      WidgetType.week,
      WidgetType.weather,
      WidgetType.currentClass,
      WidgetType.countdown,
      WidgetType.timetable,
    ];
    
    double currentY = 16.0;
    const spacing = 12.0;
    const padding = 16.0;
    
    for (final type in sortedTypes) {
      if (repairedLayout.containsKey(type)) {
        final position = repairedLayout[type]!;
        
        repairedLayout[type] = WidgetPosition(
          type: type,
          x: padding,
          y: currentY,
          width: position.width,
          height: position.height,
          isVisible: position.isVisible,
        );
        
        currentY += position.height + spacing;
      }
    }
    
    // 设置按钮特殊处理
    if (repairedLayout.containsKey(WidgetType.settings)) {
      final position = repairedLayout[WidgetType.settings]!;
      repairedLayout[WidgetType.settings] = WidgetPosition(
        type: WidgetType.settings,
        x: containerSize.width - padding - position.width,
        y: padding,
        width: position.width,
        height: position.height,
        isVisible: position.isVisible,
      );
    }
    
    return repairedLayout;
  }

  /// 验证布局
  static ValidationResult _validateLayout(
    Map<WidgetType, WidgetPosition> layout,
    Size containerSize,
  ) {
    final issues = <String>[];
    
    // 检查是否包含所有必需的组�?
    for (final type in WidgetType.values) {
      if (!layout.containsKey(type)) {
        issues.add('缺少组件: ${type.name}');
      }
    }
    
    // 检查边�?
    for (final entry in layout.entries) {
      final position = entry.value;
      
      if (position.x < 0 || position.y < 0) {
        issues.add('${entry.key.name}位置为负�?);
      }
      
      if (position.x + position.width > containerSize.width ||
          position.y + position.height > containerSize.height) {
        issues.add('${entry.key.name}超出边界');
      }
      
      if (position.width < 50 || position.height < 50) {
        issues.add('${entry.key.name}尺寸过小');
      }
    }
    
    // 检查重�?
    final positions = layout.values.where((p) => p.isVisible).toList();
    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        if (_isOverlapping(positions[i], positions[j])) {
          issues.add('${positions[i].type.name}�?{positions[j].type.name}重叠');
        }
      }
    }
    
    return ValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }

  /// 检查两个组件是否重�?
  static bool _isOverlapping(WidgetPosition a, WidgetPosition b) {
    return !(a.x + a.width <= b.x || 
             b.x + b.width <= a.x || 
             a.y + a.height <= b.y || 
             b.y + b.height <= a.y);
  }

  /// 创建安全的默认布局
  static Map<WidgetType, WidgetPosition> _createSafeDefaultLayout(Size containerSize) {
    final layoutEngine = EnhancedLayoutEngine();
    return layoutEngine.calculateOptimalLayout(containerSize, null);
  }

  /// 记录错误
  static Future<void> _logError(String message, Map<String, dynamic>? details) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 获取现有错误日志
      final errorLogJson = prefs.getString(_errorLogKey);
      List<Map<String, dynamic>> errorLog = [];
      
      if (errorLogJson != null) {
        final decoded = json.decode(errorLogJson) as List;
        errorLog = decoded.cast<Map<String, dynamic>>();
      }

      // 添加新错�?
      final newError = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'message': message,
        'details': details ?? {},
      };
      
      errorLog.insert(0, newError);
      
      // 保持最大日志数�?
      if (errorLog.length > _maxErrorLogs) {
        errorLog = errorLog.take(_maxErrorLogs).toList();
      }
      
      // 保存错误日志
      await prefs.setString(_errorLogKey, json.encode(errorLog));
      
      // 同时输出到控制台
      Logger.e('ErrorRecoveryService: $message');
      if (details != null) {
        Logger.e('Details: $details');
      }
      
    } catch (e) {
      Logger.e('Failed to log error: $e');
    }
  }

  /// 获取错误日志
  static Future<List<ErrorLogEntry>> getErrorLog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final errorLogJson = prefs.getString(_errorLogKey);
      
      if (errorLogJson == null) return [];
      
      final errorLog = json.decode(errorLogJson) as List;
      
      return errorLog.map((entry) => ErrorLogEntry(
        timestamp: DateTime.fromMillisecondsSinceEpoch(entry['timestamp']),
        message: entry['message'],
        details: Map<String, dynamic>.from(entry['details'] ?? {}),
      )).toList();
      
    } catch (e) {
      Logger.e('Failed to get error log: $e');
      return [];
    }
  }

  /// 清除错误日志
  static Future<void> clearErrorLog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_errorLogKey);
    } catch (e) {
      Logger.e('Failed to clear error log: $e');
    }
  }

  /// 清除所有备�?
  static Future<void> clearBackups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_backupKey);
    } catch (e) {
      Logger.e('Failed to clear backups: $e');
    }
  }
}

/// 布局恢复结果
class LayoutRecoveryResult {
  final Map<WidgetType, WidgetPosition> layout;
  final RecoveryLevel recoveryLevel;
  final String message;
  final bool wasRecovered;
  final List<String> issues;

  LayoutRecoveryResult({
    required this.layout,
    required this.recoveryLevel,
    required this.message,
    required this.wasRecovered,
    this.issues = const [],
  });
}

/// 恢复尝试结果
class RecoveryAttemptResult {
  final bool isSuccess;
  final Map<WidgetType, WidgetPosition>? layout;
  final String message;

  RecoveryAttemptResult({
    required this.isSuccess,
    this.layout,
    required this.message,
  });
}

/// 恢复级别
enum RecoveryLevel {
  valid,              // 布局有效
  loadedFromStorage,  // 从存储加�?
  repaired,           // 自动修复
  restoredFromBackup, // 从备份恢�?
  defaultLayout,      // 使用默认布局
  emergency,          // 紧急模�?
}

/// 验证结果
class ValidationResult {
  final bool isValid;
  final List<String> issues;

  ValidationResult({
    required this.isValid,
    required this.issues,
  });
}

/// 错误日志条目
class ErrorLogEntry {
  final DateTime timestamp;
  final String message;
  final Map<String, dynamic> details;

  ErrorLogEntry({
    required this.timestamp,
    required this.message,
    required this.details,
  });
}
