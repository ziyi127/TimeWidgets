import 'package:flutter/material.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 增强的小组件包装器
/// 提供统一的MD3样式、阴影、边框和背景效果
class EnhancedWidgetWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const EnhancedWidgetWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.isInteractive = true,
    this.backgroundColor,
    this.elevation = 0,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // 使用默认主题作为回退
    final defaultTheme = ThemeData();
    final defaultColorScheme = defaultTheme.colorScheme;
    
    // 获取主题，添加空值检查
    late ThemeData theme;
    late ColorScheme colorScheme;
    
    try {
      theme = Theme.of(context);
      colorScheme = theme.colorScheme;
    } catch (e) {
      // 当上下文没有关联的Theme时，使用默认主题
      theme = defaultTheme;
      colorScheme = defaultColorScheme;
    }
    
    // 获取MediaQuery尺寸，添加空值检查
    double width = 300.0; // 默认宽度
    try {
      final size = MediaQuery.sizeOf(context);
      width = size.width;
    } catch (e) {
      // 当上下文没有关联的MediaQuery时，使用默认宽度
    }
    
    // 使用Surface Variant颜色作为默认背景，带有一些透明度
    final defaultBgColor = colorScheme.surfaceContainerHighest.withAlpha((255 * 0.6).round());
    final effectiveBgColor = backgroundColor ?? defaultBgColor;
    
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(
      ResponsiveUtils.getBorderRadius(width, baseRadius: 16)
    );
    final effectivePadding = padding ?? EdgeInsets.all(ResponsiveUtils.value(12));

    Widget content = Container(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha((255 * 0.5).round()),
          width: ResponsiveUtils.value(1),
        ),
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((255 * 0.1).round()),
            blurRadius: ResponsiveUtils.value(elevation * 2),
            offset: Offset(0, ResponsiveUtils.value(elevation)),
          )
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );

    if (isInteractive && onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: content,
      );
    }

    return content;
  }
}
