import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableStorageService {
  static const String _prefsKey = 'timetable_data';

  Future<TimetableData> loadTimetableData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        return TimetableData.fromJson(jsonData);
      } else {
        return _getDefaultTimetableData();
      }
    } catch (e) {
      Logger.e('Error loading timetable data: $e');
      return _getDefaultTimetableData();
    }
  }

  Future<void> saveTimetableData(TimetableData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = data.toJson();
      await prefs.setString(_prefsKey, jsonEncode(jsonData));
    } catch (e) {
      Logger.e('Error saving timetable data: $e');
      throw Exception('Failed to save timetable data');
    }
  }

  TimetableData _getDefaultTimetableData() {
    return TimetableData(
      courses: const [
        CourseInfo(id: '1', name: '语文', teacher: '张老师'),
        CourseInfo(id: '2', name: '数学', teacher: '李老师'),
        CourseInfo(id: '3', name: '英语', teacher: '王老师'),
        CourseInfo(id: '4', name: '物理', teacher: '赵老师'),
        CourseInfo(id: '5', name: '化学', teacher: '陈老师'),
        CourseInfo(id: '6', name: '生物', teacher: '刘老师'),
        CourseInfo(id: '7', name: '历史', teacher: '周老师'),
        CourseInfo(id: '8', name: '地理', teacher: '吴老师'),
      ],
      timeSlots: const [
        TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '早读'),
        TimeSlot(id: '2', startTime: '08:55', endTime: '09:40', name: '第一节课'),
        TimeSlot(id: '3', startTime: '10:00', endTime: '10:45', name: '第二节课'),
        TimeSlot(id: '4', startTime: '11:00', endTime: '11:45', name: '第三节课'),
        TimeSlot(id: '5', startTime: '14:00', endTime: '14:45', name: '第四节课'),
        TimeSlot(id: '6', startTime: '15:00', endTime: '15:45', name: '第五节课'),
        TimeSlot(id: '7', startTime: '16:00', endTime: '16:45', name: '第六节课'),
        TimeSlot(id: '8', startTime: '19:00', endTime: '19:45', name: '晚自习一'),
        TimeSlot(id: '9', startTime: '20:00', endTime: '20:45', name: '晚自习二'),
      ],
      dailyCourses: const [],
    );
  }
}
