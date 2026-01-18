import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';

/// 激进优化工具类
class AggressiveOptimizer {
  static Timer? _optimizationTimer;
  
  /// 启动激进优化
  static void startAggressiveOptimization() {
    _optimizationTimer?.cancel();
    
    // 每1分钟执行一次深度清理（即使在Debug模式下也执行，以解决用户反馈的内存高问题）
    _optimizationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _performDeepCleanup();
    });
  }
  
  /// 停止激进优化
  static void stopAggressiveOptimization() {
    _optimizationTimer?.cancel();
    _optimizationTimer = null;
  }
  
  /// 执行深度清理
  static void _performDeepCleanup() {
    // 1. 清理图片缓存
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    
    // 2. 强制垃圾回收建议
    // 在Debug模式下这可能不会立即生效，但在Release模式下有助于减少RSS
    try {
      // 分配一个大对象然后立即释放，有时能触发GC
      List.filled(10000, 0); 
    } catch (_) {}
  }
  
  /// 设置极限内存限制
  static void setExtremeLimits() {
    // 图片缓存设置为最小
    PaintingBinding.instance.imageCache.maximumSize = 10; // 进一步减少缓存
    PaintingBinding.instance.imageCache.maximumSizeBytes = 2 << 20; // 2MB
  }
  
  /// 禁用所有动画以节省CPU和内存
  static void disableAnimations() {
    // 在release模式下禁用动画
    if (kReleaseMode) {
      SchedulerBinding.instance.platformDispatcher.onBeginFrame = null;
      SchedulerBinding.instance.platformDispatcher.onDrawFrame = null;
    }
  }
}
