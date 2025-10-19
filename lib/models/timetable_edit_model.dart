enum WeekType { single, double, both }

enum DayOfWeek {
  monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

class CourseInfo {
  final String id;
  final String name;
  final String teacher;
  final String classroom;
  final String color;

  CourseInfo({
    required this.id,
    required this.name,
    required this.teacher,
    this.classroom = '',
    this.color = '#2196F3',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'classroom': classroom,
      'color': color,
    };
  }

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'],
      name: json['name'],
      teacher: json['teacher'],
      classroom: json['classroom'] ?? '',
      color: json['color'] ?? '#2196F3',
    );
  }
}

class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final String name;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'name': name,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      name: json['name'],
    );
  }
}

class DailyCourse {
  final String id;
  final DayOfWeek dayOfWeek;
  final String timeSlotId;
  final String courseId;
  final WeekType weekType;

  DailyCourse({
    required this.id,
    required this.dayOfWeek,
    required this.timeSlotId,
    required this.courseId,
    this.weekType = WeekType.both,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek.index,
      'timeSlotId': timeSlotId,
      'courseId': courseId,
      'weekType': weekType.index,
    };
  }

  factory DailyCourse.fromJson(Map<String, dynamic> json) {
    return DailyCourse(
      id: json['id'],
      dayOfWeek: DayOfWeek.values[json['dayOfWeek']],
      timeSlotId: json['timeSlotId'],
      courseId: json['courseId'],
      weekType: WeekType.values[json['weekType'] ?? 2],
    );
  }
}

class TimetableData {
  final List<CourseInfo> courses;
  final List<TimeSlot> timeSlots;
  final List<DailyCourse> dailyCourses;

  TimetableData({
    required this.courses,
    required this.timeSlots,
    required this.dailyCourses,
  });

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'timeSlots': timeSlots.map((t) => t.toJson()).toList(),
      'dailyCourses': dailyCourses.map((d) => d.toJson()).toList(),
    };
  }

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      courses: (json['courses'] as List)
          .map((c) => CourseInfo.fromJson(c))
          .toList(),
      timeSlots: (json['timeSlots'] as List)
          .map((t) => TimeSlot.fromJson(t))
          .toList(),
      dailyCourses: (json['dailyCourses'] as List)
          .map((d) => DailyCourse.fromJson(d))
          .toList(),
    );
  }
}