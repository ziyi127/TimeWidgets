enum WeekType { single, double, both }

enum DayOfWeek {
  monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

/// 时间点类型 (兼容 ClassIsland TimeType)
enum TimePointType {
  classTime,    // 上课 (TimeType == 0)
  breakTime,    // 课间休息 (TimeType == 1)
  divider,      // 分割线 (TimeType == 2)
}

/// 科目/课程信息 (兼容 ClassIsland Subject)
class CourseInfo {
  final String id;
  final String name;
  final String abbreviation;  // 简称
  final String teacher;
  final String classroom;
  final String color;
  final bool isOutdoor;  // 是否户外课

  const CourseInfo({
    required this.id,
    required this.name,
    this.abbreviation = '',
    required this.teacher,
    this.classroom = '',
    this.color = '#2196F3',
    this.isOutdoor = false,
  });

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

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'] ?? '',
      teacher: json['teacher'],
      classroom: json['classroom'] ?? '',
      color: json['color'] ?? '#2196F3',
      isOutdoor: json['isOutdoor'] ?? false,
    );
  }
}


/// 时间段/时间点 (兼容 ClassIsland TimeLayout)
class TimeSlot {
  final String id;
  final String startTime;  // "HH:MM"
  final String endTime;    // "HH:MM"
  final String name;
  final TimePointType type;  // 时间点类型
  final String? defaultSubjectId;  // 默认科目ID
  final bool isHiddenByDefault;  // 默认隐藏

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.name,
    this.type = TimePointType.classTime,
    this.defaultSubjectId,
    this.isHiddenByDefault = false,
  });

  /// 获取时长 (分钟)
  int get durationMinutes {
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
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

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      name: json['name'],
      type: json['type'] != null 
          ? TimePointType.values[json['type']] 
          : TimePointType.classTime,
      defaultSubjectId: json['defaultSubjectId'],
      isHiddenByDefault: json['isHiddenByDefault'] ?? false,
    );
  }
}

/// 日课程安排
class DailyCourse {
  final String id;
  final DayOfWeek dayOfWeek;
  final String timeSlotId;
  final String courseId;
  final WeekType weekType;
  final bool isChangedClass;  // 是否为换课课程

  const DailyCourse({
    required this.id,
    required this.dayOfWeek,
    required this.timeSlotId,
    required this.courseId,
    this.weekType = WeekType.both,
    this.isChangedClass = false,
  });

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

  factory DailyCourse.fromJson(Map<String, dynamic> json) {
    return DailyCourse(
      id: json['id'],
      dayOfWeek: DayOfWeek.values[json['dayOfWeek']],
      timeSlotId: json['timeSlotId'],
      courseId: json['courseId'],
      weekType: WeekType.values[json['weekType'] ?? 2],
      isChangedClass: json['isChangedClass'] ?? false,
    );
  }
}


/// 课表触发规则 (兼容 ClassIsland TimeRule)
class ScheduleTriggerRule {
  final int weekDay;  // 0-6, 0=周日
  final WeekType weekType;
  final bool isEnabled;

  const ScheduleTriggerRule({
    required this.weekDay,
    this.weekType = WeekType.both,
    this.isEnabled = true,
  });

  /// 检查是否匹配指定日期
  bool matches(DateTime date, {int? currentWeekNumber}) {
    if (!isEnabled) return false;
    
    // 检查星期几 (DateTime: 1=周一...7=周日, 我们: 0=周日, 1=周一...)
    final dateWeekDay = date.weekday == 7 ? 0 : date.weekday;
    if (dateWeekDay != weekDay) return false;
    
    // 检查周类型
    if (weekType == WeekType.both) return true;
    
    // 计算周数 (如果未提供)
    final weekNum = currentWeekNumber ?? _calculateWeekNumber(date);
    
    final isOddWeek = weekNum % 2 == 1;
    if (weekType == WeekType.single && isOddWeek) return true;
    if (weekType == WeekType.double && !isOddWeek) return true;
    
    return false;
  }
  
  /// 计算周数 (1-based)
  int _calculateWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final firstMonday = firstDayOfYear.weekday > DateTime.monday 
        ? firstDayOfYear.add(Duration(days: 8 - firstDayOfYear.weekday))
        : firstDayOfYear;
    
    if (date.isBefore(firstMonday)) {
      return _calculateWeekNumber(date.subtract(Duration(days: 7)));
    }
    
    return ((date.difference(firstMonday).inDays / 7).floor()) + 1;
  }

  ScheduleTriggerRule copyWith({
    int? weekDay,
    WeekType? weekType,
    bool? isEnabled,
  }) {
    return ScheduleTriggerRule(
      weekDay: weekDay ?? this.weekDay,
      weekType: weekType ?? this.weekType,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekDay': weekDay,
      'weekType': weekType.index,
      'isEnabled': isEnabled,
    };
  }

  factory ScheduleTriggerRule.fromJson(Map<String, dynamic> json) {
    return ScheduleTriggerRule(
      weekDay: json['weekDay'],
      weekType: WeekType.values[json['weekType'] ?? 2],
      isEnabled: json['isEnabled'] ?? true,
    );
  }
}

