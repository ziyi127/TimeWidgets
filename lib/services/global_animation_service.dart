import 'package:flutter/material.dart';
import 'package:time_widgets/services/performance_optimization_service.dart';

/// 全局动画管理服务
/// 提供统一的动画配置、性能监控和自动调整机制
/// 包含动画缓存、统一曲线和时长规范
class GlobalAnimationService {
  /// 单例实例
  static final GlobalAnimationService instance = GlobalAnimationService._();
  
  /// 私有构造函数
  GlobalAnimationService._();
  
  /// 动画配置项
  static const Duration defaultDuration = Duration(milliseconds: 200);
  static const Duration shortDuration = Duration(milliseconds: 150);
  static const Duration longDuration = Duration(milliseconds: 300);
  
  /// 统一的动画曲线规范
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve popCurve = Curves.easeOutBack;
  static const Curve slideCurve = Curves.easeInOutCubic;
  static const Curve fastCurve = Curves.fastOutSlowIn;
  
  /// 动画缓存
  final Map<String, AnimationController> _animationControllerCache = {};
  final Map<String, Animation<dynamic>> _animationCache = {};
  
  /// 性能监控开关
  bool _performanceMonitoringEnabled = true;
  
  /// 动画性能统计
  final Map<String, Map<String, dynamic>> _animationStats = {};
  
  /// 获取动画控制器（带缓存）
  /// [key] 缓存键，用于重用动画控制器
  /// [vsync] 动画垂直同步源
  /// [duration] 动画时长
  AnimationController getAnimationController({
    required String key,
    required TickerProvider vsync,
    Duration? duration,
  }) {
    // 检查缓存中是否存在
    if (_animationControllerCache.containsKey(key)) {
      final controller = _animationControllerCache[key];
      if (controller != null) {
        // 更新时长并重用
        controller.duration = duration ?? defaultDuration;
        return controller;
      }
    }
    
    // 创建新的动画控制器
    final controller = OptimizedAnimationController(
      vsync: vsync,
      duration: duration ?? defaultDuration,
    );
    
    // 添加性能监控
    if (_performanceMonitoringEnabled) {
      controller.addStatusListener((status) {
        _trackAnimationStatus(key, status);
      });
    }
    
    // 存入缓存
    _animationControllerCache[key] = controller;
    
    return controller;
  }
  
