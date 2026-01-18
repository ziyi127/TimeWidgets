class Course {

  const Course({
    required this.subject,
    required this.teacher,
    required this.time,
    required this.classroom,
    this.isCurrent = false,
  });
  final String subject;
  final String teacher;
  final String time;
  final String classroom;
  final bool isCurrent;
}

class Timetable {

  const Timetable({
    required this.courses,
    required this.date,
  });
  final List<Course> courses;
  final DateTime date;
}
