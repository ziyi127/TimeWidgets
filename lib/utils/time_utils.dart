class TimeUtils {
  /// Parses a time string in "HH:mm" format to a DateTime on the given date.
  static DateTime? parseTime(String timeStr, DateTime date) {
    if (timeStr.isEmpty) {
      return null;
    }
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) {
        return null;
      }

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) {
        return null;
      }

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Parses a time range string "HH:mm~HH:mm"
  static ({DateTime start, DateTime end})? parseTimeRange(
      String timeRange, DateTime date,) {
    if (timeRange.isEmpty) {
      return null;
    }
    try {
      final parts = timeRange.split('~');
      if (parts.length != 2) {
        return null;
      }

      final start = parseTime(parts[0], date);
      final end = parseTime(parts[1], date);

      if (start == null || end == null) {
        return null;
      }

      return (start: start, end: end);
    } catch (e) {
      return null;
    }
  }

  /// Checks if the current time is within the given time range string "HH:mm~HH:mm"
  static bool isCurrentTimeInRange(String timeRange, DateTime now) {
    final range = parseTimeRange(timeRange, now);
    if (range == null) {
      return false;
    }

    // Use strictly before/after for better precision if needed,
    // but typically class starts exactly at start time.
    return now.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
        now.isBefore(range.end.add(const Duration(seconds: 1)));
  }

  /// Checks if the time range has passed
  static bool isTimeRangePassed(String timeRange, DateTime now) {
    final range = parseTimeRange(timeRange, now);
    if (range == null) {
      return false;
    }

    return now.isAfter(range.end);
  }
}
