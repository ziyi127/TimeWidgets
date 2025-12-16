import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_card_styles.dart';
import '../utils/md3_dialog_styles.dart';
import '../utils/md3_form_styles.dart';
import '../utils/md3_typography_styles.dart';
import '../utils/color_utils.dart';

/// 课表编辑标签�?- 网格视图
class ScheduleEditTab extends StatefulWidget {
  const ScheduleEditTab({super.key});

  @override
  State<ScheduleEditTab> createState() => _ScheduleEditTabState();
}

class _ScheduleEditTabState extends State<ScheduleEditTab> {
  String? _selectedScheduleId;
  WeekType _filterWeekType = WeekType.both;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final schedules = service.schedules;
        
        return Row(
          children: [
            // 左侧: 课表列表
            SizedBox(
              width: 280,
              child: _buildScheduleList(context, schedules, service),
            ),
            const VerticalDivider(width: 1),
            // 右侧: 课程网格编辑�?
            Expanded(
              child: _buildScheduleGrid(context, service),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleList(BuildContext context, List<Schedule> schedules, TimetableEditService service) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // 列表头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('课表列表', style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              MD3ButtonStyles.iconFilledTonal(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddScheduleDialog(context, service),
                tooltip: '添加课表',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 课表列表
        Expanded(
          child: schedules.isEmpty
              ? _buildEmptyScheduleList(context, service)
              : ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    final isSelected = schedule.id == _selectedScheduleId;
                    final isActive = schedule.isAutoEnabled && 
                        schedule.triggerRule.matches(DateTime.now());
                    
                    return ListTile(
                      leading: Icon(
                        isActive ? Icons.check_circle : Icons.calendar_today,
                        color: isActive ? colorScheme.primary : null,
                      ),
                      title: Text(schedule.name),
                      subtitle: Text(_getTriggerRuleText(schedule.triggerRule)),
                      selected: isSelected,
                      selectedTileColor: colorScheme.secondaryContainer,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '当前',
                                style: MD3TypographyStyles.labelSmall(context).copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedScheduleId = schedule.id;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyScheduleList(BuildContext context, TimetableEditService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无课表',
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '创建课表来安排每天的课程',
            style: MD3TypographyStyles.bodyMedium(context).copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          MD3ButtonStyles.filledTonal(
            onPressed: () => _showAddScheduleDialog(context, service),
            child: const Text('创建课表'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid(BuildContext context, TimetableEditService service) {
    if (_selectedScheduleId == null) {
      // Show daily courses grid (legacy mode)
      return _buildDailyCoursesGrid(context, service);
    }
    
    final schedule = service.getScheduleById(_selectedScheduleId!);
    if (schedule == null) {
      return _buildDailyCoursesGrid(context, service);
    }
    
    return _ScheduleGridEditor(
      schedule: schedule,
      service: service,
      filterWeekType: _filterWeekType,
      onFilterChanged: (type) {
        setState(() {
          _filterWeekType = type;
        });
      },
      onDelete: () {
        setState(() {
          _selectedScheduleId = null;
        });
      },
    );
  }

  Widget _buildDailyCoursesGrid(BuildContext context, TimetableEditService service) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeSlots = service.timeSlots;
    final courses = service.courses;
    final dailyCourses = service.dailyCourses;
    
    if (timeSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '请先�?时间�?中添加时间点',
              style: MD3TypographyStyles.bodyLarge(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        // 头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('课程安排', style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              // 周类型筛�?
              MD3FormStyles.segmentedButton<WeekType>(
                context: context,
                segments: const [
                  ButtonSegment(value: WeekType.both, label: Text('每周')),
                  ButtonSegment(value: WeekType.single, label: Text('单周')),
                  ButtonSegment(value: WeekType.double, label: Text('双周')),
                ],
                selected: {_filterWeekType},
                onSelectionChanged: (selected) {
                  setState(() {
                    _filterWeekType = selected.first;
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 课程网格
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _buildCourseGrid(context, service, timeSlots, courses, dailyCourses),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseGrid(
    BuildContext context,
    TimetableEditService service,
    List<TimeSlot> timeSlots,
    List<CourseInfo> courses,
    List<DailyCourse> dailyCourses,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    return DataTable(
      headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
      columns: [
        const DataColumn(label: Text('时间')),
        ...days.map((day) => DataColumn(label: Text(day))),
      ],
      rows: timeSlots.map((slot) {
        return DataRow(
          cells: [
            DataCell(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.name, style: MD3TypographyStyles.labelMedium(context)),
                  Text(
                    '${slot.startTime}-${slot.endTime}',
                    style: MD3TypographyStyles.bodySmall(context).copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            ...DayOfWeek.values.map((day) {
              final dailyCourse = dailyCourses.where((dc) =>
                dc.dayOfWeek == day &&
                dc.timeSlotId == slot.id &&
                (_filterWeekType == WeekType.both || dc.weekType == _filterWeekType || dc.weekType == WeekType.both)
              ).firstOrNull;
              
              final course = dailyCourse != null 
                  ? service.getCourseById(dailyCourse.courseId)
                  : null;
              
              return DataCell(
                _CourseCell(
                  course: course,
                  dailyCourse: dailyCourse,
                  onTap: () => _showCoursePickerDialog(context, service, slot, day),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _showAddScheduleDialog(BuildContext context, TimetableEditService service) async {
    final nameController = TextEditingController();
    int weekDay = DateTime.now().weekday;
    WeekType weekType = WeekType.both;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => MD3DialogStyles.dialog(
          context: context,
          title: '创建课表',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: nameController,
                label: '课表名称',
                hint: '例如: 周一课表',
              ),
              const SizedBox(height: 16),
              MD3FormStyles.dropdown<int>(
                context: context,
                value: weekDay,
                label: '适用星期',
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      weekDay = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('周一')),
                  DropdownMenuItem(value: 2, child: Text('周二')),
                  DropdownMenuItem(value: 3, child: Text('周三')),
                  DropdownMenuItem(value: 4, child: Text('周四')),
                  DropdownMenuItem(value: 5, child: Text('周五')),
                  DropdownMenuItem(value: 6, child: Text('周六')),
                  DropdownMenuItem(value: 0, child: Text('周日')),
                ],
              ),
              const SizedBox(height: 16),
              MD3FormStyles.dropdown<WeekType>(
                context: context,
                value: weekType,
                label: '周类�?,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      weekType = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(value: WeekType.both, child: Text('每周')),
                  DropdownMenuItem(value: WeekType.single, child: Text('单周')),
                  DropdownMenuItem(value: WeekType.double, child: Text('双周')),
                ],
              ),
            ],
          ),
          actions: [
            MD3ButtonStyles.text(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            MD3ButtonStyles.filled(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('创建'),
            ),
          ],
        ),
      ),
    );
    
    if (result == true && nameController.text.isNotEmpty) {
      final newSchedule = Schedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        triggerRule: ScheduleTriggerRule(
          weekDay: weekDay,
          weekType: weekType,
          isEnabled: true,
        ),
        courses: [],
        isAutoEnabled: true,
      );
      service.addSchedule(newSchedule);
      setState(() {
        _selectedScheduleId = newSchedule.id;
      });
    }
  }

  Future<void> _showCoursePickerDialog(
    BuildContext context,
    TimetableEditService service,
    TimeSlot slot,
    DayOfWeek day,
  ) async {
    final courses = service.courses;
    
    final selectedCourse = await MD3DialogStyles.showSelectionDialog<CourseInfo?>(
      context: context,
      title: '选择课程',
      selectedValue: null,
      items: [
        const SelectionDialogItem(
          value: null,
          title: '无课�?,
          icon: Icon(Icons.remove_circle_outline),
        ),
        ...courses.map((course) {
          final color = ColorUtils.parseHexColor(course.color) ?? 
              ColorUtils.generateColorFromName(course.name);
          return SelectionDialogItem(
            value: course,
            title: course.name,
            subtitle: course.teacher.isNotEmpty ? course.teacher : null,
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ],
    );
    
    if (selectedCourse == null) {
      // Remove existing daily course
      final existing = service.dailyCourses.where((dc) =>
        dc.dayOfWeek == day && dc.timeSlotId == slot.id
      ).firstOrNull;
      if (existing != null) {
        service.deleteDailyCourse(existing.id);
      }
    } else {
      // Add or update daily course
      final newDailyCourse = DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: day,
        timeSlotId: slot.id,
        courseId: selectedCourse.id,
        weekType: _filterWeekType,
      );
      service.addDailyCourse(newDailyCourse);
    }
  }

  String _getTriggerRuleText(ScheduleTriggerRule rule) {
    const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    String dayText = days[rule.weekDay];
    String weekTypeText = '';
    switch (rule.weekType) {
      case WeekType.single:
        weekTypeText = ' (单周)';
        break;
      case WeekType.double:
        weekTypeText = ' (双周)';
        break;
      case WeekType.both:
        weekTypeText = '';
        break;
    }
    return '$dayText$weekTypeText';
  }
}

/// 课程单元�?
class _CourseCell extends StatelessWidget {
  final CourseInfo? course;
  final DailyCourse? dailyCourse;
  final VoidCallback onTap;

  const _CourseCell({
    this.course,
    this.dailyCourse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (course == null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 80,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: colorScheme.outline,
              size: 20,
            ),
          ),
        ),
      );
    }
    
    final color = ColorUtils.parseHexColor(course!.color) ?? 
        ColorUtils.generateColorFromName(course!.name);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course!.displayName,
              style: TextStyle(
                color: ColorUtils.getContrastTextColor(color),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (dailyCourse != null && dailyCourse!.weekType != WeekType.both)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dailyCourse!.weekType == WeekType.single ? '�? : '�?,
                  style: TextStyle(
                    color: ColorUtils.getContrastTextColor(color),
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 课表网格编辑�?
class _ScheduleGridEditor extends StatelessWidget {
  final Schedule schedule;
  final TimetableEditService service;
  final WeekType filterWeekType;
  final ValueChanged<WeekType> onFilterChanged;
  final VoidCallback onDelete;

  const _ScheduleGridEditor({
    required this.schedule,
    required this.service,
    required this.filterWeekType,
    required this.onFilterChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeSlots = widget.schedule.timeLayoutId != null
        ? widget.service.getTimeLayoutById(widget.schedule.timeLayoutId!)
            ?.timeSlots ?? widget.service.timeSlots
        : widget.service.timeSlots;
    final courses = widget.service.courses;
    
    return Column(
      children: [
        // 头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(widget.schedule.name, style: MD3TypographyStyles.titleMedium(context)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTriggerRuleText(widget.schedule.triggerRule),
                  style: MD3TypographyStyles.labelSmall(context),
                ),
              ),
              const Spacer(),
              // 周类型筛选
              MD3FormStyles.segmentedButton<WeekType>(
                context: context,
                segments: const [
                  ButtonSegment(value: WeekType.both, label: Text('每周')),
                  ButtonSegment(value: WeekType.single, label: Text('单周')),
                  ButtonSegment(value: WeekType.double, label: Text('双周')),
                ],
                selected: {widget.filterWeekType},
                onSelectionChanged: widget.onFilterChanged,
                buttonStyle: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))),
              ),
              const SizedBox(width: 8),
              MD3ButtonStyles.iconOutlined(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteSchedule(context),
                tooltip: '删除课表',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 课程网格
        Expanded(
          child: timeSlots.isEmpty
              ? _buildEmptyState(context)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: _buildScheduleGrid(context, timeSlots, courses),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无时间点',
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请在时间表中添加时间点',
            style: MD3TypographyStyles.bodyMedium(context).copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid(
    BuildContext context,
    List<TimeSlot> timeSlots,
    List<CourseInfo> courses,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    return DataTable(
      headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
      columns: [
        const DataColumn(label: Text('时间')),
        ...days.map((day) => DataColumn(label: Text(day))),
      ],
      rows: timeSlots.map((slot) {
        return DataRow(
          cells: [
            DataCell(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.name, style: MD3TypographyStyles.labelMedium(context)),
                  Text(
                    '${slot.startTime}-${slot.endTime}',
                    style: MD3TypographyStyles.bodySmall(context).copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            ...DayOfWeek.values.map((day) {
              final dailyCourse = widget.schedule.courses.where((dc) =>
                dc.dayOfWeek == day &&
                dc.timeSlotId == slot.id &&
                (widget.filterWeekType == WeekType.both || dc.weekType == widget.filterWeekType || dc.weekType == WeekType.both)
              ).firstOrNull;
              
              final course = dailyCourse != null 
                  ? widget.service.getCourseById(dailyCourse.courseId)
                  : null;
              
              return DataCell(
                _CourseCell(
                  course: course,
                  dailyCourse: dailyCourse,
                  onTap: () => _showCoursePickerDialog(context, slot, day),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _showCoursePickerDialog(
    BuildContext context,
    TimeSlot slot,
    DayOfWeek day,
  ) async {
    final courses = widget.service.courses;
    
    final selectedCourse = await MD3DialogStyles.showSelectionDialog<CourseInfo?>(
      context: context,
      title: '选择课程',
      selectedValue: null,
      items: [
        const SelectionDialogItem(
          value: null,
          title: '无课程',
          icon: Icon(Icons.remove_circle_outline),
        ),
        ...courses.map((course) {
          final color = ColorUtils.parseHexColor(course.color) ?? 
              ColorUtils.generateColorFromName(course.name);
          return SelectionDialogItem(
            value: course,
            title: course.name,
            subtitle: course.teacher.isNotEmpty ? course.teacher : null,
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ],
    );
    
    // 更新课程
    final updatedCourses = List<DailyCourse>.from(widget.schedule.courses);
    
    // 查找现有课程
    final existingIndex = updatedCourses.indexWhere((dc) =>
      dc.dayOfWeek == day &&
      dc.timeSlotId == slot.id &&
      dc.weekType == widget.filterWeekType
    );
    
    if (selectedCourse == null) {
      // 删除现有课程
      if (existingIndex != -1) {
        updatedCourses.removeAt(existingIndex);
      }
    } else {
      // 添加或更新课程
      final newDailyCourse = DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: day,
        timeSlotId: slot.id,
        courseId: selectedCourse.id,
        weekType: widget.filterWeekType,
      );
      
      if (existingIndex != -1) {
        updatedCourses[existingIndex] = newDailyCourse;
      } else {
        updatedCourses.add(newDailyCourse);
      }
    }
    
    // 更新课表
    final updatedSchedule = widget.schedule.copyWith(
      courses: updatedCourses,
    );
    widget.service.updateSchedule(updatedSchedule);
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无时间点',
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请在时间表中添加时间点',
            style: MD3TypographyStyles.bodyMedium(context).copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSchedule(BuildContext context) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: schedule.name,
    );
    
    if (confirmed == true) {
      service.deleteSchedule(schedule.id);
      onDelete();
    }
  }

  String _getTriggerRuleText(ScheduleTriggerRule rule) {
    const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    String dayText = days[rule.weekDay];
    String weekTypeText = '';
    switch (rule.weekType) {
      case WeekType.single:
        weekTypeText = ' (单周)';
        break;
      case WeekType.double:
        weekTypeText = ' (双周)';
        break;
      case WeekType.both:
        weekTypeText = '';
        break;
    }
    return '$dayText$weekTypeText';
  }
}
