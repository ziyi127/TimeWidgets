import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:time_widgets/utils/logger.dart';

/// 性能优化服务
/// 提供布局计算优化、重绘减少和内存管理
class PerformanceOptimizationService {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, Timer> _debounceTimers = {};
  static Timer? _memoryMonitorTimer;
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

  /// 防抖动执�?
  static void debounce(String key, VoidCallback callback) {
    // 取消之前的定时器
    _debounceTimers[key]?.cancel();
    
    // 设置新的定时�?
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
    // 检查缓�?
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
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // 清理过期缓存
      _cleanupExpiredCache();
      
      // 如果缓存过大，清理一些旧条目
      if (_cache.length > 50) {
        final keysToRemove = _cache.keys.take(20).toList();
        for (final key in keysToRemove) {
          _cache.remove(key);
        }
      }
    });
  }

  /// 停止内存监控
  static void stopMemoryMonitoring() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;
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

  /// 虚拟化列�?
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
      cacheExtent: 200, // 缓存范围
      physics: const BouncingScrollPhysics(),
    );
  }

  // 性能监控统计
  static final Map<String, int> _apiCallCounts = {};
  static final Map<String, List<int>> _apiCallDurations = {};
  static final List<int> _frameDurations = [];
  static const int _maxFrameSamples = 50;

  /// 性能监控
  static void startPerformanceMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    Logger.i('Performance monitoring started');
  }

  static void stopPerformanceMonitoring() {
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    Logger.i('Performance monitoring stopped');
  }

  static void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan.inMicroseconds;
      
      // 存储帧时间样本
      _frameDurations.add(frameDuration);
      if (_frameDurations.length > _maxFrameSamples) {
        _frameDurations.removeAt(0);
      }
      
      // 如果帧时间超�?6.67ms�?0fps），记录性能问题
      if (frameDuration > 16670) {
        Logger.w('Performance warning: Frame took ${frameDuration / 1000}ms');
      }
    }
  }

  /// 记录API调用开始
  static Map<String, dynamic> startApiCall(String endpoint) {
    if (_apiCallCounts.length > 50 && !_apiCallCounts.containsKey(endpoint)) {
      // 简单的清理策略：清理最早添加的或者随机清理
      _apiCallCounts.remove(_apiCallCounts.keys.first);
    }
    _apiCallCounts[endpoint] = (_apiCallCounts[endpoint] ?? 0) + 1;
    return {'startTime': DateTime.now().millisecondsSinceEpoch, 'endpoint': endpoint};
  }

  /// 记录API调用结束
  static void endApiCall(Map<String, dynamic> callContext) {
    final endpoint = callContext['endpoint'] as String;
    final startTime = callContext['startTime'] as int;
    final duration = DateTime.now().millisecondsSinceEpoch - startTime;
    
    _apiCallDurations.putIfAbsent(endpoint, () => []);
    _apiCallDurations[endpoint]!.add(duration);
    
    // 限制每个端点的样本数量
    if (_apiCallDurations[endpoint]!.length > 20) {
      _apiCallDurations[endpoint]!.removeAt(0);
    }
    
    // 如果API调用时间超过1秒，记录警告
    if (duration > 1000) {
      Logger.w('Slow API call: $endpoint took ${duration}ms');
    }
  }

  /// 获取性能统计
  static Map<String, dynamic> getPerformanceStats() {
    // 计算平均帧时间
    final avgFrameTime = _frameDurations.isNotEmpty
        ? _frameDurations.reduce((a, b) => a + b) / _frameDurations.length
        : 0;
    
    // 计算帧率
    final fps = avgFrameTime > 0 ? (1000000 / avgFrameTime).floor() : 0;
    
    // 计算API调用统计
    final apiStats = <String, dynamic>{};
    for (final endpoint in _apiCallDurations.keys) {
      final durations = _apiCallDurations[endpoint]!;
      final avgDuration = durations.reduce((a, b) => a + b) / durations.length;
      final maxDuration = durations.reduce((a, b) => a > b ? a : b);
      
      apiStats[endpoint] = {
        'count': _apiCallCounts[endpoint] ?? 0,
        'avg_duration': avgDuration,
        'max_duration': maxDuration,
        'samples': durations.length,
      };
    }
    
    return {
      'cache_size': _cache.length,
      'active_debounce_timers': _debounceTimers.length,
      'memory_pressure': _cache.length > 50 ? 'high' : 'normal',
      'fps': fps,
      'avg_frame_time': avgFrameTime / 1000, // 转换为ms
      'frame_samples': _frameDurations.length,
      'api_calls': _apiCallCounts,
      'api_stats': apiStats,
    };
  }

  /// 重置性能统计
  static void resetPerformanceStats() {
    _apiCallCounts.clear();
    _apiCallDurations.clear();
    _frameDurations.clear();
  }

  /// 输出性能报告
  static void logPerformanceReport() {
    final stats = getPerformanceStats();
    Logger.i('=== Performance Report ===');
    Logger.i('Cache Size: ${stats['cache_size']}');
    Logger.i('Active Debounce Timers: ${stats['active_debounce_timers']}');
    Logger.i('Memory Pressure: ${stats['memory_pressure']}');
    Logger.i('FPS: ${stats['fps']}');
    Logger.i('Average Frame Time: ${stats['avg_frame_time']}ms');
    
    if (stats['api_calls'] != null && (stats['api_calls'] as Map).isNotEmpty) {
      Logger.i('\nAPI Call Statistics:');
      final apiStats = stats['api_stats'] as Map;
      for (final entry in apiStats.entries) {
        final endpoint = entry.key;
        final endpointStats = entry.value as Map;
        Logger.i('$endpoint: ${endpointStats['count']} calls, ${endpointStats['avg_duration']}ms avg, ${endpointStats['max_duration']}ms max');
      }
    }
    Logger.i('=========================');
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
  @Deprecated('Use RenderSyncMixin instead')
  void debouncedSetState(VoidCallback fn, [String? key]) {
    final debounceKey = key ?? runtimeType.toString();
    PerformanceOptimizationService.debounce(debounceKey, () {
      if (mounted) {
        setState(fn);
      }
    });
  }

  /// 批量状态更�?
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

/// 性能优化的布局构建�?
class OptimizedLayoutBuilder extends StatelessWidget {

  const OptimizedLayoutBuilder({
    super.key,
    required this.builder,
    this.cacheKey,
  });
  final Widget Function(BuildContext, BoxConstraints) builder;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final key = cacheKey ?? '${constraints.maxWidth}x${constraints.maxHeight}';
        
        // 尝试从缓存获�?
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
          ttl: const Duration(seconds: 30),
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
    final cpuUsage = double.tryParse(stats['cpu_usage']?.toString() ?? '0') ?? 0;
    
    // 根据内存压力和CPU使用率调整动画时长
    double scaleFactor = 1;
    
    if (isHighMemoryPressure) {
      scaleFactor = 0.6; // 高内存压力下减少40%
    } else if (cpuUsage > 80) {
      scaleFactor = 0.7; // 高CPU使用率下减少30%
    } else if (cpuUsage > 60) {
      scaleFactor = 0.85; // 中等CPU使用率下减少15%
    }
    
    final originalDuration = duration ?? this.duration ?? const Duration(milliseconds: 300);
    final adjustedDuration = originalDuration * scaleFactor;
    
    animateTo(target, duration: adjustedDuration);
  }
}

