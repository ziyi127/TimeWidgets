import 'package:flutter/material.dart';

/// Material Design 3 Chip 样式工具类
/// 提供统一的 MD3 Chip 组件样式
class MD3ChipStyles {
  /// MD3 Filter Chip
  static Widget filterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? onSelected : null,
      backgroundColor: colorScheme.surfaceContainer,
      selectedColor: colorScheme.primaryContainer,
      labelStyle: selected
          ? textTheme.labelMedium?.copyWith(color: colorScheme.onPrimaryContainer)
          : textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      side: BorderSide(
        color: selected ? colorScheme.primaryContainer : colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  /// MD3 Chip
  static Widget chip({
    required BuildContext context,
    required String label,
    VoidCallback? onDeleted,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Chip(
      label: Text(label),
      onDeleted: enabled ? onDeleted : null,
      backgroundColor: colorScheme.surfaceContainer,
      labelStyle: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      deleteIconColor: colorScheme.onSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  /// MD3 Action Chip
  static Widget actionChip({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    Widget? avatar,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      label: Text(label),
      onPressed: enabled ? onPressed : null,
      avatar: avatar,
      backgroundColor: colorScheme.surfaceContainer,
      labelStyle: textTheme.labelMedium?.copyWith(color: colorScheme.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  /// MD3 Choice Chip
  static Widget choiceChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? onSelected : null,
      backgroundColor: colorScheme.surfaceContainer,
      selectedColor: colorScheme.primaryContainer,
      labelStyle: selected
          ? textTheme.labelMedium?.copyWith(color: colorScheme.onPrimaryContainer)
          : textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      side: BorderSide(
        color: selected ? colorScheme.primaryContainer : colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}
