import 'package:flutter/material.dart';

/// Material Design 3 Button 样式工具�?
/// 提供统一�?MD3 Button 样式和变�?
class MD3ButtonStyles {
  /// Filled Button (主要按钮)
  /// 用于最重要的操�?
  static Widget filled({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool isCompact = false,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: style ?? _getFilledButtonStyle(isCompact),
      child: child,
    );
  }

  /// Filled Tonal Button (次要强调按钮)
  /// 用于重要但不是最主要的操�?
  static Widget filledTonal({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool isCompact = false,
  }) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: style ?? _getFilledTonalButtonStyle(isCompact),
      child: child,
    );
  }

  /// Outlined Button (边框按钮)
  /// 用于次要操作
  static Widget outlined({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool isCompact = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style ?? _getOutlinedButtonStyle(isCompact),
      child: child,
    );
  }

  /// Text Button (文本按钮)
  /// 用于最低优先级的操�?
  static Widget text({
    required VoidCallback? onPressed,
    required Widget child,
    ButtonStyle? style,
    bool isCompact = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: style ?? _getTextButtonStyle(isCompact),
      child: child,
    );
  }

  /// Icon Button (图标按钮)
  /// 用于工具栏和操作�?
  static Widget icon({
    required VoidCallback? onPressed,
    required Widget icon,
    ButtonStyle? style,
    String? tooltip,
    bool isCompact = false,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: style ?? _getIconButtonStyle(isCompact),
      tooltip: tooltip,
    );
  }

  /// Filled Icon Button (填充图标按钮)
  /// 用于需要强调的图标操作
  static Widget iconFilled({
    required VoidCallback? onPressed,
    required Widget icon,
    ButtonStyle? style,
    String? tooltip,
    bool isCompact = false,
  }) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: icon,
      style: style ?? _getFilledIconButtonStyle(isCompact),
      tooltip: tooltip,
    );
  }

  /// Filled Tonal Icon Button (填充色调图标按钮)
  /// 用于需要中等强调的图标操作
  static Widget iconFilledTonal({
    required VoidCallback? onPressed,
    required Widget icon,
    ButtonStyle? style,
    String? tooltip,
    bool isCompact = false,
  }) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: icon,
      style: style ?? _getFilledTonalIconButtonStyle(isCompact),
      tooltip: tooltip,
    );
  }

  /// Outlined Icon Button (边框图标按钮)
  /// 用于需要边界的图标操作
  static Widget iconOutlined({
    required VoidCallback? onPressed,
    required Widget icon,
    ButtonStyle? style,
    String? tooltip,
    bool isCompact = false,
  }) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: icon,
      style: style ?? _getOutlinedIconButtonStyle(isCompact),
      tooltip: tooltip,
    );
  }

  /// Floating Action Button (浮动操作按钮)
  /// 用于主要的浮动操�?
  static Widget fab({
    required VoidCallback? onPressed,
    required Widget child,
    String? tooltip,
    bool isExtended = false,
    bool isSmall = false,
  }) {
    if (isExtended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        label: child,
        tooltip: tooltip,
      );
    } else if (isSmall) {
      return FloatingActionButton.small(
        onPressed: onPressed,
        tooltip: tooltip,
        child: child,
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: child,
      );
    }
  }

  // 私有方法：获取各种按钮样�?

  static ButtonStyle _getFilledButtonStyle(bool isCompact) {
    return FilledButton.styleFrom(
      minimumSize: Size(isCompact ? 64 : 80, isCompact ? 36 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: isCompact ? 8 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
      ),
    );
  }

  static ButtonStyle _getFilledTonalButtonStyle(bool isCompact) {
    return FilledButton.styleFrom(
      minimumSize: Size(isCompact ? 64 : 80, isCompact ? 36 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: isCompact ? 8 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
      ),
    );
  }

  static ButtonStyle _getOutlinedButtonStyle(bool isCompact) {
    return OutlinedButton.styleFrom(
      minimumSize: Size(isCompact ? 64 : 80, isCompact ? 36 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: isCompact ? 8 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
      ),
    );
  }

  static ButtonStyle _getTextButtonStyle(bool isCompact) {
    return TextButton.styleFrom(
      minimumSize: Size(isCompact ? 48 : 64, isCompact ? 36 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 16,
        vertical: isCompact ? 8 : 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
      ),
    );
  }

  static ButtonStyle _getIconButtonStyle(bool isCompact) {
    return IconButton.styleFrom(
      minimumSize: Size(isCompact ? 40 : 48, isCompact ? 40 : 48),
      padding: EdgeInsets.all(isCompact ? 8 : 12),
    );
  }

  static ButtonStyle _getFilledIconButtonStyle(bool isCompact) {
    return IconButton.styleFrom(
      minimumSize: Size(isCompact ? 40 : 48, isCompact ? 40 : 48),
      padding: EdgeInsets.all(isCompact ? 8 : 12),
    );
  }

  static ButtonStyle _getFilledTonalIconButtonStyle(bool isCompact) {
    return IconButton.styleFrom(
      minimumSize: Size(isCompact ? 40 : 48, isCompact ? 40 : 48),
      padding: EdgeInsets.all(isCompact ? 8 : 12),
    );
  }

  static ButtonStyle _getOutlinedIconButtonStyle(bool isCompact) {
    return IconButton.styleFrom(
      minimumSize: Size(isCompact ? 40 : 48, isCompact ? 40 : 48),
      padding: EdgeInsets.all(isCompact ? 8 : 12),
    );
  }
}

