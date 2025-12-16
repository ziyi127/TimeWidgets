import 'package:flutter/material.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class TimetableGridTab extends StatelessWidget {
  final TimetableEditService service;

  const TimetableGridTab({super.key, required this.service});
  
  /// Generate a simple unique ID using timestamp and random numbers
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond % 1000;
    return 'daily_${timestamp}_$random';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeSlots = List<TimeSlot>.from(service.timeSlots)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // Filter only classTime for the grid to keep it clean, or include all?
    // Usually only classTime needs course assignment.
    final classSlots = timeSlots.where((t) => t.type == TimePointType.classTime).toList();

    return Column(
      children: [
        // Header Row (Days)
        Container(
          color: theme.colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.fromLTRB(60, 8, 0, 8), // 60 for time column
          child: Row(
            children: List.generate(7, (index) {
              final dayNames = ['一', '二', '三', '四', '五', '六', '日'];
              return Expanded(
                child: Center(
                  child: Text(
                    dayNames[index],
                    style: MD3TypographyStyles.titleSmall(context),
                  ),
                ),
              );
            }),
          ),
        ),
        
        // Grid
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Column
                SizedBox(
                  width: 60,
                  child: Column(
                    children: classSlots.map((slot) {
                      return Container(
                        height: 80, // Fixed height for cells
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                            right: BorderSide(color: theme.colorScheme.outlineVariant),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(slot.name, style: MD3TypographyStyles.labelMedium(context)),
                            Text(slot.startTime, style: MD3TypographyStyles.labelSmall(context)),
                            Text(slot.endTime, style: MD3TypographyStyles.labelSmall(context)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Days Columns
                Expanded(
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final dayOfWeek = DayOfWeek.values[dayIndex];
                      return Expanded(
                        child: Column(
                          children: classSlots.map((slot) {
                            return _buildCell(context, dayOfWeek, slot);
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCell(BuildContext context, DayOfWeek day, TimeSlot slot) {
    final theme = Theme.of(context);
    
    // Find courses for this slot
    final coursesInSlot = service.dailyCourses.where(
      (d) => d.dayOfWeek == day && d.timeSlotId == slot.id
    ).toList();

    final bothWeeksCourse = coursesInSlot.where((d) => d.weekType == WeekType.both).firstOrNull;
    final singleWeekCourse = coursesInSlot.where((d) => d.weekType == WeekType.single).firstOrNull;
    final doubleWeekCourse = coursesInSlot.where((d) => d.weekType == WeekType.double).firstOrNull;

    if (bothWeeksCourse != null) {
      return _buildTapableCell(
        context, 
        day, 
        slot, 
        bothWeeksCourse,
        isSplit: false
      );
    }
    
    if (singleWeekCourse == null && doubleWeekCourse == null) {
      // Empty, pass a dummy both-week course
      return _buildTapableCell(
        context, 
        day, 
        slot, 
        DailyCourse(
          id: '', 
          courseId: '', 
          dayOfWeek: day, 
          timeSlotId: slot.id, 
          weekType: WeekType.both
        ),
        isSplit: false
      );
    }

    // Split view
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          right: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTapableCell(
              context, 
              day, 
              slot, 
              singleWeekCourse ?? DailyCourse(
                id: '', 
                courseId: '', 
                dayOfWeek: day, 
                timeSlotId: slot.id, 
                weekType: WeekType.single
              ),
              isSplit: true,
              label: '单周'
            )
          ),
          Container(width: 1, color: theme.colorScheme.outlineVariant),
          Expanded(
            child: _buildTapableCell(
              context, 
              day, 
              slot, 
              doubleWeekCourse ?? DailyCourse(
                id: '', 
                courseId: '', 
                dayOfWeek: day, 
                timeSlotId: slot.id, 
                weekType: WeekType.double
              ),
              isSplit: true,
              label: '双周'
            )
          ),
        ],
      ),
    );
  }

  Widget _buildTapableCell(
    BuildContext context, 
    DayOfWeek day, 
    TimeSlot slot, 
    DailyCourse dailyCourse, 
    {required bool isSplit, String? label}
  ) {
    final theme = Theme.of(context);
    
    CourseInfo? course;
    if (dailyCourse.courseId.isNotEmpty) {
      try {
        course = service.courses.firstWhere((c) => c.id == dailyCourse.courseId);
      } catch (e) {
        // Course might have been deleted
      }
    }

    return InkWell(
      onTap: () => _showCourseSelectionDialog(context, day, slot, dailyCourse),
      child: Container(
        height: isSplit ? double.infinity : 80,
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: !isSplit ? Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            right: BorderSide(color: theme.colorScheme.outlineVariant),
          ) : null,
          color: course != null 
              ? Color(int.parse(course.color.replaceFirst('#', '0xFF'))).withValues(alpha: 0.2)
              : null,
        ),
        child: Stack(
          children: [
            if (course != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.displayName,
                      textAlign: TextAlign.center,
                      style: MD3TypographyStyles.bodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(course.color.replaceFirst('#', '0xFF'))),
                        fontSize: isSplit ? 10 : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (course.classroom.isNotEmpty)
                      Text(
                        course.classroom,
                        style: MD3TypographyStyles.labelSmall(context).copyWith(
                           fontSize: isSplit ? 8 : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            if (label != null)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCourseSelectionDialog(
    BuildContext context, 
    DayOfWeek day, 
    TimeSlot slot, 
    DailyCourse currentDailyCourse
  ) async {
    final courses = service.courses;
    WeekType selectedWeekType = currentDailyCourse.weekType;
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_getDayName(day)} - ${slot.name}'),
                const SizedBox(height: 8),
                // Week Type Selector
                SegmentedButton<WeekType>(
                  segments: const [
                    ButtonSegment(value: WeekType.both, label: Text('全周')),
                    ButtonSegment(value: WeekType.single, label: Text('单周')),
                    ButtonSegment(value: WeekType.double, label: Text('双周')),
                  ],
                  selected: {selectedWeekType},
                  onSelectionChanged: (Set<WeekType> newSelection) {
                    setState(() {
                      selectedWeekType = newSelection.first;
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.clear),
                    title: const Text('无课 / 清除'),
                    onTap: () {
                      if (currentDailyCourse.id.isNotEmpty) {
                        service.deleteDailyCourse(currentDailyCourse.id);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        // Check if this specific course is selected for the current state
                        final isSelected = currentDailyCourse.courseId == course.id && 
                                           currentDailyCourse.weekType == selectedWeekType;
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(int.parse(course.color.replaceFirst('#', '0xFF'))),
                            radius: 12,
                          ),
                          title: Text(course.name),
                          subtitle: course.teacher.isNotEmpty ? Text(course.teacher) : null,
                          selected: isSelected,
                          trailing: isSelected ? const Icon(Icons.check) : null,
                          onTap: () {
                            final newDailyCourse = DailyCourse(
                              id: currentDailyCourse.id.isNotEmpty && currentDailyCourse.weekType == selectedWeekType
                                  ? currentDailyCourse.id 
                                  : _generateId(),
                              courseId: course.id,
                              dayOfWeek: day,
                              timeSlotId: slot.id,
                              weekType: selectedWeekType,
                            );
                            
                            // If we are switching from 'both' to 'single'/'double' or vice versa,
                            // the service handles the cleanup of conflicting entries.
                            // But if we are just updating the course ID of an existing entry, we use update.
                            
                            // Simplified logic: Just add (which handles update/conflict internally in service)
                            // or explicit update if ID exists and matches.
                            
                            if (currentDailyCourse.id.isNotEmpty && currentDailyCourse.weekType == selectedWeekType) {
                               service.updateDailyCourse(newDailyCourse);
                            } else {
                               service.addDailyCourse(newDailyCourse);
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ],
          );
        }
      ),
    );
  }

  String _getDayName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday: return '周一';
      case DayOfWeek.tuesday: return '周二';
      case DayOfWeek.wednesday: return '周三';
      case DayOfWeek.thursday: return '周四';
      case DayOfWeek.friday: return '周五';
      case DayOfWeek.saturday: return '周六';
      case DayOfWeek.sunday: return '周日';
    }
  }
}
