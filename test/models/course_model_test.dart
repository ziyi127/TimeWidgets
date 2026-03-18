import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/course_model.dart';

void main() {
  group('Course', () {
    group('construction', () {
      test('creates instance with required parameters', () {
        const course = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        expect(course.subject, 'Math');
        expect(course.teacher, 'Mr. Smith');
        expect(course.time, '08:00-09:00');
        expect(course.classroom, 'Room 101');
        expect(course.isCurrent, false);
      });

      test('creates instance with isCurrent set to true', () {
        const course = Course(
          subject: 'Physics',
          teacher: 'Ms. Lee',
          time: '10:00-11:00',
          classroom: 'Lab 3',
          isCurrent: true,
        );

        expect(course.isCurrent, true);
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'subject': 'Chemistry',
          'teacher': 'Dr. Wang',
          'time': '14:00-15:30',
          'classroom': 'Lab 5',
          'isCurrent': true,
        };

        final course = Course.fromJson(json);

        expect(course.subject, 'Chemistry');
        expect(course.teacher, 'Dr. Wang');
        expect(course.time, '14:00-15:30');
        expect(course.classroom, 'Lab 5');
        expect(course.isCurrent, true);
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{};

        final course = Course.fromJson(json);

        expect(course.subject, '');
        expect(course.teacher, '');
        expect(course.time, '');
        expect(course.classroom, '');
        expect(course.isCurrent, false);
      });

      test('handles null values gracefully', () {
        final json = {
          'subject': null,
          'teacher': null,
          'time': null,
          'classroom': null,
          'isCurrent': null,
        };

        final course = Course.fromJson(json);

        expect(course.subject, '');
        expect(course.teacher, '');
        expect(course.time, '');
        expect(course.classroom, '');
        expect(course.isCurrent, false);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        const course = Course(
          subject: 'English',
          teacher: 'Ms. Zhang',
          time: '09:00-10:00',
          classroom: 'Room 202',
          isCurrent: true,
        );

        final json = course.toJson();

        expect(json['subject'], 'English');
        expect(json['teacher'], 'Ms. Zhang');
        expect(json['time'], '09:00-10:00');
        expect(json['classroom'], 'Room 202');
        expect(json['isCurrent'], true);
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves data', () {
        const original = Course(
          subject: 'History',
          teacher: 'Prof. Liu',
          time: '13:00-14:30',
          classroom: 'Room 305',
          isCurrent: true,
        );

        final restored = Course.fromJson(original.toJson());

        expect(restored, equals(original));
      });
    });

    group('copyWith', () {
      test('copies with changed subject', () {
        const original = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        final copied = original.copyWith(subject: 'Physics');

        expect(copied.subject, 'Physics');
        expect(copied.teacher, 'Mr. Smith');
        expect(copied.time, '08:00-09:00');
        expect(copied.classroom, 'Room 101');
      });

      test('copies with changed isCurrent', () {
        const original = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        final copied = original.copyWith(isCurrent: true);

        expect(copied.isCurrent, true);
        expect(copied.subject, 'Math');
      });

      test('copies with no changes returns equal object', () {
        const original = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        const a = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );
        const b = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different subject produces inequality', () {
        const a = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );
        const b = Course(
          subject: 'Physics',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        expect(a, isNot(equals(b)));
      });

      test('different isCurrent produces inequality', () {
        const a = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );
        const b = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
          isCurrent: true,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('contains key fields', () {
        const course = Course(
          subject: 'Math',
          teacher: 'Mr. Smith',
          time: '08:00-09:00',
          classroom: 'Room 101',
        );

        final str = course.toString();

        expect(str, contains('Course'));
        expect(str, contains('Math'));
        expect(str, contains('Mr. Smith'));
      });
    });
  });

  group('Timetable', () {
    group('construction', () {
      test('creates instance with empty courses', () {
        final timetable = Timetable(
          courses: const [],
          date: DateTime(2026, 3),
        );

        expect(timetable.courses, isEmpty);
        expect(timetable.date, DateTime(2026, 3));
      });

      test('creates instance with courses', () {
        final timetable = Timetable(
          courses: const [
            Course(
              subject: 'Math',
              teacher: 'Mr. Smith',
              time: '08:00-09:00',
              classroom: 'Room 101',
            ),
          ],
          date: DateTime(2026, 3),
        );

        expect(timetable.courses.length, 1);
        expect(timetable.courses.first.subject, 'Math');
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'courses': [
            {
              'subject': 'Math',
              'teacher': 'Mr. Smith',
              'time': '08:00-09:00',
              'classroom': 'Room 101',
            },
            {
              'subject': 'English',
              'teacher': 'Ms. Zhang',
              'time': '09:00-10:00',
              'classroom': 'Room 202',
            },
          ],
          'date': '2026-03-01T00:00:00.000',
        };

        final timetable = Timetable.fromJson(json);

        expect(timetable.courses.length, 2);
        expect(timetable.courses[0].subject, 'Math');
        expect(timetable.courses[1].subject, 'English');
        expect(timetable.date, DateTime(2026, 3));
      });

      test('handles null courses list', () {
        final json = {
          'courses': null,
          'date': '2026-03-01T00:00:00.000',
        };

        final timetable = Timetable.fromJson(json);

        expect(timetable.courses, isEmpty);
      });
    });

    group('toJson', () {
      test('serializes correctly', () {
        final timetable = Timetable(
          courses: const [
            Course(
              subject: 'Math',
              teacher: 'Mr. Smith',
              time: '08:00-09:00',
              classroom: 'Room 101',
            ),
          ],
          date: DateTime(2026, 3),
        );

        final json = timetable.toJson();

        expect(json['courses'], isList);
        expect((json['courses'] as List).length, 1);
        expect(json['date'], '2026-03-01T00:00:00.000');
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves data', () {
        final original = Timetable(
          courses: const [
            Course(
              subject: 'Physics',
              teacher: 'Dr. Wang',
              time: '10:00-11:30',
              classroom: 'Lab 2',
              isCurrent: true,
            ),
          ],
          date: DateTime(2026, 5, 20),
        );

        final restored = Timetable.fromJson(original.toJson());

        expect(restored.courses.length, original.courses.length);
        expect(restored.courses.first, equals(original.courses.first));
        expect(restored.date, original.date);
      });
    });

    group('copyWith', () {
      test('copies with changed date', () {
        final original = Timetable(
          courses: const [],
          date: DateTime(2026, 3),
        );

        final copied = original.copyWith(date: DateTime(2026, 4));

        expect(copied.date, DateTime(2026, 4));
        expect(copied.courses, isEmpty);
      });
    });

    group('toString', () {
      test('contains key info', () {
        final timetable = Timetable(
          courses: const [
            Course(
              subject: 'Math',
              teacher: 'Mr. Smith',
              time: '08:00-09:00',
              classroom: 'Room 101',
            ),
          ],
          date: DateTime(2026, 3),
        );

        final str = timetable.toString();

        expect(str, contains('Timetable'));
        expect(str, contains('1 items'));
      });
    });
  });
}
