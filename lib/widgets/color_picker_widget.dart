import 'package:flutter/material.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

/// 颜色选择器组件
/// 提供预设颜色和自定义颜色选择功能
class ColorPickerWidget extends StatefulWidget {

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.showPreview = true,
  });
  /// 当前选中的颜色
  final Color selectedColor;
  
  /// 颜色改变回调
  final ValueChanged<Color> onColorChanged;
  
  /// 是否显示预览
  final bool showPreview;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  // Material 3 推荐的种子颜色
  static const List<Color> _presetColors = [
    Color(0xFF6750A4), // Material 3 默认紫色
    Color(0xFF1976D2), // 蓝色
    Color(0xFF388E3C), // 绿色
    Color(0xFFFF5722), // 橙红色
    Color(0xFFE91E63), // 粉色
    Color(0xFF9C27B0), // 紫色
    Color(0xFF673AB7), // 深紫色
    Color(0xFF3F51B5), // 靛蓝色
    Color(0xFF2196F3), // 浅蓝色
    Color(0xFF03DAC6), // 青色
    Color(0xFF4CAF50), // 浅绿色
    Color(0xFF8BC34A), // 黄绿色
    Color(0xFFCDDC39), // 柠檬色
    Color(0xFFFFEB3B), // 黄色
    Color(0xFFFFC107), // 琥珀色
    Color(0xFFFF9800), // 橙色
    Color(0xFF795548), // 棕色
    Color(0xFF607D8B), // 蓝灰色
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 当前颜色显示
        MD3CardStyles.outlined(
          context: context,
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.value(16)),
            child: Row(
              children: [
                // 颜色圆圈
                Container(
                  width: ResponsiveUtils.value(48),
                  height: ResponsiveUtils.value(48),
                  decoration: BoxDecoration(
                    color: widget.selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline,
                      width: ResponsiveUtils.value(2),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.value(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前种子颜色',
                        style: MD3TypographyStyles.titleMedium(context).copyWith(
                          fontSize: MD3TypographyStyles.titleMedium(context).fontSize! * fontMultiplier,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.value(4)),
                      Text(
                        '#${widget.selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        style: MD3TypographyStyles.bodyMedium(context, 
                          color: colorScheme.onSurfaceVariant,).copyWith(
                          fontSize: MD3TypographyStyles.bodyMedium(context).fontSize! * fontMultiplier,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.value(16)),
        // 预设颜色网格
        Text(
          '预设颜色',
          style: MD3TypographyStyles.titleSmall(context).copyWith(
            fontSize: MD3TypographyStyles.titleSmall(context).fontSize! * fontMultiplier,
          ),
        ),
        SizedBox(height: ResponsiveUtils.value(8)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: ResponsiveUtils.value(12),
            mainAxisSpacing: ResponsiveUtils.value(12),
          ),
          itemCount: _presetColors.length,
          itemBuilder: (context, index) {
            final color = _presetColors[index];
            final isSelected = color.toARGB32() == widget.selectedColor.toARGB32();
            
            return InkWell(
              onTap: () => widget.onColorChanged(color),
              borderRadius: BorderRadius.circular(ResponsiveUtils.value(24)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: colorScheme.primary,
                          width: ResponsiveUtils.value(3),
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: ResponsiveUtils.value(2),
                      offset: Offset(0, ResponsiveUtils.value(1)),
                    ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        size: ResponsiveUtils.getIconSize(width, baseSize: 20),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
