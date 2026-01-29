import 'package:flutter/material.dart';
import '../../models/timetable_edit_model.dart';
import '../../services/timetable_edit_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/md3_button_styles.dart';
import '../../utils/md3_chip_styles.dart';
import '../../utils/md3_typography_styles.dart';

class QuickSchedulePanel extends StatelessWidget {
  const QuickSchedulePanel({
    super.key,
    required this.service,
    required this.schedule,
    required this.currentDayIndex,
    required this.currentSlotIndex,
    required this.timeSlots,
    required this.onCourseSelected,
    required this.onSkipSlot,
    required this.onUndo,
    required this.onClose,
  });

  final TimetableEditService service;
  final Schedule schedule;
  final int currentDayIndex;
  final int currentSlotIndex;
  final List<TimeSlot> timeSlots;
  final ValueChanged<CourseInfo> onCourseSelected;
  final VoidCallback onSkipSlot;
  final VoidCallback onUndo;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dayName = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'][currentDayIndex];
    
    // Determine current slot name
    String currentSlotName = '完成';
    if (currentSlotIndex < timeSlots.length) {
        currentSlotName = timeSlots[currentSlotIndex].name;
    }

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('快速排课', style: MD3TypographyStyles.titleMedium(context)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: '退出快速模式',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Status
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerHigh,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '正在安排: $dayName',
                  style: MD3TypographyStyles.labelLarge(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentSlotIndex < timeSlots.length 
                      ? '当前时间段: $currentSlotName'
                      : '该天课程已全部排完，将切换至下一天',
                  style: MD3TypographyStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: MD3ButtonStyles.outlinedButton(
                    context: context,
                    onPressed: onUndo,
                    text: '撤销',
                    icon: const Icon(Icons.undo, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MD3ButtonStyles.filledTonalButton(
                    context: context,
                    onPressed: currentSlotIndex < timeSlots.length ? onSkipSlot : () {},
                    text: '跳过/留空',
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Course List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: service.courses.map((course) {
                  final color = ColorUtils.parseHexColor(course.color) ??
                      ColorUtils.generateColorFromName(course.name);
                  final label = course.abbreviation.isNotEmpty 
                      ? course.abbreviation 
                      : (course.name.length > 2 ? course.name.substring(0, 2) : course.name);
                      
                  return MD3ChipStyles.actionChip(
                    context: context,
                    avatar: CircleAvatar(
                      backgroundColor: color,
                      radius: 8,
                    ),
                    label: label,
                    onPressed: () => onCourseSelected(course),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Helper text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '提示: 点击科目简称即可填入当前时间段并自动跳转下一个时间段。',
              style: MD3TypographyStyles.bodySmall(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
