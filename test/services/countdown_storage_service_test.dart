import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';

void main() {
  group('CountdownStorageService', () {
    late CountdownStorageService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = CountdownStorageService();
    });

    CountdownData createCountdown({
      String id = 'cd-1',
      String title = 'Test Countdown',
      String type = 'event',
    }) {
      return CountdownData(
        id: id,
        title: title,
        description: 'Test description',
        targetDate: DateTime(2026, 12, 25),
        type: type,
        progress: 0,
      );
    }

    group('loadAllCountdowns', () {
      test('returns empty list when no data stored', () async {
        final countdowns = await service.loadAllCountdowns();
        expect(countdowns, isEmpty);
      });

      test('returns stored countdowns', () async {
        await service.saveCountdown(createCountdown());
        await service.saveCountdown(createCountdown(id: 'cd-2', title: 'Second'));

        final countdowns = await service.loadAllCountdowns();

        expect(countdowns.length, 2);
        expect(countdowns[0].id, 'cd-1');
        expect(countdowns[1].id, 'cd-2');
      });
    });

    group('saveCountdown', () {
      test('saves new countdown', () async {
        final countdown = createCountdown();

        await service.saveCountdown(countdown);

        final loaded = await service.loadAllCountdowns();
        expect(loaded.length, 1);
        expect(loaded.first.id, 'cd-1');
        expect(loaded.first.title, 'Test Countdown');
      });

      test('updates existing countdown with same id', () async {
        await service.saveCountdown(createCountdown(title: 'Original'));
        await service.saveCountdown(createCountdown(title: 'Updated'));

        final loaded = await service.loadAllCountdowns();

        expect(loaded.length, 1);
        expect(loaded.first.title, 'Updated');
      });
    });

    group('updateCountdown', () {
      test('updates existing countdown', () async {
        await service.saveCountdown(createCountdown(title: 'Original'));

        final updated = createCountdown(title: 'Updated Title');
        await service.updateCountdown(updated);

        final loaded = await service.loadAllCountdowns();
        expect(loaded.first.title, 'Updated Title');
      });

      test('throws when countdown not found', () async {
        final nonExistent = createCountdown(id: 'non-existent');

        expect(
          () => service.updateCountdown(nonExistent),
          throwsException,
        );
      });
    });

    group('deleteCountdown', () {
      test('deletes existing countdown', () async {
        await service.saveCountdown(createCountdown());
        await service.saveCountdown(createCountdown(id: 'cd-2', title: 'Keep'));

        await service.deleteCountdown('cd-1');

        final loaded = await service.loadAllCountdowns();
        expect(loaded.length, 1);
        expect(loaded.first.id, 'cd-2');
      });

      test('does nothing when id not found', () async {
        await service.saveCountdown(createCountdown());

        await service.deleteCountdown('non-existent');

        final loaded = await service.loadAllCountdowns();
        expect(loaded.length, 1);
      });
    });

    group('saveAllCountdowns', () {
      test('replaces all countdowns', () async {
        await service.saveCountdown(createCountdown(id: 'old-1'));
        await service.saveCountdown(createCountdown(id: 'old-2'));

        final newList = [
          createCountdown(id: 'new-1'),
          createCountdown(id: 'new-2'),
          createCountdown(id: 'new-3'),
        ];

        await service.saveAllCountdowns(newList);

        final loaded = await service.loadAllCountdowns();
        expect(loaded.length, 3);
        expect(loaded.map((c) => c.id).toList(), ['new-1', 'new-2', 'new-3']);
      });

      test('can save empty list', () async {
        await service.saveCountdown(createCountdown());

        await service.saveAllCountdowns([]);

        final loaded = await service.loadAllCountdowns();
        expect(loaded, isEmpty);
      });
    });

    group('onChange stream', () {
      test('emits on saveCountdown', () async {
        final future = service.onChange.first;

        await service.saveCountdown(createCountdown());

        // If we get here without timeout, the stream emitted
        await future;
      });

      test('emits on deleteCountdown', () async {
        await service.saveCountdown(createCountdown());

        final future = service.onChange.first;
        await service.deleteCountdown('cd-1');

        await future;
      });

      test('emits on updateCountdown', () async {
        await service.saveCountdown(createCountdown(title: 'Original'));

        final future = service.onChange.first;
        await service.updateCountdown(createCountdown(title: 'Updated'));

        await future;
      });
    });
  });
}
