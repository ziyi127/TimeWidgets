enum WeekType { single, double, both }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

/// 时间点类型 (兼容 ClassIsland TimeType)
enum TimePointType {
  classTime, // 上课 (TimeType == 0)
  breakTime, // 课间休息 (TimeType == 1)
  divider, // 分割线 (TimeType == 2)
}

/// 科目/课程信息 (兼容 ClassIsland Subject)
class CourseInfo {
  // 是否户外课

  const CourseInfo({
    required this.id,
    required this.name,
    this.abbreviation = '',
    required this.teacher,
    this.classroom = '',
    this.color = '#2196F3',
    this.isOutdoor = false,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String? ?? '',
      teacher: json['teacher'] as String,
      classroom: json['classroom'] as String? ?? '',
      color: json['color'] as String? ?? '#2196F3',
      isOutdoor: json['isOutdoor'] as bool? ?? false,
    );
  }
  final String id;
  final String name;
  final String abbreviation; // 简称
  final String teacher;
  final String classroom;
  final String color;
  final bool isOutdoor;

  /// 获取显示名称 (优先使用简称)
  String get displayName => abbreviation.isNotEmpty ? abbreviation : name;

  CourseInfo copyWith({
    String? id,
    String? name,
    String? abbreviation,
    String? teacher,
    String? classroom,
    String? color,
    bool? isOutdoor,
  }) {
    return CourseInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      teacher: teacher ?? this.teacher,
      classroom: classroom ?? this.classroom,
      color: color ?? this.color,
      isOutdoor: isOutdoor ?? this.isOutdoor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'teacher': teacher,
      'classroom': classroom,
      'color': color,
      'isOutdoor': isOutdoor,
    };
  }
}

/// 时间段/时间点 (兼容 ClassIsland TimeLayout)
class TimeSlot {
  // 默认隐藏

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.name,
    this.type = TimePointType.classTime,
    this.defaultSubjectId,
    this.isHiddenByDefault = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? TimePointType.values[json['type'] as int]
          : TimePointType.classTime,
      defaultSubjectId: json['defaultSubjectId'] as String?,
      isHiddenByDefault: json['isHiddenByDefault'] as bool? ?? false,
    );
  }
  final String id;
  final String startTime; // "HH:MM"
  final String endTime; // "HH:MM"
  final String name;
  final TimePointType type; // 时间点类型
  final String? defaultSubjectId; // 默认科目ID
  final bool isHiddenByDefault;

  /// 获取时长 (分钟)
  int get durationMinutes {
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    return endMinutes - startMinutes;
  }

  TimeSlot copyWith({
    String? id,
    String? startTime,
    String? endTime,
    String? name,
    TimePointType? type,
    String? defaultSubjectId,
    bool? isHiddenByDefault,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      name: name ?? this.name,
      type: type ?? this.type,
      defaultSubjectId: defaultSubjectId ?? this.defaultSubjectId,
      isHiddenByDefault: isHiddenByDefault ?? this.isHiddenByDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'name': name,
      'type': type.index,
      'defaultSubjectId': defaultSubjectId,
      'isHiddenByDefault': isHiddenByDefault,
    };
  }
}

/// 日课程安排
class DailyCourse {
  // 是否为换课课程

  const DailyCourse({
    required this.id,
    required this.dayOfWeek,
    required this.timeSlotId,
    required this.courseId,
    this.weekType = WeekType.both,
    this.isChangedClass = false,
  });

  factory DailyCourse.fromJson(Map<String, dynamic> json) {
    return DailyCourse(
      id: json['id'] as String,
      dayOfWeek: DayOfWeek.values[json['dayOfWeek'] as int],
      timeSlotId: json['timeSlotId'] as String,
      courseId: json['courseId'] as String,
      weekType: WeekType.values[json['weekType'] as int? ?? 2],
      isChangedClass: json['isChangedClass'] as bool? ?? false,
    );
  }
  final String id;
  final DayOfWeek dayOfWeek;
  final String timeSlotId;
  final String courseId;
  final WeekType weekType;
  final bool isChangedClass;

  DailyCourse copyWith({
    String? id,
    DayOfWeek? dayOfWeek,
    String? timeSlotId,
    String? courseId,
    WeekType? weekType,
    bool? isChangedClass,
  }) {
    return DailyCourse(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      courseId: courseId ?? this.courseId,
      weekType: weekType ?? this.weekType,
      isChangedClass: isChangedClass ?? this.isChangedClass,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek.index,
      'timeSlotId': timeSlotId,
      'courseId': courseId,
      'weekType': weekType.index,
      'isChangedClass': isChangedClass,
    };
  }
}

/// 触发条件
class TriggerCondition {
  const TriggerCondition({
    required this.id,
    this.dates,
    this.weekDays,
    this.weekNumbers,
    this.startWeek,
    this.endWeek,
  });

