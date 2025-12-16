import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';

/// 增强的小组件渲染器
/// 提供统一的桌面小组件渲染和样式管理，支持同步渲染和性能优化
/// 包含装饰缓存、组件缓存和响应式设计支持
class EnhancedWidgetRenderer {
  /// 装饰缓存，避免重复创建相同的装饰样式
  /// 键值格式: 'widgetType_isEditMode_isCompact_colorSchemeHashCode'
  static final Map<String, BoxDecoration> _decorationCache = {};
  
  /// 组件缓存，避免重复渲染相同的静态组件
  /// 键值格式: 'widgetType_responsive_widthxheight_isEditMode_isCompact'
  static final Map<String, Widget> _widgetCache = {};
  /// 渲染桌面小组件容器（优化版本）
  /// 负责创建具有统一样式和交互行为的桌面小组件容器
  /// 支持编辑模式、紧凑模式和点击事件
  static Widget renderDesktopWidget({
    required BuildContext context,
    required Widget child,
    required WidgetType type,
    bool isEditMode = false,
    bool isCompact = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 生成缓存键，确保相同配置的装饰只创建一次
    final cacheKey = '${type.name}_${isEditMode}_${isCompact}_${colorScheme.hashCode}';
    
    // 从缓存获取或创建新的装饰样式
    final decoration = _getOrCreateDecoration(
      cacheKey,
      colorScheme,
      type,
      isEditMode,
      isCompact,
    );
    
    // 使用RepaintBoundary优化重绘性能
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(isCompact ? 8.0 : 12.0),
        child: Container(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isCompact ? 8.0 : 12.0),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// 渲染响应式小组件（性能优化版本）
  /// 根据容器尺寸自动调整小组件布局和样式
  /// 包含组件缓存机制，避免重复渲染相同配置的静态组件
  static Widget renderResponsiveWidget({
    required BuildContext context,
    required Widget child,
    required Size containerSize,
    required WidgetType type,
    bool isEditMode = false,
    VoidCallback? onTap,
  }) {
    // 根据容器尺寸决定是否使用紧凑模式（宽度<300或高度<600时启用）
    final isCompact = containerSize.width < 300 || containerSize.height < 600;
    
    // 生成响应式缓存键，包含组件类型、尺寸、编辑模式和紧凑模式信息
    final responsiveCacheKey = '${type.name}_responsive_${containerSize.width.toInt()}x${containerSize.height.toInt()}_${isEditMode}_$isCompact';
    
    // 检查缓存中是否存在相同配置的组件
    if (_widgetCache.containsKey(responsiveCacheKey)) {
      final cachedWidget = _widgetCache[responsiveCacheKey];
      if (cachedWidget != null) {
        return cachedWidget;
      }
    }
    
    // 创建新的响应式组件，使用RepaintBoundary优化重绘性能
    final widget = RepaintBoundary(
      child: renderDesktopWidget(
        context: context,
        child: child,
        type: type,
        isEditMode: isEditMode,
        isCompact: isCompact,
        onTap: onTap,
      ),
    );
    
    // 仅缓存静态内容（非编辑模式且无点击事件）
    if (!isEditMode && onTap == null) {
      _widgetCache[responsiveCacheKey] = widget;
      
      // 限制缓存大小，最多保留50个组件，超出则移除最旧的缓存
      if (_widgetCache.length > 50) {
        final oldestKey = _widgetCache.keys.first;
        _widgetCache.remove(oldestKey);
      }
    }
    
    return widget;
  }

  /// 渲染编辑模式指示器
  /// 在编辑模式下显示在小组件右上角的拖拽图标
  /// 用于指示小组件当前处于可编辑状态
  static Widget renderEditModeIndicator({
    required BuildContext context,
    required WidgetType type,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.drag_handle_rounded,
          color: colorScheme.onPrimary,
          size: 16,
        ),
      ),
    );
  }

  /// 渲染拖拽反馈
  /// 当用户拖拽小组件时显示的视觉反馈效果
  /// 具有半透明效果、主色调边框和增强的阴影
  static Widget renderDragFeedback({
    required BuildContext context,
    required Widget child,
    required Size size,
    required WidgetType type,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Material(
      color: Colors.transparent,
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          // 获取组件背景色并设置半透明效果
          color: _getWidgetBackgroundColor(colorScheme, type, true).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          // 添加主色调边框，指示拖拽状态
          border: Border.all(
            color: colorScheme.primary,
            width: 2,
          ),
          // 增强阴影效果，提升视觉层次感
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        // 降低子组件不透明度，区分拖拽状态
        child: Opacity(
          opacity: 0.8,
          child: child,
        ),
      ),
    );
  }

