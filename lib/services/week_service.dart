import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/ntp_service.dart';

class WeekService {
  /// 计算当前是第几周
  /// [semesterStart] 学期开始日期
  /// [currentDate] 当前日期
  /// 返回周数（从1开始）
  int calculateWeekNumber(DateTime semesterStart, DateTime currentDate) {
    // 将日期标准化到当天的开始
    final start =
        DateTime(semesterStart.year, semesterStart.month, semesterStart.day);
    final current =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // 如果当前日期在学期开始之前，返回0
    if (current.isBefore(start)) {
      return 0;
    }

    // 计算天数差
    final daysDifference = current.difference(start).inDays;

    // 计算周数（向上取整，第一天就是第1周）
    return (daysDifference ~/ 7) + 1;
  }

  /// 判断是否为单周
  /// [weekNumber] 周数
  /// 返回 true 表示单周，false 表示双周
  bool isOddWeek(int weekNumber) {
    return weekNumber % 2 == 1;
  }

  /// 获取周类型文本
  String getWeekTypeText(int weekNumber) {
    if (weekNumber <= 0) {
      return '学期未开始';
    }
    return isOddWeek(weekNumber) ? '单周' : '双周';
  }

  /// 根据周类型过滤课程
  /// [courses] 所有课程
  /// [weekNumber] 当前周数
  /// 返回符合当前周类型的课程列表
  List<DailyCourse> filterCoursesByWeekType(
    List<DailyCourse> courses,
    int weekNumber,
  ) {
    if (weekNumber <= 0) {
      return [];
    }

    final isOdd = isOddWeek(weekNumber);

    return courses.where((course) {
      switch (course.weekType) {
        case WeekType.both:
          return true;
        case WeekType.single:
          return isOdd;
        case WeekType.double:
          return !isOdd;
      }
    }).toList();
  }

  /// 获取今天是星期几
  DayOfWeek getTodayDayOfWeek() {
    final weekday = NtpService().now.weekday;
    // DateTime.weekday: 1=Monday, 7=Sunday
    // DayOfWeek: 0=Monday, 6=Sunday
    return DayOfWeek.values[weekday - 1];
  }

  /// 获取指定日期是星期几
  DayOfWeek getDayOfWeek(DateTime date) {
    return DayOfWeek.values[date.weekday - 1];
  }
}
