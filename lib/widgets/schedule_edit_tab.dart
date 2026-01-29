import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_edit_model.dart';
import '../services/classisland_import_service.dart';
import '../services/general_import_service.dart';
import '../services/timetable_edit_service.dart';
import '../services/timetable_export_service.dart';
import '../utils/color_utils.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_dialog_styles.dart';
import '../utils/md3_form_styles.dart';
import '../utils/md3_typography_styles.dart';
import 'timetable_edit/daily_time_layout_selector.dart';
import 'timetable_edit/quick_schedule_panel.dart';
import 'timetable_edit/timetable_tree_widget.dart';
import 'timetable_edit/trigger_condition_editor.dart';

/// 课表编辑标签页 - 层级目录树视图
class ScheduleEditTab extends StatefulWidget {
  const ScheduleEditTab({super.key});

  @override
  State<ScheduleEditTab> createState() => _ScheduleEditTabState();
}

class _ScheduleEditTabState extends State<ScheduleEditTab> {
  String? _selectedScheduleId;
  int? _selectedDayIndex; // 0-6 (Mon-Sun based on implementation)
  final TimetableExportService _exportService = TimetableExportService();
  
  // Quick Edit State
  bool _isQuickEditMode = false;
  int _quickEditSlotIndex = 0;
  // Stack to store history for undo: [DayIndex, SlotIndex, PreviousCourse?]
  final List<Map<String, dynamic>> _quickEditHistory = [];

