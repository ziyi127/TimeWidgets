import 'package:flutter/foundation.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';

class TimetableEditService extends ChangeNotifier {
  final TimetableStorageService _storageService = TimetableStorageService();
  TimetableData? _timetableData;
  final List<CourseInfo> _courses = [];
  final List<TimeSlot> _timeSlots = [];
  final List<DailyCourse> _dailyCourses = [];
  
  // Getters
  List<CourseInfo> get courses => List.unmodifiable(_courses);
  List<TimeSlot> get timeSlots => List.unmodifiable(_timeSlots);
  List<DailyCourse> get dailyCourses => List.unmodifiable(_dailyCourses);

  // Auto-save method
  Future<void> _autoSave() async {
    try {
      final updatedData = TimetableData(
        courses: List.from(_courses),
        timeSlots: List.from(_timeSlots),
        dailyCourses: List.from(_dailyCourses),
      );
      
      await _storageService.saveTimetableData(updatedData);
      _timetableData = updatedData;
    } catch (e) {
      print('Error auto-saving timetable data: $e');
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
    // Check if a course already exists for this time slot and week type
    final existingIndex = _dailyCourses.indexWhere((d) => 
        d.dayOfWeek == dailyCourse.dayOfWeek && 
        d.timeSlotId == dailyCourse.timeSlotId &&
        d.weekType == dailyCourse.weekType);
    
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
  void loadTimetableData(TimetableData data) {
    _timetableData = data;
    _courses.clear();
    _courses.addAll(data.courses);
    
    _timeSlots.clear();
    _timeSlots.addAll(data.timeSlots);
    
    _dailyCourses.clear();
    _dailyCourses.addAll(data.dailyCourses);
    
    notifyListeners();
  }
  
  // Save timetable data
  Future<void> saveTimetableData() async {
    if (_timetableData != null) {
      final updatedData = TimetableData(
        courses: List.from(_courses),
        timeSlots: List.from(_timeSlots),
        dailyCourses: List.from(_dailyCourses),
      );
      
      await _storageService.saveTimetableData(updatedData);
      _timetableData = updatedData;
    }
  }

  // Get courses for a specific day
  List<DailyCourse> getDailyCoursesForDay(DayOfWeek dayOfWeek, {WeekType? weekType}) {
    return _dailyCourses.where((d) {
      if (d.dayOfWeek != dayOfWeek) return false;
      if (weekType != null && d.weekType != weekType && d.weekType != WeekType.both) return false;
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