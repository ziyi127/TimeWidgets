 import 'package:flutter/material.dart';
import '../utils/md3_chip_styles.dart';

/// 无障碍设置卡片
/// 
/// 包含：
/// 1. 色盲模式选择
/// 2. 高对比度模式
/// 3. 字号放大
/// 4. 屏幕阅读器优化
class AccessibilitySettingsCard extends StatelessWidget {
  const AccessibilitySettingsCard({
    super.key,
    required this.colorBlindMode,
    required this.highContrastMode,
    required this.largeTextMode,
    required this.screenReaderMode,
    required this.onColorBlindModeChanged,
    required this.onHighContrastModeChanged,
    required this.onLargeTextModeChanged,
    required this.onScreenReaderModeChanged,
  });

  final ColorBlindMode colorBlindMode;
  final bool highContrastMode;
  final bool largeTextMode;
  final bool screenReaderMode;

  final ValueChanged<ColorBlindMode> onColorBlindModeChanged;
  final ValueChanged<bool> onHighContrastModeChanged;
  final ValueChanged<bool> onLargeTextModeChanged;
  final ValueChanged<bool> onScreenReaderModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(
                  Icons.accessibility_new_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '无障碍设置',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '让每个人都能轻松使用',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 色盲模式
            _buildColorBlindModeSelector(context, theme, colorScheme),
            const SizedBox(height: 16),

            // 高对比度模式
            SwitchListTile(
              secondary: Icon(
                Icons.contrast_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('高对比度模式'),
              subtitle: const Text('增强文字和背景的对比度'),
              value: highContrastMode,
              onChanged: onHighContrastModeChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),

            // 大字号模式
            SwitchListTile(
              secondary: Icon(
                Icons.text_increase_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('大字号模式'),
              subtitle: const Text('适合远距离阅读（班级大屏）'),
              value: largeTextMode,
              onChanged: onLargeTextModeChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),

            // 屏幕阅读器优化
            SwitchListTile(
              secondary: Icon(
                Icons.record_voice_over_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('屏幕阅读器优化'),
              subtitle: const Text('为视障用户优化语义标签'),
              value: screenReaderMode,
              onChanged: onScreenReaderModeChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 色盲模式选择器
  Widget _buildColorBlindModeSelector(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '色盲模式',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ColorBlindMode.values.map((mode) {
              final isSelected = mode == colorBlindMode;
              return MD3ChipStyles.choiceChip(
                context: context,
                label: _getColorBlindModeLabel(mode),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onColorBlindModeChanged(mode);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // 色盲模式说明
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getColorBlindModeDescription(colorBlindMode),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getColorBlindModeLabel(ColorBlindMode mode) {
    switch (mode) {
      case ColorBlindMode.none:
        return '正常';
      case ColorBlindMode.protanopia:
        return '红色盲';
      case ColorBlindMode.deuteranopia:
        return '绿色盲';
      case ColorBlindMode.tritanopia:
        return '蓝色盲';
    }
  }

  String _getColorBlindModeDescription(ColorBlindMode mode) {
    switch (mode) {
      case ColorBlindMode.none:
        return '使用标准配色方案';
      case ColorBlindMode.protanopia:
        return '优化红色感知困难用户的视觉体验';
      case ColorBlindMode.deuteranopia:
        return '优化绿色感知困难用户的视觉体验';
      case ColorBlindMode.tritanopia:
        return '优化蓝色感知困难用户的视觉体验';
    }
  }
}

/// 色盲模式枚举
enum ColorBlindMode {
  none,        // 正常
  protanopia,  // 红色盲
  deuteranopia,// 绿色盲
  tritanopia,  // 蓝色盲
}
