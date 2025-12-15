import 'package:glados/glados.dart';
import 'package:time_widgets/models/countdown_model.dart';

void main() {
  group('Countdown Persistence Property Tests', () {
    // **Feature: project-enhancement, Property 1: Countdown Event Persistence Round Trip**
    // **Validates: Requirements 2.1, 2.3**
    Glados2(any.intInRange(1, 100), any.intInRange(1, 365)).test(
      'CountdownData JSON round trip preserves all fields',
      (id, daysUntil) {
        final original = CountdownData(
          id: id.toString(),
          title: 'Test Event $id',
          description: 'Description for event $id',
          targetDate: DateTime.now().add(Duration(days: daysUntil)),
          type: 'exam',
          progress: 0.5,
          category: 'Academic',
        );

        final json = original.toJson();
        final restored = CountdownData.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.title, equals(original.title));
        expect(restored.description, equals(original.description));
        expect(restored.targetDate.year, equals(original.targetDate.year));
        expect(restored.targetDate.month, equals(original.targetDate.month));
        expect(restored.targetDate.day, equals(original.targetDate.day));
        expect(restored.type, equals(original.type));
        expect(restored.progress, equals(original.progress));
        expect(restored.category, equals(original.category));
      },
    );

    test('CountdownData with null category round trips correctly', () {
      final original = CountdownData(
        id: '1',
        title: 'Test',
        description: 'Test description',
        targetDate: DateTime(2025, 6, 1),
        type: 'event',
        progress: 0.0,
        category: null,
      );

      final json = original.toJson();
      final restored = CountdownData.fromJson(json);

      expect(restored.category, isNull);
    });
  });

  group('Countdown List Sorting Property Tests', () {
    // **Feature: project-enhancement, Property 2: Countdown List Sorting**
    // **Validates: Requirements 2.2**
    test('sorted countdown list has ascending target dates', () {
      final countdowns = [
        CountdownData(
          id: '1',
          title: 'Event 1',
          description: 'Desc 1',
          targetDate: DateTime(2025, 3, 15),
          type: 'exam',
          progress: 0.0,
        ),
        CountdownData(
          id: '2',
          title: 'Event 2',
          description: 'Desc 2',
          targetDate: DateTime(2025, 1, 10),
          type: 'deadline',
          progress: 0.0,
        ),
        CountdownData(
          id: '3',
          title: 'Event 3',
          description: 'Desc 3',
          targetDate: DateTime(2025, 2, 20),
          type: 'event',
          progress: 0.0,
        ),
      ];

      countdowns.sort((a, b) => a.targetDate.compareTo(b.targetDate));

      for (int i = 0; i < countdowns.length - 1; i++) {
        expect(
          countdowns[i].targetDate.isBefore(countdowns[i + 1].targetDate) ||
              countdowns[i].targetDate.isAtSameMomentAs(countdowns[i + 1].targetDate),
          isTrue,
        );
      }
    });

    Glados(any.intInRange(2, 10)).test(
      'sorting preserves all elements',
      (count) {
        final countdowns = List.generate(
          count,
          (i) => CountdownData(
            id: i.toString(),
            title: 'Event $i',
            description: 'Desc $i',
            targetDate: DateTime.now().add(Duration(days: (count - i) * 10)),
            type: 'exam',
            progress: 0.0,
          ),
        );

        final originalIds = countdowns.map((c) => c.id).toSet();
        countdowns.sort((a, b) => a.targetDate.compareTo(b.targetDate));
        final sortedIds = countdowns.map((c) => c.id).toSet();

        expect(sortedIds, equals(originalIds));
        expect(countdowns.length, equals(count));
      },
    );
  });

  group('Countdown Deletion Property Tests', () {
    // **Feature: project-enhancement, Property 3: Countdown Deletion Removes Event**
    // **Validates: Requirements 2.4**
    test('deleting countdown removes it from list', () {
      final countdowns = [
        CountdownData(
          id: '1',
          title: 'Event 1',
          description: 'Desc 1',
          targetDate: DateTime(2025, 3, 15),
          type: 'exam',
          progress: 0.0,
        ),
        CountdownData(
          id: '2',
          title: 'Event 2',
          description: 'Desc 2',
          targetDate: DateTime(2025, 1, 10),
          type: 'deadline',
          progress: 0.0,
        ),
      ];

      final idToDelete = '1';
      countdowns.removeWhere((c) => c.id == idToDelete);

      expect(countdowns.any((c) => c.id == idToDelete), isFalse);
      expect(countdowns.length, equals(1));
    });

    Glados(any.intInRange(1, 10)).test(
      'deleting countdown reduces list size by 1',
      (count) {
        final countdowns = List.generate(
          count,
          (i) => CountdownData(
            id: i.toString(),
            title: 'Event $i',
            description: 'Desc $i',
            targetDate: DateTime.now().add(Duration(days: i * 10)),
            type: 'exam',
            progress: 0.0,
          ),
        );

        final originalLength = countdowns.length;
        final idToDelete = '0';
        countdowns.removeWhere((c) => c.id == idToDelete);

        expect(countdowns.length, equals(originalLength - 1));
        expect(countdowns.any((c) => c.id == idToDelete), isFalse);
      },
    );
  });

  group('Countdown Remaining Days Calculation', () {
    test('remainingDays calculates correctly for future dates', () {
      final futureDate = DateTime.now().add(const Duration(days: 10));
      final countdown = CountdownData(
        id: '1',
        title: 'Future Event',
        description: 'Desc',
        targetDate: futureDate,
        type: 'exam',
        progress: 0.0,
      );

      expect(countdown.remainingDays, greaterThanOrEqualTo(9));
      expect(countdown.remainingDays, lessThanOrEqualTo(10));
    });

    test('remainingDays is negative for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 5));
      final countdown = CountdownData(
        id: '1',
        title: 'Past Event',
        description: 'Desc',
        targetDate: pastDate,
        type: 'exam',
        progress: 0.0,
      );

      expect(countdown.remainingDays, lessThan(0));
      expect(countdown.isExpired, isTrue);
    });
  });
}
