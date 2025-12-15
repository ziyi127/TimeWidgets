import 'package:flutter/material.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';

/// 颜色选择器组�?
/// 提供预设颜色和自定义颜色选择功能
class ColorPickerWidget extends StatefulWidget {
  /// 当前选中的颜�?
  final Color selectedColor;
  
  /// 颜色改变回调
  final ValueChanged<Color> onColorChanged;
  
  /// 是否显示预览
  final bool showPreview;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.showPreview = true,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  // Material 3 推荐的种子颜�?
  static const List<Color> _presetColors = [
    Color(0xFF6750A4), // Material 3 默认紫色
    Color(0xFF1976D2), // 蓝色
    Color(0xFF388E3C), // 绿色
    Color(0xFFFF5722), // 橙红�?
    Color(0xFFE91E63), // 粉色
    Color(0xFF9C27B0), // 紫色
    Color(0xFF673AB7), // 深紫�?
    Color(0xFF3F51B5), // 靛蓝�?
    Color(0xFF2196F3), // 浅蓝�?
    Color(0xFF03DAC6), // 青色
    Color(0xFF4CAF50), // 浅绿�?
    Color(0xFF8BC34A), // 黄绿�?
    Color(0xFFCDDC39), // 柠檬�?
    Color(0xFFFFEB3B), // 黄色
    Color(0xFFFFC107), // 琥珀�?
    Color(0xFFFF9800), // 橙色
    Color(0xFF795548), // 棕色
    Color(0xFF607D8B), // 蓝灰�?
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 当前颜色显示
        MD3CardStyles.outlined(
          context: context,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 颜色圆圈
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前种子颜色',
                        style: MD3TypographyStyles.titleMedium(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#${widget.selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        style: MD3TypographyStyles.bodyMedium(context, 
                          color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 预设颜色网格
        Text(
          '预设颜色',
          style: MD3TypographyStyles.titleSmall(context),
        ),
        const SizedBox(height: 8),
        
        MD3CardStyles.surfaceContainer(
          context: context,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: _presetColors.length,
              itemBuilder: (context, index) {
                final color = _presetColors[index];
                final isSelected = color.toARGB32() == widget.selectedColor.toARGB32();
                
                return GestureDetector(
                  onTap: () => widget.onColorChanged(color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.outline.withValues(alpha: 0.5),
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _getContrastColor(color),
                          size: 20,
                        )
                      : null,
                  ),
                );
              },
            ),
          ),
        ),
        
        if (widget.showPreview) ...[
          const SizedBox(height: 16),
          
          // 主题预览
          Text(
            '主题预览',
            style: MD3TypographyStyles.titleSmall(context),
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: ThemePreview(
                  seedColor: widget.selectedColor,
                  isDark: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ThemePreview(
                  seedColor: widget.selectedColor,
                  isDark: true,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 获取对比色，用于在彩色背景上显示图标
  Color _getContrastColor(Color backgroundColor) {
    // 计算亮度
    final luminance = backgroundColor.computeLuminance();
    // 如果背景较暗，使用白色；如果背景较亮，使用黑�?
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// 颜色选择对话�?
class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String title;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    this.title = '选择种子颜色',
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: ColorPickerWidget(
          selectedColor: _selectedColor,
          onColorChanged: (color) {
            setState(() {
              _selectedColor = color;
            });
          },
          showPreview: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selectedColor),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
