import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 增强的小组件包装器
/// 提供统一的MD3样式、阴影、边框和背景效果
class EnhancedWidgetWrapper extends StatefulWidget {
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
  final Widget child;
  final VoidCallback? onTap;
  final bool isInteractive;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  State<EnhancedWidgetWrapper> createState() => _EnhancedWidgetWrapperState();
}

class _EnhancedWidgetWrapperState extends State<EnhancedWidgetWrapper> {
  bool _isHovered = false;
  StreamSubscription<dynamic>? _themeSubscription;
  StreamSubscription<dynamic>? _settingsSubscription;

  @override
  void initState() {
    super.initState();
    // 监听主题设置变化，确保实时更新
    _themeSubscription = ThemeService().themeStream.listen((_) {
      if (mounted) setState(() {});
    });
    // 监听全局设置变化（如UI缩放），确保实时更新
    _settingsSubscription = SettingsService().settingsStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _themeSubscription?.cancel();
    _settingsSubscription?.cancel();
    super.dispose();
  }

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
    double width = 300; // 默认宽度
    try {
      final size = MediaQuery.sizeOf(context);
      width = size.width;
    } catch (e) {
      // 当上下文没有关联的MediaQuery时，使用默认宽度
    }

    // 获取主题设置
    final themeSettings = ThemeService().currentSettings;
    final componentOpacity = themeSettings.componentOpacity;
    final shadowStrength = themeSettings.shadowStrength;
    final enableGradients = themeSettings.enableGradients;

    // 使用Surface Variant颜色作为默认背景，带有一些透明度
    final defaultBgColor = colorScheme.surfaceContainerHighest
        .withValues(alpha: 0.6 * componentOpacity);
    final effectiveBgColor = widget.backgroundColor != null
        ? widget.backgroundColor!
            .withValues(alpha: widget.backgroundColor!.a * componentOpacity)
        : defaultBgColor;

    final effectiveBorderRadius = widget.borderRadius ??
        BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(width),
        );
    final effectivePadding =
        widget.padding ?? EdgeInsets.all(ResponsiveUtils.value(12));

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: enableGradients
            ? null
            : (_isHovered && widget.isInteractive
                ? Color.alphaBlend(colorScheme.primary.withValues(alpha: 0.08),
                    effectiveBgColor)
                : effectiveBgColor),
        gradient: enableGradients
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _isHovered && widget.isInteractive
                      ? Color.alphaBlend(
                          colorScheme.primary.withValues(alpha: 0.15),
                          effectiveBgColor)
                      : Color.alphaBlend(Colors.white.withValues(alpha: 0.1),
                          effectiveBgColor),
                  effectiveBgColor,
                ],
              )
            : null,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: _isHovered && widget.isInteractive
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: ResponsiveUtils.value(
              _isHovered && widget.isInteractive ? 1.5 : 1),
        ),
        boxShadow: (widget.elevation > 0 || _isHovered) && widget.isInteractive
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                      alpha: (_isHovered ? 0.15 : 0.1) * shadowStrength),
                  blurRadius: ResponsiveUtils.value(
                      (widget.elevation + (_isHovered ? 4 : 0)) * 2),
                  offset: Offset(
                      0,
                      ResponsiveUtils.value(
                          widget.elevation + (_isHovered ? 2 : 0))),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: effectivePadding,
          child: widget.child,
        ),
      ),
    );

    if (widget.isInteractive) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
