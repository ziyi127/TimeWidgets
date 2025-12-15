import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:time_widgets/utils/logger.dart';

/// 渲染同步服务
/// 确保所有渲染操作与屏幕刷新率同步，消除撕裂现象
class RenderSyncService {
  static RenderSyncService? _instance;
  static RenderSyncService get instance => _instance ??= RenderSyncService._();
  
  RenderSyncService._();

  bool _isInitialized = false;
  final List<VoidCallback> _pendingUpdates = [];
  final Map<String, Timer> _scheduledUpdates = {};
  
  // 性能监控
  final List<Duration> _frameTimes = [];
  double _averageFrameTime = 16.67; // 60fps baseline
  int _droppedFrames = 0;

  /// 初始化渲染同步服�?
  void initialize() {
    if (_isInitialized) return;
    
    // 开始帧时间监控
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    
    // 设置帧回�?
    SchedulerBinding.instance.addPostFrameCallback(_processFrameUpdates);
    
    _isInitialized = true;
    Logger.i('RenderSyncService initialized');
  }

  /// 销毁服�?
  void dispose() {
    if (!_isInitialized) return;
    
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    _pendingUpdates.clear();
    _scheduledUpdates.values.forEach((timer) => timer.cancel());
    _scheduledUpdates.clear();
    
    _isInitialized = false;
  }

