import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_widgets/utils/platform_utils.dart';

/// 增强版 Material Design 3 Card 样式工具类
/// 提供跨平台优化的统一 MD3 Card 样式和动画效果
class MD3EnhancedCardStyles {
  MD3EnhancedCardStyles._();

  /// 标准 Surface Container Card（带动画）
  static Widget surfaceContainer({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
    bool animate = true,
    Duration? animationDuration,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final platformStyles = PlatformUtils.getPlatformStyles();

    return AnimatedContainer(
      duration: animationDuration ?? const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(
          animate ? platformStyles.cardBorderRadius : 0,
        ),
        boxShadow: platformStyles.useElevation
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: animate ? 4 : 0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
          enableFeedback: platformStyles.useRippleEffect,
          child: Container(
            padding: padding ?? EdgeInsets.all(platformStyles.defaultPadding),
            child: child,
          ),
        ),
      ),
    );
  }

  /// 带悬停效果的 Card
  static Widget hoverEffectCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    Color? hoverColor,
  }) {
    return _HoverEffectCard(
      context: context,
      padding: padding,
      onTap: onTap,
      hoverColor: hoverColor,
      child: child,
    );
  }

  /// 带缩放点击效果的 Card
  static Widget scaleOnTapCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return _ScaleOnTapCard(
      context: context,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// 渐变背景 Card
  static Widget gradientCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    List<Color>? gradientColors,
    LinearGradient? gradient,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final platformStyles = PlatformUtils.getPlatformStyles();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
        child: Container(
          padding: padding ?? EdgeInsets.all(platformStyles.defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors ??
                      [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// 毛玻璃效果 Card（仅支持的平台）
  static Widget glassmorphismCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double blur = 10.0,
    Color? color,
  }) {
    final platformStyles = PlatformUtils.getPlatformStyles();
    
    // 仅在不支持透明效果的平台降级为标准 Card
    if (!PlatformUtils.supportsTransparency) {
      return surfaceContainer(
        context: context,
        child: child,
        padding: padding,
        onTap: onTap,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? EdgeInsets.all(platformStyles.defaultPadding),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 悬停效果 Card 组件
class _HoverEffectCard extends StatefulWidget {

  const _HoverEffectCard({
    required this.context,
    required this.child,
    this.padding,
    this.onTap,
    this.hoverColor,
  });
  final BuildContext context;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? hoverColor;

  @override
  State<_HoverEffectCard> createState() => _HoverEffectCardState();
}

class _HoverEffectCardState extends State<_HoverEffectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(widget.context);
    final colorScheme = theme.colorScheme;
    final platformStyles = PlatformUtils.getPlatformStyles();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.hoverColor ?? colorScheme.surfaceContainerHighest)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
          boxShadow: platformStyles.useElevation
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.05),
                    blurRadius: _isHovered ? 8 : 4,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
            child: Container(
              padding: widget.padding ?? EdgeInsets.all(platformStyles.defaultPadding),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 缩放点击效果 Card 组件
class _ScaleOnTapCard extends StatefulWidget {

  const _ScaleOnTapCard({
    required this.context,
    required this.child,
    this.padding,
    this.onTap,
  });
  final BuildContext context;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<_ScaleOnTapCard> createState() => _ScaleOnTapCardState();
}

class _ScaleOnTapCardState extends State<_ScaleOnTapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(widget.context);
    final colorScheme = theme.colorScheme;
    final platformStyles = PlatformUtils.getPlatformStyles();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(platformStyles.cardBorderRadius),
          ),
          padding: widget.padding ?? EdgeInsets.all(platformStyles.defaultPadding),
          child: widget.child,
        ),
      ),
    );
  }
}
