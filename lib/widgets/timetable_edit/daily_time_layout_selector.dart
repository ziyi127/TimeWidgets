import 'package:flutter/material.dart';
import '../../models/timetable_edit_model.dart';
import '../../utils/md3_form_styles.dart';

class DailyTimeLayoutSelector extends StatelessWidget {
  const DailyTimeLayoutSelector({
    super.key,
    required this.timeLayouts,
    required this.selectedLayoutId,
    required this.onChanged,
  });

  final List<TimeLayout> timeLayouts;
  final String? selectedLayoutId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return MD3FormStyles.dropdown<String?>(
      context: context,
      value: selectedLayoutId,
      label: '使用时间表',
      onChanged: onChanged,
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text(
            '默认 (跟随全局)',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...timeLayouts.map((layout) {
          return DropdownMenuItem(
            value: layout.id,
            child: Text(
              layout.name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
      ],
    );
  }
}