  /// 同步执行渲染更新
  void syncUpdate(VoidCallback update, {String? key}) {
    if (!_isInitialized) {
      update();
      return;
    }

    // 如果有key，取消之前的更新
    if (key != null) {
      _scheduledUpdates[key]?.cancel();
      _scheduledUpdates.remove(key);
    }

    // 添加到待处理队列
    _pendingUpdates.add(update);
    
    // 如果性能良好，立即执�?
    if (_averageFrameTime < 14.0) { // 留有余量
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _processPendingUpdates();
      });
    } else {
      // 性能不佳时，延迟执行
      final timer = Timer(Duration(milliseconds: 1), () {
        _processPendingUpdates();
        if (key != null) _scheduledUpdates.remove(key);
      });
      
      if (key != null) {
        _scheduledUpdates[key] = timer;
      }
    }
  }

  /// 批量同步更新
  void batchSyncUpdate(List<VoidCallback> updates) {
    if (!_isInitialized) {
      updates.forEach((update) => update());
      return;
    }

    _pendingUpdates.addAll(updates);
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _processPendingUpdates();
    });
  }

  /// 智能延迟更新（根据性能自适应�?
  void smartDelayedUpdate(VoidCallback update, {String? key}) {
    if (!_isInitialized) {
      update();
      return;
    }

    // 根据当前性能决定延迟时间
    final delay = _calculateOptimalDelay();
    
    if (key != null) {
      _scheduledUpdates[key]?.cancel();
    }

    final timer = Timer(delay, () {
      syncUpdate(update);
      if (key != null) _scheduledUpdates.remove(key);
    });

    if (key != null) {
      _scheduledUpdates[key] = timer;
    }
  }

  /// 处理帧更�?
  void _processFrameUpdates(Duration timeStamp) {
    if (_pendingUpdates.isNotEmpty) {
      _processPendingUpdates();
    }
    
    // 继续监听下一�?
    SchedulerBinding.instance.addPostFrameCallback(_processFrameUpdates);
  }

  /// 处理待处理的更新
  void _processPendingUpdates() {
    if (_pendingUpdates.isEmpty) return;

    final updates = List<VoidCallback>.from(_pendingUpdates);
    _pendingUpdates.clear();

    // 分批执行更新，避免单帧过�?
    const maxUpdatesPerFrame = 5;
    final batches = <List<VoidCallback>>[];
    
    for (int i = 0; i < updates.length; i += maxUpdatesPerFrame) {
      final end = (i + maxUpdatesPerFrame).clamp(0, updates.length);
      batches.add(updates.sublist(i, end));
    }

    // 执行第一�?
    if (batches.isNotEmpty) {
      _executeBatch(batches.first);
      
      // 如果有更多批次，在下一帧执�?
      if (batches.length > 1) {
        for (int i = 1; i < batches.length; i++) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _executeBatch(batches[i]);
          });
        }
      }
    }
  }

  /// 执行更新批次
  void _executeBatch(List<VoidCallback> batch) {
    try {
      for (final update in batch) {
        update();
      }
    } catch (e) {
      Logger.e('Error executing render update batch: $e');
    }
  }

  /// 帧时间回�?
  void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan;
      _frameTimes.add(frameDuration);
      
      // 保持最�?00帧的数据
      if (_frameTimes.length > 100) {
        _frameTimes.removeAt(0);
      }
      
      // 检测掉�?
      if (frameDuration.inMicroseconds > 16670) { // 超过16.67ms
        _droppedFrames++;
      }
    }
    
    // 更新平均帧时�?
    _updateAverageFrameTime();
  }

  /// 更新平均帧时�?
  void _updateAverageFrameTime() {
    if (_frameTimes.isEmpty) return;
    
    final totalMicroseconds = _frameTimes
        .map((duration) => duration.inMicroseconds)
        .reduce((a, b) => a + b);
    
    _averageFrameTime = totalMicroseconds / _frameTimes.length / 1000.0; // 转换为毫�?
  }

  /// 计算最优延迟时�?
  Duration _calculateOptimalDelay() {
    if (_averageFrameTime < 12.0) {
      return Duration.zero; // 性能很好，无需延迟
    } else if (_averageFrameTime < 16.0) {
      return const Duration(milliseconds: 1); // 轻微延迟
    } else if (_averageFrameTime < 20.0) {
      return const Duration(milliseconds: 2); // 中等延迟
    } else {
      return const Duration(milliseconds: 5); // 较大延迟
    }
  }

  /// 获取性能统计
  Map<String, dynamic> getPerformanceStats() {
    return {
      'average_frame_time_ms': _averageFrameTime,
      'dropped_frames': _droppedFrames,
      'pending_updates': _pendingUpdates.length,
      'scheduled_updates': _scheduledUpdates.length,
      'performance_level': _getPerformanceLevel(),
      'frame_rate': _averageFrameTime > 0 ? 1000.0 / _averageFrameTime : 0.0,
    };
  }

  /// 获取性能等级
  String _getPerformanceLevel() {
    if (_averageFrameTime < 12.0) return 'excellent';
    if (_averageFrameTime < 16.0) return 'good';
    if (_averageFrameTime < 20.0) return 'fair';
    return 'poor';
  }

  /// 重置性能统计
  void resetStats() {
    _frameTimes.clear();
    _droppedFrames = 0;
    _averageFrameTime = 16.67;
  }

  /// 检查是否需要性能优化
  bool needsOptimization() {
    return _averageFrameTime > 18.0 || _droppedFrames > 10;
  }

  /// 获取建议的优化措�?
  List<String> getOptimizationSuggestions() {
    final suggestions = <String>[];
    
    if (_averageFrameTime > 20.0) {
      suggestions.add('减少同时更新的组件数�?);
    }
    
    if (_droppedFrames > 20) {
      suggestions.add('启用更激进的缓存策略');
    }
    
    if (_pendingUpdates.length > 10) {
      suggestions.add('增加更新批次大小');
    }
    
    return suggestions;
  }
}

/// 同步渲染混入
mixin RenderSyncMixin<T extends StatefulWidget> on State<T> {
  /// 同步setState
  void syncSetState(VoidCallback fn, {String? key}) {
    RenderSyncService.instance.syncUpdate(() {
      if (mounted) setState(fn);
    }, key: key);
  }

  /// 智能延迟setState
  void smartSetState(VoidCallback fn, {String? key}) {
    RenderSyncService.instance.smartDelayedUpdate(() {
      if (mounted) setState(fn);
    }, key: key);
  }

  /// 批量setState
  void batchSetState(List<VoidCallback> updates) {
    RenderSyncService.instance.batchSyncUpdate(
      updates.map((update) => () {
        if (mounted) setState(update);
      }).toList(),
    );
  }
}
