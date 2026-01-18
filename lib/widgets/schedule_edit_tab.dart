import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/timetable_edit_model.dart';
import '../services/classisland_import_service.dart';
import '../services/timetable_edit_service.dart';
import '../services/timetable_export_service.dart';
import '../utils/color_utils.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_dialog_styles.dart';
import '../utils/md3_form_styles.dart';
import '../utils/md3_typography_styles.dart';

/// 课表编辑标签页 - 网格视图
class ScheduleEditTab extends StatefulWidget {
  const ScheduleEditTab({super.key});

  @override
  State<ScheduleEditTab> createState() => _ScheduleEditTabState();
}

class _ScheduleEditTabState extends State<ScheduleEditTab> {
  String? _selectedScheduleId;
  WeekType _filterWeekType = WeekType.both;
  final TimetableExportService _exportService = TimetableExportService();

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: colorScheme.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _importFromJson(TimetableEditService service) async {
    final result = await _exportService.importFromFileWithStats();
    if (!mounted) return;
    
    if (result.success && result.data != null) {
      service.loadTimetableData(result.data!);
      _showSuccessSnackBar('已导入: ${result.stats}');
    } else {
      _showErrorSnackBar(result.errorMessage ?? '导入失败');
    }
  }

  Future<void> _importFromClassIsland(TimetableEditService service) async {
    final result = await ClassislandImportService.importFromFileWithStats();
    if (!mounted) return;
    
    if (result.success && result.data != null) {
      service.loadTimetableData(result.data!);
      _showSuccessSnackBar('已导入: ${result.stats}');
    } else {
      _showErrorSnackBar(result.errorMessage ?? '导入失败');
    }
  }

