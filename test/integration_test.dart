import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/timetable_export_service.dart';
import 'package:time_widgets/services/week_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Integration Tests', () {
    setUp(() {
      // Initialize SharedPreferences with mock values for testing
      SharedPreferences.setMockInitialValues({});
    });

    test('Settings service integration works correctly', () async {
      final settingsService = SettingsService();
      
      // Test default settings
      final defaultSettings = AppSettings.defaultSettings();
      expect(defaultSettings.themeMode, equals(ThemeMode.system));
      expect(defaultSettings.language, equals('zh'));
      
      // Test settings persistence
      final customSettings = defaultSettings.copyWith(
        language: 'en',
        enableNotifications: false,
      );
      
      await settingsService.saveSettings(customSettings);
      final loadedSettings = await settingsService.loadSettings();
      
      expect(loadedSettings.language, equals('en'));
      expect(loadedSettings.enableNotifications, isFalse);
    });

    test('Countdown storage service integration works correctly', () async {
      final storageService = CountdownStorageService();
      
      // Create test countdown
      final countdown = CountdownData(
        id: 'test-1',
        title: 'Test Event',
        description: 'Test Description',
        targetDate: DateTime.now().add(const Duration(days: 30)),
        type: 'exam',
        progress: 0.5,
        category: 'Academic',
      );
      
      // Save countdown
      await storageService.saveCountdown(countdown);
      
      // Load and verify
      final loadedCountdowns = await storageService.loadAllCountdowns();
      expect(loadedCountdowns.any((c) => c.id == 'test-1'), isTrue);
      
      // Delete countdown
      await storageService.deleteCountdown('test-1');
      final afterDelete = await storageService.loadAllCountdowns();
      expect(afterDelete.any((c) => c.id == 'test-1'), isFalse);
    });

    test('Week service integration works correctly', () {
      final weekService = WeekService();
      final semesterStart = DateTime(2024, 9, 2); // Monday
      
      // Test week calculation
      final week1 = weekService.calculateWeekNumber(semesterStart, semesterStart);
      expect(week1, equals(1));
      
      final week2 = weekService.calculateWeekNumber(
        semesterStart, 
        semesterStart.add(const Duration(days: 7)),
      );
      expect(week2, equals(2));
      
      // Test odd/even classification
      expect(weekService.isOddWeek(1), isTrue);
      expect(weekService.isOddWeek(2), isFalse);
      
      // Test course filtering
      final courses = [
        DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.single),
        DailyCourse(id: '2', dayOfWeek: DayOfWeek.monday, timeSlotId: '2', courseId: '2', weekType: WeekType.double),
        DailyCourse(id: '3', dayOfWeek: DayOfWeek.monday, timeSlotId: '3', courseId: '3', weekType: WeekType.both),
      ];
      
      final oddWeekCourses = weekService.filterCoursesByWeekType(courses, 1);
      expect(oddWeekCourses.length, equals(2)); // single + both
      
      final evenWeekCourses = weekService.filterCoursesByWeekType(courses, 2);
      expect(evenWeekCourses.length, equals(2)); // double + both
    });

    test('Timetable export service integration works correctly', () {
      final exportService = TimetableExportService();
      
      // Create test data
      final timetableData = TimetableData(
        courses: [
          CourseInfo(id: '1', name: '数学', teacher: '张老师'),
        ],
        timeSlots: [
          TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
        ],
        dailyCourses: [
          DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1'),
        ],
      );
      
      // Test export and import
      final jsonString = exportService.exportToJson(timetableData);
      expect(jsonString, isNotEmpty);
      
      final validation = exportService.validateJson(jsonString);
      expect(validation.isValid, isTrue);
      
      final imported = exportService.importFromJson(jsonString);
      expect(imported, isNotNull);
      expect(imported!.courses.length, equals(1));
      expect(imported.courses.first.name, equals('数学'));
    });
  });
}