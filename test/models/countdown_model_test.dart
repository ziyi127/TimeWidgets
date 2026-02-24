import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/countdown_model.dart';

void main() {
  group('CountdownData', () {
    final now = DateTime(2026, 3, 1, 12, 0, 0);
    final futureDate = DateTime(2026, 3, 10, 12, 0, 0);
    final pastDate = DateTime(2026, 2, 20, 12, 0, 0);
    final approachingDate = DateTime(2026, 3, 5, 12, 0, 0);

    CountdownData createCountdown({
      String id = 'test-1',
      String title = 'Math Exam',
      String description = 'Final exam',
      DateTime? targetDate,
      String type = 'exam',
      double progress = 0.5,
      String? category,
      Color? color,
    }) {
      return CountdownData(
        id: id,
        title: title,
        description: description,
        targetDate: targetDate ?? futureDate,
        type: type,
        progress: progress,
        category: category,
        color: color,
      );
    }

    group('construction', () {
      test('creates instance with required parameters', () {
        final countdown = createCountdown();

        expect(countdown.id, 'test-1');
        expect(countdown.title, 'Math Exam');
        expect(countdown.description, 'Final exam');
        expect(countdown.targetDate, futureDate);
        expect(countdown.type, 'exam');
        expect(countdown.progress, 0.5);
        expect(countdown.category, isNull);
        expect(countdown.color, isNull);
      });

      test('creates instance with optional parameters', () {
        final countdown = createCountdown(
          category: 'study',
          color: const Color(0xFFFF0000),
        );

        expect(countdown.category, 'study');
        expect(countdown.color, const Color(0xFFFF0000));
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'id': 'cd-1',
          'title': 'Exam',
          'description': 'Math final',
          'targetDate': '2026-06-15T09:00:00.000',
          'type': 'exam',
          'progress': 0.75,
          'category': 'study',
          'color': 0xFFFF5722,
        };

        final countdown = CountdownData.fromJson(json);

        expect(countdown.id, 'cd-1');
        expect(countdown.title, 'Exam');
        expect(countdown.description, 'Math final');
        expect(countdown.targetDate, DateTime(2026, 6, 15, 9, 0, 0));
        expect(countdown.type, 'exam');
        expect(countdown.progress, 0.75);
        expect(countdown.category, 'study');
        expect(countdown.color, const Color(0xFFFF5722));
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{};

        final countdown = CountdownData.fromJson(json);

        expect(countdown.id, '');
        expect(countdown.title, '');
        expect(countdown.description, '');
        expect(countdown.type, 'event');
        expect(countdown.progress, 0.0);
        expect(countdown.category, isNull);
        expect(countdown.color, isNull);
      });

      test('handles null values gracefully', () {
        final json = {
          'id': null,
          'title': null,
          'description': null,
          'type': null,
          'progress': null,
        };

        final countdown = CountdownData.fromJson(json);

        expect(countdown.id, '');
        expect(countdown.title, '');
        expect(countdown.type, 'event');
        expect(countdown.progress, 0.0);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        final countdown = CountdownData(
          id: 'cd-1',
          title: 'Exam',
          description: 'Math final',
          targetDate: DateTime(2026, 6, 15, 9, 0, 0),
          type: 'exam',
          progress: 0.75,
          category: 'study',
          color: const Color(0xFFFF5722),
        );

        final json = countdown.toJson();

        expect(json['id'], 'cd-1');
        expect(json['title'], 'Exam');
        expect(json['description'], 'Math final');
        expect(json['targetDate'], '2026-06-15T09:00:00.000');
        expect(json['type'], 'exam');
        expect(json['progress'], 0.75);
        expect(json['category'], 'study');
        // color is serialized via toARGB32
        expect(json['color'], isNotNull);
      });

      test('serializes null optional fields', () {
        final countdown = createCountdown();
        final json = countdown.toJson();

        expect(json['category'], isNull);
        expect(json['color'], isNull);
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves data', () {
        final original = CountdownData(
          id: 'rt-1',
          title: 'Round Trip',
          description: 'Test round trip',
          targetDate: DateTime(2026, 12, 25),
          type: 'event',
          progress: 0.33,
          category: 'holiday',
        );

        final restored = CountdownData.fromJson(original.toJson());

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.description, original.description);
        expect(restored.targetDate, original.targetDate);
        expect(restored.type, original.type);
        expect(restored.progress, original.progress);
        expect(restored.category, original.category);
      });
    });

    group('typeLabel', () {
      test('returns correct label for exam', () {
        final countdown = createCountdown(type: 'exam');
        expect(countdown.typeLabel, '考试');
      });

      test('returns correct label for deadline', () {
        final countdown = createCountdown(type: 'deadline');
        expect(countdown.typeLabel, '截止');
      });

      test('returns correct label for event', () {
        final countdown = createCountdown(type: 'event');
        expect(countdown.typeLabel, '事件');
      });

      test('returns correct label for task', () {
        final countdown = createCountdown(type: 'task');
        expect(countdown.typeLabel, '任务');
      });

      test('returns raw type for unknown type', () {
        final countdown = createCountdown(type: 'custom');
        expect(countdown.typeLabel, 'custom');
      });

      test('handles case-insensitive type matching', () {
        final countdown = createCountdown(type: 'EXAM');
        expect(countdown.typeLabel, '考试');
      });
    });

    group('typeColor', () {
      test('returns custom color when set', () {
        final countdown = createCountdown(color: const Color(0xFF123456));
        expect(countdown.typeColor, const Color(0xFF123456));
      });

      test('returns red for exam type', () {
        final countdown = createCountdown(type: 'exam');
        expect(countdown.typeColor, const Color(0xFFF44336));
      });

      test('returns orange for deadline type', () {
        final countdown = createCountdown(type: 'deadline');
        expect(countdown.typeColor, const Color(0xFFFF9800));
      });

      test('returns green for event type', () {
        final countdown = createCountdown(type: 'event');
        expect(countdown.typeColor, const Color(0xFF4CAF50));
      });

      test('returns blue for task type', () {
        final countdown = createCountdown(type: 'task');
        expect(countdown.typeColor, const Color(0xFF2196F3));
      });

      test('returns grey for unknown type', () {
        final countdown = createCountdown(type: 'other');
        expect(countdown.typeColor, const Color(0xFF9E9E9E));
      });
    });

    group('copyWith', () {
      test('copies with changed title', () {
        final original = createCountdown();
        final copied = original.copyWith(title: 'New Title');

        expect(copied.title, 'New Title');
        expect(copied.id, original.id);
        expect(copied.type, original.type);
      });

      test('copies with no changes returns equal object', () {
        final original = createCountdown();
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        final a = createCountdown();
        final b = createCountdown();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different id produces inequality', () {
        final a = createCountdown(id: 'a');
        final b = createCountdown(id: 'b');

        expect(a, isNot(equals(b)));
      });

      test('identical returns true', () {
        final a = createCountdown();

        expect(a, equals(a));
      });
    });

    group('toString', () {
      test('contains key fields', () {
        final countdown = createCountdown();
        final str = countdown.toString();

        expect(str, contains('CountdownData'));
        expect(str, contains('test-1'));
        expect(str, contains('Math Exam'));
      });
    });
  });
}
