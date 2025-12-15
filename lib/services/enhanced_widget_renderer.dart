import 'package:flutter/material.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/render_sync_service.dart';

/// 增强的小组件渲染器
/// 提供统一的桌面小组件渲染和样式管理，支持同步渲染和性能优化
class EnhancedWidgetRenderer {
  // 静态缓存，避免重复创建相同的装饰
  static final Map<String, BoxDecoration> _decorationCache = {};
  static final Map<String, Widget> _widgetCache = {};
  /// 渲染桌面小组件容器（优化版本）
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
    
    // 生成缓存键
    final cacheKey = '${type.name}_${isEditMode}_${isCompact}_${colorScheme.hashCode}';
    
    // 尝试从缓存获取装饰
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
  static Widget renderResponsiveWidget({
    required BuildContext context,
    required Widget child,
    required Size containerSize,
    required WidgetType type,
    bool isEditMode = false,
    VoidCallback? onTap,
  }) {
    // 根据容器尺寸决定是否使用紧凑模式
    final isCompact = containerSize.width < 300 || containerSize.height < 600;
    
    // 生成响应式缓存键
    final responsiveCacheKey = '${type.name}_responsive_${containerSize.width.toInt()}x${containerSize.height.toInt()}_${isEditMode}_${isCompact}';
    
    // 检查缓存
    if (_widgetCache.containsKey(responsiveCacheKey)) {
      final cachedWidget = _widgetCache[responsiveCacheKey];
      if (cachedWidget != null) {
        return cachedWidget;
      }
    }
    
    // 创建新的widget
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
    
    // 缓存widget（仅缓存静态内容）
    if (!isEditMode && onTap == null) {
      _widgetCache[responsiveCacheKey] = widget;
      
      // 限制缓存大小
      if (_widgetCache.length > 50) {
        final oldestKey = _widgetCache.keys.first;
        _widgetCache.remove(oldestKey);
      }
    }
    
    return widget;
  }

  /// 渲染编辑模式指示器
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
          color: _getWidgetBackgroundColor(colorScheme, type, true).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Opacity(
          opacity: 0.8,
          child: child,
        ),
      ),
    );
  }

  /// 渲染拖拽占位符
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
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
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

  /// 获取或创建装饰（带缓存）
  static BoxDecoration _getOrCreateDecoration(
    String cacheKey,
    ColorScheme colorScheme,
    WidgetType type,
    bool isEditMode,
    bool isCompact,
  ) {
    if (_decorationCache.containsKey(cacheKey)) {
      return _decorationCache[cacheKey]!;
    }
    
    final decoration = BoxDecoration(
      color: _getWidgetBackgroundColor(colorScheme, type, isEditMode),
      borderRadius: BorderRadius.circular(isCompact ? 8.0 : 12.0),
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
    
    _decorationCache[cacheKey] = decoration;
    
    // 限制缓存大小
    if (_decorationCache.length > 100) {
      final oldestKey = _decorationCache.keys.first;
      _decorationCache.remove(oldestKey);
    }
    
    return decoration;
  }

  /// 获取小组件背景颜色
  static Color _getWidgetBackgroundColor(
    ColorScheme colorScheme, 
    WidgetType type, 
    bool isEditMode
  ) {
    if (isEditMode) {
      return colorScheme.primaryContainer.withValues(alpha: 0.95);
    }
    
    switch (type) {
      case WidgetType.time:
        return colorScheme.surfaceContainer.withValues(alpha: 0.95);
      case WidgetType.date:
        return colorScheme.surfaceContainer.withValues(alpha: 0.95);
      case WidgetType.week:
        return colorScheme.surfaceContainerHighest.withValues(alpha: 0.95);
      case WidgetType.weather:
        return colorScheme.surfaceContainer.withValues(alpha: 0.95);
      case WidgetType.currentClass:
        return colorScheme.primaryContainer.withValues(alpha: 0.9);
      case WidgetType.countdown:
        return colorScheme.surfaceContainer.withValues(alpha: 0.95);
      case WidgetType.timetable:
        return colorScheme.surfaceContainerHighest.withValues(alpha: 0.95);
      case WidgetType.settings:
        return colorScheme.surface.withValues(alpha: 0.95);
    }
  }

  /// 获取小组件阴影
  static List<BoxShadow> _getWidgetShadow(ColorScheme colorScheme, bool isEditMode) {
    if (isEditMode) {
      return [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    
    return [
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.08),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// 包装内容以处理溢出
  static Widget _wrapWithOverflowHandling(Widget child, BoxConstraints constraints) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: OverflowBox(
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
        child: child,
      ),
    );
  }

  /// 创建响应式文本样式
  static TextStyle createResponsiveTextStyle({
    required BuildContext context,
    required TextStyle baseStyle,
    required Size containerSize,
    double? minFontSize,
    double? maxFontSize,
  }) {
    final theme = Theme.of(context);
    
    // 根据容器尺寸调整字体大小
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.85;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.1;
    }
    
    final adjustedFontSize = (baseStyle.fontSize ?? 14.0) * scaleFactor;
    final clampedFontSize = adjustedFontSize.clamp(
      minFontSize ?? 10.0, 
      maxFontSize ?? 24.0
    );
    
    return baseStyle.copyWith(fontSize: clampedFontSize);
  }

  /// 创建响应式图标尺寸
  static double createResponsiveIconSize({
    required Size containerSize,
    double baseSize = 24.0,
    double minSize = 16.0,
    double maxSize = 32.0,
  }) {
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.8;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.2;
    }
    
    final adjustedSize = baseSize * scaleFactor;
    return adjustedSize.clamp(minSize, maxSize);
  }

  /// 创建响应式间距
  static EdgeInsets createResponsivePadding({
    required Size containerSize,
    EdgeInsets basePadding = const EdgeInsets.all(16.0),
  }) {
    double scaleFactor = 1.0;
    
    if (containerSize.width < 300) {
      scaleFactor = 0.75;
    } else if (containerSize.width > 400) {
      scaleFactor = 1.25;
    }
    
    return EdgeInsets.only(
      left: basePadding.left * scaleFactor,
      top: basePadding.top * scaleFactor,
      right: basePadding.right * scaleFactor,
      bottom: basePadding.bottom * scaleFactor,
    );
  }

  /// 清理缓存
  static void clearCache() {
    _decorationCache.clear();
    _widgetCache.clear();
  }

  /// 清理特定类型的缓存
  static void clearCacheForType(WidgetType type) {
    final keysToRemove = <String>[];
    
    for (final key in _decorationCache.keys) {
      if (key.startsWith(type.name)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _decorationCache.remove(key);
    }
    
    keysToRemove.clear();
    
    for (final key in _widgetCache.keys) {
      if (key.startsWith(type.name)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _widgetCache.remove(key);
    }
  }

  /// 获取缓存统计
  static Map<String, int> getCacheStats() {
    return {
      'decoration_cache_size': _decorationCache.length,
      'widget_cache_size': _widgetCache.length,
    };
  }
}