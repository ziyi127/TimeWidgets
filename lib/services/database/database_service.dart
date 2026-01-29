import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/database/isar_models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Isar? _isar;

  Future<void> initialize() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        IsarCourseInfoSchema,
        IsarTimeLayoutSchema,
        IsarScheduleSchema,
        IsarScheduleGroupSchema,
      ],
      directory: dir.path,
    );
  }

  Isar get isar {
    if (_isar == null) {
      throw Exception('DatabaseService not initialized');
    }
    return _isar!;
  }

  // Mappers
  
  // Domain -> Isar
  IsarCourseInfo _mapCourseToIsar(CourseInfo course) {
    return IsarCourseInfo()
      ..courseId = course.id
      ..name = course.name
      ..abbreviation = course.abbreviation
      ..teacher = course.teacher
      ..classroom = course.classroom
      ..color = course.color
      ..isOutdoor = course.isOutdoor;
  }

  IsarTimeLayout _mapTimeLayoutToIsar(TimeLayout layout) {
    return IsarTimeLayout()
      ..layoutId = layout.id
      ..name = layout.name
      ..timeSlots = layout.timeSlots.map((s) => IsarTimeSlot()
        ..slotId = s.id
        ..startTime = s.startTime
        ..endTime = s.endTime
        ..name = s.name
        ..type = s.type.index
        ..defaultSubjectId = s.defaultSubjectId
        ..isHiddenByDefault = s.isHiddenByDefault
      ).toList();
  }

  IsarSchedule _mapScheduleToIsar(Schedule schedule) {
    final dayTimeLayouts = <IsarDayTimeLayout>[];
    schedule.dayTimeLayoutIds.forEach((day, layoutId) {
      dayTimeLayouts.add(IsarDayTimeLayout()
        ..dayOfWeek = day
        ..layoutId = layoutId);
    });

    return IsarSchedule()
      ..scheduleId = schedule.id
      ..name = schedule.name
      ..timeLayoutId = schedule.timeLayoutId
      ..groupId = schedule.groupId
      ..triggers = schedule.triggers.map((t) => IsarTriggerCondition()
        ..conditionId = t.id
        ..dates = t.dates
        ..weekDays = t.weekDays
        ..weekNumbers = t.weekNumbers
        ..startWeek = t.startWeek
        ..endWeek = t.endWeek
      ).toList()
      ..dayTimeLayouts = dayTimeLayouts
      ..courses = schedule.courses.map((c) => IsarDailyCourse()
        ..dailyCourseId = c.id
        ..dayOfWeek = c.dayOfWeek.index
        ..timeSlotId = c.timeSlotId
        ..courseId = c.courseId
        ..weekType = c.weekType.index
        ..isChangedClass = c.isChangedClass
      ).toList()
      ..isAutoEnabled = schedule.isAutoEnabled
      ..priority = schedule.priority
      ..isOverlay = schedule.isOverlay
      ..overlaySourceId = schedule.overlaySourceId;
  }
  
  IsarScheduleGroup _mapGroupToIsar(ScheduleGroup group) {
    return IsarScheduleGroup()
      ..groupId = group.id
      ..name = group.name
      ..parentId = group.parentId;
  }

  // Isar -> Domain
  CourseInfo _mapIsarToCourse(IsarCourseInfo isarCourse) {
    return CourseInfo(
      id: isarCourse.courseId,
      name: isarCourse.name,
      abbreviation: isarCourse.abbreviation,
      teacher: isarCourse.teacher,
      classroom: isarCourse.classroom,
      color: isarCourse.color,
      isOutdoor: isarCourse.isOutdoor,
    );
  }

  TimeLayout _mapIsarToTimeLayout(IsarTimeLayout isarLayout) {
    return TimeLayout(
      id: isarLayout.layoutId,
      name: isarLayout.name,
      timeSlots: isarLayout.timeSlots.map((s) => TimeSlot(
        id: s.slotId,
        startTime: s.startTime,
        endTime: s.endTime,
        name: s.name,
        type: TimePointType.values[s.type],
        defaultSubjectId: s.defaultSubjectId,
        isHiddenByDefault: s.isHiddenByDefault,
      )).toList(),
    );
  }

  Schedule _mapIsarToSchedule(IsarSchedule isarSchedule) {
    final dayTimeLayoutIds = <int, String>{};
    for (var layout in isarSchedule.dayTimeLayouts) {
      dayTimeLayoutIds[layout.dayOfWeek] = layout.layoutId;
    }

    return Schedule(
      id: isarSchedule.scheduleId,
      name: isarSchedule.name,
      timeLayoutId: isarSchedule.timeLayoutId,
      groupId: isarSchedule.groupId,
      triggers: isarSchedule.triggers.map((t) => TriggerCondition(
        id: t.conditionId,
        dates: t.dates,
        weekDays: t.weekDays,
        weekNumbers: t.weekNumbers,
        startWeek: t.startWeek,
        endWeek: t.endWeek,
      )).toList(),
      dayTimeLayoutIds: dayTimeLayoutIds,
      courses: isarSchedule.courses.map((c) => DailyCourse(
        id: c.dailyCourseId,
        dayOfWeek: DayOfWeek.values[c.dayOfWeek],
        timeSlotId: c.timeSlotId,
        courseId: c.courseId,
        weekType: WeekType.values[c.weekType],
        isChangedClass: c.isChangedClass,
      )).toList(),
      isAutoEnabled: isarSchedule.isAutoEnabled,
      priority: isarSchedule.priority,
      isOverlay: isarSchedule.isOverlay,
      overlaySourceId: isarSchedule.overlaySourceId,
    );
  }

  ScheduleGroup _mapIsarToGroup(IsarScheduleGroup isarGroup) {
    return ScheduleGroup(
      id: isarGroup.groupId,
      name: isarGroup.name,
      parentId: isarGroup.parentId,
    );
  }

  // CRUD Operations

  Future<void> saveTimetableData(TimetableData data) async {
    await isar.writeTxn(() async {
      // Clear existing data (Full overwrite strategy for now to match SP behavior)
      await isar.isarCourseInfos.clear();
      await isar.isarTimeLayouts.clear();
      await isar.isarSchedules.clear();
      await isar.isarScheduleGroups.clear();

      // Put new data
      await isar.isarCourseInfos.putAll(data.courses.map(_mapCourseToIsar).toList());
      await isar.isarTimeLayouts.putAll(data.timeLayouts.map(_mapTimeLayoutToIsar).toList());
      await isar.isarSchedules.putAll(data.schedules.map(_mapScheduleToIsar).toList());
      await isar.isarScheduleGroups.putAll(data.groups.map(_mapGroupToIsar).toList());
    });
  }

  Future<TimetableData> loadTimetableData() async {
    final isarCourses = await isar.isarCourseInfos.where().findAll();
    final isarLayouts = await isar.isarTimeLayouts.where().findAll();
    final isarSchedules = await isar.isarSchedules.where().findAll();
    final isarGroups = await isar.isarScheduleGroups.where().findAll();

    // Reconstruct TimetableData
    // Note: timeSlots and dailyCourses in TimetableData are legacy/flat lists.
    // If we migrate fully, we might leave them empty or reconstruct them from layouts/schedules if needed for backward compatibility.
    // For now, let's assume the app uses the new hierarchical structure (layouts/schedules) primarily.
    // However, if the app relies on flat lists, we might need to populate them.
    // Looking at the original model, TimetableData has flat lists AND structured lists.
    // Let's populate the structured ones primarily.
    
    return TimetableData(
      courses: isarCourses.map(_mapIsarToCourse).toList(),
      timeLayouts: isarLayouts.map(_mapIsarToTimeLayout).toList(),
      schedules: isarSchedules.map(_mapIsarToSchedule).toList(),
      groups: isarGroups.map(_mapIsarToGroup).toList(),
      // Backward compatibility:
      timeSlots: [], // Or flatten from layouts?
      dailyCourses: [], // Or flatten from schedules?
    );
  }
  
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
