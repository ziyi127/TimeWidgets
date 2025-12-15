import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/models/timetable_edit_model.dart';

/// **Feature: md3-settings-timetable-enhancement, Property 7: Timetable data serialization round-trip**
/// **Validates: Requirements 15.1, 15.2**
///
/// For any valid TimetableData object containing subjects, time layouts, and
/// course assignments, serializing to JSON and then deserializing SHALL produce
/// an equivalent TimetableData object.
void main() {
  group('Timetable Serialization Properties', () {
    group('Property 7: Serialization round-trip', () {
      test('CourseInfo round-trip preserves all fields', () {
        final original = CourseInfo(
          id: '1',
          name: '数学',
          abbreviation: '数',
          teacher: '张老师',
          classroom: 'A101',
          color: '#FF5722',
          isOutdoor: false,
        );

        final json = original.toJson();
        final restored = CourseInfo.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.abbreviation, equals(original.abbreviation));
        expect(restored.teacher, equals(original.teacher));
        expect(restored.classroom, equals(original.classroom));
        expect(restored.color, equals(original.color));
        expect(restored.isOutdoor, equals(original.isOutdoor));
      });

      test('TimeSlot round-trip preserves all fields', () {
        final original = TimeSlot(
          id: '1',
          name: '第一节',
          startTime: '08:00',
          endTime: '08:45',
          type: TimePointType.classTime,
          defaultSubjectId: 'subject1',
          isHiddenByDefault: false,
        );

        final json = original.toJson();
        final restored = TimeSlot.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.startTime, equals(original.startTime));
        expect(restored.endTime, equals(original.endTime));
        expect(restored.type, equals(original.type));
        expect(restored.defaultSubjectId, equals(original.defaultSubjectId));
        expect(restored.isHiddenByDefault, equals(original.isHiddenByDefault));
      });

      test('DailyCourse round-trip preserves all fields', () {
        final original = DailyCourse(
          id: '1',
          dayOfWeek: DayOfWeek.monday,
          timeSlotId: 'slot1',
          courseId: 'course1',
          weekType: WeekType.single,
        );

        final json = original.toJson();
        final restored = DailyCourse.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.dayOfWeek, equals(original.dayOfWeek));
        expect(restored.timeSlotId, equals(original.timeSlotId));
        expect(restored.courseId, equals(original.courseId));
        expect(restored.weekType, equals(original.weekType));
      });

      test('ScheduleTriggerRule round-trip preserves all fields', () {
        final original = ScheduleTriggerRule(
          weekDay: 1,
          weekType: WeekType.single,
          isEnabled: true,
        );

        final json = original.toJson();
        final restored = ScheduleTriggerRule.fromJson(json);

        expect(restored.weekDay, equals(original.weekDay));
        expect(restored.weekType, equals(original.weekType));
        expect(restored.isEnabled, equals(original.isEnabled));
      });

      test('Schedule round-trip preserves all fields', () {
        final original = Schedule(
          id: '1',
          name: '周一课表',
          timeLayoutId: 'layout1',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.both,
            isEnabled: true,
          ),
          courses: [
            DailyCourse(
              id: '1',
              dayOfWeek: DayOfWeek.monday,
              timeSlotId: 'slot1',
              courseId: 'course1',
            ),
          ],
          isAutoEnabled: true,
          priority: 1,
        );

        final json = original.toJson();
        final restored = Schedule.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.timeLayoutId, equals(original.timeLayoutId));
        expect(restored.triggerRule.weekDay, equals(original.triggerRule.weekDay));
        expect(restored.courses.length, equals(original.courses.length));
        expect(restored.isAutoEnabled, equals(original.isAutoEnabled));
        expect(restored.priority, equals(original.priority));
      });

      test('TimeLayout round-trip preserves all fields', () {
        final original = TimeLayout(
          id: '1',
          name: '默认时间表',
          timeSlots: [
            TimeSlot(
              id: '1',
              name: '第一节',
              startTime: '08:00',
              endTime: '08:45',
              type: TimePointType.classTime,
            ),
            TimeSlot(
              id: '2',
              name: '课间',
              startTime: '08:45',
              endTime: '08:55',
              type: TimePointType.breakTime,
            ),
          ],
        );

        final json = original.toJson();
        final restored = TimeLayout.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.timeSlots.length, equals(original.timeSlots.length));
        expect(restored.timeSlots[0].type, equals(original.timeSlots[0].type));
        expect(restored.timeSlots[1].type, equals(original.timeSlots[1].type));
      });

      test('TimetableData round-trip preserves all data', () {
        final original = TimetableData(
          courses: [
            CourseInfo(
              id: '1',
              name: '数学',
              abbreviation: '数',
              teacher: '张老师',
            ),
            CourseInfo(
              id: '2',
              name: '语文',
              abbreviation: '语',
              teacher: '李老师',
            ),
          ],
          timeSlots: [
            TimeSlot(
              id: '1',
              name: '第一节',
              startTime: '08:00',
              endTime: '08:45',
              type: TimePointType.classTime,
            ),
          ],
          dailyCourses: [
            DailyCourse(
              id: '1',
              dayOfWeek: DayOfWeek.monday,
              timeSlotId: '1',
              courseId: '1',
            ),
          ],
          timeLayouts: [
            TimeLayout(
              id: '1',
              name: '默认时间表',
              timeSlots: [],
            ),
          ],
          schedules: [
            Schedule(
              id: '1',
              name: '周一课表',
              triggerRule: const ScheduleTriggerRule(weekDay: 1),
            ),
          ],
        );

        final json = original.toJson();
        final restored = TimetableData.fromJson(json);

        expect(restored.courses.length, equals(original.courses.length));
        expect(restored.timeSlots.length, equals(original.timeSlots.length));
        expect(restored.dailyCourses.length, equals(original.dailyCourses.length));
        expect(restored.timeLayouts.length, equals(original.timeLayouts.length));
        expect(restored.schedules.length, equals(original.schedules.length));

        // Verify first course details
        expect(restored.courses[0].name, equals(original.courses[0].name));
        expect(restored.courses[0].abbreviation, equals(original.courses[0].abbreviation));
      });

      // Property-based tests using Glados
      Glados(any.intInRange(0, 100)).test(
        'CourseInfo serialization is idempotent for various inputs',
        (seed) {
          final course = CourseInfo(
            id: 'id_$seed',
            name: 'Course_$seed',
            abbreviation: 'C$seed',
            teacher: 'Teacher_$seed',
            color: '#${(seed * 12345 % 0xFFFFFF).toRadixString(16).padLeft(6, '0')}',
            isOutdoor: seed % 2 == 0,
          );

          final json = course.toJson();
          final restored = CourseInfo.fromJson(json);
          final json2 = restored.toJson();

          expect(json, equals(json2));
        },
      );

      Glados(any.intInRange(0, 100)).test(
        'TimeSlot serialization is idempotent for various inputs',
        (seed) {
          final hour = seed % 24;
          final minute = (seed * 7) % 60;
          final timeSlot = TimeSlot(
            id: 'id_$seed',
            name: 'Slot_$seed',
            startTime: '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            endTime: '${((hour + 1) % 24).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            type: TimePointType.values[seed % 3],
          );

          final json = timeSlot.toJson();
          final restored = TimeSlot.fromJson(json);
          final json2 = restored.toJson();

          expect(json, equals(json2));
        },
      );

      Glados(any.intInRange(0, 100)).test(
        'DailyCourse serialization is idempotent for various inputs',
        (seed) {
          final dailyCourse = DailyCourse(
            id: 'id_$seed',
            dayOfWeek: DayOfWeek.values[seed % 7],
            timeSlotId: 'slot_$seed',
            courseId: 'course_$seed',
            weekType: WeekType.values[seed % 3],
          );

          final json = dailyCourse.toJson();
          final restored = DailyCourse.fromJson(json);
          final json2 = restored.toJson();

          expect(json, equals(json2));
        },
      );
    });

    group('Backward compatibility', () {
      test('TimeSlot without new fields should use defaults', () {
        final json = {
          'id': '1',
          'startTime': '08:00',
          'endTime': '08:45',
          'name': '第一节',
        };

        final restored = TimeSlot.fromJson(json);

        expect(restored.type, equals(TimePointType.classTime));
        expect(restored.defaultSubjectId, isNull);
        expect(restored.isHiddenByDefault, isFalse);
      });

      test('CourseInfo without new fields should use defaults', () {
        final json = {
          'id': '1',
          'name': '数学',
          'teacher': '张老师',
        };

        final restored = CourseInfo.fromJson(json);

        expect(restored.abbreviation, equals(''));
        expect(restored.classroom, equals(''));
        expect(restored.color, equals('#2196F3'));
        expect(restored.isOutdoor, isFalse);
      });

      test('TimetableData without new fields should use empty lists', () {
        final json = {
          'courses': <Map<String, dynamic>>[],
          'timeSlots': <Map<String, dynamic>>[],
          'dailyCourses': <Map<String, dynamic>>[],
        };

        final restored = TimetableData.fromJson(json);

        expect(restored.timeLayouts, isEmpty);
        expect(restored.schedules, isEmpty);
      });
    });
  });
}
