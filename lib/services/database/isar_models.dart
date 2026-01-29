import 'package:isar/isar.dart';

part 'isar_models.g.dart';

@collection
class IsarCourseInfo {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String courseId;

  late String name;
  late String abbreviation;
  late String teacher;
  late String classroom;
  late String color;
  late bool isOutdoor;
}

@collection
class IsarTimeLayout {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String layoutId;

  late String name;
  
  List<IsarTimeSlot> timeSlots = [];
}

@embedded
class IsarTimeSlot {
  late String slotId;
  late String startTime;
  late String endTime;
  late String name;
  
  @enumerated
  late int type; // 0: classTime, 1: breakTime, 2: divider
  
  String? defaultSubjectId;
  late bool isHiddenByDefault;
}

@collection
class IsarSchedule {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String scheduleId;

  late String name;
  String? timeLayoutId;
  String? groupId;
  
  List<IsarTriggerCondition> triggers = [];
  
  // Map<int, String> stored as List of entries because Isar doesn't support Maps
  List<IsarDayTimeLayout> dayTimeLayouts = [];
  
  List<IsarDailyCourse> courses = [];
  
  late bool isAutoEnabled;
  late int priority;
  late bool isOverlay;
  String? overlaySourceId;
}

@collection
class IsarScheduleGroup {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String groupId;

  late String name;
  String? parentId;
}

@embedded
class IsarTriggerCondition {
  late String conditionId;
  List<DateTime>? dates;
  List<int>? weekDays;
  List<int>? weekNumbers;
  int? startWeek;
  int? endWeek;
}

@embedded
class IsarDayTimeLayout {
  late int dayOfWeek;
  late String layoutId;
}

@embedded
class IsarDailyCourse {
  late String courseId; // Just keep ID for now to avoid complexity of Links in Embedded
  late String dailyCourseId;
  
  @enumerated
  late int dayOfWeek; // 0-6 or Enum index
  
  late String timeSlotId;
  
  @enumerated
  late int weekType; // 0: single, 1: double, 2: both
  
  late bool isChangedClass;
}
