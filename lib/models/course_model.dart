class Course {
  final String subject;
  final String teacher;
  final String time;
  final String classroom;
  final bool isCurrent;

  const Course({
    required this.subject,
    required this.teacher,
    required this.time,
    required this.classroom,
    this.isCurrent = false,
  });
}

class Timetable {
  final List<Course> courses;
  final DateTime date;

  const Timetable({
    required this.courses,
    required this.date,
  });
}
