import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';

void main() {
  group('JSON Storage Tests', () {
    // late TimetableStorageService storageService; - Removed unused variable
    
    setUp(() {
      // storageService initialized but not used in tests
    });
    
    test('TimetableData JSON serialization and deserialization', () {
      // Create test data
      final timetableData = TimetableData(
        courses: [
          CourseInfo(
            id: '1',
            name: '语文',
            teacher: '张老师',
            classroom: '101',
            color: '#FF0000',
          ),
          CourseInfo(
            id: '2',
            name: '数学',
            teacher: '李老师',
            classroom: '102',
            color: '#00FF00',
          ),
        ],
        timeSlots: [
          TimeSlot(
            id: '1',
            startTime: '08:00',
            endTime: '08:45',
            name: '早读',
          ),
          TimeSlot(
            id: '2',
            startTime: '09:00',
            endTime: '09:45',
            name: '第一节课',
          ),
        ],
        dailyCourses: [
          DailyCourse(
            id: '1',
            dayOfWeek: DayOfWeek.monday,
            timeSlotId: '1',
            courseId: '1',
            weekType: WeekType.both,
          ),
          DailyCourse(
            id: '2',
            dayOfWeek: DayOfWeek.tuesday,
            timeSlotId: '2',
            courseId: '2',
            weekType: WeekType.single,
          ),
        ],
      );
      
      // Serialize to JSON
      final jsonData = timetableData.toJson();
      final jsonString = jsonEncode(jsonData);
      
      // Deserialize from JSON
      final decodedJson = jsonDecode(jsonString);
      final deserializedData = TimetableData.fromJson(decodedJson);
      
      // Verify data integrity
      expect(deserializedData.courses.length, equals(2));
      expect(deserializedData.timeSlots.length, equals(2));
      expect(deserializedData.dailyCourses.length, equals(2));
      
      expect(deserializedData.courses[0].id, equals('1'));
      expect(deserializedData.courses[0].name, equals('语文'));
      expect(deserializedData.courses[0].teacher, equals('张老师'));
      expect(deserializedData.courses[0].classroom, equals('101'));
      expect(deserializedData.courses[0].color, equals('#FF0000'));
      
      expect(deserializedData.timeSlots[0].id, equals('1'));
      expect(deserializedData.timeSlots[0].startTime, equals('08:00'));
      expect(deserializedData.timeSlots[0].endTime, equals('08:45'));
      expect(deserializedData.timeSlots[0].name, equals('早读'));
      
      expect(deserializedData.dailyCourses[0].id, equals('1'));
      expect(deserializedData.dailyCourses[0].dayOfWeek, equals(DayOfWeek.monday));
      expect(deserializedData.dailyCourses[0].timeSlotId, equals('1'));
      expect(deserializedData.dailyCourses[0].courseId, equals('1'));
      expect(deserializedData.dailyCourses[0].weekType, equals(WeekType.both));
    });
  });
}