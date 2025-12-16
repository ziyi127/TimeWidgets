import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart' hide group, expect, test;
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';

/// **Feature: md3-settings-timetable-enhancement**
/// **Property 4: Subject deletion prevention when in use**
/// **Validates: Requirements 12.4**
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Initialize Flutter binding for tests that use Flutter services
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Set up mock SharedPreferences for all tests
  SharedPreferences.setMockInitialValues({});
  
  group('Subject Deletion Properties', () {
    group('Property 4: Subject deletion prevention when in use', () {
      test('subject used in daily course should not be deletable', () {
        final service = TimetableEditService();
        
        // Add a subject
        final subject = CourseInfo(
          id: 'subject1',
          name: 'Math',
          teacher: 'Teacher',
        );
        service.addCourse(subject);
        
        // Add a time slot
        final timeSlot = TimeSlot(
          id: 'slot1',
          name: 'Period 1',
          startTime: '08:00',
          endTime: '08:45',
        );
        service.addTimeSlot(timeSlot);
        
        // Add a daily course using this subject
        final dailyCourse = DailyCourse(
          id: 'dc1',
          dayOfWeek: DayOfWeek.monday,
          timeSlotId: 'slot1',
          courseId: 'subject1',
        );
        service.addDailyCourse(dailyCourse);
        
        // Check if subject can be deleted
        expect(service.canDeleteCourse('subject1'), isFalse);
      });

      test('subject used in schedule should not be deletable', () {
        final service = TimetableEditService();
        
        // Add a subject
        final subject = CourseInfo(
          id: 'subject1',
          name: 'Math',
          teacher: 'Teacher',
        );
        service.addCourse(subject);
        
        // Add a schedule with course using this subject
        final schedule = Schedule(
          id: 'schedule1',
          name: 'Monday Schedule',
          triggerRule: const ScheduleTriggerRule(weekDay: 1, isEnabled: true),
          courses: [
            DailyCourse(
              id: 'dc1',
              dayOfWeek: DayOfWeek.monday,
              timeSlotId: 'slot1',
              courseId: 'subject1',
            ),
          ],
        );
        service.addSchedule(schedule);
        
        // Check if subject can be deleted
        expect(service.canDeleteCourse('subject1'), isFalse);
      });

      test('unused subject should be deletable', () {
        final service = TimetableEditService();
        
        // Add a subject
        final subject = CourseInfo(
          id: 'subject1',
          name: 'Math',
          teacher: 'Teacher',
        );
        service.addCourse(subject);
        
        // Check if subject can be deleted (no usages)
        expect(service.canDeleteCourse('subject1'), isTrue);
      });

      test('findSubjectUsages should return all usages', () {
        final service = TimetableEditService();
        
        // Add a subject
        final subject = CourseInfo(
          id: 'subject1',
          name: 'Math',
          teacher: 'Teacher',
        );
        service.addCourse(subject);
        
        // Add time slots
        service.addTimeSlot(TimeSlot(
          id: 'slot1',
          name: 'Period 1',
          startTime: '08:00',
          endTime: '08:45',
        ));
        service.addTimeSlot(TimeSlot(
          id: 'slot2',
          name: 'Period 2',
          startTime: '09:00',
          endTime: '09:45',
        ));
        
        // Add daily courses
        service.addDailyCourse(DailyCourse(
          id: 'dc1',
          dayOfWeek: DayOfWeek.monday,
          timeSlotId: 'slot1',
          courseId: 'subject1',
        ));
        service.addDailyCourse(DailyCourse(
          id: 'dc2',
          dayOfWeek: DayOfWeek.tuesday,
          timeSlotId: 'slot2',
          courseId: 'subject1',
        ));
        
        // Add schedule with course
        service.addSchedule(Schedule(
          id: 'schedule1',
          name: 'Wednesday Schedule',
          triggerRule: const ScheduleTriggerRule(weekDay: 3, isEnabled: true),
          courses: [
            DailyCourse(
              id: 'dc3',
              dayOfWeek: DayOfWeek.wednesday,
              timeSlotId: 'slot1',
              courseId: 'subject1',
            ),
          ],
        ));
        
        // Find usages
        final usages = service.findSubjectUsages('subject1');
        
        expect(usages.length, equals(3));
        expect(usages.where((u) => u.type == SubjectUsageType.dailyCourse).length, equals(2));
        expect(usages.where((u) => u.type == SubjectUsageType.schedule).length, equals(1));
      });

      test('findSubjectUsages should return empty list for unused subject', () {
        final service = TimetableEditService();
        
        final subject = CourseInfo(
          id: 'subject1',
          name: 'Math',
          teacher: 'Teacher',
        );
        service.addCourse(subject);
        
        final usages = service.findSubjectUsages('subject1');
        expect(usages, isEmpty);
      });

      test('findSubjectUsages should return empty list for non-existent subject', () {
        final service = TimetableEditService();
        
        final usages = service.findSubjectUsages('non_existent');
        expect(usages, isEmpty);
      });

      // Property-based test
      Glados(any.intInRange(1, 5)).test(
        'subject with N usages should have N items in findSubjectUsages',
        (usageCount) {
          final service = TimetableEditService();
          
          // Add subject
          final subject = CourseInfo(
            id: 'subject1',
            name: 'Test Subject',
            teacher: 'Teacher',
          );
          service.addCourse(subject);
          
          // Add time slots and daily courses
          for (var i = 0; i < usageCount; i++) {
            service.addTimeSlot(TimeSlot(
              id: 'slot_$i',
              name: 'Period $i',
              startTime: '${8 + i}:00',
              endTime: '${8 + i}:45',
            ));
            
            service.addDailyCourse(DailyCourse(
              id: 'dc_$i',
              dayOfWeek: DayOfWeek.values[i % 7],
              timeSlotId: 'slot_$i',
              courseId: 'subject1',
            ));
          }
          
          final usages = service.findSubjectUsages('subject1');
          expect(usages.length, equals(usageCount));
          expect(service.canDeleteCourse('subject1'), isFalse);
        },
      );

      Glados(any.intInRange(1, 5)).test(
        'subject should become deletable after all usages are removed',
        (usageCount) {
          final service = TimetableEditService();
          
          // Add subject
          final subject = CourseInfo(
            id: 'subject1',
            name: 'Test Subject',
            teacher: 'Teacher',
          );
          service.addCourse(subject);
          
          // Add usages
          for (var i = 0; i < usageCount; i++) {
            service.addTimeSlot(TimeSlot(
              id: 'slot_$i',
              name: 'Period $i',
              startTime: '${8 + i}:00',
              endTime: '${8 + i}:45',
            ));
            
            service.addDailyCourse(DailyCourse(
              id: 'dc_$i',
              dayOfWeek: DayOfWeek.values[i % 7],
              timeSlotId: 'slot_$i',
              courseId: 'subject1',
            ));
          }
          
          // Verify not deletable
          expect(service.canDeleteCourse('subject1'), isFalse);
          
          // Remove all usages
          for (var i = 0; i < usageCount; i++) {
            service.deleteDailyCourse('dc_$i');
          }
          
          // Now should be deletable
          expect(service.canDeleteCourse('subject1'), isTrue);
        },
      );
    });
  });
}