  /// 渲染拖拽占位符
  /// 在拖拽过程中显示的空白占位区域
  /// 用于指示小组件可以放置的位置
  static Widget renderDragPlaceholder({
    required BuildContext context,
    required Size size,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        // 使用半透明背景色，保持视觉轻盈
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        // 添加内边框，指示放置区域
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.drag_indicator_rounded,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          size: 32,
        ),
      ),
    );
  }

  /// 获取或创建装饰样式（带缓存机制）
  /// 从缓存中获取已存在的装饰样式，或创建新的装饰样式并缓存
  /// 
  /// 参数：
  /// - cacheKey: 用于缓存查找的唯一键值
  /// - colorScheme: 主题色彩方案
  /// - type: 小组件类型
  /// - isEditMode: 是否处于编辑模式
  /// - isCompact: 是否使用紧凑模式
  /// 
  /// 返回：
  /// - 适配当前配置的BoxDecoration对象
  static BoxDecoration _getOrCreateDecoration(
    String cacheKey,
    ColorScheme colorScheme,
    WidgetType type,
    bool isEditMode,
    bool isCompact,
  ) {
    // 检查缓存中是否已存在相同配置的装饰样式
    if (_decorationCache.containsKey(cacheKey)) {
      return _decorationCache[cacheKey]!;
    }
    
    // 创建新的装饰样式
    final decoration = BoxDecoration(
      color: _getWidgetBackgroundColor(colorScheme, type, isEditMode),
      borderRadius: BorderRadius.circular(isCompact ? 8.0 : 12.0),
      // 根据编辑模式使用不同的边框样式
      border: isEditMode 
          ? Border.all(
              color: colorScheme.primary.withValues(alpha: 0.6),
              width: 2.0,
            )
          : Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1.0,
            ),
      boxShadow: _getWidgetShadow(colorScheme, isEditMode),
    );
    
    // 将新创建的装饰样式添加到缓存中
    _decorationCache[cacheKey] = decoration;
    
    // 限制装饰缓存大小，最多保留100个样式，超出则移除最旧的缓存
    if (_decorationCache.length > 100) {
      final oldestKey = _decorationCache.keys.first;
      _decorationCache.remove(oldestKey);
    }
    
    return decoration;
  }

  /// 获取小组件背景颜色
  /// 根据小组件类型和模式返回相应的背景颜色
  /// 
  /// 参数：
  /// - colorScheme: 主题色彩方案
  /// - type: 小组件类型
  /// - isEditMode: 是否处于编辑模式
  /// 
  /// 返回：
  /// - 适配当前配置的背景颜色，带有适当的透明度
  static Color _getWidgetBackgroundColor(
    ColorScheme colorScheme, 
    WidgetType type, 
    bool isEditMode
  ) {
    // 编辑模式下使用主色调容器色
    if (isEditMode) {
      return colorScheme.primaryContainer.withValues(alpha: 0.95);
    }
    
    // 根据不同的小组件类型返回不同的背景色
    switch (type) {
      case WidgetType.time:
      case WidgetType.date:
      case WidgetType.weather:
      case WidgetType.countdown:
        return colorScheme.surfaceContainer.withValues(alpha: 0.95);
        
      case WidgetType.week:
      case WidgetType.timetable:
        return colorScheme.surfaceContainerHighest.withValues(alpha: 0.95);
        
      case WidgetType.currentClass:
        return colorScheme.primaryContainer.withValues(alpha: 0.9);
        
      case WidgetType.settings:
        return colorScheme.surface.withValues(alpha: 0.95);
    }
  }

  /// 获取小组件阴影
  /// 根据模式返回相应的阴影效果
  /// 
  /// 参数：
  /// - colorScheme: 主题色彩方案
  /// - isEditMode: 是否处于编辑模式
  /// 
  /// 返回：
  /// - 适配当前模式的阴影列表
  static List<BoxShadow> _getWidgetShadow(ColorScheme colorScheme, bool isEditMode) {
    // 编辑模式下使用主色调阴影，增强视觉突出效果
    if (isEditMode) {
      return [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    
    // 普通模式下使用双层阴影，增强深度感
    return [
      // 内层阴影：小模糊半径，近偏移
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.08),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
      // 外层阴影：大模糊半径，远偏移
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// 创建响应式文本样式
  /// 根据容器尺寸自动调整字体大小，保持文本可读性
  /// 
  /// 参数：
  /// - context: 构建上下文
  /// - baseStyle: 基础文本样式
  /// - containerSize: 容器尺寸
  /// - minFontSize: 最小字体大小（可选，默认10.0）
  /// - maxFontSize: 最大字体大小（可选，默认24.0）
  /// 
  /// 返回：
  /// - 适配容器尺寸的响应式文本样式
  static TextStyle createResponsiveTextStyle({
    required BuildContext context,
    required TextStyle baseStyle,
    required Size containerSize,
    double? minFontSize,
    double? maxFontSize,
  }) {
    // 根据容器宽度调整缩放因子
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.85; // 小容器缩小字体
    } else if (containerSize.width > 400) {
      scaleFactor = 1.1;  // 大容器放大字体
    }
    
    // 计算调整后的字体大小
    final adjustedFontSize = (baseStyle.fontSize ?? 14.0) * scaleFactor;
    // 限制字体大小在最小和最大值之间
    final clampedFontSize = adjustedFontSize.clamp(
      minFontSize ?? 10.0, 
      maxFontSize ?? 24.0
    );
    
    return baseStyle.copyWith(fontSize: clampedFontSize);
  }

  /// 创建响应式图标尺寸
  /// 根据容器尺寸自动调整图标大小
  /// 
  /// 参数：
  /// - containerSize: 容器尺寸
  /// - baseSize: 基础图标大小（默认24.0）
  /// - minSize: 最小图标大小（默认16.0）
  /// - maxSize: 最大图标大小（默认32.0）
  /// 
  /// 返回：
  /// - 适配容器尺寸的响应式图标大小
  static double createResponsiveIconSize({
    required Size containerSize,
    double baseSize = 24.0,
    double minSize = 16.0,
    double maxSize = 32.0,
  }) {
    // 根据容器宽度调整缩放因子
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.8;  // 小容器缩小图标
    } else if (containerSize.width > 400) {
      scaleFactor = 1.2;  // 大容器放大图标
    }
    
    // 计算调整后的图标大小并限制在范围内
    final adjustedSize = baseSize * scaleFactor;
    return adjustedSize.clamp(minSize, maxSize);
  }

  /// 创建响应式间距
  /// 根据容器尺寸自动调整内边距
  /// 
  /// 参数：
  /// - containerSize: 容器尺寸
  /// - basePadding: 基础内边距（默认EdgeInsets.all(16.0)）
  /// 
  /// 返回：
  /// - 适配容器尺寸的响应式内边距
  static EdgeInsets createResponsivePadding({
    required Size containerSize,
    EdgeInsets basePadding = const EdgeInsets.all(16.0),
  }) {
    // 根据容器宽度调整缩放因子
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.75; // 小容器缩小内边距
    } else if (containerSize.width > 400) {
      scaleFactor = 1.25; // 大容器放大内边距
    }
    
    // 为各个方向的内边距应用缩放因子
    return EdgeInsets.only(
      left: basePadding.left * scaleFactor,
      top: basePadding.top * scaleFactor,
      right: basePadding.right * scaleFactor,
      bottom: basePadding.bottom * scaleFactor,
    );
  }

  /// 清理所有缓存
  /// 清空装饰缓存和组件缓存，释放内存
  static void clearCache() {
    _decorationCache.clear();
    _widgetCache.clear();
  }

  /// 清理特定类型的缓存
  /// 只清理指定类型小组件的缓存，保留其他类型的缓存
  /// 
  /// 参数：
  /// - type: 要清理缓存的小组件类型
  static void clearCacheForType(WidgetType type) {
    final keysToRemove = <String>[];
    
    // 清理装饰缓存
    for (final key in _decorationCache.keys) {
      if (key.startsWith(type.name)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _decorationCache.remove(key);
    }
    
    keysToRemove.clear();
    
    // 清理组件缓存
    for (final key in _widgetCache.keys) {
      if (key.startsWith(type.name)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _widgetCache.remove(key);
    }
  }

  /// 获取缓存统计信息
  /// 返回当前缓存的大小统计
  /// 
  /// 返回：
  /// - 包含装饰缓存和组件缓存大小的映射
  static Map<String, int> getCacheStats() {
    return {
      'decoration_cache_size': _decorationCache.length,
      'widget_cache_size': _widgetCache.length,
    };
  }
}