  // SnackBar helpers...
  void _showSuccessSnackBar(String message) {
    if (!mounted) {
      return;
    }
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
    if (!mounted) {
      return;
    }
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

  // Import/Export methods...
  // ignore: unused_element
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

  // ignore: unused_element
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

  // ignore: unused_element
  Future<void> _importGeneral(TimetableEditService service) async {
    final result = await GeneralImportService.importFromFile();
    if (!mounted) return;
    if (result.success && result.data != null) {
      service.loadTimetableData(result.data!);
      _showSuccessSnackBar('已导入: ${result.stats}');
    } else {
      _showErrorSnackBar(result.errorMessage ?? '导入失败');
    }
  }

  // ignore: unused_element
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧: 目录树
            SizedBox(
              width: 280,
              child: TimetableTreeWidget(
                schedules: schedules,
                groups: service.groups,
                selectedScheduleId: _selectedScheduleId,
                selectedDayIndex: _selectedDayIndex,
                onScheduleSelected: (id) {
                  setState(() {
                    _selectedScheduleId = id;
                    _selectedDayIndex = null;
                  });
                },
                onDaySelected: (scheduleId, dayIndex) {
                  // Deprecated: Tree no longer selects days directly
                  // But we might want to keep the callback for now or remove it.
                  // If we remove the day nodes from tree, this won't be called.
                  // For now, let's keep it but it might not be used.
                  setState(() {
                    _selectedScheduleId = scheduleId;
                    _selectedDayIndex = dayIndex;
                  });
                },
                onAddSchedule: (groupId) => _showAddScheduleDialog(context, service, groupId),
                onAddGroup: (parentId) => _showAddGroupDialog(context, service, parentId),
                onDeleteGroup: (groupId) => service.deleteGroup(groupId),
                onUpdateGroup: (group) => service.updateGroup(group),
              ),
            ),
            const VerticalDivider(width: 1),
            // 右侧: 编辑区
            Expanded(
              child: _selectedScheduleId == null
                  ? _buildEmptyState(context, service)
                  : Row(
                      children: [
                        Expanded(child: _buildEditorContent(context, service)),
                        if (_isQuickEditMode && _selectedScheduleId != null)
                          _buildQuickEditPanel(context, service),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickEditPanel(BuildContext context, TimetableEditService service) {
    final schedule = service.getScheduleById(_selectedScheduleId!);
    if (schedule == null) {
      return const SizedBox();
    }

    final dayIndex = _selectedDayIndex ?? 0;
    
    // Get effective time slots
    final currentLayoutId = schedule.dayTimeLayoutIds[dayIndex];
    final effectiveLayoutId = currentLayoutId ?? schedule.timeLayoutId;
    final timeLayout = effectiveLayoutId != null
        ? service.getTimeLayoutById(effectiveLayoutId)
        : null;
    final timeSlots = timeLayout?.timeSlots ?? service.timeSlots;

    return QuickSchedulePanel(
        service: service,
        schedule: schedule,
        currentDayIndex: dayIndex,
        currentSlotIndex: _quickEditSlotIndex,
        timeSlots: timeSlots,
        onCourseSelected: (course) => _handleQuickEdit(service, schedule, timeSlots, course),
        onSkipSlot: () => _handleQuickEdit(service, schedule, timeSlots, null),
        onUndo: () => _handleQuickEditUndo(service, schedule),
        onClose: () {
          setState(() {
            _isQuickEditMode = false;
            _quickEditHistory.clear();
          });
        },
    );
  }

  void _handleQuickEdit(
    TimetableEditService service,
    Schedule schedule,
    List<TimeSlot> timeSlots,
    CourseInfo? course,
  ) {
    if (_quickEditSlotIndex >= timeSlots.length) {
      return;
    }

    final dayIndex = _selectedDayIndex ?? 0;
    final dayOfWeek = DayOfWeek.values[dayIndex];
    final slot = timeSlots[_quickEditSlotIndex];

    // 1. Save history
    // Find if there was a course before (for undo)
    final existingCourse = schedule.courses.where((dc) => 
      dc.dayOfWeek == dayOfWeek && dc.timeSlotId == slot.id
    ).firstOrNull;

    _quickEditHistory.add({
      'dayIndex': dayIndex,
      'slotIndex': _quickEditSlotIndex,
      'prevCourse': existingCourse,
    });

    // 2. Update Schedule
    final updatedCourses = List<DailyCourse>.from(schedule.courses);
    // Remove existing
    updatedCourses.removeWhere((dc) => dc.dayOfWeek == dayOfWeek && dc.timeSlotId == slot.id);
    
    // Add new if not null (skip)
    if (course != null) {
      updatedCourses.add(DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: dayOfWeek,
        timeSlotId: slot.id,
        courseId: course.id,
        weekType: WeekType.both,
      ));
    }
    
    service.updateSchedule(schedule.copyWith(courses: updatedCourses));

    // 3. Advance to next slot/day
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _quickEditSlotIndex++;
      if (_quickEditSlotIndex >= timeSlots.length) {
        // Switch to next day
        if (dayIndex < 6) {
           _selectedDayIndex = dayIndex + 1;
           _quickEditSlotIndex = 0;
           _showSuccessSnackBar(l10n.quickEditDoneNextDay(_getDayName(dayOfWeek)));
        } else {
           _showSuccessSnackBar(l10n.quickEditAllDone);
           _isQuickEditMode = false; // Exit mode
        }
      }
    });
  }

  void _handleQuickEditUndo(TimetableEditService service, Schedule schedule) {
    if (_quickEditHistory.isEmpty) {
      return;
    }

    final lastAction = _quickEditHistory.removeLast();
    final dayIndex = lastAction['dayIndex'] as int;
    final slotIndex = lastAction['slotIndex'] as int;
    final prevCourse = lastAction['prevCourse'] as DailyCourse?;

    final dayOfWeek = DayOfWeek.values[dayIndex];
    
    // Need to get slots again to find ID, assuming slots didn't change
    // We can just query by dayIndex, but we need the slot ID. 
    // Wait, prevCourse has slot ID. But if prevCourse is null (it was empty), we need to know which slot ID to clear.
    // So we need to re-fetch slots logic or store slot ID in history.
    // Let's rely on re-fetching logic in UI but here we are in logic method.
    // Simpler: Just restore `prevCourse`.
    // If `prevCourse` was null, it means it was empty. We should ensure it's empty now.
    // But we don't know the slot ID if prevCourse is null.
    // So we DO need the slot ID.
    // Let's assume we can get it from the current state? No, we might have switched days.
    
    // Better approach for Undo:
    // Just revert the schedule change and restore indices.
    
    // However, I need to know which slot ID I just modified to clear it if I am reverting to empty.
    // Let's fetch the slot ID from the service/layout again.
    
    final currentLayoutId = schedule.dayTimeLayoutIds[dayIndex];
    final effectiveLayoutId = currentLayoutId ?? schedule.timeLayoutId;
    final timeLayout = effectiveLayoutId != null
        ? service.getTimeLayoutById(effectiveLayoutId)
        : null;
    final timeSlots = timeLayout?.timeSlots ?? service.timeSlots;

    if (slotIndex >= timeSlots.length) {
      return; // Should not happen if data consistent
    }
    final slotId = timeSlots[slotIndex].id;

    final updatedCourses = List<DailyCourse>.from(schedule.courses);
    // Remove current (the one we just added/skipped)
    updatedCourses.removeWhere((dc) => dc.dayOfWeek == dayOfWeek && dc.timeSlotId == slotId);
    
    // Restore previous
    if (prevCourse != null) {
      updatedCourses.add(prevCourse);
    }
    
    service.updateSchedule(schedule.copyWith(courses: updatedCourses));

    setState(() {
      _selectedDayIndex = dayIndex;
      _quickEditSlotIndex = slotIndex;
    });
  }

  Widget _buildEmptyState(BuildContext context, TimetableEditService service) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.selectOrCreateTimetable,
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          MD3ButtonStyles.filledTonalButton(
            context: context,
            onPressed: () => _showAddScheduleDialog(context, service, null),
            text: l10n.createTimetable,
          ),
        ],
      ),
    );
  }

  Widget _buildEditorContent(BuildContext context, TimetableEditService service) {
    final schedule = service.getScheduleById(_selectedScheduleId!);
    if (schedule == null) {
      return const SizedBox();
    }
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      key: ValueKey(schedule.id), // Reset controller when schedule changes
      length: 8,
      initialIndex: _selectedDayIndex ?? 0,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: l10n.monday),
                Tab(text: l10n.tuesday),
                Tab(text: l10n.wednesday),
                Tab(text: l10n.thursday),
                Tab(text: l10n.friday),
                Tab(text: l10n.saturday),
                Tab(text: l10n.sunday),
                Tab(text: l10n.settingsTitle, icon: const Icon(Icons.settings_outlined, size: 18)),
              ],
            ),
          ),
          if (_isQuickEditMode)
            LinearProgressIndicator(
              value: 0, // Indeterminate or based on slots
              // To make it useful we need total slots. 
              // But simpler is just a divider or small hint.
              // Let's just use a different color for TabBar? 
              // Or maybe just show it's in quick mode.
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              color: Theme.of(context).colorScheme.primary,
              minHeight: 2,
            ),
          Expanded(
            child: TabBarView(
              // Disable swiping when in quick mode to avoid confusion?
              // No, user might want to look around.
              physics: _isQuickEditMode ? const NeverScrollableScrollPhysics() : null,
              children: [
                _buildDailyEditor(context, service, schedule, 0),
                _buildDailyEditor(context, service, schedule, 1),
                _buildDailyEditor(context, service, schedule, 2),
                _buildDailyEditor(context, service, schedule, 3),
                _buildDailyEditor(context, service, schedule, 4),
                _buildDailyEditor(context, service, schedule, 5),
                _buildDailyEditor(context, service, schedule, 6),
                _buildScheduleSettings(context, service, schedule),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSettings(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
  ) {
    final nameController = TextEditingController(text: schedule.name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('课表设置', style: MD3TypographyStyles.headlineSmall(context)),
              const Spacer(),
              // Quick Edit Toggle
              MD3ButtonStyles.filledTonalButton(
                context: context,
                icon: const Icon(Icons.flash_on),
                onPressed: () {
                    setState(() {
                      _isQuickEditMode = !_isQuickEditMode;
                      if (_isQuickEditMode) {
                        _quickEditSlotIndex = 0;
                        _quickEditHistory.clear();
                        _showSuccessSnackBar('已进入快速排课模式');
                      }
                    });
                },
                text: '快速排课',
              ),
              const SizedBox(width: 12),
              MD3ButtonStyles.iconOutlined(
                context: context,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteSchedule(context, service, schedule),
                tooltip: '删除课表',
              ),
            ],
          ),
          const SizedBox(height: 24),
          MD3FormStyles.outlinedTextField(
            context: context,
            controller: nameController,
            label: '课表名称',
            onChanged: (value) {
              if (value.isNotEmpty) {
                service.updateSchedule(schedule.copyWith(name: value));
              }
            },
          ),
          const SizedBox(height: 32),
          TriggerConditionEditor(
            triggers: schedule.triggers,
            onChanged: (newTriggers) {
              service.updateSchedule(schedule.copyWith(triggers: newTriggers));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEditor(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
    int dayIndex,
  ) {
    final dayName = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'][dayIndex];
    final currentLayoutId = schedule.dayTimeLayoutIds[dayIndex];
    
    // 获取实际生效的时间表用于显示课程网格
    final effectiveLayoutId = currentLayoutId ?? schedule.timeLayoutId;
    final timeLayout = effectiveLayoutId != null
        ? service.getTimeLayoutById(effectiveLayoutId)
        : null;
        
    final timeSlots = timeLayout?.timeSlots ?? service.timeSlots;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('$dayName - 课程安排', style: MD3TypographyStyles.titleMedium(context)),
              const SizedBox(width: 8),
              // Copy button
              PopupMenuButton<int>(
                icon: const Icon(Icons.copy_outlined, size: 20),
                tooltip: '复制课程到...',
                onSelected: (targetDayIndex) => _copyScheduleToDay(
                  context,
                  service,
                  schedule,
                  dayIndex,
                  targetDayIndex,
                ),
                itemBuilder: (context) {
                   final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                   return List.generate(7, (index) {
                     if (index == dayIndex) return null;
                     return PopupMenuItem(
                       value: index,
                       child: Text('复制到 ${days[index]}'),
                     );
                   }).whereType<PopupMenuItem<int>>().toList();
                },
              ),
              const Spacer(),
              SizedBox(
                width: 240,
                child: DailyTimeLayoutSelector(
                  timeLayouts: service.timeLayouts,
                  selectedLayoutId: currentLayoutId,
                  onChanged: (newId) {
                    final newMap = Map<int, String>.from(schedule.dayTimeLayoutIds);
                    if (newId == null) {
                      newMap.remove(dayIndex);
                    } else {
                      newMap[dayIndex] = newId;
                    }
                    service.updateSchedule(schedule.copyWith(dayTimeLayoutIds: newMap));
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Grid
        Expanded(
          child: timeSlots.isEmpty
              ? Center(child: Text('该时间表没有时间段', style: TextStyle(color: Theme.of(context).colorScheme.outline)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildDayCourseList(context, service, schedule, dayIndex, timeSlots),
                ),
        ),
      ],
    );
  }

  void _copyScheduleToDay(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
    int sourceDayIndex,
    int targetDayIndex,
  ) {
    // 1. Get source courses
    final sourceDay = DayOfWeek.values[sourceDayIndex];
    final targetDay = DayOfWeek.values[targetDayIndex];
    
    final sourceCourses = schedule.courses.where((c) => c.dayOfWeek == sourceDay).toList();
    
    // 2. Remove existing courses on target day
    final updatedCourses = List<DailyCourse>.from(schedule.courses);
    updatedCourses.removeWhere((c) => c.dayOfWeek == targetDay);
    
    // 3. Add copies
    for (final course in sourceCourses) {
      updatedCourses.add(course.copyWith(
        id: '${DateTime.now().millisecondsSinceEpoch}_${updatedCourses.length}',
        dayOfWeek: targetDay,
      ));
    }
    
    service.updateSchedule(schedule.copyWith(courses: updatedCourses));
    final l10n = AppLocalizations.of(context)!;
    _showSuccessSnackBar(l10n.scheduleCopied(_getDayName(targetDay)));
  }

  String _getDayName(DayOfWeek day) {
    final l10n = AppLocalizations.of(context)!;
    switch (day) {
      case DayOfWeek.monday: return l10n.monday;
      case DayOfWeek.tuesday: return l10n.tuesday;
      case DayOfWeek.wednesday: return l10n.wednesday;
      case DayOfWeek.thursday: return l10n.thursday;
      case DayOfWeek.friday: return l10n.friday;
      case DayOfWeek.saturday: return l10n.saturday;
      case DayOfWeek.sunday: return l10n.sunday;
    }
  }

  Widget _buildDayCourseList(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
    int dayIndex,
    List<TimeSlot> timeSlots,
  ) {
    // Model's DayOfWeek enum logic: 
    // Assuming DayOfWeek.values[dayIndex] corresponds to the dayIndex we passed (0-6).
    // Let's verify: DayOfWeek enum usually: monday, tuesday... 
    // In `TimetableTreeWidget` we used `DayOfWeek.values[index]`.
    // So here we should use the same.
    final dayOfWeek = DayOfWeek.values[dayIndex];
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: timeSlots.map((slot) {
        // Find course for this slot and day
        final dailyCourse = schedule.courses.where((dc) => 
          dc.dayOfWeek == dayOfWeek && dc.timeSlotId == slot.id
        ).firstOrNull;
        
        final course = dailyCourse != null 
            ? service.getCourseById(dailyCourse.courseId) 
            : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showCoursePickerDialog(context, service, schedule, slot, dayOfWeek),
            onLongPress: course != null 
                ? () => _showCourseContextMenu(context, service, schedule, slot, dayOfWeek, course)
                : null,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(slot.startTime, style: MD3TypographyStyles.labelMedium(context)),
                    Text(slot.endTime, style: MD3TypographyStyles.labelSmall(context).copyWith(color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
              ),
              title: Text(course?.name ?? l10n.noCourse),
              subtitle: Text(slot.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (course != null) ...[
                    CircleAvatar(
                      backgroundColor: ColorUtils.parseHexColor(course.color) ?? Colors.grey,
                      radius: 6,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        tooltip: l10n.clearCourse,
                        onPressed: () {
                          // Clear course
                          final updatedCourses = List<DailyCourse>.from(schedule.courses);
                          updatedCourses.removeWhere((dc) => dc.dayOfWeek == dayOfWeek && dc.timeSlotId == slot.id);
                          service.updateSchedule(schedule.copyWith(courses: updatedCourses));
                        },
                    ),
                  ] else 
                    const Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showCourseContextMenu(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
    TimeSlot slot,
    DayOfWeek day,
    CourseInfo course,
  ) {
    // ignore: unused_local_variable
    final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final l10n = AppLocalizations.of(context)!;
    
    // We need to get the tap position, but LongPress doesn't give it easily without GestureDetector details.
    // For now, let's use a ModalBottomSheet or a Dialog, or a PopupMenuButton on the card itself if we change structure.
    // Simpler: Just showing a bottom sheet.
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editCourseInfo(course.name)),
              onTap: () {
                Navigator.pop(context);
                // Switch to Subject Tab and edit? Or show dialog?
                // Showing dialog is better.
                _showEditSubjectDialog(context, service, course);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.removeFromSlot, style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                final updatedCourses = List<DailyCourse>.from(schedule.courses);
                updatedCourses.removeWhere((dc) => dc.dayOfWeek == day && dc.timeSlotId == slot.id);
                service.updateSchedule(schedule.copyWith(courses: updatedCourses));
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _showEditSubjectDialog(
      BuildContext context, TimetableEditService service, CourseInfo course) async {
    // This requires replicating SubjectEditTab's dialog logic or reusing it.
    // For simplicity, let's just show a snackbar saying "Please go to Subjects tab" or implement a simple edit.
    // Implementing simple edit here.
    final nameController = TextEditingController(text: course.name);
    final teacherController = TextEditingController(text: course.teacher);
    final roomController = TextEditingController(text: course.classroom);
    final l10n = AppLocalizations.of(context)!;
    
    await showDialog<void>(
      context: context,
      builder: (context) => MD3DialogStyles.dialog(
        context: context,
        title: l10n.editCourse,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MD3FormStyles.outlinedTextField(
                context: context, controller: nameController, label: l10n.courseName),
            const SizedBox(height: 16),
            MD3FormStyles.outlinedTextField(
                context: context, controller: teacherController, label: l10n.teacherName),
            const SizedBox(height: 16),
            MD3FormStyles.outlinedTextField(
                context: context, controller: roomController, label: l10n.classroom),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              final updated = course.copyWith(
                name: nameController.text,
                teacher: teacherController.text,
                classroom: roomController.text,
              );
              service.updateCourse(updated);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSubjectDialog(
      BuildContext context, TimetableEditService service) async {
    final nameController = TextEditingController();
    final teacherController = TextEditingController();
    final roomController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) => MD3DialogStyles.dialog(
        context: context,
        title: l10n.addCourse,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MD3FormStyles.outlinedTextField(
                context: context, controller: nameController, label: l10n.courseName),
            const SizedBox(height: 16),
            MD3FormStyles.outlinedTextField(
                context: context, controller: teacherController, label: l10n.teacherName),
            const SizedBox(height: 16),
            MD3FormStyles.outlinedTextField(
                context: context, controller: roomController, label: l10n.classroom),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCourse = CourseInfo(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  teacher: teacherController.text,
                  classroom: roomController.text,
                  color: ColorUtils.toHexString(
                      ColorUtils.generateColorFromName(nameController.text)),
                );
                service.addCourse(newCourse);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddScheduleDialog(
    BuildContext context,
    TimetableEditService service,
    String? groupId,
  ) async {
    final nameController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => MD3DialogStyles.dialog(
        context: context,
        title: l10n.createTimetable,
        content: MD3FormStyles.outlinedTextField(
          context: context,
          controller: nameController,
          label: l10n.timetableName,
          hint: l10n.exampleScheduleName,
        ),
        actions: [
          MD3ButtonStyles.textButton(
            context: context,
            onPressed: () => Navigator.pop(context, false),
            text: l10n.cancel,
          ),
          MD3ButtonStyles.filledButton(
            context: context,
            onPressed: () => Navigator.pop(context, true),
            text: l10n.create,
          ),
        ],
      ),
    );

    if ((result ?? false) && nameController.text.isNotEmpty) {
      final newSchedule = Schedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        groupId: groupId,
        triggers: [], // Start with no triggers
        courses: [],
      );
      service.addSchedule(newSchedule);
      setState(() {
        _selectedScheduleId = newSchedule.id;
        _selectedDayIndex = null;
      });
    }
  }

  Future<void> _showAddGroupDialog(
    BuildContext context,
    TimetableEditService service,
    String? parentId,
  ) async {
    final nameController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => MD3DialogStyles.dialog(
        context: context,
        title: l10n.createGroup,
        content: MD3FormStyles.outlinedTextField(
          context: context,
          controller: nameController,
          label: l10n.groupName,
          hint: l10n.exampleGroupName,
        ),
        actions: [
          MD3ButtonStyles.textButton(
            context: context,
            onPressed: () => Navigator.pop(context, false),
            text: l10n.cancel,
          ),
          MD3ButtonStyles.filledButton(
            context: context,
            onPressed: () => Navigator.pop(context, true),
            text: l10n.create,
          ),
        ],
      ),
    );

    if ((result ?? false) && nameController.text.isNotEmpty) {
      final newGroup = ScheduleGroup(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        parentId: parentId,
      );
      service.addGroup(newGroup);
    }
  }

  Future<void> _deleteSchedule(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
  ) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: schedule.name,
    );

    if (confirmed ?? false) {
      service.deleteSchedule(schedule.id);
      setState(() {
        _selectedScheduleId = null;
        _selectedDayIndex = null;
      });
    }
  }

  Future<void> _showCoursePickerDialog(
    BuildContext context,
    TimetableEditService service,
    Schedule schedule,
    TimeSlot slot,
    DayOfWeek day,
  ) async {
    final courses = service.courses;
    final l10n = AppLocalizations.of(context)!;

    final selectedCourse = await MD3DialogStyles.showSelectionDialog<CourseInfo?>(
      context: context,
      title: l10n.select,
      items: [
        SelectionDialogItem(
          value: null,
          title: l10n.noCourse,
          icon: const Icon(Icons.remove_circle_outline),
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
      actions: [
        TextButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            await _showAddSubjectDialog(context, service);
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.addCourse),
        ),
      ],
    );

    // Update Schedule
    // Logic: Remove existing for this slot/day, add new if not null
    final updatedCourses = List<DailyCourse>.from(schedule.courses);
    updatedCourses.removeWhere((dc) => dc.dayOfWeek == day && dc.timeSlotId == slot.id);
    
    if (selectedCourse != null) {
      updatedCourses.add(DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: day,
        timeSlotId: slot.id,
        courseId: selectedCourse.id,
        weekType: WeekType.both, // Default, not used in new logic much
      ));
    }
    
    service.updateSchedule(schedule.copyWith(courses: updatedCourses));
  }
}
