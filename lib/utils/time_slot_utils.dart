import 'package:time_widgets/models/timetable_edit_model.dart';

class TimeSlotUtils {
  /// 判断给定时间是否在时间段内
  /// [timeSlot] 时间段
  /// [currentTime] 当前时间 (格式: "HH:MM" 或 DateTime)
  static bool isCurrentTimeSlot(TimeSlot timeSlot, DateTime currentTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = _parseTimeToMinutes(timeSlot.startTime);
    final endMinutes = _parseTimeToMinutes(timeSlot.endTime);

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  /// 查找当前时间�?
  /// [timeSlots] 所有时间段
  /// [currentTime] 当前时间
  /// 返回当前时间段的索引，如果没有则返回 -1
  static int findCurrentTimeSlotIndex(List<TimeSlot> timeSlots, DateTime currentTime) {
    for (var i = 0; i < timeSlots.length; i++) {
      if (isCurrentTimeSlot(timeSlots[i], currentTime)) {
        return i;
      }
    }
    return -1;
  }

  /// 获取当前时间段
  /// [timeSlots] 所有时间段
  /// [currentTime] 当前时间
  /// 返回当前时间段，如果没有则返回 null
  static TimeSlot? getCurrentTimeSlot(List<TimeSlot> timeSlots, DateTime currentTime) {
    final index = findCurrentTimeSlotIndex(timeSlots, currentTime);
    return index >= 0 ? timeSlots[index] : null;
  }

  /// 获取下一个时间段
  /// [timeSlots] 所有时间段
  /// [currentTime] 当前时间
  /// 返回下一个时间段，如果没有则返回 null
  static TimeSlot? getNextTimeSlot(List<TimeSlot> timeSlots, DateTime currentTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;

    for (var slot in timeSlots) {
      final startMinutes = _parseTimeToMinutes(slot.startTime);
      if (startMinutes > currentMinutes) {
        return slot;
      }
    }
    return null;
  }

  /// 计算距离下一个时间段的分钟数
  static int? getMinutesUntilNextSlot(List<TimeSlot> timeSlots, DateTime currentTime) {
    final nextSlot = getNextTimeSlot(timeSlots, currentTime);
    if (nextSlot == null) return null;

    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final nextStartMinutes = _parseTimeToMinutes(nextSlot.startTime);
    return nextStartMinutes - currentMinutes;
  }

  /// 计算当前时间段的剩余分钟�?
  static int? getRemainingMinutesInCurrentSlot(List<TimeSlot> timeSlots, DateTime currentTime) {
    final currentSlot = getCurrentTimeSlot(timeSlots, currentTime);
    if (currentSlot == null) return null;

    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final endMinutes = _parseTimeToMinutes(currentSlot.endTime);
    return endMinutes - currentMinutes;
  }

  /// 将时间字符串解析为分钟数
  /// [timeString] 时间字符串，格式: "HH:MM"
  static int _parseTimeToMinutes(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    return hours * 60 + minutes;
  }

  /// 格式化分钟数为时间字符串
  static String formatMinutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  /// 判断时间段是否已�?
  static bool isTimeSlotPassed(TimeSlot timeSlot, DateTime currentTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final endMinutes = _parseTimeToMinutes(timeSlot.endTime);
    return currentMinutes > endMinutes;
  }

  /// 判断时间段是否即将开始（15分钟内）
  static bool isTimeSlotUpcoming(TimeSlot timeSlot, DateTime currentTime, {int withinMinutes = 15}) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = _parseTimeToMinutes(timeSlot.startTime);
    final diff = startMinutes - currentMinutes;
    return diff > 0 && diff <= withinMinutes;
  }
}
