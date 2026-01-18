import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableService {
  final ApiService _apiService = ApiService();
  final TimetableStorageService _storageService = TimetableStorageService();
  
  // Calculate week number (1-based) from a given date
  // Assuming week 1 starts from the first Monday of the year
  int _calculateWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final firstMonday = firstDayOfYear.weekday > DateTime.monday 
        ? firstDayOfYear.add(Duration(days: 8 - firstDayOfYear.weekday))
        : firstDayOfYear;
    
    if (date.isBefore(firstMonday)) {
      return _calculateWeekNumber(date.subtract(const Duration(days: 7)));
    }
    
    return ((date.difference(firstMonday).inDays / 7).floor()) + 1;
  }
  
  // 确定周数
  Schedule? _getActiveSchedule(TimetableData timetableData, DateTime date) {
    final currentWeekNumber = _calculateWeekNumber(date);
    
    // 获取所有自动启用的课表
    final matchingSchedules = timetableData.schedules.where((schedule) {
      if (!schedule.isAutoEnabled) return false;
      return schedule.triggerRule.matches(date, currentWeekNumber: currentWeekNumber);
    }).toList();
    
    if (matchingSchedules.isEmpty) {
      return null;
    }
    
    // 按优先级排序（数字越小优先级越高）
    matchingSchedules.sort((a, b) => a.priority.compareTo(b.priority));
    return matchingSchedules.first;
  }
  
  // 获取课程表数据
  Future<Timetable> getTimetable(DateTime date) async {
    try {
      // 优先从本地存储获取
      final timetableData = await _storageService.loadTimetableData();
      
      // 1. 确定星期几 (0-6, 0=Monday in our model, DateTime.weekday 1=Mon...7=Sun)
      final weekday = date.weekday - 1;
      final dayOfWeek = DayOfWeek.values[weekday];
      
      // 2. 确定周数
      final currentWeekNumber = _calculateWeekNumber(date);
      
      // 3. 获取当前适用的课表
      final activeSchedule = _getActiveSchedule(timetableData, date);
      
      List<DailyCourse> dailyCourses = [];
      List<TimeSlot> timeSlots = [];
      
      if (activeSchedule != null) {
        // 使用课表中的课程
        dailyCourses = activeSchedule.courses;
        
        // 查找关联的时间表
        if (activeSchedule.timeLayoutId != null) {
          final timeLayout = timetableData.timeLayouts.firstWhere(
            (tl) => tl.id == activeSchedule.timeLayoutId,
            orElse: () => const TimeLayout(id: '', name: ''),
          );
          timeSlots = timeLayout.timeSlots;
        }
      }
      
      // 如果没有找到适用的课表或时间表，使用默认的旧格式数据
      if (dailyCourses.isEmpty) {
        dailyCourses = timetableData.dailyCourses;
        timeSlots = timetableData.timeSlots;
      }
      
      // 筛选当天的课程并检查周类型
      final filteredDailyCourses = dailyCourses.where((d) => 
        d.dayOfWeek == dayOfWeek,
      ).toList();
      
      final List<Course> courses = [];
      
      for (final daily in filteredDailyCourses) {
        // Check if course matches current week type
        bool matchesWeekType = false;
        switch (daily.weekType) {
          case WeekType.both:
            matchesWeekType = true;
            break;
          case WeekType.single:
            matchesWeekType = currentWeekNumber % 2 == 1;
            break;
          case WeekType.double:
            matchesWeekType = currentWeekNumber % 2 == 0;
            break;
        }
        
        if (!matchesWeekType) continue;
        
        final slot = timeSlots.firstWhere(
          (t) => t.id == daily.timeSlotId,
          orElse: () => const TimeSlot(id: '', startTime: '', endTime: '', name: ''),
        );
        
        if (slot.id.isEmpty) continue;
        
        final info = timetableData.courses.firstWhere(
          (c) => c.id == daily.courseId,
          orElse: () => const CourseInfo(id: '', name: 'Unknown', teacher: ''),
        );
        
        bool isCurrent = false;
        try {
          final ntpService = NtpService();
          final now = ntpService.now;
          final startParts = slot.startTime.split(':');
          final endParts = slot.endTime.split(':');
          if (startParts.length == 2 && endParts.length == 2) {
            final start = DateTime(now.year, now.month, now.day, 
                int.parse(startParts[0]), int.parse(startParts[1]),);
            final end = DateTime(now.year, now.month, now.day, 
                int.parse(endParts[0]), int.parse(endParts[1]),);
            if (now.isAfter(start) && now.isBefore(end)) {
              isCurrent = true;
            }
          }
        } catch (e) {
          // Ignore parsing errors
        }

        courses.add(Course(
          subject: info.displayName,
          teacher: info.teacher,
          time: '${slot.startTime}~${slot.endTime}',
          classroom: info.classroom,
          isCurrent: isCurrent,
        ),);
      }
      
      // 按开始时间排序
      courses.sort((a, b) {
        final aStartTime = a.time.split('~')[0];
        final bStartTime = b.time.split('~')[0];
        return aStartTime.compareTo(bStartTime);
      });
      
      return Timetable(
        date: date,
        courses: courses,
      );
      
    } catch (e) {
      Logger.e('Failed to fetch timetable: $e');
      return Timetable(date: date, courses: []);
    }
  }
  
  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    try {
      final ntpService = NtpService();
      final now = ntpService.now;
      final timetable = await getTimetable(now);
      
      // 简单判断当前时间是否在课程时间内
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      for (final course in timetable.courses) {
        final parts = course.time.split('~');
        if (parts.length == 2) {
          final start = parts[0];
          final end = parts[1];
          if (currentTime.compareTo(start) >= 0 && currentTime.compareTo(end) <= 0) {
            return Course(
              subject: course.subject,
              teacher: course.teacher,
              time: course.time,
              classroom: course.classroom,
              isCurrent: true,
            );
          }
        }
      }
      
      return null;
    } catch (e) {
      Logger.e('Failed to get current course: $e');
      return null;
    }
  }

  // 获取当前和下一节课程
  Future<Map<String, Course?>> getCurrentAndNextCourse() async {
    try {
      final ntpService = NtpService();
      final now = ntpService.now;
      final timetable = await getTimetable(now);
      
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      Course? currentCourse;
      Course? nextCourse;
      
      for (int i = 0; i < timetable.courses.length; i++) {
        final course = timetable.courses[i];
        final parts = course.time.split('~');
        if (parts.length == 2) {
          final start = parts[0];
          final end = parts[1];
          
          // Check if current
          if (currentTime.compareTo(start) >= 0 && currentTime.compareTo(end) <= 0) {
            currentCourse = Course(
              subject: course.subject,
              teacher: course.teacher,
              time: course.time,
              classroom: course.classroom,
              isCurrent: true,
            );
            
            // If there is a next course in the list
            if (i + 1 < timetable.courses.length) {
              nextCourse = timetable.courses[i + 1];
            }
            break; // Found current, so next is set (if exists) and we are done
          }
          
          // Check if this course is in the future (potential next course if no current course found yet)
          if (currentTime.compareTo(start) < 0) {
            nextCourse ??= course;
            // If we haven't found a current course yet, this is the next upcoming one.
            // Since the list is sorted, we can stop if we just want the *immediate* next.
            // But if we want to be sure we didn't miss a current one (overlapping?), we should continue?
            // The list is sorted by start time.
            // If we are strictly before this course, and we haven't found a "current" course,
            // then this is the next course.
            break; 
          }
        }
      }
      
      return {
        'current': currentCourse,
        'next': nextCourse,
      };
    } catch (e) {
      Logger.e('Failed to get current and next course: $e');
      return {'current': null, 'next': null};
    }
  }
  
  // 获取天气信息
  Future<WeatherData> getWeather() async {
    try {
      return await _apiService.getWeather();
    } catch (e) {
      Logger.e('Failed to fetch weather from API, using mock data: $e');
      return WeatherData(
        cityName: 'Beijing',
        description: 'sunny',
        temperature: 25,
        temperatureRange: '20C~30C',
        aqiLevel: 50,
        humidity: 40,
        wind: '3-4 level',
        pressure: 1013,
        sunrise: '06:00',
        sunset: '18:30',
        weatherType: 0,
        weatherIcon: 'weather_0.png',
        feelsLike: 26,
        visibility: '10000',
        uvIndex: '5',
        pubTime: DateTime.now().toIso8601String(),
      );
    }
  }
}