/// 动画性能监控工具
class AnimationPerformanceMonitor {
  /// 记录动画开始时间
  static final Map<String, int> _animationStartTimes = {};
  
  /// 记录动画帧时间
  static final Map<String, List<int>> _animationFrameTimes = {};
  
  /// 开始监控动画性能
  static void startMonitoring(String animationId) {
    _animationStartTimes[animationId] = DateTime.now().millisecondsSinceEpoch;
    _animationFrameTimes[animationId] = [];
  }
  
  /// 记录动画帧时间
  static void recordFrame(String animationId, int frameTime) {
    if (_animationFrameTimes.containsKey(animationId)) {
      _animationFrameTimes[animationId]!.add(frameTime);
    }
  }
  
  /// 结束监控并获取动画性能统计
  static Map<String, dynamic> stopMonitoring(String animationId) {
    if (!_animationStartTimes.containsKey(animationId)) {
      return {};
    }
    
    final startTime = _animationStartTimes[animationId]!;
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final totalDuration = endTime - startTime;
    
    final frameTimes = _animationFrameTimes[animationId] ?? [];
    double avgFrameTime = 0;
    if (frameTimes.isNotEmpty) {
      final sum = frameTimes.reduce((a, b) => a + b);
      avgFrameTime = sum / frameTimes.length;
    }
    
    final fps = frameTimes.isNotEmpty ? (1000 / avgFrameTime).round() : 0;
    
    // 清理临时数据
    _animationStartTimes.remove(animationId);
    _animationFrameTimes.remove(animationId);
    
    return {
      'total_duration': totalDuration,
      'frame_count': frameTimes.length,
      'avg_frame_time': avgFrameTime,
      'fps': fps,
      'jank_count': frameTimes.where((time) => time > 16).length, // 超过16ms视为卡顿
    };
  }
}
