import 'package:glados/glados.dart';
import 'package:time_widgets/services/week_service.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';

void main() {
  final weekService = WeekService();

  group('Week Number Calculation Property Tests', () {
    // **Feature: project-enhancement, Property 9: Week Number Calculation**
    // **Validates: Requirements 6.1, 6.3**
    Glados(any.intInRange(0, 365)).test(
      'week number equals ceil((currentDate - startDate).inDays / 7) + 1',
      (daysAfterStart) {
        final semesterStart = DateTime(2024, 9, 2); // Monday
        final currentDate = semesterStart.add(Duration(days: daysAfterStart));

        final weekNumber = weekService.calculateWeekNumber(semesterStart, currentDate);
        final expectedWeek = (daysAfterStart ~/ 7) + 1;

        expect(weekNumber, equals(expectedWeek));
      },
    );

    test('week number is 0 when current date is before semester start', () {
      final semesterStart = DateTime(2024, 9, 2);
      final currentDate = DateTime(2024, 9, 1);

      final weekNumber = weekService.calculateWeekNumber(semesterStart, currentDate);

      expect(weekNumber, equals(0));
    });

    test('first day of semester is week 1', () {
      final semesterStart = DateTime(2024, 9, 2);

      final weekNumber = weekService.calculateWeekNumber(semesterStart, semesterStart);

      expect(weekNumber, equals(1));
    });

    test('day 7 is still week 1', () {
      final semesterStart = DateTime(2024, 9, 2);
      final day7 = semesterStart.add(const Duration(days: 6));

      final weekNumber = weekService.calculateWeekNumber(semesterStart, day7);

      expect(weekNumber, equals(1));
    });

    test('day 8 is week 2', () {
      final semesterStart = DateTime(2024, 9, 2);
      final day8 = semesterStart.add(const Duration(days: 7));

      final weekNumber = weekService.calculateWeekNumber(semesterStart, day8);

      expect(weekNumber, equals(2));
    });
  });

  group('Odd/Even Week Classification Property Tests', () {
    // **Feature: project-enhancement, Property 10: Odd/Even Week Classification**
    // **Validates: Requirements 6.2**
    Glados(any.intInRange(1, 100)).test(
      'isOddWeek returns true if weekNumber % 2 == 1',
      (weekNumber) {
        final isOdd = weekService.isOddWeek(weekNumber);
        final expected = weekNumber % 2 == 1;

        expect(isOdd, equals(expected));
      },
    );

    test('week 1 is odd', () {
      expect(weekService.isOddWeek(1), isTrue);
    });

    test('week 2 is even', () {
      expect(weekService.isOddWeek(2), isFalse);
    });

    test('week 3 is odd', () {
      expect(weekService.isOddWeek(3), isTrue);
    });
  });

  group('Course Filtering by Week Type Property Tests', () {
    // **Feature: project-enhancement, Property 11: Course Filtering by Week Type**
    // **Validates: Requirements 6.4**
    test('courses with WeekType.both are always included', () {
      final courses = [
        DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.both),
        DailyCourse(id: '2', dayOfWeek: DayOfWeek.monday, timeSlotId: '2', courseId: '2', weekType: WeekType.both),
      ];

      final filteredOdd = weekService.filterCoursesByWeekType(courses, 1);
      final filteredEven = weekService.filterCoursesByWeekType(courses, 2);

      expect(filteredOdd.length, equals(2));
      expect(filteredEven.length, equals(2));
    });

    test('courses with WeekType.single are only included in odd weeks', () {
      final courses = [
        DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.single),
      ];

      final filteredOdd = weekService.filterCoursesByWeekType(courses, 1);
      final filteredEven = weekService.filterCoursesByWeekType(courses, 2);

      expect(filteredOdd.length, equals(1));
      expect(filteredEven.length, equals(0));
    });

    test('courses with WeekType.double are only included in even weeks', () {
      final courses = [
        DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.double),
      ];

      final filteredOdd = weekService.filterCoursesByWeekType(courses, 1);
      final filteredEven = weekService.filterCoursesByWeekType(courses, 2);

      expect(filteredOdd.length, equals(0));
      expect(filteredEven.length, equals(1));
    });

    Glados(any.intInRange(1, 20)).test(
      'filtering preserves courses with matching week type',
      (weekNumber) {
        final isOdd = weekNumber % 2 == 1;
        final courses = [
          DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.both),
          DailyCourse(id: '2', dayOfWeek: DayOfWeek.monday, timeSlotId: '2', courseId: '2', weekType: WeekType.single),
          DailyCourse(id: '3', dayOfWeek: DayOfWeek.monday, timeSlotId: '3', courseId: '3', weekType: WeekType.double),
        ];

        final filtered = weekService.filterCoursesByWeekType(courses, weekNumber);

        // Both type should always be included
        expect(filtered.any((c) => c.id == '1'), isTrue);
        // Single type should be included only in odd weeks
        expect(filtered.any((c) => c.id == '2'), equals(isOdd));
        // Double type should be included only in even weeks
        expect(filtered.any((c) => c.id == '3'), equals(!isOdd));
      },
    );

    test('returns empty list when week number is 0 or negative', () {
      final courses = [
        DailyCourse(id: '1', dayOfWeek: DayOfWeek.monday, timeSlotId: '1', courseId: '1', weekType: WeekType.both),
      ];

      expect(weekService.filterCoursesByWeekType(courses, 0), isEmpty);
      expect(weekService.filterCoursesByWeekType(courses, -1), isEmpty);
    });
  });
}
