import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

/// 性能优化服务
/// 提供布局计算优化、重绘减少和内存管理
class PerformanceOptimizationService {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, Timer> _debounceTimers = {};
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  /// 缓存布局计算结果
  static T? getCachedResult<T>(String key) {
    final cached = _cache[key];
    if (cached is T) {
      return cached;
    }
    return null;
  }

  /// 设置缓存结果
  static void setCachedResult<T>(String key, T result, {Duration? ttl}) {
    _cache[key] = result;
    
    // 设置过期时间
    if (ttl != null) {
      Timer(ttl, () => _cache.remove(key));
    }
  }

  /// 清除缓存
  static void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
  }

  /// 防抖动执行
  static void debounce(String key, VoidCallback callback) {
    // 取消之前的定时器
    _debounceTimers[key]?.cancel();
    
    // 设置新的定时器
    _debounceTimers[key] = Timer(_debounceDelay, () {
      callback();
      _debounceTimers.remove(key);
    });
  }

  /// 批量更新布局
  static void batchLayoutUpdate(List<VoidCallback> updates) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final update in updates) {
        update();
      }
    });
  }

  /// 优化的布局计算
  static Future<T> optimizedLayoutCalculation<T>(
    String cacheKey,
    Future<T> Function() calculation, {
    Duration cacheTtl = const Duration(minutes: 5),
  }) async {
    // 检查缓存
    final cached = getCachedResult<T>(cacheKey);
    if (cached != null) {
      return cached;
    }

    // 执行计算
    final result = await calculation();
    
    // 缓存结果
    setCachedResult(cacheKey, result, ttl: cacheTtl);
    
    return result;
  }

  /// 内存使用监控
  static void monitorMemoryUsage() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      // 清理过期缓存
      _cleanupExpiredCache();
      
      // 如果缓存过大，清理一些旧条目
      if (_cache.length > 100) {
        final keysToRemove = _cache.keys.take(20).toList();
        for (final key in keysToRemove) {
          _cache.remove(key);
        }
      }
    });
  }

  /// 清理过期缓存
  static void _cleanupExpiredCache() {
    // 这里可以实现更复杂的过期逻辑
    // 目前依赖Timer自动清理
  }

  /// 优化重绘性能
  static Widget optimizedRepaintBoundary({
    required Widget child,
    String? debugLabel,
  }) {
    return RepaintBoundary(
      child: child,
    );
  }

  /// 延迟加载组件
  static Widget lazyLoadWidget({
    required Widget Function() builder,
    Widget? placeholder,
  }) {
    return FutureBuilder<Widget>(
      future: Future.microtask(builder),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return placeholder ?? const SizedBox.shrink();
      },
    );
  }

  /// 虚拟化列表
  static Widget virtualizedList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    double? itemExtent,
    ScrollController? controller,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      itemExtent: itemExtent,
      controller: controller,
      cacheExtent: 200.0, // 缓存范围
      physics: const BouncingScrollPhysics(),
    );
  }

  /// 性能监控
  static void startPerformanceMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
  }

  static void stopPerformanceMonitoring() {
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
  }

  static void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan;
      
      // 如果帧时间超过16.67ms（60fps），记录性能问题
      if (frameDuration.inMicroseconds > 16670) {
        print('Performance warning: Frame took ${frameDuration.inMilliseconds}ms');
      }
    }
  }

  /// 获取性能统计
  static Map<String, dynamic> getPerformanceStats() {
    return {
      'cache_size': _cache.length,
      'active_debounce_timers': _debounceTimers.length,
      'memory_pressure': _cache.length > 50 ? 'high' : 'normal',
    };
  }
}

/// 性能优化的StatefulWidget基类
abstract class OptimizedStatefulWidget extends StatefulWidget {
  const OptimizedStatefulWidget({super.key});
}

/// 性能优化的State基类
abstract class OptimizedState<T extends OptimizedStatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  /// 防抖动的setState（已弃用，使用RenderSyncMixin代替）
  @deprecated
  void debouncedSetState(VoidCallback fn, [String? key]) {
    final debounceKey = key ?? runtimeType.toString();
    PerformanceOptimizationService.debounce(debounceKey, () {
      if (mounted) {
        setState(fn);
      }
    });
  }

  /// 批量状态更新
  void batchStateUpdate(List<VoidCallback> updates) {
    PerformanceOptimizationService.batchLayoutUpdate([
      () {
        if (mounted) {
          setState(() {
            for (final update in updates) {
              update();
            }
          });
        }
      }
    ]);
  }

  @override
  void dispose() {
    // 清理相关缓存
    PerformanceOptimizationService.clearCache(runtimeType.toString());
    super.dispose();
  }
}

/// 性能优化的布局构建器
class OptimizedLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints) builder;
  final String? cacheKey;

  const OptimizedLayoutBuilder({
    super.key,
    required this.builder,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final key = cacheKey ?? '${constraints.maxWidth}x${constraints.maxHeight}';
        
        // 尝试从缓存获取
        final cached = PerformanceOptimizationService.getCachedResult<Widget>(key);
        if (cached != null) {
          return cached;
        }

        // 构建新的widget
        final widget = builder(context, constraints);
        
        // 缓存结果
        PerformanceOptimizationService.setCachedResult(
          key, 
          widget, 
          ttl: const Duration(seconds: 30)
        );
        
        return widget;
      },
    );
  }
}

/// 性能优化的动画控制器
class OptimizedAnimationController extends AnimationController {
  OptimizedAnimationController({
    required super.vsync,
    super.duration,
    super.debugLabel,
  });

  /// 智能动画 - 根据性能自动调整
  void smartAnimate({
    required double target,
    Duration? duration,
  }) {
    final stats = PerformanceOptimizationService.getPerformanceStats();
    final isHighMemoryPressure = stats['memory_pressure'] == 'high';
    
    // 如果内存压力大，减少动画时长
    final adjustedDuration = isHighMemoryPressure 
        ? (duration ?? this.duration!) * 0.5
        : duration ?? this.duration!;
    
    animateTo(target, duration: adjustedDuration);
  }
}