  factory TriggerCondition.fromJson(Map<String, dynamic> json) {
    return TriggerCondition(
      id: json['id'] as String? ?? DateTime.now().toIso8601String(),
      dates: (json['dates'] as List?)?.map((e) => DateTime.parse(e as String)).toList(),
      weekDays: (json['weekDays'] as List?)?.map((e) => e as int).toList(),
      weekNumbers: (json['weekNumbers'] as List?)?.map((e) => e as int).toList(),
      startWeek: json['startWeek'] as int?,
      endWeek: json['endWeek'] as int?,
    );
  }

  final String id;
  final List<DateTime>? dates; // 具体日期
  final List<int>? weekDays; // 星期几 (0-6)
  final List<int>? weekNumbers; // 指定周次
  final int? startWeek; // 开始周
  final int? endWeek; // 结束周

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dates': dates?.map((e) => e.toIso8601String()).toList(),
      'weekDays': weekDays,
      'weekNumbers': weekNumbers,
      'startWeek': startWeek,
      'endWeek': endWeek,
    };
  }

  /// 检查是否匹配
  bool matches(DateTime date, {int? currentWeekNumber}) {
    // 1. 检查具体日期
    if (dates != null && dates!.isNotEmpty) {
      // ignore: unused_local_variable
      final dateStr = "${date.year}-${date.month}-${date.day}";
      final matchesDate = dates!.any((d) => 
        d.year == date.year && d.month == date.month && d.day == date.day
      );
      // 如果指定了日期，必须匹配日期 (或者与其他条件是 OR 关系? 用户说是组合条件，通常一个Condition内是AND)
      // 用户需求： "支持组合条件（如：每月的第一个星期一，或第2、4、6周等）"
      // "每月的第一个星期一" -> WeekDay=1 AND DayOfMonth <= 7? 
      // 这里的简单模型可能无法覆盖所有自然语言描述，但 Specific Date, Weekday, Week Number 是基础。
      // 假设 Condition 内字段是 AND 关系。
      if (!matchesDate) return false;
    }

    // 2. 检查星期
    if (weekDays != null && weekDays!.isNotEmpty) {
      final dateWeekDay = date.weekday == 7 ? 0 : date.weekday;
      if (!weekDays!.contains(dateWeekDay)) return false;
    }

    // 3. 检查周次
    if (currentWeekNumber != null) {
      if (weekNumbers != null && weekNumbers!.isNotEmpty) {
        if (!weekNumbers!.contains(currentWeekNumber)) return false;
      }
      if (startWeek != null && currentWeekNumber < startWeek!) return false;
      if (endWeek != null && currentWeekNumber > endWeek!) return false;
    }

    return true;
  }
  
  TriggerCondition copyWith({
    String? id,
    List<DateTime>? dates,
    List<int>? weekDays,
    List<int>? weekNumbers,
    int? startWeek,
    int? endWeek,
  }) {
    return TriggerCondition(
      id: id ?? this.id,
      dates: dates ?? this.dates,
      weekDays: weekDays ?? this.weekDays,
      weekNumbers: weekNumbers ?? this.weekNumbers,
      startWeek: startWeek ?? this.startWeek,
      endWeek: endWeek ?? this.endWeek,
    );
  }
}

