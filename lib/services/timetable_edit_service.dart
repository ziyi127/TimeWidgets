import 'package:flutter/foundation.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableEditService extends ChangeNotifier {
  final TimetableStorageService _storageService = TimetableStorageService();
  TimetableData? _timetableData;
  final List<CourseInfo> _courses = [];
  final List<TimeSlot> _timeSlots = [];
  final List<DailyCourse> _dailyCourses = [];
  final List<TimeLayout> _timeLayouts = [];
  final List<Schedule> _schedules = [];

  // Getters
  List<CourseInfo> get courses => List.unmodifiable(_courses);
  List<TimeSlot> get timeSlots => List.unmodifiable(_timeSlots);
  List<DailyCourse> get dailyCourses => List.unmodifiable(_dailyCourses);
  List<TimeLayout> get timeLayouts => List.unmodifiable(_timeLayouts);
  List<Schedule> get schedules => List.unmodifiable(_schedules);

  // Auto-save method
  Future<void> _autoSave() async {
    try {
      final updatedData = TimetableData(
        courses: List.from(_courses),
        timeSlots: List.from(_timeSlots),
        dailyCourses: List.from(_dailyCourses),
        timeLayouts: List.from(_timeLayouts),
        schedules: List.from(_schedules),
      );

      await _storageService.saveTimetableData(updatedData);
      _timetableData = updatedData;
    } catch (e) {
      Logger.e('Error auto-saving timetable data: $e');
    }
  }

  // Course management methods
  void addCourse(CourseInfo course) {
    _courses.add(course);
    _autoSave();
    notifyListeners();
  }

  void updateCourse(CourseInfo course) {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _courses[index] = course;
      _autoSave();
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    // Also remove related daily courses
    _dailyCourses.removeWhere((d) => d.courseId == courseId);
    _autoSave();
    notifyListeners();
  }

  // Time slot management methods
  void addTimeSlot(TimeSlot timeSlot) {
    _timeSlots.add(timeSlot);
    _autoSave();
    notifyListeners();
  }

  void updateTimeSlot(TimeSlot timeSlot) {
    final index = _timeSlots.indexWhere((t) => t.id == timeSlot.id);
    if (index != -1) {
      _timeSlots[index] = timeSlot;
      _autoSave();
      notifyListeners();
    }
  }

  void deleteTimeSlot(String timeSlotId) {
    _timeSlots.removeWhere((t) => t.id == timeSlotId);
    // Also remove related daily courses
    _dailyCourses.removeWhere((d) => d.timeSlotId == timeSlotId);
    _autoSave();
    notifyListeners();
  }

  // Daily course management methods
  void addDailyCourse(DailyCourse dailyCourse) {
    // Conflict resolution:
    // If adding 'both', remove any 'single' or 'double' for this slot
    if (dailyCourse.weekType == WeekType.both) {
      _dailyCourses.removeWhere(
        (d) =>
            d.dayOfWeek == dailyCourse.dayOfWeek &&
            d.timeSlotId == dailyCourse.timeSlotId &&
            d.weekType != WeekType.both,
      );
    }

    // If adding 'single' or 'double', remove 'both' for this slot
    if (dailyCourse.weekType != WeekType.both) {
      _dailyCourses.removeWhere(
        (d) =>
            d.dayOfWeek == dailyCourse.dayOfWeek &&
            d.timeSlotId == dailyCourse.timeSlotId &&
            d.weekType == WeekType.both,
      );
    }

    // Check if a course already exists for this time slot and week type
    final existingIndex = _dailyCourses.indexWhere(
      (d) =>
          d.dayOfWeek == dailyCourse.dayOfWeek &&
          d.timeSlotId == dailyCourse.timeSlotId &&
          d.weekType == dailyCourse.weekType,
    );

    if (existingIndex != -1) {
      // Update existing course
      _dailyCourses[existingIndex] = dailyCourse;
    } else {
      // Add new course
      _dailyCourses.add(dailyCourse);
    }
    _autoSave();
    notifyListeners();
  }

  void updateDailyCourse(DailyCourse dailyCourse) {
    final index = _dailyCourses.indexWhere((d) => d.id == dailyCourse.id);
    if (index != -1) {
      _dailyCourses[index] = dailyCourse;
      _autoSave();
      notifyListeners();
    }
  }

  void deleteDailyCourse(String dailyCourseId) {
    _dailyCourses.removeWhere((d) => d.id == dailyCourseId);
    _autoSave();
    notifyListeners();
  }

  // Load timetable data
  Future<void> loadData() async {
    try {
      final data = await _storageService.loadTimetableData();
      loadTimetableData(data);
    } catch (e) {
      Logger.e('Failed to load timetable data: $e');
    }
  }

  void loadTimetableData(TimetableData data) {
    _timetableData = data;
    _courses.clear();
    _courses.addAll(data.courses);

    _timeSlots.clear();
    _timeSlots.addAll(data.timeSlots);

    _dailyCourses.clear();
    _dailyCourses.addAll(data.dailyCourses);

    _timeLayouts.clear();
    _timeLayouts.addAll(data.timeLayouts);

    _schedules.clear();
    _schedules.addAll(data.schedules);

    notifyListeners();
  }

  // Save timetable data
  Future<void> saveTimetableData() async {
    if (_timetableData != null) {
      final updatedData = TimetableData(
        courses: List.from(_courses),
        timeSlots: List.from(_timeSlots),
        dailyCourses: List.from(_dailyCourses),
        timeLayouts: List.from(_timeLayouts),
        schedules: List.from(_schedules),
      );

      await _storageService.saveTimetableData(updatedData);
      _timetableData = updatedData;
    }
  }

  // TimeLayout management methods with schedule sync
  void addTimeLayout(TimeLayout timeLayout) {
    _timeLayouts.add(timeLayout);
    _autoSave();
    notifyListeners();
  }

  void updateTimeLayout(TimeLayout timeLayout) {
    final index = _timeLayouts.indexWhere((t) => t.id == timeLayout.id);
    if (index != -1) {
      _timeLayouts[index] = timeLayout;
      _autoSave();
      notifyListeners();
    }
  }

  void deleteTimeLayout(String timeLayoutId) {
    // Remove reference from all schedules
    for (final schedule in _schedules) {
      if (schedule.timeLayoutId == timeLayoutId) {
        updateSchedule(schedule.copyWith());
      }
    }
    _timeLayouts.removeWhere((t) => t.id == timeLayoutId);
    _autoSave();
    notifyListeners();
  }

  TimeLayout? getTimeLayoutById(String timeLayoutId) {
    try {
      return _timeLayouts.firstWhere((t) => t.id == timeLayoutId);
    } catch (e) {
      return null;
    }
  }

  // Schedule management methods
  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    _autoSave();
    notifyListeners();
  }

  void updateSchedule(Schedule schedule) {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule;
      _autoSave();
      notifyListeners();
    }
  }

  void deleteSchedule(String scheduleId) {
    _schedules.removeWhere((s) => s.id == scheduleId);
    _autoSave();
    notifyListeners();
  }

  Schedule? getScheduleById(String scheduleId) {
    try {
      return _schedules.firstWhere((s) => s.id == scheduleId);
    } catch (e) {
      return null;
    }
  }

  /// Get the active schedule for a given date
  /// Returns the schedule with matching trigger rule and highest priority (lowest number)
  Schedule? getActiveSchedule(DateTime date, {int? currentWeekNumber}) {
    final matchingSchedules = _schedules.where((schedule) {
      if (!schedule.isAutoEnabled) return false;
      return schedule.triggerRule
          .matches(date, currentWeekNumber: currentWeekNumber);
    }).toList();

    if (matchingSchedules.isEmpty) return null;

    // Sort by priority (lower number = higher priority)
    matchingSchedules.sort((a, b) => a.priority.compareTo(b.priority));
    return matchingSchedules.first;
  }

  /// Get all schedules matching a date, sorted by priority
  List<Schedule> getMatchingSchedules(DateTime date, {int? currentWeekNumber}) {
    final matchingSchedules = _schedules.where((schedule) {
      if (!schedule.isAutoEnabled) return false;
      return schedule.triggerRule
          .matches(date, currentWeekNumber: currentWeekNumber);
    }).toList();

    // Sort by priority (lower number = higher priority)
    matchingSchedules.sort((a, b) => a.priority.compareTo(b.priority));
    return matchingSchedules;
  }

  /// Refresh schedules when time layout changes
  void refreshSchedulesForTimeLayout(String timeLayoutId) {
    // This method would be called when a time layout is updated
    // For now, we'll just trigger a save and notification
    _autoSave();
    notifyListeners();
  }

  /// Check if a course/subject can be deleted (not in use)
  bool canDeleteCourse(String courseId) {
    return !_dailyCourses.any((d) => d.courseId == courseId) &&
        !_schedules.any((s) => s.courses.any((c) => c.courseId == courseId));
  }

  /// Find all usages of a subject/course
  List<SubjectUsage> findSubjectUsages(String courseId) {
    final usages = <SubjectUsage>[];

    // Check daily courses
    for (final dailyCourse in _dailyCourses) {
      if (dailyCourse.courseId == courseId) {
        final timeSlot = getTimeSlotById(dailyCourse.timeSlotId);
        usages.add(
          SubjectUsage(
            type: SubjectUsageType.dailyCourse,
            description:
                '${dailyCourse.dayOfWeek.name} - ${timeSlot?.name ?? dailyCourse.timeSlotId}',
          ),
        );
      }
    }

    // Check schedules
    for (final schedule in _schedules) {
      for (final course in schedule.courses) {
        if (course.courseId == courseId) {
          final timeSlot = getTimeSlotById(course.timeSlotId);
          usages.add(
            SubjectUsage(
              type: SubjectUsageType.schedule,
              description:
                  '${schedule.name} - ${timeSlot?.name ?? course.timeSlotId}',
            ),
          );
        }
      }
    }

    return usages;
  }

  // Get courses for a specific day
  List<DailyCourse> getDailyCoursesForDay(
    DayOfWeek dayOfWeek, {
    WeekType? weekType,
  }) {
    return _dailyCourses.where((d) {
      if (d.dayOfWeek != dayOfWeek) return false;
      if (weekType != null &&
          d.weekType != weekType &&
          d.weekType != WeekType.both) {
        return false;
      }
      return true;
    }).toList();
  }

  // Get course by ID
  CourseInfo? getCourseById(String courseId) {
    try {
      return _courses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Get time slot by ID
  TimeSlot? getTimeSlotById(String timeSlotId) {
    try {
      return _timeSlots.firstWhere((t) => t.id == timeSlotId);
    } catch (e) {
      return null;
    }
  }

  // Get current timetable data
  TimetableData getTimetableData() {
    return TimetableData(
      courses: List.from(_courses),
      timeSlots: List.from(_timeSlots),
      dailyCourses: List.from(_dailyCourses),
      timeLayouts: List.from(_timeLayouts),
      schedules: List.from(_schedules),
    );
  }

  // Refresh data from storage
  Future<void> refreshData() async {
    _timetableData = await _storageService.loadTimetableData();
    if (_timetableData != null) {
      loadTimetableData(_timetableData!);
    }
  }
}

/// Subject usage type
enum SubjectUsageType {
  dailyCourse,
  schedule,
}

/// Subject usage information
class SubjectUsage {
  const SubjectUsage({
    required this.type,
    required this.description,
  });
  final SubjectUsageType type;
  final String description;
}
