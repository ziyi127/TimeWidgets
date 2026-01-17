import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 内存优化工具类
class MemoryOptimizer {
  static Timer? _gcTimer;
  
  /// 启动主动垃圾回收
  static void startAggressiveGC() {
    _gcTimer?.cancel();
    
    // 改为每60秒触发一次，减少CPU占用
    _gcTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      // 在 release 模式下，这会提示 VM 进行 GC
      if (kReleaseMode) {
        // 创建一些临时对象然后立即丢弃，触发 GC
        final temp = List.generate(100, (i) => i);
        temp.clear();
      }
    });
  }
  
  /// 停止主动垃圾回收
  static void stopAggressiveGC() {
    _gcTimer?.cancel();
    _gcTimer = null;
  }
  
  /// 清理图片缓存
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
  
  /// 设置图片缓存大小限制
  static void limitImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 50; // 默认1000
    PaintingBinding.instance.imageCache.maximumSizeBytes = 10 << 20; // 10MB，默认100MB
  }
}