/// 课表 (兼容 ClassIsland ClassPlan)
class Schedule {
  const Schedule({
    required this.id,
    required this.name,
    this.timeLayoutId,
    this.groupId,
    this.triggers = const [],
    this.dayTimeLayoutIds = const {},
    this.courses = const [],
    this.isAutoEnabled = true,
    this.priority = 0,
    this.isOverlay = false,
    this.overlaySourceId,
    // Deprecated fields kept for migration if needed, but we will remove them from constructor
    // to force update.
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    // Migration logic for old fields could go here
    var triggers = (json['triggers'] as List?)
            ?.map((t) => TriggerCondition.fromJson(t as Map<String, dynamic>))
            .toList() ?? [];
            
    // Migrate old triggerRule if triggers is empty and triggerRule exists
    if (triggers.isEmpty && json['triggerRule'] != null) {
        // Simple migration logic...
        try {
           final oldRuleMap = json['triggerRule'] as Map<String, dynamic>;
           final weekDay = oldRuleMap['weekDay'] as int?;
           if (weekDay != null) {
             triggers.add(TriggerCondition(
               id: 'migrated_${DateTime.now().millisecondsSinceEpoch}',
               weekDays: [weekDay],
             ));
           }
        } catch (_) {}
    }

    return Schedule(
      id: json['id'] as String,
      name: json['name'] as String,
      timeLayoutId: json['timeLayoutId'] as String?,
      groupId: json['groupId'] as String?,
      triggers: triggers,
      dayTimeLayoutIds: (json['dayTimeLayoutIds'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(int.parse(k), v as String),
      ) ?? {},
      courses: (json['courses'] as List?)
              ?.map((c) => DailyCourse.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      isAutoEnabled: json['isAutoEnabled'] as bool? ?? true,
      priority: json['priority'] as int? ?? 0,
      isOverlay: json['isOverlay'] as bool? ?? false,
      overlaySourceId: json['overlaySourceId'] as String?,
    );
  }
  
  final String id;
  final String name;
  final String? timeLayoutId; // Default fallback layout ID
  final String? groupId; // 所属分组ID
  final List<TriggerCondition> triggers; // 触发条件列表 (OR关系)
  final Map<int, String> dayTimeLayoutIds; // 每天使用的时间表ID (Key: 0-6)
  final List<DailyCourse> courses;
  final bool isAutoEnabled;
  final int priority;
  final bool isOverlay;
  final String? overlaySourceId;

  Schedule copyWith({
    String? id,
    String? name,
    String? timeLayoutId,
    String? groupId,
    List<TriggerCondition>? triggers,
    Map<int, String>? dayTimeLayoutIds,
    List<DailyCourse>? courses,
    bool? isAutoEnabled,
    int? priority,
    bool? isOverlay,
    String? overlaySourceId,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      timeLayoutId: timeLayoutId ?? this.timeLayoutId,
      groupId: groupId ?? this.groupId,
      triggers: triggers ?? this.triggers,
      dayTimeLayoutIds: dayTimeLayoutIds ?? this.dayTimeLayoutIds,
      courses: courses ?? this.courses,
      isAutoEnabled: isAutoEnabled ?? this.isAutoEnabled,
      priority: priority ?? this.priority,
      isOverlay: isOverlay ?? this.isOverlay,
      overlaySourceId: overlaySourceId ?? this.overlaySourceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timeLayoutId': timeLayoutId,
      'groupId': groupId,
      'triggers': triggers.map((t) => t.toJson()).toList(),
      'dayTimeLayoutIds': dayTimeLayoutIds.map((k, v) => MapEntry(k.toString(), v)),
      'courses': courses.map((c) => c.toJson()).toList(),
      'isAutoEnabled': isAutoEnabled,
      'priority': priority,
      'isOverlay': isOverlay,
      'overlaySourceId': overlaySourceId,
    };
  }
}

/// 课表分组
class ScheduleGroup {
  const ScheduleGroup({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory ScheduleGroup.fromJson(Map<String, dynamic> json) {
    return ScheduleGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
    );
  }

  final String id;
  final String name;
  final String? parentId;

  ScheduleGroup copyWith({
    String? id,
    String? name,
    String? parentId,
  }) {
    return ScheduleGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
    };
  }
}

/// 时间表/时间布局 (兼容 ClassIsland TimeLayout)
class TimeLayout {
  const TimeLayout({
    required this.id,
    required this.name,
    this.timeSlots = const [],
  });

  factory TimeLayout.fromJson(Map<String, dynamic> json) {
    return TimeLayout(
      id: json['id'] as String,
      name: json['name'] as String,
      timeSlots: (json['timeSlots'] as List?)
              ?.map((t) => TimeSlot.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  final String id;
  final String name;
  final List<TimeSlot> timeSlots;

  TimeLayout copyWith({
    String? id,
    String? name,
    List<TimeSlot>? timeSlots,
  }) {
    return TimeLayout(
      id: id ?? this.id,
      name: name ?? this.name,
      timeSlots: timeSlots ?? this.timeSlots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timeSlots': timeSlots.map((t) => t.toJson()).toList(),
    };
  }
}

/// 课表数据 (包含所有数据)
class TimetableData {
  // 课表列表

  const TimetableData({
    required this.courses,
    required this.timeSlots,
    required this.dailyCourses,
    this.timeLayouts = const [],
    this.schedules = const [],
    this.groups = const [],
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      courses: (json['courses'] as List?)
              ?.map((c) => CourseInfo.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      timeSlots: (json['timeSlots'] as List?)
              ?.map((t) => TimeSlot.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      dailyCourses: (json['dailyCourses'] as List?)
              ?.map((d) => DailyCourse.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      timeLayouts: (json['timeLayouts'] as List?)
              ?.map((t) => TimeLayout.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      schedules: (json['schedules'] as List?)
              ?.map((s) => Schedule.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      groups: (json['groups'] as List?)
              ?.map((g) => ScheduleGroup.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  final List<CourseInfo> courses; // 科目列表
  final List<TimeSlot> timeSlots; // 时间段列表 (向后兼容)
  final List<DailyCourse> dailyCourses; // 日课程安排 (向后兼容)
  final List<TimeLayout> timeLayouts; // 时间表列表
  final List<Schedule> schedules;
  final List<ScheduleGroup> groups;

  TimetableData copyWith({
    List<CourseInfo>? courses,
    List<TimeSlot>? timeSlots,
    List<DailyCourse>? dailyCourses,
    List<TimeLayout>? timeLayouts,
    List<Schedule>? schedules,
    List<ScheduleGroup>? groups,
  }) {
    return TimetableData(
      courses: courses ?? this.courses,
      timeSlots: timeSlots ?? this.timeSlots,
      dailyCourses: dailyCourses ?? this.dailyCourses,
      timeLayouts: timeLayouts ?? this.timeLayouts,
      schedules: schedules ?? this.schedules,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'timeSlots': timeSlots.map((t) => t.toJson()).toList(),
      'dailyCourses': dailyCourses.map((d) => d.toJson()).toList(),
      'timeLayouts': timeLayouts.map((t) => t.toJson()).toList(),
      'schedules': schedules.map((s) => s.toJson()).toList(),
      'groups': groups.map((g) => g.toJson()).toList(),
    };
  }
}
