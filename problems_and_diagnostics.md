# Problems and Diagnostics in TimetableService

## Overview
This report identifies and analyzes issues in the `TimetableService` class and related components.

## Problems Found

### 1. DayOfWeek Enum Mismatch
**Location:** `timetable_service.dart:21`
**Issue:** Incorrect mapping between `DateTime.weekday` and the `DayOfWeek` enum.
**Details:**
- `DateTime.weekday` returns 1-7 (1=Monday, 7=Sunday)
- `DayOfWeek` enum in `timetable_edit_model.dart` has `monday` as index 0
- Current mapping: `date.weekday == 7 ? 0 : date.weekday` maps:
  - DateTime.Monday (1) → 1 (should be 0 for DayOfWeek.monday)
  - DateTime.Sunday (7) → 0 (correct for DayOfWeek.sunday)
**Impact:** Courses will be displayed for the wrong day.

### 2. WeekType Handling Missing
**Location:** `timetable_service.dart:28-30`
**Issue:** The code ignores the `weekType` field when filtering courses.
**Details:**
- `DailyCourse` has a `weekType` field (single, double, or both)
- The current implementation filters courses only by `dayOfWeek`
- No check if the current week matches the course's week type
**Impact:** Courses scheduled for specific week types (single/double) will always be displayed.

### 3. Incorrect NtpService Usage
**Location:** `timetable_service.dart:49`
**Issue:** Creating new instance instead of using the singleton properly.
**Details:**
- `NtpService` is designed as a singleton with lazy initialization
- Current code: `final now = NtpService().now` creates a new instance but doesn't call `initialize()`
- The `NtpService` needs to be initialized to sync time properly
**Impact:** NTP time correction won't work unless the service has been initialized elsewhere.

### 4. Course Sorting Issue
**Location:** `timetable_service.dart:75`
**Issue:** Sorting courses by string comparison instead of actual time values.
**Details:**
- Courses are sorted using `a.time.compareTo(b.time)` where `time` is a string like "08:00~08:45"
- String comparison works for this format but is less reliable than comparing actual time values
**Impact:** Potential sorting issues if time formats are inconsistent.

### 5. Schedule and TimeLayout Support Missing
**Location:** `timetable_service.dart:14-97`
**Issue:** The code ignores the new `schedules` and `timeLayouts` fields.
**Details:**
- `TimetableData` contains modern scheduling features with `schedules` and `timeLayouts`
- The current implementation only uses the deprecated `dailyCourses` and `timeSlots`
- No support for multiple schedules or time layouts
**Impact:** Limited functionality compared to what the data model supports.

### 6. API Service Fallback Issues
**Location:** `timetable_service.dart:78-86`
**Issue:** Inefficient error handling for API fallback.
**Details:**
- If local data is empty, it attempts to call the API which always throws an exception
- The catch block returns an empty timetable, which is redundant since we already checked for empty courses
**Impact:** Unnecessary exception handling and potential performance impact.

## Code Quality Recommendations

### 1. Improve Error Handling
- Add more descriptive error messages
- Consider using a logging framework consistently
- Avoid silent failures where possible

### 2. Add Type Safety
- Consider adding more type checks and assertions
- Use non-nullable types consistently

### 3. Implement Proper Initialization
- Ensure services are properly initialized before use
- Consider adding initialization checks

### 4. Refactor for Maintainability
- Break down large methods into smaller, focused functions
- Add comments to explain complex logic
- Follow consistent naming conventions

### 5. Add Unit Tests
- Test edge cases (e.g., different weekdays, week types)
- Test error handling scenarios
- Test sorting and filtering logic

## Solution Approach

1. **Fix DayOfWeek Mapping**:
   ```dart
   // Correct mapping: DateTime.Monday (1) → DayOfWeek.monday (0)
   final weekday = date.weekday == 7 ? 0 : date.weekday - 1;
   ```

2. **Implement WeekType Checking**:
   ```dart
   // Add week number calculation and week type check
   bool matchesWeekType = false;
   final weekNumber = _calculateWeekNumber(date); // Implement this function
   
   switch (daily.weekType) {
     case WeekType.both:
       matchesWeekType = true;
       break;
     case WeekType.single:
       matchesWeekType = weekNumber % 2 == 1;
       break;
     case WeekType.double:
       matchesWeekType = weekNumber % 2 == 0;
       break;
   }
   
   if (!matchesWeekType) continue;
   ```

3. **Fix NtpService Usage**:
   ```dart
   // Ensure NtpService is properly initialized
   // In app initialization:
   await NtpService().initialize();
   
   // Then use it:
   final now = NtpService().now;
   ```

4. **Improve Course Sorting**:
   ```dart
   courses.sort((a, b) {
     final aStart = a.time.split('~')[0];
     final bStart = b.time.split('~')[0];
     return aStart.compareTo(bStart);
   });
   ```

5. **Add Schedule and TimeLayout Support**:
   ```dart
   // Implement logic to check active schedules based on trigger rules
   // Use time layouts to get time slots
   ```

6. **Optimize API Fallback**:
   ```dart
   // Remove redundant API call since it always throws
   if (courses.isEmpty) {
     return Timetable(date: date, courses: []);
   }
   ```

## Conclusion
The `TimetableService` has several issues that need to be addressed to ensure correct functionality. The most critical issues are the DayOfWeek mapping and WeekType handling, which directly affect the accuracy of course display. Implementing the recommended solutions will improve the reliability, maintainability, and functionality of the timetable service.