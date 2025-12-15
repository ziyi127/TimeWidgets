import 'package:flutter/material.dart';

/// Material Design 3 Card 样式工具�?
/// 提供统一�?MD3 Card 样式和变�?
class MD3CardStyles {
  /// 标准 Surface Container Card
  /// 用于大多数内容卡�?
  static Widget surfaceContainer({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 0,
      color: colorScheme.surfaceContainer,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Surface Container Highest Card
  /// 用于需要更高对比度的卡�?
  static Widget surfaceContainerHighest({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 1,
      color: colorScheme.surfaceContainerHighest,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Primary Container Card
  /// 用于主要内容或强调的卡片
  static Widget primaryContainer({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 0,
      color: colorScheme.primaryContainer,
      surfaceTintColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Error Container Card
  /// 用于错误状态的卡片
  static Widget errorContainer({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 0,
      color: colorScheme.errorContainer,
      surfaceTintColor: colorScheme.error,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Outlined Card
  /// 带边框的卡片，用于需要明确边界的内容
  static Widget outlined({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    Color? borderColor,
    double? borderWidth,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor ?? colorScheme.outline,
          width: borderWidth ?? 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Elevated Card
  /// 带阴影的卡片，用于需要浮起效果的内容
  static Widget elevated({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? elevation,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 1,
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  /// Compact Card
  /// 紧凑型卡片，用于空间有限的场�?
  static Widget compact({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: backgroundColor ?? colorScheme.surfaceContainer,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }

  /// 获取 MD3 标准间距
  static EdgeInsets getStandardPadding(bool isCompact) {
    return EdgeInsets.all(isCompact ? 12.0 : 16.0);
  }

  /// 获取 MD3 标准圆角
  static BorderRadius getStandardBorderRadius(bool isCompact) {
    return BorderRadius.circular(isCompact ? 8.0 : 12.0);
  }

  /// 获取 MD3 标准阴影
  static double getStandardElevation(bool isElevated) {
    return isElevated ? 1.0 : 0.0;
  }
}

/// MD3 Card 变体枚举
enum MD3CardVariant {
  surfaceContainer,
  surfaceContainerHighest,
  primaryContainer,
  errorContainer,
  outlined,
  elevated,
  compact,
}

/// MD3 Card Builder
/// 提供更灵活的 Card 构建方式
class MD3CardBuilder {
  final BuildContext context;
  final Widget child;
  
  MD3CardVariant _variant = MD3CardVariant.surfaceContainer;
  EdgeInsetsGeometry? _padding;
  VoidCallback? _onTap;
  double? _elevation;
  Color? _backgroundColor;
  Color? _borderColor;
  double? _borderWidth;

  MD3CardBuilder({
    required this.context,
    required this.child,
  });

  MD3CardBuilder variant(MD3CardVariant variant) {
    _variant = variant;
    return this;
  }

  MD3CardBuilder padding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  MD3CardBuilder onTap(VoidCallback onTap) {
    _onTap = onTap;
    return this;
  }

  MD3CardBuilder elevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  MD3CardBuilder backgroundColor(Color color) {
    _backgroundColor = color;
    return this;
  }

  MD3CardBuilder border({Color? color, double? width}) {
    _borderColor = color;
    _borderWidth = width;
    return this;
  }

  // Note: compact method removed as _isCompact field is not used in build()

  Widget build() {
    switch (_variant) {
      case MD3CardVariant.surfaceContainer:
        return MD3CardStyles.surfaceContainer(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          elevation: _elevation,
        );
      case MD3CardVariant.surfaceContainerHighest:
        return MD3CardStyles.surfaceContainerHighest(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          elevation: _elevation,
        );
      case MD3CardVariant.primaryContainer:
        return MD3CardStyles.primaryContainer(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          elevation: _elevation,
        );
      case MD3CardVariant.errorContainer:
        return MD3CardStyles.errorContainer(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          elevation: _elevation,
        );
      case MD3CardVariant.outlined:
        return MD3CardStyles.outlined(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          borderColor: _borderColor,
          borderWidth: _borderWidth,
        );
      case MD3CardVariant.elevated:
        return MD3CardStyles.elevated(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          elevation: _elevation,
        );
      case MD3CardVariant.compact:
        return MD3CardStyles.compact(
          context: context,
          child: child,
          padding: _padding,
          onTap: _onTap,
          backgroundColor: _backgroundColor,
        );
    }
  }
}
