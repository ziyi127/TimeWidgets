import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';

void main() {
  group('TempScheduleChange', () {
    final testDate = DateTime(2026, 3, 15);
    final createdAt = DateTime(2026, 3, 10, 14, 30);

    TempScheduleChange createDayChange({
      String id = 'tsc-1',
      String? note,
    }) {
      return TempScheduleChange(
        id: id,
        type: TempChangeType.day,
        date: testDate,
        originalScheduleId: 'schedule-mon',
        newScheduleId: 'schedule-fri',
        createdAt: createdAt,
        note: note,
      );
    }

    TempScheduleChange createPeriodChange({
      String id = 'tsc-2',
    }) {
      return TempScheduleChange(
        id: id,
        type: TempChangeType.period,
        date: testDate,
        timeSlotId: 'slot-3',
        originalCourseId: 'course-math',
        newCourseId: 'course-english',
        createdAt: createdAt,
        note: 'Teacher sick',
      );
    }

    group('construction', () {
      test('creates day change', () {
        final change = createDayChange(note: 'Holiday swap');

        expect(change.id, 'tsc-1');
        expect(change.type, TempChangeType.day);
        expect(change.date, testDate);
        expect(change.originalScheduleId, 'schedule-mon');
        expect(change.newScheduleId, 'schedule-fri');
        expect(change.timeSlotId, isNull);
        expect(change.originalCourseId, isNull);
        expect(change.newCourseId, isNull);
        expect(change.createdAt, createdAt);
        expect(change.note, 'Holiday swap');
      });

      test('creates period change', () {
        final change = createPeriodChange();

        expect(change.type, TempChangeType.period);
        expect(change.timeSlotId, 'slot-3');
        expect(change.originalCourseId, 'course-math');
        expect(change.newCourseId, 'course-english');
        expect(change.originalScheduleId, isNull);
        expect(change.newScheduleId, isNull);
      });
    });

    group('fromJson', () {
      test('parses day change JSON', () {
        final json = {
          'id': 'tsc-1',
          'type': 0, // TempChangeType.day.index
          'date': '2026-03-15T00:00:00.000',
          'originalScheduleId': 'schedule-mon',
          'newScheduleId': 'schedule-fri',
          'createdAt': '2026-03-10T14:30:00.000',
          'note': 'Holiday swap',
        };

        final change = TempScheduleChange.fromJson(json);

        expect(change.id, 'tsc-1');
        expect(change.type, TempChangeType.day);
        expect(change.date, testDate);
        expect(change.originalScheduleId, 'schedule-mon');
        expect(change.newScheduleId, 'schedule-fri');
        expect(change.note, 'Holiday swap');
      });

      test('parses period change JSON', () {
        final json = {
          'id': 'tsc-2',
          'type': 1, // TempChangeType.period.index
          'date': '2026-03-15T00:00:00.000',
          'timeSlotId': 'slot-3',
          'originalCourseId': 'course-math',
          'newCourseId': 'course-english',
          'createdAt': '2026-03-10T14:30:00.000',
          'note': 'Teacher sick',
        };

        final change = TempScheduleChange.fromJson(json);

        expect(change.type, TempChangeType.period);
        expect(change.timeSlotId, 'slot-3');
        expect(change.originalCourseId, 'course-math');
        expect(change.newCourseId, 'course-english');
      });

      test('handles null optional fields', () {
        final json = {
          'id': 'tsc-3',
          'type': 0,
          'date': '2026-03-15T00:00:00.000',
          'createdAt': '2026-03-10T14:30:00.000',
        };

        final change = TempScheduleChange.fromJson(json);

        expect(change.timeSlotId, isNull);
        expect(change.originalCourseId, isNull);
        expect(change.newCourseId, isNull);
        expect(change.originalScheduleId, isNull);
        expect(change.newScheduleId, isNull);
        expect(change.note, isNull);
      });
    });

    group('toJson', () {
      test('serializes day change correctly', () {
        final change = createDayChange(note: 'Test note');
        final json = change.toJson();

        expect(json['id'], 'tsc-1');
        expect(json['type'], 0);
        expect(json['date'], testDate.toIso8601String());
        expect(json['originalScheduleId'], 'schedule-mon');
        expect(json['newScheduleId'], 'schedule-fri');
        expect(json['createdAt'], createdAt.toIso8601String());
        expect(json['note'], 'Test note');
        expect(json['timeSlotId'], isNull);
      });

      test('serializes period change correctly', () {
        final change = createPeriodChange();
        final json = change.toJson();

        expect(json['type'], 1);
        expect(json['timeSlotId'], 'slot-3');
        expect(json['originalCourseId'], 'course-math');
        expect(json['newCourseId'], 'course-english');
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves day change', () {
        final original = createDayChange(note: 'Round trip test');
        final restored = TempScheduleChange.fromJson(original.toJson());

        expect(restored, equals(original));
      });

      test('fromJson(toJson()) preserves period change', () {
        final original = createPeriodChange();
        final restored = TempScheduleChange.fromJson(original.toJson());

        expect(restored, equals(original));
      });
    });

    group('copyWith', () {
      test('copies with changed note', () {
        final original = createDayChange();
        final copied = original.copyWith(note: 'Updated note');

        expect(copied.note, 'Updated note');
        expect(copied.id, original.id);
        expect(copied.type, original.type);
      });

      test('copies with changed type', () {
        final original = createDayChange();
        final copied = original.copyWith(type: TempChangeType.period);

        expect(copied.type, TempChangeType.period);
      });

      test('copies with no changes returns equal object', () {
        final original = createPeriodChange();
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        final a = createDayChange();
        final b = createDayChange();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different id produces inequality', () {
        final a = createDayChange(id: 'a');
        final b = createDayChange(id: 'b');

        expect(a, isNot(equals(b)));
      });

      test('identical returns true', () {
        final a = createDayChange();

        expect(a, equals(a));
      });
    });

    group('toString', () {
      test('contains key fields', () {
        final change = createDayChange(note: 'Test');
        final str = change.toString();

        expect(str, contains('TempScheduleChange'));
        expect(str, contains('tsc-1'));
        expect(str, contains('Test'));
      });
    });
  });

  group('TempChangeType', () {
    test('has correct values', () {
      expect(TempChangeType.day.index, 0);
      expect(TempChangeType.period.index, 1);
    });

    test('has correct number of values', () {
      expect(TempChangeType.values.length, 2);
    });
  });
}