/// MD3 Button 变体枚举
enum MD3ButtonVariant {
  filled,
  filledTonal,
  outlined,
  text,
  icon,
  iconFilled,
  iconFilledTonal,
  iconOutlined,
  fab,
}

/// MD3 Button Builder
/// 提供更灵活的 Button 构建方式
class MD3ButtonBuilder {
  final VoidCallback? onPressed;
  final Widget child;
  
  MD3ButtonVariant _variant = MD3ButtonVariant.filled;
  ButtonStyle? _style;
  String? _tooltip;
  bool _isCompact = false;
  bool _isExtended = false;
  bool _isSmall = false;

  MD3ButtonBuilder({
    required this.onPressed,
    required this.child,
  });

  MD3ButtonBuilder variant(MD3ButtonVariant variant) {
    _variant = variant;
    return this;
  }

  MD3ButtonBuilder style(ButtonStyle style) {
    _style = style;
    return this;
  }

  MD3ButtonBuilder tooltip(String tooltip) {
    _tooltip = tooltip;
    return this;
  }

  MD3ButtonBuilder compact(bool isCompact) {
    _isCompact = isCompact;
    return this;
  }

  MD3ButtonBuilder extended(bool isExtended) {
    _isExtended = isExtended;
    return this;
  }

  MD3ButtonBuilder small(bool isSmall) {
    _isSmall = isSmall;
    return this;
  }

  Widget build() {
    switch (_variant) {
      case MD3ButtonVariant.filled:
        return MD3ButtonStyles.filled(
          onPressed: onPressed,
          child: child,
          style: _style,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.filledTonal:
        return MD3ButtonStyles.filledTonal(
          onPressed: onPressed,
          child: child,
          style: _style,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.outlined:
        return MD3ButtonStyles.outlined(
          onPressed: onPressed,
          child: child,
          style: _style,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.text:
        return MD3ButtonStyles.text(
          onPressed: onPressed,
          child: child,
          style: _style,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.icon:
        return MD3ButtonStyles.icon(
          onPressed: onPressed,
          icon: child,
          style: _style,
          tooltip: _tooltip,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.iconFilled:
        return MD3ButtonStyles.iconFilled(
          onPressed: onPressed,
          icon: child,
          style: _style,
          tooltip: _tooltip,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.iconFilledTonal:
        return MD3ButtonStyles.iconFilledTonal(
          onPressed: onPressed,
          icon: child,
          style: _style,
          tooltip: _tooltip,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.iconOutlined:
        return MD3ButtonStyles.iconOutlined(
          onPressed: onPressed,
          icon: child,
          style: _style,
          tooltip: _tooltip,
          isCompact: _isCompact,
        );
      case MD3ButtonVariant.fab:
        return MD3ButtonStyles.fab(
          onPressed: onPressed,
          child: child,
          tooltip: _tooltip,
          isExtended: _isExtended,
          isSmall: _isSmall,
        );
    }
  }
}
