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
    
    // 每2分钟执行一次深度清理
    _optimizationTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (kReleaseMode) {
        _performDeepCleanup();
      }
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
    
    // 2. 清理字体缓存（如果有的话）
    // FontLoader 相关的清理
    
    // 3. 触发GC
    final temp = List.generate(1000, (i) => i);
    temp.clear();
  }
  
  /// 设置极限内存限制
  static void setExtremeLimits() {
    // 图片缓存设置为最小
    PaintingBinding.instance.imageCache.maximumSize = 20; // 只保留20张
    PaintingBinding.instance.imageCache.maximumSizeBytes = 5 << 20; // 5MB
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
