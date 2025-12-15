import 'package:glados/glados.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/utils/time_slot_utils.dart';

void main() {
  group('Time Slot Highlighting Property Tests', () {
    // **Feature: project-enhancement, Property 12: Current Time Slot Highlighting**
    // **Validates: Requirements 7.2**

    test('at most one time slot is current at any given time', () {
      final timeSlots = [
        TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
        TimeSlot(id: '2', startTime: '09:00', endTime: '09:45', name: '第二节'),
        TimeSlot(id: '3', startTime: '10:00', endTime: '10:45', name: '第三节'),
        TimeSlot(id: '4', startTime: '11:00', endTime: '11:45', name: '第四节'),
      ];

      // Test various times throughout the day
      final testTimes = [
        DateTime(2024, 1, 1, 7, 30),  // Before first slot
        DateTime(2024, 1, 1, 8, 20),  // During first slot
        DateTime(2024, 1, 1, 8, 50),  // Between slots
        DateTime(2024, 1, 1, 9, 30),  // During second slot
        DateTime(2024, 1, 1, 12, 0),  // After all slots
      ];

      for (final time in testTimes) {
        int currentCount = 0;
        for (final slot in timeSlots) {
          if (TimeSlotUtils.isCurrentTimeSlot(slot, time)) {
            currentCount++;
          }
        }
        expect(currentCount, lessThanOrEqualTo(1),
            reason: 'At time ${time.hour}:${time.minute}, found $currentCount current slots');
      }
    });

    Glados(any.intInRange(0, 23)).test(
      'current time slot is correctly identified for any hour',
      (hour) {
        final timeSlots = [
          TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
          TimeSlot(id: '2', startTime: '09:00', endTime: '09:45', name: '第二节'),
          TimeSlot(id: '3', startTime: '14:00', endTime: '14:45', name: '第三节'),
        ];

        final testTime = DateTime(2024, 1, 1, hour, 30);
        final currentIndex = TimeSlotUtils.findCurrentTimeSlotIndex(timeSlots, testTime);

        // Verify the result is valid
        expect(currentIndex, greaterThanOrEqualTo(-1));
        expect(currentIndex, lessThan(timeSlots.length));

        // If a slot is found, verify it's actually current
        if (currentIndex >= 0) {
          expect(
            TimeSlotUtils.isCurrentTimeSlot(timeSlots[currentIndex], testTime),
            isTrue,
          );
        }
      },
    );

    test('time within slot boundaries is correctly identified', () {
      final slot = TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节');

      // Exactly at start time
      expect(
        TimeSlotUtils.isCurrentTimeSlot(slot, DateTime(2024, 1, 1, 8, 0)),
        isTrue,
      );

      // In the middle
      expect(
        TimeSlotUtils.isCurrentTimeSlot(slot, DateTime(2024, 1, 1, 8, 20)),
        isTrue,
      );

      // Exactly at end time
      expect(
        TimeSlotUtils.isCurrentTimeSlot(slot, DateTime(2024, 1, 1, 8, 45)),
        isTrue,
      );

      // Before start time
      expect(
        TimeSlotUtils.isCurrentTimeSlot(slot, DateTime(2024, 1, 1, 7, 59)),
        isFalse,
      );

      // After end time
      expect(
        TimeSlotUtils.isCurrentTimeSlot(slot, DateTime(2024, 1, 1, 8, 46)),
        isFalse,
      );
    });

    test('non-overlapping time slots have distinct current periods', () {
      final timeSlots = [
        TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
        TimeSlot(id: '2', startTime: '09:00', endTime: '09:45', name: '第二节'),
      ];

      // During first slot
      final time1 = DateTime(2024, 1, 1, 8, 30);
      expect(TimeSlotUtils.findCurrentTimeSlotIndex(timeSlots, time1), equals(0));

      // During second slot
      final time2 = DateTime(2024, 1, 1, 9, 30);
      expect(TimeSlotUtils.findCurrentTimeSlotIndex(timeSlots, time2), equals(1));

      // Between slots
      final time3 = DateTime(2024, 1, 1, 8, 50);
      expect(TimeSlotUtils.findCurrentTimeSlotIndex(timeSlots, time3), equals(-1));
    });

    test('getNextTimeSlot returns correct next slot', () {
      final timeSlots = [
        TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节'),
        TimeSlot(id: '2', startTime: '09:00', endTime: '09:45', name: '第二节'),
        TimeSlot(id: '3', startTime: '10:00', endTime: '10:45', name: '第三节'),
      ];

      // Before first slot
      final next1 = TimeSlotUtils.getNextTimeSlot(timeSlots, DateTime(2024, 1, 1, 7, 30));
      expect(next1?.id, equals('1'));

      // During first slot
      final next2 = TimeSlotUtils.getNextTimeSlot(timeSlots, DateTime(2024, 1, 1, 8, 30));
      expect(next2?.id, equals('2'));

      // After all slots
      final next3 = TimeSlotUtils.getNextTimeSlot(timeSlots, DateTime(2024, 1, 1, 11, 0));
      expect(next3, isNull);
    });

    test('isTimeSlotPassed correctly identifies passed slots', () {
      final slot = TimeSlot(id: '1', startTime: '08:00', endTime: '08:45', name: '第一节');

      expect(
        TimeSlotUtils.isTimeSlotPassed(slot, DateTime(2024, 1, 1, 7, 30)),
        isFalse,
      );
      expect(
        TimeSlotUtils.isTimeSlotPassed(slot, DateTime(2024, 1, 1, 8, 30)),
        isFalse,
      );
      expect(
        TimeSlotUtils.isTimeSlotPassed(slot, DateTime(2024, 1, 1, 9, 0)),
        isTrue,
      );
    });

    test('isTimeSlotUpcoming correctly identifies upcoming slots', () {
      final slot = TimeSlot(id: '1', startTime: '09:00', endTime: '09:45', name: '第一节');

      // 30 minutes before - not upcoming (default 15 min window)
      expect(
        TimeSlotUtils.isTimeSlotUpcoming(slot, DateTime(2024, 1, 1, 8, 30)),
        isFalse,
      );

      // 10 minutes before - upcoming
      expect(
        TimeSlotUtils.isTimeSlotUpcoming(slot, DateTime(2024, 1, 1, 8, 50)),
        isTrue,
      );

      // During slot - not upcoming
      expect(
        TimeSlotUtils.isTimeSlotUpcoming(slot, DateTime(2024, 1, 1, 9, 10)),
        isFalse,
      );
    });
  });
}