  /// 获取动画对象（带缓存）
  /// [key] 缓存键
  /// [controller] 动画控制器
  /// [tween] 动画补间
  /// [curve] 动画曲线
  Animation<T> getAnimation<T>({
    required String key,
    required AnimationController controller,
    required Tween<T> tween,
    Curve? curve,
  }) {
    // 检查缓存中是否存在
    if (_animationCache.containsKey(key)) {
      final animation = _animationCache[key] as Animation<T>?;
      if (animation != null) {
        return animation;
      }
    }
    
    // 创建新的动画
    final animation = tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: curve ?? defaultCurve,
      ),
    );
    
    // 存入缓存
    _animationCache[key] = animation;
    
    return animation;
  }
  
  /// 获取智能调整的动画时长
  /// 根据设备性能自动调整动画时长
  Duration getSmartDuration(Duration baseDuration) {
    final stats = PerformanceOptimizationService.getPerformanceStats();
    final isHighMemoryPressure = stats['memory_pressure'] == 'high';
    final cpuUsage = double.tryParse(stats['cpu_usage']?.toString() ?? '0') ?? 0;
    
    // 根据内存压力和CPU使用率调整时长
    double scaleFactor = 1.0;
    
    if (isHighMemoryPressure) {
      scaleFactor = 0.6; // 高内存压力下减少40%
    } else if (cpuUsage > 80) {
      scaleFactor = 0.7; // 高CPU使用率下减少30%
    } else if (cpuUsage > 60) {
      scaleFactor = 0.85; // 中等CPU使用率下减少15%
    }
    
    return Duration(
      milliseconds: (baseDuration.inMilliseconds * scaleFactor).round(),
    );
  }
  
  /// 智能启动动画
  /// 自动根据性能调整动画时长
  void smartAnimate({
    required AnimationController controller,
    required double target,
    Duration? duration,
    Curve? curve,
  }) {
    final adjustedDuration = getSmartDuration(duration ?? controller.duration ?? defaultDuration);
    // 先更新控制器的时长，再调用animateTo
    controller.duration = adjustedDuration;
    controller.animateTo(target);
  }
  
  /// 智能反向动画
  void smartReverse({
    required AnimationController controller,
  }) {
    controller.reverse();
  }
  
  /// 动画状态跟踪
  void _trackAnimationStatus(String key, AnimationStatus status) {
    if (!_animationStats.containsKey(key)) {
      _animationStats[key] = {
        'start_time': null,
        'end_time': null,
        'duration': 0,
        'count': 0,
        'avg_duration': 0,
      };
    }
    
    final stats = _animationStats[key]!;
    
    if (status == AnimationStatus.forward) {
      stats['start_time'] = DateTime.now().millisecondsSinceEpoch;
    } else if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      final startTime = stats['start_time'] as int?;
      if (startTime != null) {
        final endTime = DateTime.now().millisecondsSinceEpoch;
        final duration = endTime - startTime;
        
        stats['end_time'] = endTime;
        stats['duration'] = duration;
        stats['count'] = (stats['count'] as int) + 1;
        
        // 更新平均时长
        final avgDuration = stats['avg_duration'] as int;
        final count = stats['count'] as int;
        final totalDuration = avgDuration * (count - 1) + duration;
        stats['avg_duration'] = totalDuration ~/ count;
      }
    }
  }
  
  /// 清除指定动画控制器缓存
  void clearControllerCache(String key) {
    final controller = _animationControllerCache.remove(key);
    controller?.dispose();
  }
  
  /// 清除指定动画缓存
  void clearAnimationCache(String key) {
    _animationCache.remove(key);
  }
  
  /// 清除所有动画缓存
  void clearAllCache() {
    // 释放所有控制器资源
    for (final controller in _animationControllerCache.values) {
      controller.dispose();
    }
    
    _animationControllerCache.clear();
    _animationCache.clear();
    _animationStats.clear();
  }
  
  /// 启用/禁用性能监控
  set performanceMonitoringEnabled(bool enabled) {
    _performanceMonitoringEnabled = enabled;
  }
  
  /// 获取动画性能统计
  Map<String, Map<String, dynamic>> getAnimationStats() {
    return Map.unmodifiable(_animationStats);
  }
  
  /// 重置动画性能统计
  void resetAnimationStats() {
    _animationStats.clear();
  }
  
  /// 创建淡入淡出动画
  Animation<double> createFadeAnimation({
    required String key,
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve? curve,
  }) {
    return getAnimation<double>(
      key: '${key}_fade',
      controller: controller,
      tween: Tween<double>(begin: begin, end: end),
      curve: curve ?? defaultCurve,
    );
  }
  
  /// 创建缩放动画
  Animation<double> createScaleAnimation({
    required String key,
    required AnimationController controller,
    double begin = 0.95,
    double end = 1.0,
    Curve? curve,
  }) {
    return getAnimation<double>(
      key: '${key}_scale',
      controller: controller,
      tween: Tween<double>(begin: begin, end: end),
      curve: curve ?? popCurve,
    );
  }
  
  /// 创建平移动画
  Animation<Offset> createSlideAnimation({
    required String key,
    required AnimationController controller,
    Offset begin = Offset.zero,
    Offset end = Offset.zero,
    Curve? curve,
  }) {
    return getAnimation<Offset>(
      key: '${key}_slide',
      controller: controller,
      tween: Tween<Offset>(begin: begin, end: end),
      curve: curve ?? slideCurve,
    );
  }
  
  /// 创建旋转动画
  Animation<double> createRotationAnimation({
    required String key,
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve? curve,
  }) {
    return getAnimation<double>(
      key: '${key}_rotation',
      controller: controller,
      tween: Tween<double>(begin: begin, end: end),
      curve: curve ?? defaultCurve,
    );
  }
  
  /// 获取适合当前性能的动画配置
  AnimationConfig getPerformanceAdjustedConfig({
    Duration? duration,
    Curve? curve,
  }) {
    return AnimationConfig(
      duration: getSmartDuration(duration ?? defaultDuration),
      curve: curve ?? defaultCurve,
    );
  }
}

/// 动画配置类
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  
  const AnimationConfig({
    required this.duration,
    required this.curve,
  });
}

/// 优化的动画组件基类
mixin OptimizedAnimationMixin on StatefulWidget {
  /// 创建动画控制器（带智能配置）
  AnimationController createOptimizedAnimationController({
    required TickerProvider vsync,
    String? cacheKey,
    Duration? duration,
  }) {
    final controller = cacheKey != null
        ? GlobalAnimationService.instance.getAnimationController(
            key: cacheKey,
            vsync: vsync,
            duration: duration,
          )
        : OptimizedAnimationController(
            vsync: vsync,
            duration: duration ?? GlobalAnimationService.defaultDuration,
          );
    
    return controller;
  }
  
  /// 智能启动动画
  void smartAnimate({
    required AnimationController controller,
    required double target,
    Duration? duration,
    Curve? curve,
  }) {
    GlobalAnimationService.instance.smartAnimate(
      controller: controller,
      target: target,
      duration: duration,
      curve: curve,
    );
  }
  
  /// 智能反向动画
  void smartReverse({
    required AnimationController controller,
    Curve? curve,
  }) {
    GlobalAnimationService.instance.smartReverse(
      controller: controller,
    );
  }
}
