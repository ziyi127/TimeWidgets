import 'package:flutter/material.dart';
import 'md3_typography_styles.dart';

/// Material Design 3 Form 样式工具�?
/// 提供统一�?MD3 表单组件样式
class MD3FormStyles {
  /// MD3 Outlined TextField
  static Widget outlinedTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    bool autofocus = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: false,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      autofocus: autofocus,
    );
  }

  /// MD3 Filled TextField
  static Widget filledTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    bool autofocus = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      autofocus: autofocus,
    );
  }

  /// MD3 Dropdown
  static Widget dropdown<T>({
    required BuildContext context,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String label,
    String? hint,
    Widget? prefixIcon,
    bool enabled = true,
    FormFieldValidator<T>? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
      dropdownColor: colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// MD3 Time Picker Button
  static Widget timePickerButton({
    required BuildContext context,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onChanged,
    required String label,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeText = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '选择时间';

    return InkWell(
      onTap: enabled
          ? () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time ?? const TimeOfDay(hour: 8, minute: 0),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        hourMinuteShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dayPeriodShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onChanged(picked);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          suffixIcon: Icon(
            Icons.access_time,
            color: enabled ? colorScheme.onSurfaceVariant : colorScheme.outline,
          ),
        ),
        child: Text(
          timeText,
          style: MD3TypographyStyles.bodyLarge(context).copyWith(
            color: time != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// MD3 Date Picker Button
  static Widget datePickerButton({
    required BuildContext context,
    required DateTime? date,
    required ValueChanged<DateTime> onChanged,
    required String label,
    DateTime? firstDate,
    DateTime? lastDate,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateText =
        date != null ? '${date.year}年${date.month}月${date.day}日' : '选择日期';

    return InkWell(
      onTap: enabled
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(2020),
                lastDate: lastDate ?? DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        headerBackgroundColor: colorScheme.primaryContainer,
                        headerForegroundColor: colorScheme.onPrimaryContainer,
                        dayShape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onChanged(picked);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          suffixIcon: Icon(
            Icons.calendar_today,
            color: enabled ? colorScheme.onSurfaceVariant : colorScheme.outline,
          ),
        ),
        child: Text(
          dateText,
          style: MD3TypographyStyles.bodyLarge(context).copyWith(
            color: date != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// MD3 Color Picker Button
  static Widget colorPickerButton({
    required BuildContext context,
    required Color color,
    required ValueChanged<Color> onChanged,
    required String label,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: enabled
          ? () async {
              final picked = await _showColorPickerDialog(context, color);
              if (picked != null) {
                onChanged(picked);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
              style: MD3TypographyStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );
  }

  /// MD3 Switch ListTile
  static Widget switchListTile({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String title,
    String? subtitle,
    Widget? secondary,
    bool enabled = true,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: Text(
        title,
        style: MD3TypographyStyles.bodyLarge(context),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: MD3TypographyStyles.bodyMedium(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      secondary: secondary,
    );
  }

  /// MD3 Segmented Button
  static Widget segmentedButton<T>({
    required BuildContext context,
    required List<ButtonSegment<T>> segments,
    required Set<T> selected,
    required ValueChanged<Set<T>> onSelectionChanged,
    bool multiSelectionEnabled = false,
    bool emptySelectionAllowed = false,
  }) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// 显示颜色选择器对话框
  static Future<Color?> _showColorPickerDialog(
    BuildContext context,
    Color initialColor,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    Color selectedColor = initialColor;

    // 预定义的 MD3 颜色
    const colors = [
      Color(0xFFEF4444), // Red
      Color(0xFFEC4899), // Pink
      Color(0xFF8B5CF6), // Purple
      Color(0xFF6366F1), // Indigo
      Color(0xFF3B82F6), // Blue
      Color(0xFF0EA5E9), // Light Blue
      Color(0xFF06B6D4), // Cyan
      Color(0xFF10B981), // Teal
      Color(0xFF22C55E), // Green
      Color(0xFF84CC16), // Light Green
      Color(0xFFEAB308), // Yellow
      Color(0xFFF59E0B), // Amber
      Color(0xFFF97316), // Orange
      Color(0xFFEF4444), // Deep Red
      Color(0xFF7C3AED), // Violet
      Color(0xFFF43F5E), // Rose
      Color(0xFF14B8A6), // Emerald
      Color(0xFFFBBF24), // Gold
    ];

    return showDialog<Color>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: colorScheme.surfaceContainerHigh,
          title: Text(
            '选择颜色',
            style: MD3TypographyStyles.headlineSmall(context),
          ),
          content: SizedBox(
            width: 280,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                final isSelected = selectedColor.toARGB32() == color.toARGB32();
                return InkWell(
                  onTap: () => setState(() => selectedColor = color),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: colorScheme.primary,
                              width: 3,
                            )
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(selectedColor),
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }
}
