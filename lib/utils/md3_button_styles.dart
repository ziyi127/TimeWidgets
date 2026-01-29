import 'package:flutter/material.dart';

/// Material Design 3 Button 样式工具类
/// 提供统一的 MD3 按钮组件样式
class MD3ButtonStyles {
  /// MD3 Filled Button
  static Widget filledButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }

  /// MD3 Filled Tonal Button
  static Widget filledTonalButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }

  /// MD3 Outlined Button
  static Widget outlinedButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        side: BorderSide(
          color: enabled ? colorScheme.outline : colorScheme.outlineVariant,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }

  /// MD3 Text Button
  static Widget textButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: textTheme.labelLarge,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }

  /// MD3 Icon Button
  static Widget iconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget icon,
    String? tooltip,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: icon,
      tooltip: tooltip,
      color: enabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
      hoverColor:
          enabled ? colorScheme.primary.withAlpha((255 * 0.08).round()) : null,
      highlightColor:
          enabled ? colorScheme.primary.withAlpha((255 * 0.12).round()) : null,
      splashColor:
          enabled ? colorScheme.primary.withAlpha((255 * 0.16).round()) : null,
      padding: const EdgeInsets.all(12),
    );
  }

  /// MD3 Icon Button (alternative name for compatibility)
  static Widget icon({
    required BuildContext context,
    required Widget icon,
    required VoidCallback onPressed,
    String? tooltip,
    bool enabled = true,
  }) {
    return iconButton(
      context: context,
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      enabled: enabled,
    );
  }

  /// MD3 Filled Icon Button
  static Widget iconFilled({
    required BuildContext context,
    required Widget icon,
    required VoidCallback onPressed,
    String? tooltip,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final button = FilledButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: icon,
      label: const SizedBox.shrink(),
      style: FilledButton.styleFrom(
        backgroundColor:
            enabled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
        foregroundColor:
            enabled ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }

  /// MD3 Filled Tonal Icon Button
  static Widget iconFilledTonal({
    required BuildContext context,
    required Widget icon,
    required VoidCallback onPressed,
    String? tooltip,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final button = FilledButton.tonalIcon(
      onPressed: enabled ? onPressed : null,
      icon: icon,
      label: const SizedBox.shrink(),
      style: FilledButton.styleFrom(
        backgroundColor: enabled
            ? colorScheme.secondaryContainer
            : colorScheme.surfaceContainerHighest,
        foregroundColor: enabled
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }

  /// MD3 Outlined Icon Button
  static Widget iconOutlined({
    required BuildContext context,
    required Widget icon,
    required VoidCallback onPressed,
    String? tooltip,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final button = OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: icon,
      label: const SizedBox.shrink(),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            enabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
        side: BorderSide(
          color: enabled ? colorScheme.outline : colorScheme.outlineVariant,
        ),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }
}
