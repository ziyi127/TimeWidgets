import 'package:flutter/material.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/services/temp_schedule_change_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';

class DayScheduleChangeDialog extends StatefulWidget {
  const DayScheduleChangeDialog({super.key});

  @override
  State<DayScheduleChangeDialog> createState() => _DayScheduleChangeDialogState();
}

class _DayScheduleChangeDialogState extends State<DayScheduleChangeDialog> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedScheduleId;
  List<Schedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storageService = TimetableStorageService();
    final timetableData = await storageService.loadTimetableData();

    if (mounted) {
      setState(() {
        _schedules = timetableData.schedules;
        _isLoading = false;
      });

      if (_schedules.isEmpty) {
        // Delay pop to avoid building issues
        Future.delayed(Duration.zero, () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocalizationService.getString('no_available_schedule')),
                backgroundColor: Colors.orange,
              ),
            );
            Navigator.of(context).pop();
          }
        });
      }
    }
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
      title: Text(LocalizationService.getString('change_by_day')),
      content: SizedBox(
        width: 400,
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
            Text(LocalizationService.getString('select_schedule_label')),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  children: _schedules.map((schedule) {
                    return RadioListTile<String>(
                      title: Text(schedule.name),
                      subtitle: Text(_getScheduleDescription(schedule)),
                      value: schedule.id,
                      // ignore: deprecated_member_use
                      groupValue: _selectedScheduleId,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        setState(() {
                          _selectedScheduleId = value;
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocalizationService.getString('cancel')),
        ),
        FilledButton(
          onPressed: _selectedScheduleId == null
              ? null
              : () async {
                  await _saveDayScheduleChange(
                    _selectedDate,
                    _selectedScheduleId!,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
          child: Text(LocalizationService.getString('confirm')),
        ),
      ],
    );
  }

  /// 获取课表描述
  String _getScheduleDescription(Schedule schedule) {
    // 兼容旧的显示逻辑，如果有 triggers 则使用第一个，否则显示默认
    if (schedule.triggers.isEmpty) {
      return '${schedule.courses.length}节课';
    }

    // 简单展示第一个触发条件的信息
    final trigger = schedule.triggers.first;
    final weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    
    // 如果指定了星期
    if (trigger.weekDays != null && trigger.weekDays!.isNotEmpty) {
      final daysText = trigger.weekDays!.map((d) => weekDays[d]).join('、');
      return '$daysText • ${schedule.courses.length}节课';
    }
    
    // 如果指定了日期
    if (trigger.dates != null && trigger.dates!.isNotEmpty) {
       return '特定日期 • ${schedule.courses.length}节课';
    }

    return '${schedule.courses.length}节课';
  }

  /// 保存按天调课记录
  Future<void> _saveDayScheduleChange(DateTime date, String scheduleId) async {
    try {
      final tempService = TempScheduleChangeService();

      // 检查是否已有该日期的调课记录
      final existingChange = await tempService.getDayChangeForDate(date);
      if (existingChange != null) {
        await tempService.removeChange(existingChange.id);
      }

      // 创建新的调课记录
      final change = TempScheduleChange(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TempChangeType.day,
        date: date,
        newScheduleId: scheduleId,
        createdAt: DateTime.now(),
      );

      await tempService.addChange(change);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocalizationService.getString('set_temp_schedule_success', params: {
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
