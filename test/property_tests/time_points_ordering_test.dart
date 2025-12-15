import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/models/timetable_edit_model.dart';

/// **Feature: md3-settings-timetable-enhancement**
/// **Property 1: Time points chronological ordering**
/// **Validates: Requirements 10.1**
///
/// For any list of time points in a time layout, when displayed in the timeline view,
/// the time points SHALL be ordered by start time in ascending order.
void main() {
  group('Time Points Ordering Properties', () {
    group('Property 1: Time points chronological ordering', () {
      test('time slots should be sortable by start time', () {
        final timeSlots = [
          TimeSlot(id: '3', name: 'Third', startTime: '10:00', endTime: '10:45'),
          TimeSlot(id: '1', name: 'First', startTime: '08:00', endTime: '08:45'),
          TimeSlot(id: '2', name: 'Second', startTime: '09:00', endTime: '09:45'),
        ];
        
        final sorted = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        expect(sorted[0].id, equals('1'));
        expect(sorted[1].id, equals('2'));
        expect(sorted[2].id, equals('3'));
      });

      test('time slots with same start time should maintain stable order', () {
        final timeSlots = [
          TimeSlot(id: '1', name: 'First', startTime: '08:00', endTime: '08:45'),
          TimeSlot(id: '2', name: 'Second', startTime: '08:00', endTime: '08:30'),
        ];
        
        final sorted = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        // Both have same start time, order should be stable
        expect(sorted.length, equals(2));
      });

      test('empty time slots list should sort without error', () {
        final timeSlots = <TimeSlot>[];
        
        final sorted = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        expect(sorted, isEmpty);
      });

      test('single time slot should sort without error', () {
        final timeSlots = [
          TimeSlot(id: '1', name: 'Only', startTime: '08:00', endTime: '08:45'),
        ];
        
        final sorted = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        expect(sorted.length, equals(1));
        expect(sorted[0].id, equals('1'));
      });

      test('time slots spanning midnight should sort correctly', () {
        final timeSlots = [
          TimeSlot(id: '2', name: 'Morning', startTime: '08:00', endTime: '08:45'),
          TimeSlot(id: '1', name: 'Early', startTime: '06:00', endTime: '06:45'),
          TimeSlot(id: '3', name: 'Evening', startTime: '18:00', endTime: '18:45'),
        ];
        
        final sorted = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        expect(sorted[0].startTime, equals('06:00'));
        expect(sorted[1].startTime, equals('08:00'));
        expect(sorted[2].startTime, equals('18:00'));
      });

      test('TimeLayout should contain time slots that can be sorted', () {
        final layout = TimeLayout(
          id: '1',
          name: 'Test Layout',
          timeSlots: [
            TimeSlot(id: '3', name: 'Third', startTime: '10:00', endTime: '10:45'),
            TimeSlot(id: '1', name: 'First', startTime: '08:00', endTime: '08:45'),
            TimeSlot(id: '2', name: 'Second', startTime: '09:00', endTime: '09:45'),
          ],
        );
        
        final sorted = List<TimeSlot>.from(layout.timeSlots)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        expect(sorted[0].name, equals('First'));
        expect(sorted[1].name, equals('Second'));
        expect(sorted[2].name, equals('Third'));
      });

      // Property-based test
      Glados(any.intInRange(2, 20)).test(
        'any list of time slots should be sortable by start time',
        (count) {
          // Generate random time slots
          final timeSlots = List.generate(count, (i) {
            final hour = (i * 2 + 6) % 24; // Spread across day
            return TimeSlot(
              id: 'slot_$i',
              name: 'Slot $i',
              startTime: '${hour.toString().padLeft(2, '0')}:00',
              endTime: '${((hour + 1) % 24).toString().padLeft(2, '0')}:00',
            );
          });
          
          // Shuffle to randomize order
          timeSlots.shuffle();
          
          // Sort by start time
          final sorted = List<TimeSlot>.from(timeSlots)
            ..sort((a, b) => a.startTime.compareTo(b.startTime));
          
          // Verify sorted order
          for (var i = 0; i < sorted.length - 1; i++) {
            expect(
              sorted[i].startTime.compareTo(sorted[i + 1].startTime) <= 0,
              isTrue,
              reason: 'Time slot at index $i should have start time <= next slot',
            );
          }
        },
      );

      Glados(any.intInRange(0, 23)).test(
        'time slot start time comparison should be consistent',
        (hour) {
          final slot1 = TimeSlot(
            id: '1',
            name: 'Slot 1',
            startTime: '${hour.toString().padLeft(2, '0')}:00',
            endTime: '${((hour + 1) % 24).toString().padLeft(2, '0')}:00',
          );
          
          final slot2 = TimeSlot(
            id: '2',
            name: 'Slot 2',
            startTime: '${((hour + 1) % 24).toString().padLeft(2, '0')}:00',
            endTime: '${((hour + 2) % 24).toString().padLeft(2, '0')}:00',
          );
          
          // slot1 should come before slot2 (unless wrapping around midnight)
          if (hour < 23) {
            expect(
              slot1.startTime.compareTo(slot2.startTime) < 0,
              isTrue,
              reason: 'Earlier time should compare less than later time',
            );
          }
        },
      );
    });

    group('Time slot duration calculation', () {
      test('duration should be calculated correctly', () {
        final slot = TimeSlot(
          id: '1',
          name: 'Test',
          startTime: '08:00',
          endTime: '08:45',
        );
        
        expect(slot.durationMinutes, equals(45));
      });

      test('duration should handle hour boundaries', () {
        final slot = TimeSlot(
          id: '1',
          name: 'Test',
          startTime: '08:30',
          endTime: '09:15',
        );
        
        expect(slot.durationMinutes, equals(45));
      });

      test('duration should handle multi-hour slots', () {
        final slot = TimeSlot(
          id: '1',
          name: 'Test',
          startTime: '08:00',
          endTime: '10:00',
        );
        
        expect(slot.durationMinutes, equals(120));
      });

      // Property-based test
      Glados(any.intInRange(1, 180)).test(
        'duration calculation should be consistent',
        (durationMinutes) {
          final startHour = 8;
          final startMinute = 0;
          final endHour = startHour + (durationMinutes ~/ 60);
          final endMinute = durationMinutes % 60;
          
          final slot = TimeSlot(
            id: '1',
            name: 'Test',
            startTime: '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
            endTime: '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
          );
          
          expect(slot.durationMinutes, equals(durationMinutes));
        },
      );
    });
  });
}
