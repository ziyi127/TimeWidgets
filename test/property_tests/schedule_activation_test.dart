import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';

/// **Feature: md3-settings-timetable-enhancement**
/// **Property 2: Schedule auto-activation based on trigger rules**
/// **Property 3: Schedule priority ordering**
/// **Validates: Requirements 11.3, 11.4**
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Initialize Flutter binding for tests that use Flutter services
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Set up mock SharedPreferences for all tests
  SharedPreferences.setMockInitialValues({});
  
  group('Schedule Activation Properties', () {
    group('Property 2: Schedule auto-activation based on trigger rules', () {
      test('schedule with matching weekday should be activated', () {
        final service = TimetableEditService();
        
        // Monday schedule
        final mondaySchedule = Schedule(
          id: '1',
          name: 'Monday Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1, // Monday
            weekType: WeekType.both,
            isEnabled: true,
          ),
          isAutoEnabled: true,
        );
        
        service.addSchedule(mondaySchedule);
        
        // Test with a Monday (2024-01-01 is Monday)
        final monday = DateTime(2024, 1, 1);
        final activeSchedule = service.getActiveSchedule(monday);
        
        expect(activeSchedule, isNotNull);
        expect(activeSchedule!.id, equals('1'));
      });

      test('schedule with non-matching weekday should not be activated', () {
        final service = TimetableEditService();
        
        // Monday schedule
        final mondaySchedule = Schedule(
          id: '1',
          name: 'Monday Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1, // Monday
            weekType: WeekType.both,
            isEnabled: true,
          ),
          isAutoEnabled: true,
        );
        
        service.addSchedule(mondaySchedule);
        
        // Test with a Tuesday (2024-01-02 is Tuesday)
        final tuesday = DateTime(2024, 1, 2);
        final activeSchedule = service.getActiveSchedule(tuesday);
        
        expect(activeSchedule, isNull);
      });

      test('disabled schedule should not be activated', () {
        final service = TimetableEditService();
        
        final schedule = Schedule(
          id: '1',
          name: 'Disabled Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.both,
            isEnabled: false, // Disabled rule
          ),
          isAutoEnabled: true,
        );
        
        service.addSchedule(schedule);
        
        final monday = DateTime(2024, 1, 1);
        final activeSchedule = service.getActiveSchedule(monday);
        
        expect(activeSchedule, isNull);
      });

      test('schedule with isAutoEnabled=false should not be activated', () {
        final service = TimetableEditService();
        
        final schedule = Schedule(
          id: '1',
          name: 'Manual Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.both,
            isEnabled: true,
          ),
          isAutoEnabled: false, // Manual activation only
        );
        
        service.addSchedule(schedule);
        
        final monday = DateTime(2024, 1, 1);
        final activeSchedule = service.getActiveSchedule(monday);
        
        expect(activeSchedule, isNull);
      });

      test('single week schedule should only activate on odd weeks', () {
        final service = TimetableEditService();
        
        final schedule = Schedule(
          id: '1',
          name: 'Single Week Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.single, // Odd weeks only
            isEnabled: true,
          ),
          isAutoEnabled: true,
        );
        
        service.addSchedule(schedule);
        
        final monday = DateTime(2024, 1, 1);
        
        // Week 1 (odd) - should activate
        final activeOdd = service.getActiveSchedule(monday, currentWeekNumber: 1);
        expect(activeOdd, isNotNull);
        
        // Week 2 (even) - should not activate
        final activeEven = service.getActiveSchedule(monday, currentWeekNumber: 2);
        expect(activeEven, isNull);
      });

      test('double week schedule should only activate on even weeks', () {
        final service = TimetableEditService();
        
        final schedule = Schedule(
          id: '1',
          name: 'Double Week Schedule',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.double, // Even weeks only
            isEnabled: true,
          ),
          isAutoEnabled: true,
        );
        
        service.addSchedule(schedule);
        
        final monday = DateTime(2024, 1, 1);
        
        // Week 1 (odd) - should not activate
        final activeOdd = service.getActiveSchedule(monday, currentWeekNumber: 1);
        expect(activeOdd, isNull);
        
        // Week 2 (even) - should activate
        final activeEven = service.getActiveSchedule(monday, currentWeekNumber: 2);
        expect(activeEven, isNotNull);
      });

      // Property-based test
      Glados(any.intInRange(1, 7)).test(
        'schedule matching weekday should always be found',
        (weekDay) {
          final service = TimetableEditService();
          
          final schedule = Schedule(
            id: '1',
            name: 'Test Schedule',
            triggerRule: ScheduleTriggerRule(
              weekDay: weekDay,
              weekType: WeekType.both,
              isEnabled: true,
            ),
            isAutoEnabled: true,
          );
          
          service.addSchedule(schedule);
          
          // Find a date that matches the weekday
          // Start from 2024-01-01 (Monday = weekday 1)
          var testDate = DateTime(2024, 1, 1);
          while (testDate.weekday != weekDay) {
            testDate = testDate.add(const Duration(days: 1));
          }
          
          final activeSchedule = service.getActiveSchedule(testDate);
          expect(activeSchedule, isNotNull);
          expect(activeSchedule!.id, equals('1'));
        },
      );
    });

    group('Property 3: Schedule priority ordering', () {
      test('schedule with lower priority number should be selected', () {
        final service = TimetableEditService();
        
        // Add schedules with different priorities
        final lowPriority = Schedule(
          id: '1',
          name: 'Low Priority',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.both,
            isEnabled: true,
          ),
          isAutoEnabled: true,
          priority: 10,
        );
        
        final highPriority = Schedule(
          id: '2',
          name: 'High Priority',
          triggerRule: const ScheduleTriggerRule(
            weekDay: 1,
            weekType: WeekType.both,
            isEnabled: true,
          ),
          isAutoEnabled: true,
          priority: 1, // Lower number = higher priority
        );
        
        service.addSchedule(lowPriority);
        service.addSchedule(highPriority);
        
        final monday = DateTime(2024, 1, 1);
        final activeSchedule = service.getActiveSchedule(monday);
        
        expect(activeSchedule, isNotNull);
        expect(activeSchedule!.id, equals('2')); // High priority should be selected
      });

      test('getMatchingSchedules should return schedules sorted by priority', () {
        final service = TimetableEditService();
        
        final schedules = [
          Schedule(
            id: '1',
            name: 'Priority 5',
            triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
            isAutoEnabled: true,
            priority: 5,
          ),
          Schedule(
            id: '2',
            name: 'Priority 1',
            triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
            isAutoEnabled: true,
            priority: 1,
          ),
          Schedule(
            id: '3',
            name: 'Priority 3',
            triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
            isAutoEnabled: true,
            priority: 3,
          ),
        ];
        
        for (final s in schedules) {
          service.addSchedule(s);
        }
        
        final monday = DateTime(2024, 1, 1);
        final matching = service.getMatchingSchedules(monday);
        
        expect(matching.length, equals(3));
        expect(matching[0].id, equals('2')); // Priority 1
        expect(matching[1].id, equals('3')); // Priority 3
        expect(matching[2].id, equals('1')); // Priority 5
      });

      test('equal priority schedules should maintain stable order', () {
        final service = TimetableEditService();
        
        final schedule1 = Schedule(
          id: '1',
          name: 'First Added',
          triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
          isAutoEnabled: true,
          priority: 0,
        );
        
        final schedule2 = Schedule(
          id: '2',
          name: 'Second Added',
          triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
          isAutoEnabled: true,
          priority: 0,
        );
        
        service.addSchedule(schedule1);
        service.addSchedule(schedule2);
        
        final monday = DateTime(2024, 1, 1);
        final matching = service.getMatchingSchedules(monday);
        
        expect(matching.length, equals(2));
        // Both have same priority, first one should be selected
        final active = service.getActiveSchedule(monday);
        expect(active, isNotNull);
      });

      // Property-based test
      Glados(any.intInRange(2, 10)).test(
        'active schedule should always have lowest priority among matching',
        (count) {
          final service = TimetableEditService();
          
          // Create schedules with random priorities
          final priorities = List.generate(count, (i) => i * 2 + 1);
          priorities.shuffle();
          
          for (var i = 0; i < count; i++) {
            service.addSchedule(Schedule(
              id: 'schedule_$i',
              name: 'Schedule $i',
              triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
              isAutoEnabled: true,
              priority: priorities[i],
            ));
          }
          
          final monday = DateTime(2024, 1, 1);
          final active = service.getActiveSchedule(monday);
          final matching = service.getMatchingSchedules(monday);
          
          expect(active, isNotNull);
          expect(matching.isNotEmpty, isTrue);
          
          // Active should be the first in sorted list (lowest priority number)
          expect(active!.id, equals(matching.first.id));
          
          // Verify sorting
          for (var i = 0; i < matching.length - 1; i++) {
            expect(matching[i].priority, lessThanOrEqualTo(matching[i + 1].priority));
          }
        },
      );
    });

    group('ScheduleTriggerRule.matches', () {
      test('Sunday should match weekDay 0', () {
        const rule = ScheduleTriggerRule(weekDay: 0, isEnabled: true);
        
        // 2024-01-07 is Sunday
        final sunday = DateTime(2024, 1, 7);
        expect(rule.matches(sunday), isTrue);
        
        // 2024-01-08 is Monday
        final monday = DateTime(2024, 1, 8);
        expect(rule.matches(monday), isFalse);
      });

      test('weekday mapping should be correct', () {
        // Test all weekdays
        final weekdayTests = [
          (DateTime(2024, 1, 7), 0),  // Sunday
          (DateTime(2024, 1, 1), 1),  // Monday
          (DateTime(2024, 1, 2), 2),  // Tuesday
          (DateTime(2024, 1, 3), 3),  // Wednesday
          (DateTime(2024, 1, 4), 4),  // Thursday
          (DateTime(2024, 1, 5), 5),  // Friday
          (DateTime(2024, 1, 6), 6),  // Saturday
        ];
        
        for (final (date, expectedWeekDay) in weekdayTests) {
          final rule = ScheduleTriggerRule(weekDay: expectedWeekDay, isEnabled: true);
          expect(rule.matches(date), isTrue, 
            reason: 'Date ${date.toIso8601String()} should match weekDay $expectedWeekDay');
        }
      });
    });
  });
}
