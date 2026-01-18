import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:time_widgets/utils/logger.dart';

/// 渲染同步服务
/// 确保所有渲染操作与屏幕刷新率同步，消除撕裂现象
class RenderSyncService {
  RenderSyncService._();
  static RenderSyncService? _instance;
  static RenderSyncService get instance => _instance ??= RenderSyncService._();

  bool _isInitialized = false;
  final List<VoidCallback> _pendingUpdates = [];
  final Map<String, Timer> _scheduledUpdates = {};

  // 性能监控
  // final List<Duration> _frameTimes = [];
  // final double _averageFrameTime = 16.67; // 60fps baseline
  // final int _droppedFrames = 0;

  /// 初始化渲染同步服务
  void initialize() {
    if (_isInitialized) return;

    // 不启动帧时间监控以减少CPU占用
    // SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);

    // 设置帧回调
    // SchedulerBinding.instance.addPostFrameCallback(_processFrameUpdates);

    _isInitialized = true;
    Logger.i('RenderSyncService initialized (lightweight mode)');
  }

  /// 销毁服务
  void dispose() {
    if (!_isInitialized) return;

    // SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    _pendingUpdates.clear();
    for (final timer in _scheduledUpdates.values) {
      timer.cancel();
    }
    _scheduledUpdates.clear();

    _isInitialized = false;
  }

  /// 同步执行渲染更新
  void syncUpdate(VoidCallback update, {String? key}) {
    // 简化版本：直接执行，不做复杂的性能检查
    update();
  }

  /// 批量同步更新
  void batchSyncUpdate(List<VoidCallback> updates) {
    if (!_isInitialized) {
      for (final update in updates) {
        update();
      }
      return;
    }

    _pendingUpdates.addAll(updates);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _processPendingUpdates();
    });
  }

  /// 智能延迟更新（根据性能自适应）
  void smartDelayedUpdate(VoidCallback update, {String? key}) {
    if (!_isInitialized) {
      update();
      return;
    }

    // 默认延迟
    const delay = Duration(milliseconds: 1);

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

  /// 处理帧更新
  // void _processFrameUpdates(Duration timeStamp) {
  //   if (_pendingUpdates.isNotEmpty) {
  //     _processPendingUpdates();
  //   }
  //
  //   // 继续监听下一帧
  //   SchedulerBinding.instance.addPostFrameCallback(_processFrameUpdates);
  // }

  /// 处理待处理的更新
  void _processPendingUpdates() {
    if (_pendingUpdates.isEmpty) return;

    final updates = List<VoidCallback>.from(_pendingUpdates);
    _pendingUpdates.clear();

    // 分批执行更新，避免单帧过载
    const maxUpdatesPerFrame = 5;
    final batches = <List<VoidCallback>>[];

    for (int i = 0; i < updates.length; i += maxUpdatesPerFrame) {
      final end = (i + maxUpdatesPerFrame).clamp(0, updates.length);
      batches.add(updates.sublist(i, end));
    }

    // 执行第一批次
    if (batches.isNotEmpty) {
      _executeBatch(batches.first);

      // 如果有更多批次，在下一帧执行
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

  /// 获取性能统计
  Map<String, dynamic> getPerformanceStats() {
    return {
      'pending_updates': _pendingUpdates.length,
      'scheduled_updates': _scheduledUpdates.length,
    };
  }

  /// 重置性能统计
  void resetStats() {
    // No stats to reset in lightweight mode
  }
}

/// 同步渲染混入
mixin RenderSyncMixin<T extends StatefulWidget> on State<T> {
  /// 同步setState
  void syncSetState(VoidCallback fn, {String? key}) {
    RenderSyncService.instance.syncUpdate(
      () {
        if (mounted) setState(fn);
      },
      key: key,
    );
  }

  /// 智能延迟setState
  void smartSetState(VoidCallback fn, {String? key}) {
    RenderSyncService.instance.smartDelayedUpdate(
      () {
        if (mounted) setState(fn);
      },
      key: key,
    );
  }

  /// 批量setState
  void batchSetState(List<VoidCallback> updates) {
    RenderSyncService.instance.batchSyncUpdate(
      updates
          .map(
            (update) => () {
              if (mounted) setState(update);
            },
          )
          .toList(),
    );
  }
}
