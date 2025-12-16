import 'package:flutter/material.dart';

/// 增强的小组件包装器
/// 提供统一的MD3样式、阴影、边框和背景效果
class EnhancedWidgetWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const EnhancedWidgetWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.isInteractive = true,
    this.backgroundColor,
    this.elevation = 0,
    this.borderRadius,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 使用Surface Variant颜色作为默认背景，带有一些透明度
    final defaultBgColor = colorScheme.surfaceContainerHighest.withAlpha((255 * 0.6).round());
    final effectiveBgColor = backgroundColor ?? defaultBgColor;
    
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);

    Widget content = Container(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha((255 * 0.5).round()),
          width: 1,
        ),
        boxShadow: elevation > 0 ? [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((255 * 0.1).round()),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          )
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: padding,
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