/// 课表 (兼容 ClassIsland ClassPlan)
class Schedule {
  final String id;
  final String name;
  final String? timeLayoutId;  // 关联的时间表ID
  final ScheduleTriggerRule triggerRule;
  final List<DailyCourse> courses;
  final bool isAutoEnabled;
  final int priority;  // 优先级 (数字越小优先级越高)
  final bool isOverlay;  // 是否为临时层课表
  final String? overlaySourceId;  // 临时层来源课表ID

  const Schedule({
    required this.id,
    required this.name,
    this.timeLayoutId,
    required this.triggerRule,
    this.courses = const [],
    this.isAutoEnabled = true,
    this.priority = 0,
    this.isOverlay = false,
    this.overlaySourceId,
  });

  Schedule copyWith({
    String? id,
    String? name,
    String? timeLayoutId,
    ScheduleTriggerRule? triggerRule,
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
      triggerRule: triggerRule ?? this.triggerRule,
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
      'triggerRule': triggerRule.toJson(),
      'courses': courses.map((c) => c.toJson()).toList(),
      'isAutoEnabled': isAutoEnabled,
      'priority': priority,
      'isOverlay': isOverlay,
      'overlaySourceId': overlaySourceId,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      name: json['name'],
      timeLayoutId: json['timeLayoutId'],
      triggerRule: ScheduleTriggerRule.fromJson(json['triggerRule']),
      courses: (json['courses'] as List?)
          ?.map((c) => DailyCourse.fromJson(c))
          .toList() ?? [],
      isAutoEnabled: json['isAutoEnabled'] ?? true,
      priority: json['priority'] ?? 0,
      isOverlay: json['isOverlay'] ?? false,
      overlaySourceId: json['overlaySourceId'],
    );
  }
}


/// 时间表/时间布局 (兼容 ClassIsland TimeLayout)
class TimeLayout {
  final String id;
  final String name;
  final List<TimeSlot> timeSlots;

  const TimeLayout({
    required this.id,
    required this.name,
    this.timeSlots = const [],
  });

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

  factory TimeLayout.fromJson(Map<String, dynamic> json) {
    return TimeLayout(
      id: json['id'],
      name: json['name'],
      timeSlots: (json['timeSlots'] as List?)
          ?.map((t) => TimeSlot.fromJson(t))
          .toList() ?? [],
    );
  }
}

/// 课表数据 (包含所有数据)
class TimetableData {
  final List<CourseInfo> courses;  // 科目列表
  final List<TimeSlot> timeSlots;  // 时间段列表 (向后兼容)
  final List<DailyCourse> dailyCourses;  // 日课程安排 (向后兼容)
  final List<TimeLayout> timeLayouts;  // 时间表列表
  final List<Schedule> schedules;  // 课表列表

  const TimetableData({
    required this.courses,
    required this.timeSlots,
    required this.dailyCourses,
    this.timeLayouts = const [],
    this.schedules = const [],
  });

  TimetableData copyWith({
    List<CourseInfo>? courses,
    List<TimeSlot>? timeSlots,
    List<DailyCourse>? dailyCourses,
    List<TimeLayout>? timeLayouts,
    List<Schedule>? schedules,
  }) {
    return TimetableData(
      courses: courses ?? this.courses,
      timeSlots: timeSlots ?? this.timeSlots,
      dailyCourses: dailyCourses ?? this.dailyCourses,
      timeLayouts: timeLayouts ?? this.timeLayouts,
      schedules: schedules ?? this.schedules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'timeSlots': timeSlots.map((t) => t.toJson()).toList(),
      'dailyCourses': dailyCourses.map((d) => d.toJson()).toList(),
      'timeLayouts': timeLayouts.map((t) => t.toJson()).toList(),
      'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      courses: (json['courses'] as List?)
          ?.map((c) => CourseInfo.fromJson(c))
          .toList() ?? [],
      timeSlots: (json['timeSlots'] as List?)
          ?.map((t) => TimeSlot.fromJson(t))
          .toList() ?? [],
      dailyCourses: (json['dailyCourses'] as List?)
          ?.map((d) => DailyCourse.fromJson(d))
          .toList() ?? [],
      timeLayouts: (json['timeLayouts'] as List?)
          ?.map((t) => TimeLayout.fromJson(t))
          .toList() ?? [],
      schedules: (json['schedules'] as List?)
          ?.map((s) => Schedule.fromJson(s))
          .toList() ?? [],
    );
  }
}
