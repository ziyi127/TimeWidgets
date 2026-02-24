class Course {
  const Course({
    required this.subject,
    required this.teacher,
    required this.time,
    required this.classroom,
    this.isCurrent = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subject: json['subject'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      time: json['time'] as String? ?? '',
      classroom: json['classroom'] as String? ?? '',
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  final String subject;
  final String teacher;
  final String time;
  final String classroom;
  final bool isCurrent;

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'teacher': teacher,
      'time': time,
      'classroom': classroom,
      'isCurrent': isCurrent,
    };
  }

  Course copyWith({
    String? subject,
    String? teacher,
    String? time,
    String? classroom,
    bool? isCurrent,
  }) {
    return Course(
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      time: time ?? this.time,
      classroom: classroom ?? this.classroom,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.subject == subject &&
        other.teacher == teacher &&
        other.time == time &&
        other.classroom == classroom &&
        other.isCurrent == isCurrent;
  }

  @override
  int get hashCode {
    return Object.hash(subject, teacher, time, classroom, isCurrent);
  }

  @override
  String toString() {
    return 'Course(subject: $subject, teacher: $teacher, time: $time, '
        'classroom: $classroom, isCurrent: $isCurrent)';
  }
}

class Timetable {
  const Timetable({
    required this.courses,
    required this.date,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    final coursesList = (json['courses'] as List<dynamic>?)
            ?.map((c) => Course.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];
    return Timetable(
      courses: coursesList,
      date: DateTime.parse(json['date'] as String),
    );
  }

  final List<Course> courses;
  final DateTime date;

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }

  Timetable copyWith({
    List<Course>? courses,
    DateTime? date,
  }) {
    return Timetable(
      courses: courses ?? this.courses,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Timetable(date: $date, courses: ${courses.length} items)';
  }
}
