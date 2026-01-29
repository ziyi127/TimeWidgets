import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/utils/error_handling/enhanced_error_handler.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/utils/time_utils.dart';

class TimetableService {
  final ApiService _apiService = ApiService();
  final TimetableStorageService _storageService = TimetableStorageService();
  final EnhancedErrorHandler _errorHandler = EnhancedErrorHandler();
  
  // Memory cache
  TimetableData? _cachedData;

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

  // 清除缓存
  void clearCache() {
    _cachedData = null;
  }

  // 确定周数
  Schedule? _getActiveSchedule(TimetableData timetableData, DateTime date) {
    final currentWeekNumber = _calculateWeekNumber(date);

    // 获取所有自动启用的课表
    final matchingSchedules = timetableData.schedules.where((schedule) {
      if (!schedule.isAutoEnabled) {
        return false;
      }

      // Check if triggers list is empty, if so skip (or handle legacy logic if needed)
      if (schedule.triggers.isEmpty) {
        return false;
      }

      return schedule.triggers.any(
        (trigger) =>
            trigger.matches(date, currentWeekNumber: currentWeekNumber),
      );
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
      TimetableData timetableData;
      
      if (_cachedData != null) {
        timetableData = _cachedData!;
      } else {
        timetableData = await _storageService.loadTimetableData();
        _cachedData = timetableData;
      }

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
      final filteredDailyCourses = dailyCourses
          .where(
            (d) => d.dayOfWeek == dayOfWeek,
          )
          .toList();

      final List<Course> courses = [];

      for (final daily in filteredDailyCourses) {
        // Check if course matches current week type
        bool matchesWeekType = false;
        switch (daily.weekType) {
          case WeekType.both:
            matchesWeekType = true;
            break;
          case WeekType.single:
            matchesWeekType = currentWeekNumber.isOdd;
            break;
          case WeekType.double:
            matchesWeekType = currentWeekNumber.isEven;
            break;
        }

        if (!matchesWeekType) {
          continue;
        }

        final slot = timeSlots.firstWhere(
          (t) => t.id == daily.timeSlotId,
          orElse: () =>
              const TimeSlot(id: '', startTime: '', endTime: '', name: ''),
        );

        if (slot.id.isEmpty) {
          continue;
        }

        final info = timetableData.courses.firstWhere(
          (c) => c.id == daily.courseId,
          orElse: () => const CourseInfo(id: '', name: 'Unknown', teacher: ''),
        );

        final ntpService = NtpService();
        final now = ntpService.now;

        // Use TimeUtils to check range
        final timeRange = '${slot.startTime}~${slot.endTime}';
        final isCurrent = TimeUtils.isCurrentTimeInRange(timeRange, now);

        courses.add(
          Course(
            subject: info.displayName,
            teacher: info.teacher,
            time: timeRange,
            classroom: info.classroom,
            isCurrent: isCurrent,
          ),
        );
      }

      // 按开始时间排序
      courses.sort((a, b) {
        final aRange = TimeUtils.parseTimeRange(a.time, date);
        final bRange = TimeUtils.parseTimeRange(b.time, date);
        if (aRange == null || bRange == null) {
          return 0;
        }
        return aRange.start.compareTo(bRange.start);
      });

      return Timetable(
        date: date,
        courses: courses,
      );
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        e,
        stackTrace: stackTrace,
        context: {'operation': 'getTimetable', 'date': date.toIso8601String()},
      );
      // Fallback: return empty timetable but log the error properly
      return Timetable(date: date, courses: []);
    }
  }

  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    try {
      final ntpService = NtpService();
      final now = ntpService.now;
      final timetable = await getTimetable(now);

      for (final course in timetable.courses) {
        if (TimeUtils.isCurrentTimeInRange(course.time, now)) {
          return Course(
            subject: course.subject,
            teacher: course.teacher,
            time: course.time,
            classroom: course.classroom,
            isCurrent: true,
          );
        }
      }

      return null;
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        e,
        stackTrace: stackTrace,
        context: {'operation': 'getCurrentCourse'},
      );
      return null;
    }
  }

  // 获取当前和下一节课程
  Future<Map<String, Course?>> getCurrentAndNextCourse() async {
    try {
      final ntpService = NtpService();
      final now = ntpService.now;
      final timetable = await getTimetable(now);

      Course? currentCourse;
      Course? nextCourse;

      for (int i = 0; i < timetable.courses.length; i++) {
        final course = timetable.courses[i];

        if (TimeUtils.isCurrentTimeInRange(course.time, now)) {
          currentCourse = Course(
            subject: course.subject,
            teacher: course.teacher,
            time: course.time,
            classroom: course.classroom,
            isCurrent: true,
          );

          if (i + 1 < timetable.courses.length) {
            nextCourse = timetable.courses[i + 1];
          }
          break;
        }

        // If not current, check if it's future
        final range = TimeUtils.parseTimeRange(course.time, now);
        if (range != null && now.isBefore(range.start)) {
          nextCourse = course;
          break;
        }
      }

      return {
        'current': currentCourse,
        'next': nextCourse,
      };
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        e,
        stackTrace: stackTrace,
        context: {'operation': 'getCurrentAndNextCourse'},
      );
      return {'current': null, 'next': null};
    }
  }

  // 获取天气信息
  Future<WeatherData> getWeather() async {
    try {
      return await _apiService.getWeather();
    } catch (e, stackTrace) {
      // Let the caller handle UI feedback, but log here if needed or fallback
      _errorHandler.handleNetworkError(
        e,
        url: 'WeatherAPI', // Ideally ApiService exposes the URL
        method: 'GET',
        stackTrace: stackTrace,
      );
      // Fallback mock data
      Logger.w('Using mock weather data due to error: $e');
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
