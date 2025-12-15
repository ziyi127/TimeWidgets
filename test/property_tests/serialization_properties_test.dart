import 'package:glados/glados.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_export_service.dart';

void main() {
  final exportService = TimetableExportService();

  group('Timetable JSON Round Trip Property Tests', () {
    // **Feature: project-enhancement, Property 6: Timetable JSON Round Trip**
    // **Validates: Requirements 4.1, 4.2, 4.5**
    test('TimetableData JSON round trip preserves all data', () {
      final original = TimetableData(
        courses: [
          CourseInfo(id: '1', name: '语文', teacher: '张老师', classroom: '101', color: '#FF0000'),
          CourseInfo(id: '2', name: '数学', teacher: '李老师', classroom: '102', color: '#00FF00'),
        ],
        timeSlots: [
          TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
          TimeSlot(id: '2', startTime: '09:00', endTime: '09:45', name: '第二节'),
        ],
        dailyCourses: [
          DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.both),
          DailyCourse(id: '2', dayOfWeek: DayOfWeek.tuesday, timeSlotId: '2', courseId: '2', weekType: WeekType.single),
        ],
      );

      final jsonString = exportService.exportToJson(original);
      final restored = exportService.importFromJson(jsonString);

      expect(restored, isNotNull);
      expect(restored!.courses.length, equals(original.courses.length));
      expect(restored.timeSlots.length, equals(original.timeSlots.length));
      expect(restored.dailyCourses.length, equals(original.dailyCourses.length));

      // Verify courses
      for (var i = 0; i < original.courses.length; i++) {
        expect(restored.courses[i].id, equals(original.courses[i].id));
        expect(restored.courses[i].name, equals(original.courses[i].name));
        expect(restored.courses[i].teacher, equals(original.courses[i].teacher));
        expect(restored.courses[i].classroom, equals(original.courses[i].classroom));
        expect(restored.courses[i].color, equals(original.courses[i].color));
      }

      // Verify timeSlots
      for (var i = 0; i < original.timeSlots.length; i++) {
        expect(restored.timeSlots[i].id, equals(original.timeSlots[i].id));
        expect(restored.timeSlots[i].startTime, equals(original.timeSlots[i].startTime));
        expect(restored.timeSlots[i].endTime, equals(original.timeSlots[i].endTime));
        expect(restored.timeSlots[i].name, equals(original.timeSlots[i].name));
      }

      // Verify dailyCourses
      for (var i = 0; i < original.dailyCourses.length; i++) {
        expect(restored.dailyCourses[i].id, equals(original.dailyCourses[i].id));
        expect(restored.dailyCourses[i].dayOfWeek, equals(original.dailyCourses[i].dayOfWeek));
        expect(restored.dailyCourses[i].timeSlotId, equals(original.dailyCourses[i].timeSlotId));
        expect(restored.dailyCourses[i].courseId, equals(original.dailyCourses[i].courseId));
        expect(restored.dailyCourses[i].weekType, equals(original.dailyCourses[i].weekType));
      }
    });

    Glados(any.intInRange(1, 10)).test(
      'round trip preserves course count',
      (courseCount) {
        final courses = List.generate(
          courseCount,
          (i) => CourseInfo(
            id: i.toString(),
            name: 'Course $i',
            teacher: 'Teacher $i',
          ),
        );

        final original = TimetableData(
          courses: courses,
          timeSlots: [],
          dailyCourses: [],
        );

        final jsonString = exportService.exportToJson(original);
        final restored = exportService.importFromJson(jsonString);

        expect(restored, isNotNull);
        expect(restored!.courses.length, equals(courseCount));
      },
    );

    test('empty timetable round trips correctly', () {
      final original = TimetableData(
        courses: [],
        timeSlots: [],
        dailyCourses: [],
      );

      final jsonString = exportService.exportToJson(original);
      final restored = exportService.importFromJson(jsonString);

      expect(restored, isNotNull);
      expect(restored!.courses, isEmpty);
      expect(restored.timeSlots, isEmpty);
      expect(restored.dailyCourses, isEmpty);
    });
  });

  group('Invalid JSON Validation Property Tests', () {
    // **Feature: project-enhancement, Property 7: Invalid JSON Validation**
    // **Validates: Requirements 4.3**
    test('empty string is invalid', () {
      final result = exportService.validateJson('');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, isNotEmpty);
    });

    test('malformed JSON is invalid', () {
      final result = exportService.validateJson('{invalid json}');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('JSON'));
    });

    test('JSON without courses field is invalid', () {
      final result = exportService.validateJson('{"timeSlots": [], "dailyCourses": []}');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('courses'));
    });

    test('JSON without timeSlots field is invalid', () {
      final result = exportService.validateJson('{"courses": [], "dailyCourses": []}');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('timeSlots'));
    });

    test('JSON without dailyCourses field is invalid', () {
      final result = exportService.validateJson('{"courses": [], "timeSlots": []}');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('dailyCourses'));
    });

    test('valid JSON passes validation', () {
      final validJson = '''
      {
        "courses": [{"id": "1", "name": "Math", "teacher": "Mr. Smith"}],
        "timeSlots": [{"id": "1", "startTime": "08:00", "endTime": "08:45", "name": "Period 1"}],
        "dailyCourses": []
      }
      ''';
      final result = exportService.validateJson(validJson);
      expect(result.isValid, isTrue);
    });

    test('course without id is invalid', () {
      final invalidJson = '''
      {
        "courses": [{"name": "Math", "teacher": "Mr. Smith"}],
        "timeSlots": [],
        "dailyCourses": []
      }
      ''';
      final result = exportService.validateJson(invalidJson);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('id'));
    });

    test('timeSlot without required fields is invalid', () {
      final invalidJson = '''
      {
        "courses": [],
        "timeSlots": [{"id": "1"}],
        "dailyCourses": []
      }
      ''';
      final result = exportService.validateJson(invalidJson);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('startTime'));
    });
  });
}
