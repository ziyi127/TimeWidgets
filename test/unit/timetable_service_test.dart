import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TimetableService Tests', () {
    late TimetableService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = TimetableService();
    });

    test('getTimetable returns empty list when no data is available', () async {
      final date = DateTime(2023, 10, 25); // Wednesday
      final timetable = await service.getTimetable(date);
      
      expect(timetable.courses, isEmpty);
      expect(timetable.date, date);
    });
  });
}