  Future<void> _exportTimetable(TimetableEditService service) async {
    try {
      final data = service.getTimetableData();
      final success = await _exportService.exportToFile(data);
      if (success && mounted) {
        _showSuccessSnackBar('课表数据已导出');
      }
    } catch (e) {
      _showErrorSnackBar('导出失败: $e');
    }
  }

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
            // 右侧: 课程网格编辑器
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('课表列表', style: MD3TypographyStyles.titleMedium(context)),
                  const Spacer(),
                  // 导入/导出菜单按钮
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: colorScheme.primary),
                    tooltip: '导入/导出',
                    onSelected: (result) {
                      if (result == 'export_json') {
                        _exportTimetable(service);
                      } else if (result == 'import_json') {
                        _importFromJson(service);
                      } else if (result == 'import_classisland') {
                        _importFromClassIsland(service);
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'import_json',
                        child: ListTile(
                          leading: Icon(Icons.file_upload_outlined),
                          title: Text('导入课表'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'export_json',
                        child: ListTile(
                          leading: Icon(Icons.file_download_outlined),
                          title: Text('导出课表'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'import_classisland',
                        child: ListTile(
                          leading: Icon(Icons.sync_alt),
                          title: Text('从ClassIsland导入'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  MD3ButtonStyles.iconFilledTonal(
                    context: context,
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddScheduleDialog(context, service),
                    tooltip: '添加课表',
                  ),
                ],
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
          MD3ButtonStyles.filledTonalButton(
            context: context,
            onPressed: () => _showAddScheduleDialog(context, service),
            text: '创建课表',
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
              '请先在时间表中添加时间点',
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
              // 周类型筛选
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
                (_filterWeekType == WeekType.both || dc.weekType == _filterWeekType || dc.weekType == WeekType.both),
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
    int weekDay = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;
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
                label: '周类型',
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
            MD3ButtonStyles.textButton(
              context: context,
              onPressed: () => Navigator.pop(context, false),
              text: '取消',
            ),
            MD3ButtonStyles.filledButton(
              context: context,
              onPressed: () => Navigator.pop(context, true),
              text: '创建',
            ),
          ],
        ),
      ),
    );
    
    if ((result ?? false) && nameController.text.isNotEmpty) {
      final newSchedule = Schedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        triggerRule: ScheduleTriggerRule(
          weekDay: weekDay,
          weekType: weekType,
        ),
        courses: [],
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
    
    if (selectedCourse == null) {
      // 删除现有课程
      final existing = service.dailyCourses.where((dc) =>
        dc.dayOfWeek == day && dc.timeSlotId == slot.id,
      ).firstOrNull;
      if (existing != null) {
        service.deleteDailyCourse(existing.id);
      }
    } else {
      // 添加或更新课程
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
    final dayText = days[rule.weekDay];
    final weekTypeText = switch (rule.weekType) {
      WeekType.single => ' (单周)',
      WeekType.double => ' (双周)',
      WeekType.both => '',
    };
    return '$dayText$weekTypeText';
  }
}

/// 课程单元格
class _CourseCell extends StatefulWidget {

  const _CourseCell({
    this.course,
    this.dailyCourse,
    required this.onTap,
  });
  final CourseInfo? course;
  final DailyCourse? dailyCourse;
  final VoidCallback onTap;

  @override
  State<_CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<_CourseCell> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (widget.course == null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            height: 64,
            decoration: BoxDecoration(
              color: _isHovering 
                  ? colorScheme.surfaceContainerHighest.withAlpha((255 * 0.5).round())
                  : Colors.transparent,
              border: Border.all(
                color: _isHovering 
                    ? colorScheme.outline 
                    : colorScheme.outlineVariant.withAlpha((255 * 0.5).round()),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                color: _isHovering ? colorScheme.primary : colorScheme.outline,
                size: 24,
              ),
            ),
          ),
        ),
      );
    }
    
    final color = ColorUtils.parseHexColor(widget.course!.color) ?? 
        ColorUtils.generateColorFromName(widget.course!.name);
    final textColor = ColorUtils.getContrastTextColor(color);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(_isHovering ? 255 : (255 * 0.9).round()),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovering 
                ? [
                    BoxShadow(
                      color: color.withAlpha((255 * 0.3).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.course!.displayName,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.course!.classroom.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  widget.course!.classroom,
                  style: TextStyle(
                    color: textColor.withAlpha((255 * 0.9).round()),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (widget.dailyCourse != null && widget.dailyCourse!.weekType != WeekType.both) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.dailyCourse!.weekType == WeekType.single ? '单周' : '双周',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 课表网格编辑器
class _ScheduleGridEditor extends StatelessWidget {

  const _ScheduleGridEditor({
    required this.schedule,
    required this.service,
    required this.filterWeekType,
    required this.onFilterChanged,
    required this.onDelete,
  });
  final Schedule schedule;
  final TimetableEditService service;
  final WeekType filterWeekType;
  final ValueChanged<WeekType> onFilterChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeSlots = schedule.timeLayoutId != null
        ? service.getTimeLayoutById(schedule.timeLayoutId!)
            ?.timeSlots ?? service.timeSlots
        : service.timeSlots;
    final courses = service.courses;
    
    return Column(
      children: [
        // 头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(schedule.name, style: MD3TypographyStyles.titleMedium(context)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTriggerRuleText(schedule.triggerRule),
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
                selected: {filterWeekType},
                onSelectionChanged: (selected) => onFilterChanged(selected.first),
              ),
              const SizedBox(width: 8),
              MD3ButtonStyles.iconOutlined(
                context: context,
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
              final dailyCourse = schedule.courses.where((dc) =>
                dc.dayOfWeek == day &&
                dc.timeSlotId == slot.id &&
                (filterWeekType == WeekType.both || dc.weekType == filterWeekType || dc.weekType == WeekType.both),
              ).firstOrNull;
              
              final course = dailyCourse != null 
                  ? service.getCourseById(dailyCourse.courseId)
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
    final courses = service.courses;
    
    final selectedCourse = await MD3DialogStyles.showSelectionDialog<CourseInfo?>(
      context: context,
      title: '选择课程',
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
    
    // 更新课程列表
    final updatedCourses = List<DailyCourse>.from(schedule.courses);
    
    // 查找现有课程索引
    final existingIndex = updatedCourses.indexWhere((dc) =>
      dc.dayOfWeek == day &&
      dc.timeSlotId == slot.id &&
      dc.weekType == filterWeekType,
    );
    
    if (selectedCourse == null) {
      // 删除现有课程
      if (existingIndex != -1) {
        updatedCourses.removeAt(existingIndex);
      }
    } else {
      // 创建新课程
      final newDailyCourse = DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: day,
        timeSlotId: slot.id,
        courseId: selectedCourse.id,
        weekType: filterWeekType,
      );
      
      // 添加或更新课程
      if (existingIndex != -1) {
        updatedCourses[existingIndex] = newDailyCourse;
      } else {
        updatedCourses.add(newDailyCourse);
      }
    }
    
    // 更新课表
    final updatedSchedule = schedule.copyWith(courses: updatedCourses);
    service.updateSchedule(updatedSchedule);
  }

  Future<void> _deleteSchedule(BuildContext context) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: schedule.name,
    );
    
    if (confirmed ?? false) {
      service.deleteSchedule(schedule.id);
      onDelete();
    }
  }

  String _getTriggerRuleText(ScheduleTriggerRule rule) {
    const days = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    final dayText = days[rule.weekDay];
    final weekTypeText = switch (rule.weekType) {
      WeekType.single => ' (单周)',
      WeekType.double => ' (双周)',
      WeekType.both => '',
    };
    return '$dayText$weekTypeText';
  }
}
