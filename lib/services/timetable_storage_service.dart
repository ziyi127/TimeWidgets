import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/database/database_service.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableStorageService {
  static const String _prefsKey = 'timetable_data';
  static const String _migratedKey = 'is_migrated_to_isar';
  final DatabaseService _db = DatabaseService();

  Future<TimetableData> loadTimetableData() async {
    try {
      await _db.initialize();
      
      // Check if migration is needed
      final prefs = await SharedPreferences.getInstance();
      final isMigrated = prefs.getBool(_migratedKey) ?? false;
      
      if (!isMigrated) {
        // Try load from SP
        final jsonString = prefs.getString(_prefsKey);
        if (jsonString != null) {
          try {
            final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
            final data = TimetableData.fromJson(jsonData);
            
            // Migrate to Isar
            await _db.saveTimetableData(data);
            await prefs.setBool(_migratedKey, true);
            Logger.i('Successfully migrated timetable data to Isar');
            return data;
          } catch (e) {
            Logger.e('Error parsing legacy data for migration: $e');
            // Fallback to default if migration fails? 
            // Or try to load from Isar if partial migration happened?
            // Let's assume if JSON exists but fails, we might want to return default 
            // but NOT mark as migrated so we can try again or user can fix it.
          }
        }
      }

      // Load from Isar
      final data = await _db.loadTimetableData();
      
      // If Isar is empty (new install or data cleared), return default
      if (data.courses.isEmpty && data.schedules.isEmpty && data.timeLayouts.isEmpty) {
         // Check if it's really empty or just a fresh start. 
         // If it's a fresh start, we should return default data.
         return _getDefaultTimetableData();
      }
      
      return data;
    } catch (e) {
      Logger.e('Error loading timetable data: $e');
      return _getDefaultTimetableData();
    }
  }

  Future<void> saveTimetableData(TimetableData data) async {
    try {
      await _db.initialize();
      await _db.saveTimetableData(data);
      
      // Optional: Backup to SP? Or just clear SP to save space?
      // Agora suggested keeping a backup or handling transactions.
      // Since we successfully wrote to Isar, we can consider it safe.
      // But for safety during this transition period, we might want to KEEP the SP data 
      // but strictly read from Isar.
      // However, if we update data in Isar, SP becomes stale.
      // So keeping stale data in SP might be confusing. 
      // Let's just update the migration flag.
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_migratedKey) != true) {
         await prefs.setBool(_migratedKey, true);
      }
    } catch (e) {
      Logger.e('Error saving timetable data: $e');
      throw Exception('Failed to save timetable data');
    }
  }

  TimetableData _getDefaultTimetableData() {
    return const TimetableData(
      courses: [
        CourseInfo(id: '1', name: '语文', teacher: '张老师'),
        CourseInfo(id: '2', name: '数学', teacher: '李老师'),
        CourseInfo(id: '3', name: '英语', teacher: '王老师'),
        CourseInfo(id: '4', name: '物理', teacher: '赵老师'),
        CourseInfo(id: '5', name: '化学', teacher: '陈老师'),
        CourseInfo(id: '6', name: '生物', teacher: '刘老师'),
        CourseInfo(id: '7', name: '历史', teacher: '周老师'),
        CourseInfo(id: '8', name: '地理', teacher: '吴老师'),
      ],
      timeSlots: [
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
      dailyCourses: [],
    );
  }
}
