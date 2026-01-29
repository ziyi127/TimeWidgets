import 'package:flutter/material.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/services/temp_schedule_change_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';

class PeriodScheduleChangeDialog extends StatefulWidget {
  const PeriodScheduleChangeDialog({super.key});

  @override
  State<PeriodScheduleChangeDialog> createState() => _PeriodScheduleChangeDialogState();
}

class _PeriodScheduleChangeDialogState extends State<PeriodScheduleChangeDialog> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlotId;
  String? _selectedCourseId;
  
  List<TimeSlot> _timeSlots = [];
  List<CourseInfo> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storageService = TimetableStorageService();
    final timetableData = await storageService.loadTimetableData();

    if (!mounted) return;

    if (timetableData.courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationService.getString('no_available_course')),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    // 获取时间段列表
    final timeSlots = timetableData.timeSlots.isNotEmpty
        ? timetableData.timeSlots
        : timetableData.timeLayouts.isNotEmpty
            ? timetableData.timeLayouts.first.timeSlots
            : <TimeSlot>[];

    if (timeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationService.getString('no_available_period')),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _courses = timetableData.courses;
      _timeSlots = timeSlots;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(LocalizationService.getString('status_loading')),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Text(LocalizationService.getString('change_by_period')),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocalizationService.getString('select_date_label')),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(LocalizationService.getString('select_period_label')),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: _timeSlots.map((slot) {
                      return RadioListTile<String>(
                        title: Text(slot.name),
                        subtitle: Text('${slot.startTime} - ${slot.endTime}'),
                        value: slot.id,
                        // ignore: deprecated_member_use
                        groupValue: _selectedTimeSlotId,
                        // ignore: deprecated_member_use
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeSlotId = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(LocalizationService.getString('select_course_label')),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: _courses.map((course) {
                      return RadioListTile<String>(
                        title: Text(course.name),
                        subtitle: Text(course.teacher),
                        value: course.id,
                        // ignore: deprecated_member_use
                        groupValue: _selectedCourseId,
                        // ignore: deprecated_member_use
                        onChanged: (value) {
                          setState(() {
                            _selectedCourseId = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocalizationService.getString('cancel')),
        ),
        FilledButton(
          onPressed: _selectedTimeSlotId == null || _selectedCourseId == null
              ? null
              : () async {
                  await _savePeriodScheduleChange(
                    _selectedDate,
                    _selectedTimeSlotId!,
                    _selectedCourseId!,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
          child: Text(LocalizationService.getString('confirm')),
        ),
      ],
    );
  }

  /// 保存按节调课记录
  Future<void> _savePeriodScheduleChange(
    DateTime date,
    String timeSlotId,
    String courseId,
  ) async {
    try {
      final tempService = TempScheduleChangeService();

      // 检查是否已有该日期和节次的调课记录
      final existingChange =
          await tempService.getChangeForPeriod(date, timeSlotId);
      if (existingChange != null) {
        await tempService.removeChange(existingChange.id);
      }

      // 创建新的调课记录
      final change = TempScheduleChange(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TempChangeType.period,
        date: date,
        timeSlotId: timeSlotId,
        newCourseId: courseId,
        createdAt: DateTime.now(),
      );

      await tempService.addChange(change);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocalizationService.getString('set_temp_change_success', params: {
                'date': '${date.month}月${date.day}日'
              }),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocalizationService.getString('save_failed')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
