import 'package:flutter/material.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/utils/md3_form_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class TimeSlotTab extends StatelessWidget {

  const TimeSlotTab({super.key, required this.service});
  final TimetableEditService service;
  
  /// Generate a simple unique ID using timestamp and random numbers
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond % 1000;
    return 'slot_${timestamp}_$random';
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = service.timeSlots;
    final theme = Theme.of(context);

    // Sort time slots by start time
    final sortedSlots = List<TimeSlot>.from(timeSlots)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: sortedSlots.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('暂无作息时间', style: MD3TypographyStyles.titleMedium(context)),
                  const SizedBox(height: 8),
                  Text('点击下方按钮添加时间段', style: MD3TypographyStyles.bodyMedium(context)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedSlots.length,
              itemBuilder: (context, index) {
                final slot = sortedSlots[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MD3CardStyles.surfaceContainer(
                    context: context,
                    child: ListTile(
                      leading: Icon(
                        _getIconForType(slot.type),
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(slot.name, style: MD3TypographyStyles.titleMedium(context)),
                      subtitle: Text(
                        '${slot.startTime} - ${slot.endTime}',
                        style: MD3TypographyStyles.bodySmall(context),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditDialog(context, slot),
                      ),
                      onLongPress: () => _confirmDelete(context, slot),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context, null),
        icon: const Icon(Icons.add),
        label: const Text('添加时间段'),
      ),
    );
  }

  IconData _getIconForType(TimePointType type) {
    switch (type) {
      case TimePointType.classTime:
        return Icons.class_outlined;
      case TimePointType.breakTime:
        return Icons.coffee_outlined;
      case TimePointType.divider:
        return Icons.horizontal_rule;
    }
  }

  Future<void> _showEditDialog(BuildContext context, TimeSlot? slot) async {
    final isEditing = slot != null;
    final nameController = TextEditingController(text: slot?.name);
    TimePointType selectedType = slot?.type ?? TimePointType.classTime;
    
    // TimeOfDay parsing/formatting helper
    TimeOfDay parseTime(String time) {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    
    String formatTime(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    TimeOfDay startTime = slot != null ? parseTime(slot.startTime) : const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = slot != null ? parseTime(slot.endTime) : const TimeOfDay(hour: 8, minute: 45);

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? '编辑时间段' : '添加时间段'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MD3FormStyles.outlinedTextField(
                    context: context,
                    controller: nameController,
                    label: '名称（如：第一节）',
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TimePointType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(
                      labelText: '类型',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: TimePointType.classTime, child: Text('上课')),
                      DropdownMenuItem(value: TimePointType.breakTime, child: Text('休息')),
                      DropdownMenuItem(value: TimePointType.divider, child: Text('分割线')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => selectedType = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: startTime,
                            );
                            if (time != null) setState(() => startTime = time);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '开始时间',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.schedule),
                            ),
                            child: Text(formatTime(startTime)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: endTime,
                            );
                            if (time != null) setState(() => endTime = time);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '结束时间',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.schedule_outlined),
                            ),
                            child: Text(formatTime(endTime)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请输入名称')),
                    );
                    return;
                  }

                  final newSlot = TimeSlot(
                    id: slot?.id ?? _generateId(),
                    name: nameController.text,
                    startTime: formatTime(startTime),
                    endTime: formatTime(endTime),
                    type: selectedType,
                  );

                  if (isEditing) {
                    service.updateTimeSlot(newSlot);
                  } else {
                    service.addTimeSlot(newSlot);
                  }
                  Navigator.pop(context);
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, TimeSlot slot) async {
    final confirmed = await MD3DialogStyles.showConfirmDialog(
      context: context,
      title: '删除时间段',
      message: '确定要删除"${slot.name}"吗？相关课程安排也将被移除。',
      confirmText: '删除',
      isDestructive: true,
    );

    if (confirmed ?? false) {
      service.deleteTimeSlot(slot.id);
    }
  }
}
