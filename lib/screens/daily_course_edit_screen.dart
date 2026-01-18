import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';

class DailyCourseEditScreen extends StatefulWidget {
  const DailyCourseEditScreen({super.key});

  @override
  State<DailyCourseEditScreen> createState() => _DailyCourseEditScreenState();
}

class _DailyCourseEditScreenState extends State<DailyCourseEditScreen> {
  DayOfWeek? _selectedDay;
  WeekType? _selectedWeekType;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final courses = service.courses;
        final timeSlots = service.timeSlots;
        final dailyCourses = service.dailyCourses;
        
        return Column(
          children: [
            // Day and week type selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<DayOfWeek>(
                      decoration: const InputDecoration(
                        labelText: '选择星期',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedDay,
                      items: DayOfWeek.values.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(_getDayName(day)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<WeekType>(
                      decoration: const InputDecoration(
                        labelText: '选择周类型',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedWeekType,
                      items: WeekType.values.map((weekType) {
                        return DropdownMenuItem(
                          value: weekType,
                          child: Text(_getWeekTypeName(weekType)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWeekType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Timetable grid
            Expanded(
              child: _selectedDay != null && _selectedWeekType != null
                  ? _buildTimetableGrid(service, courses, timeSlots, dailyCourses)
                  : const Center(
                      child: Text('请选择星期和周类型'),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimetableGrid(
    TimetableEditService service,
    List<CourseInfo> courses,
    List<TimeSlot> timeSlots,
    List<DailyCourse> dailyCourses,
  ) {
    // Sort time slots by start time
    final sortedTimeSlots = List<TimeSlot>.from(timeSlots)
      ..sort((a, b) {
        // Parse time strings "HH:MM" and compare
        final aParts = a.startTime.split(':');
        final bParts = b.startTime.split(':');
        
        final aHour = int.parse(aParts[0]);
        final aMinute = int.parse(aParts[1]);
        final bHour = int.parse(bParts[0]);
        final bMinute = int.parse(bParts[1]);
        
        final aTotalMinutes = aHour * 60 + aMinute;
        final bTotalMinutes = bHour * 60 + bMinute;
        
        return aTotalMinutes.compareTo(bTotalMinutes);
      });
    
    // Filter daily courses for selected day and week type
    final filteredDailyCourses = dailyCourses.where((dc) =>
        dc.dayOfWeek == _selectedDay && dc.weekType == _selectedWeekType,).toList();
    
    if (sortedTimeSlots.isEmpty) {
      return const Center(
        child: Text('请先在时间表中添加时间段'),
      );
    }
    
    if (courses.isEmpty) {
      return const Center(
        child: Text('请先在课程表中添加课程'),
      );
    }
    
    return Column(
      children: [
        // Header row with time slot names
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).primaryColor.withAlpha((255 * 0.1).round()),
          child: Row(
            children: [
              const SizedBox(width: 80), // Space for course selector
              ...sortedTimeSlots.map((timeSlot) => Expanded(
                child: Center(
                  child: Text(
                    timeSlot.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),),
            ],
          ),
        ),
        
        // Course row
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Course selector row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('课程', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 40),
                      ...sortedTimeSlots.map((timeSlot) => Expanded(
                        child: _buildCourseSelector(
                          service,
                          timeSlot,
                          filteredDailyCourses,
                          courses,
                        ),
                      ),),
                    ],
                  ),
                ),
                
                // Time display row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('时间', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 40),
                      ...sortedTimeSlots.map((timeSlot) => Expanded(
                        child: Center(
                          child: Text(
                            '${_formatTime(timeSlot.startTime)}\n${_formatTime(timeSlot.endTime)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseSelector(
    TimetableEditService service,
    TimeSlot timeSlot,
    List<DailyCourse> filteredDailyCourses,
    List<CourseInfo> courses,
  ) {
    // Find existing daily course for this time slot
    final existingCourse = filteredDailyCourses.firstWhere(
      (dc) => dc.timeSlotId == timeSlot.id,
      orElse: () => DailyCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: _selectedDay!,
        weekType: _selectedWeekType!,
        timeSlotId: timeSlot.id,
        courseId: '',
      ),
    );
    
    return DropdownButton<String>(
      isExpanded: true,
      value: existingCourse.courseId.isEmpty ? null : existingCourse.courseId,
      hint: const Text('无课程'),
      items: [
        const DropdownMenuItem(
          value: '',
          child: Text('无课程'),
        ),
        ...courses.map((course) => DropdownMenuItem(
          value: course.id,
          child: Text(
            course.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),),
      ],
      onChanged: (value) {
        if (value != null) {
          if (value.isEmpty) {
            // Remove the daily course
            service.deleteDailyCourse(existingCourse.id);
          } else {
            // Update or add the daily course
            final updatedCourse = DailyCourse(
              id: existingCourse.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : existingCourse.id,
              dayOfWeek: _selectedDay!,
              weekType: _selectedWeekType!,
              timeSlotId: timeSlot.id,
              courseId: value,
            );
            
            if (existingCourse.id.isEmpty) {
              service.addDailyCourse(updatedCourse);
            } else {
              service.updateDailyCourse(updatedCourse);
            }
          }
        }
      },
    );
  }

  String _getDayName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return '星期一';
      case DayOfWeek.tuesday:
        return '星期二';
      case DayOfWeek.wednesday:
        return '星期三';
      case DayOfWeek.thursday:
        return '星期四';
      case DayOfWeek.friday:
        return '星期五';
      case DayOfWeek.saturday:
        return '星期六';
      case DayOfWeek.sunday:
        return '星期日';
    }
  }

  String _getWeekTypeName(WeekType weekType) {
    switch (weekType) {
      case WeekType.both:
        return '每周';
      case WeekType.single:
        return '单周';
      case WeekType.double:
        return '双周';
    }
  }

  String _formatTime(String timeString) {
    // Assuming timeString is in format "HH:MM"
    return timeString;
  }
}
