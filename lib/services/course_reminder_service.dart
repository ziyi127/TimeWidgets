import 'dart:async';

import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/logger.dart';

enum ReminderType {
  upcoming, // 即将开始
  start,    // 开始
  ending,   // 即将结束
  end       // 结束
}

class CourseReminderService {
  final SettingsService _settingsService = SettingsService();
  final TimetableService _timetableService = TimetableService();
  
  Timer? _checkTimer;
  StreamSubscription<AppSettings>? _settingsSubscription;
  bool _isInitialized = false;
  AppSettings? _settings;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isInitialized = true;
    
    // 加载设置
    _settings = await _settingsService.loadSettings();
    
    // 监听设置变化
    _settingsSubscription = _settingsService.settingsStream.listen((newSettings) {
      _settings = newSettings;
      _updateTimer();
    });
    
    // 初始化定时器
    _updateTimer();
    
    Logger.d('CourseReminderService initialized');
  }

  void dispose() {
    _checkTimer?.cancel();
    _settingsSubscription?.cancel();
    _isInitialized = false;
    Logger.d('CourseReminderService disposed');
  }
  
  void _updateTimer() {
    // 取消现有定时器
    _checkTimer?.cancel();
    
    // 如果启用了课程提醒，设置定时器
    if (_settings?.enableCourseReminder ?? false) {
      // 每分钟检查一次
      _checkTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _checkUpcomingCourses();
      });
      
      // 立即检查一次
      _checkUpcomingCourses();
    }
  }
  
  Future<void> _checkUpcomingCourses() async {
    try {
      if (_settings?.enableCourseReminder != true) return;
      
      final now = DateTime.now();
      final timetable = await _timetableService.getTimetable(now);
      
      // 检查每门课程
      for (final course in timetable.courses) {
        final timeParts = course.time.split('~');
        if (timeParts.length != 2) continue;
        
        final startTime = timeParts[0];
        final endTime = timeParts[1];
        
        final startParts = startTime.split(':');
        final endParts = endTime.split(':');
        if (startParts.length != 2 || endParts.length != 2) continue;
        
        final courseStart = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(startParts[0]),
          int.parse(startParts[1]),
        );
        
        final courseEnd = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );
        
        // 计算距离课程开始和结束的时间（分钟）
        final minutesUntilStart = courseStart.difference(now).inMinutes;
        final minutesUntilEnd = courseEnd.difference(now).inMinutes;
        
        // 如果课程即将开始（5分钟前），发送提醒
        if (minutesUntilStart == 5 && !course.isCurrent) {
          _sendCourseReminder(course, ReminderType.upcoming);
        }
        
        // 如果课程刚刚开始（0分钟），发送提醒
        if (minutesUntilStart == 0 && !course.isCurrent) {
          _sendCourseReminder(course, ReminderType.start);
        }
        
        // 如果课程即将结束（1分钟前），发送提醒
        if (minutesUntilEnd == 1 && course.isCurrent) {
          _sendCourseReminder(course, ReminderType.ending);
        }
        
        // 如果课程刚刚结束（0分钟），发送提醒
        if (minutesUntilEnd == 0 && course.isCurrent) {
          _sendCourseReminder(course, ReminderType.end);
        }
      }
    } catch (e) {
      Logger.e('Failed to check upcoming courses: $e');
    }
  }
  
  Future<void> _sendCourseReminder(Course course, ReminderType type) async {
    if (_settings?.enableNotifications != true) return;
    
    String reminderMessage = '';
    
    switch (type) {
      case ReminderType.upcoming:
        reminderMessage = '课程即将开始: ${course.subject} 将在5分钟后开始，上课时间 ${course.time}，地点 ${course.classroom}';
        break;
      case ReminderType.start:
        reminderMessage = '课程开始: ${course.subject} 已经开始，上课时间 ${course.time}，地点 ${course.classroom}';
        break;
      case ReminderType.ending:
        reminderMessage = '课程即将结束: ${course.subject} 将在1分钟后结束';
        break;
      case ReminderType.end:
        reminderMessage = '课程结束: ${course.subject} 已经结束';
        break;
    }
    
    // 记录日志
    Logger.i('Course reminder: $reminderMessage');
    
    // 根据不同类型和设置发送不同类型的提醒
    if (type == ReminderType.start && (_settings?.showNotificationOnClassStart ?? false)) {
      // 可以添加开始提醒的特殊处理
    }
    
    if (type == ReminderType.end && (_settings?.showNotificationOnClassEnd ?? false)) {
      // 可以添加结束提醒的特殊处理
    }
  }
}
