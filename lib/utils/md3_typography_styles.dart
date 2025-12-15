import 'package:flutter/material.dart';

/// Material Design 3 Typography 样式工具类
/// 提供统一的 MD3 文本样式和变体
/// 遵循 Material 3 Type Scale 规范
class MD3TypographyStyles {
  /// Display Large - 用于最大的标题文本
  /// 通常用于启动屏幕或重要的品牌展示
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.displayLarge?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Display Medium - 用于大型标题文本
  /// 通常用于页面主标题
  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.displayMedium?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Display Small - 用于中等大小的标题文本
  /// 通常用于卡片标题或重要信息
  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.displaySmall?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Headline Large - 用于大型标题
  /// 通常用于页面或章节标题
  static TextStyle headlineLarge(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineLarge?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Headline Medium - 用于中等标题
  /// 通常用于子页面标题或重要区块标题
  static TextStyle headlineMedium(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineMedium?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Headline Small - 用于小型标题
  /// 通常用于卡片标题或列表组标题
  static TextStyle headlineSmall(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineSmall?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Title Large - 用于大型标题文本
  /// 通常用于 AppBar 标题或对话框标题
  static TextStyle titleLarge(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Title Medium - 用于中等标题文本
  /// 通常用于列表项标题或卡片标题
  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.titleMedium?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Title Small - 用于小型标题文本
  /// 通常用于按钮文本或小标题
  static TextStyle titleSmall(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.titleSmall?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Body Large - 用于大型正文文本
  /// 通常用于重要的正文内容
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Body Medium - 用于中等正文文本
  /// 通常用于一般的正文内容
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Body Small - 用于小型正文文本
  /// 通常用于辅助信息或说明文本
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodySmall?.copyWith(
      color: color ?? theme.colorScheme.onSurfaceVariant,
    ) ?? TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: color ?? theme.colorScheme.onSurfaceVariant,
    );
  }

  /// Label Large - 用于大型标签文本
  /// 通常用于按钮文本或重要标签
  static TextStyle labelLarge(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.labelLarge?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Label Medium - 用于中等标签文本
  /// 通常用于标签或小按钮文本
  static TextStyle labelMedium(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.labelMedium?.copyWith(
      color: color ?? theme.colorScheme.onSurface,
    ) ?? TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: color ?? theme.colorScheme.onSurface,
    );
  }

  /// Label Small - 用于小型标签文本
  /// 通常用于图标标签或状态指示器
  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    return theme.textTheme.labelSmall?.copyWith(
      color: color ?? theme.colorScheme.onSurfaceVariant,
    ) ?? TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: color ?? theme.colorScheme.onSurfaceVariant,
    );
  }

  // 特殊用途的文本样式

  /// 错误文本样式
  static TextStyle error(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      color: theme.colorScheme.error,
    );
  }

  /// 成功文本样式
  static TextStyle success(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      color: theme.colorScheme.primary,
    );
  }

  /// 警告文本样式
  static TextStyle warning(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      color: theme.colorScheme.tertiary,
    );
  }

  /// 禁用文本样式
  static TextStyle disabled(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
    );
  }

  /// 链接文本样式
  static TextStyle link(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );
  }

  /// 代码文本样式
  static TextStyle code(BuildContext context, {TextStyle? baseStyle}) {
    final theme = Theme.of(context);
    final base = baseStyle ?? bodyMedium(context);
    return base.copyWith(
      fontFamily: 'monospace',
      backgroundColor: theme.colorScheme.surfaceContainer,
      color: theme.colorScheme.onSurfaceVariant,
    );
  }
}

/// MD3 Typography 变体枚举
enum MD3TypographyVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// MD3 Typography Builder
/// 提供更灵活的文本样式构建方式
class MD3TypographyBuilder {
  final BuildContext context;
  final String text;
  
  MD3TypographyVariant _variant = MD3TypographyVariant.bodyMedium;
  Color? _color;
  TextAlign? _textAlign;
  int? _maxLines;
  TextOverflow? _overflow;
  bool _selectable = false;

  MD3TypographyBuilder({
    required this.context,
    required this.text,
  });

  MD3TypographyBuilder variant(MD3TypographyVariant variant) {
    _variant = variant;
    return this;
  }

  MD3TypographyBuilder color(Color color) {
    _color = color;
    return this;
  }

  MD3TypographyBuilder align(TextAlign align) {
    _textAlign = align;
    return this;
  }

  MD3TypographyBuilder maxLines(int maxLines) {
    _maxLines = maxLines;
    return this;
  }

  MD3TypographyBuilder overflow(TextOverflow overflow) {
    _overflow = overflow;
    return this;
  }

  MD3TypographyBuilder selectable(bool selectable) {
    _selectable = selectable;
    return this;
  }

  Widget build() {
    final style = _getStyleForVariant();
    
    if (_selectable) {
      return SelectableText(
        text,
        style: style,
        textAlign: _textAlign,
        maxLines: _maxLines,
      );
    } else {
      return Text(
        text,
        style: style,
        textAlign: _textAlign,
        maxLines: _maxLines,
        overflow: _overflow,
      );
    }
  }

  TextStyle _getStyleForVariant() {
    switch (_variant) {
      case MD3TypographyVariant.displayLarge:
        return MD3TypographyStyles.displayLarge(context, color: _color);
      case MD3TypographyVariant.displayMedium:
        return MD3TypographyStyles.displayMedium(context, color: _color);
      case MD3TypographyVariant.displaySmall:
        return MD3TypographyStyles.displaySmall(context, color: _color);
      case MD3TypographyVariant.headlineLarge:
        return MD3TypographyStyles.headlineLarge(context, color: _color);
      case MD3TypographyVariant.headlineMedium:
        return MD3TypographyStyles.headlineMedium(context, color: _color);
      case MD3TypographyVariant.headlineSmall:
        return MD3TypographyStyles.headlineSmall(context, color: _color);
      case MD3TypographyVariant.titleLarge:
        return MD3TypographyStyles.titleLarge(context, color: _color);
      case MD3TypographyVariant.titleMedium:
        return MD3TypographyStyles.titleMedium(context, color: _color);
      case MD3TypographyVariant.titleSmall:
        return MD3TypographyStyles.titleSmall(context, color: _color);
      case MD3TypographyVariant.bodyLarge:
        return MD3TypographyStyles.bodyLarge(context, color: _color);
      case MD3TypographyVariant.bodyMedium:
        return MD3TypographyStyles.bodyMedium(context, color: _color);
      case MD3TypographyVariant.bodySmall:
        return MD3TypographyStyles.bodySmall(context, color: _color);
      case MD3TypographyVariant.labelLarge:
        return MD3TypographyStyles.labelLarge(context, color: _color);
      case MD3TypographyVariant.labelMedium:
        return MD3TypographyStyles.labelMedium(context, color: _color);
      case MD3TypographyVariant.labelSmall:
        return MD3TypographyStyles.labelSmall(context, color: _color);
    }
  }
}