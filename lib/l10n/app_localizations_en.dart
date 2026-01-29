// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Timetable';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherLoading => 'Loading weather...';

  @override
  String get weatherLoadFailed => 'Failed to load weather';

  @override
  String get weatherUnknown => 'Unknown';

  @override
  String get countdownTitle => 'Countdown';

  @override
  String get countdownEmpty => 'No Countdowns';

  @override
  String get countdownAddHint => 'Click to add important events';

  @override
  String get countdownLoadFailed => 'Failed to load countdowns';

  @override
  String get deleteSuccess => 'Deleted';

  @override
  String get undo => 'Undo';

  @override
  String get days => 'days';

  @override
  String get eventExam => 'Exam';

  @override
  String get eventAssignment => 'Assignment';

  @override
  String get eventProject => 'Project';

  @override
  String get eventHoliday => 'Holiday';

  @override
  String get eventDefault => 'Event';

  @override
  String get desktopWidgetDisabled => 'Desktop Widgets Disabled';

  @override
  String get desktopWidgetDisabledHint =>
      'Enable in settings or right-click tray icon';

  @override
  String get currentClassTitle => 'Current Class';

  @override
  String get currentClassEmpty => 'No Class Now';

  @override
  String get currentClassNext => 'Next';

  @override
  String get currentClassLocation => 'Location';

  @override
  String get currentClassTime => 'Time';

  @override
  String get currentClassTeacher => 'Teacher';

  @override
  String get currentClassLoading => 'Loading classes...';

  @override
  String get currentClassLoadFailed => 'Failed to load classes';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsResetTitle => 'Reset Settings';

  @override
  String get settingsResetMessage =>
      'Are you sure you want to reset all settings to default? This action cannot be undone.';

  @override
  String get settingsResetConfirm => 'Reset';

  @override
  String get settingsResetSuccess => 'Settings reset';

  @override
  String get resetToDefault => 'Reset to default';

  @override
  String get select => 'Select';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get change => 'Change';

  @override
  String get notSet => 'Not set';

  @override
  String get keepUnchanged => 'Keep Unchanged';

  @override
  String get generalSettings => 'General';

  @override
  String get language => 'Language';

  @override
  String get languageZh => 'Simplified Chinese';

  @override
  String get languageEn => 'English';

  @override
  String get appearanceSettings => 'Appearance';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get dynamicColor => 'Dynamic Color';

  @override
  String get dynamicColorSubtitle => 'Use Material You dynamic coloring';

  @override
  String get followSystemColor => 'Follow System Color';

  @override
  String get followSystemColorSubtitle => 'Use system accent color';

  @override
  String get seedColor => 'Seed Color';

  @override
  String get seedColorSubtitle => 'Customize app theme color';

  @override
  String get selectSeedColor => 'Select Seed Color';

  @override
  String get fontSize => 'Font Size';

  @override
  String get borderRadius => 'Border Radius';

  @override
  String get componentOpacity => 'Component Opacity';

  @override
  String get shadowStrength => 'Shadow Strength';

  @override
  String get enableGradients => 'Enable Gradients';

  @override
  String get enableGradientsSubtitle =>
      'Add gradient effects to buttons and cards';

  @override
  String get uiScale => 'UI Scale';

  @override
  String get widgetDisplaySettings => 'Widget Display';

  @override
  String get timeDisplay => 'Time Display';

  @override
  String get timeDisplaySubtitle => 'Show time on home screen';

  @override
  String get dateDisplay => 'Date Display';

  @override
  String get dateDisplaySubtitle => 'Show date on home screen';

  @override
  String get weekDisplay => 'Week Display';

  @override
  String get weekDisplaySubtitle => 'Show current week number on home screen';

  @override
  String get weatherDisplay => 'Weather Display';

  @override
  String get weatherDisplaySubtitle => 'Show weather info on home screen';

  @override
  String get weatherLocation => 'Weather Location';

  @override
  String get countdownDisplay => 'Countdown Display';

  @override
  String get countdownDisplaySubtitle => 'Show countdown on home screen';

  @override
  String get currentClassDisplay => 'Current Class Display';

  @override
  String get currentClassDisplaySubtitle => 'Show current class on home screen';

  @override
  String get desktopWidgets => 'Desktop Widgets';

  @override
  String get enableDesktopWidgets => 'Enable Desktop Widgets';

  @override
  String get enableDesktopWidgetsSubtitle => 'Show widgets on desktop';

  @override
  String get semesterSettings => 'Semester';

  @override
  String get semesterStartDate => 'Semester Start Date';

  @override
  String get refreshSettings => 'Refresh Interval';

  @override
  String get weatherRefreshInterval => 'Weather Refresh Interval';

  @override
  String get countdownRefreshInterval => 'Countdown Refresh Interval';

  @override
  String get timeSyncSettings => 'Time Sync';

  @override
  String get autoNtpSync => 'Auto NTP Sync';

  @override
  String get autoNtpSyncSubtitle =>
      'Automatically calibrate system time when enabled';

  @override
  String get ntpServer => 'NTP Server';

  @override
  String get modifyNtpServer => 'Modify NTP Server';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get syncInterval => 'Sync Interval';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get timeOffset => 'Time Offset';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get notificationSettings => 'Notification';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsSubtitle =>
      'Receive course and countdown reminders';

  @override
  String get courseReminder => 'Course Reminder';

  @override
  String get courseReminderSubtitle =>
      'Remind before class starts when enabled';

  @override
  String get voiceReminder => 'Voice Reminder';

  @override
  String get voiceReminderSubtitle =>
      'Use system TTS for course reminders when enabled';

  @override
  String get classStartNotification => 'Class Start Notification';

  @override
  String get classStartNotificationSubtitle =>
      'Send notification when class starts';

  @override
  String get classEndNotification => 'Class End Notification';

  @override
  String get classEndNotificationSubtitle =>
      'Send notification when class ends';

  @override
  String get countdownNotification => 'Countdown Notification';

  @override
  String get countdownNotificationSubtitle =>
      'Send notification when countdown ends';

  @override
  String get startupSettings => 'Startup';

  @override
  String get startWithWindows => 'Start with Windows';

  @override
  String get startWithWindowsSubtitle =>
      'Automatically run app on system startup';

  @override
  String get minimizeToTray => 'Minimize to Tray';

  @override
  String get minimizeToTraySubtitle =>
      'Minimize to system tray when closing window';

  @override
  String get advancedSettings => 'Advanced';

  @override
  String get debugMode => 'Debug Mode';

  @override
  String get debugModeSubtitle => 'Show debug info and logs';

  @override
  String get performanceMonitoring => 'Performance Monitoring';

  @override
  String get performanceMonitoringSubtitle => 'Monitor app performance metrics';

  @override
  String get apiBaseUrl => 'API Base URL';

  @override
  String get modifyApiBaseUrl => 'Modify API Base URL';

  @override
  String get apiUrl => 'API URL';

  @override
  String get interconnectionSettings => 'Device Interconnection';

  @override
  String get experimental => 'Experimental';

  @override
  String get interconnectionSubtitle =>
      'Connect other devices to sync timetable and settings';

  @override
  String get securityWarning => 'Security Warning';

  @override
  String get securityWarningMessage =>
      'The device interconnection feature uses unencrypted LAN broadcast and transmission protocols.\n\nOnce enabled, your device name, IP address, and synced timetable data may be accessed by other users on the LAN.\n\nPlease ensure you only use this feature in a trusted network environment (e.g., home WiFi). Continue?';

  @override
  String get securityWarningConfirm => 'I understand, continue';

  @override
  String get aboutSettings => 'About';

  @override
  String get aboutApp => 'About App';

  @override
  String get aboutAppSubtitle => 'View app version, developer info, etc.';

  @override
  String get minutes => 'minutes';

  @override
  String get seconds => 'seconds';

  @override
  String get ntpServerHint => 'e.g., pool.ntp.org';

  @override
  String get apiUrlHint => 'e.g., http://localhost:3000/api';

  @override
  String get timetableEditTitle => 'Edit Timetable';

  @override
  String get tabSchedule => 'Schedule';

  @override
  String get tabTimeLayout => 'Time Layout';

  @override
  String get tabSubjects => 'Subjects';

  @override
  String get saveTimetable => 'Save Timetable';

  @override
  String get timetableSaved => 'Timetable saved';

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String courseListTitle(int count) {
    return 'Courses ($count)';
  }

  @override
  String get addCourse => 'Add Course';

  @override
  String get editCourse => 'Edit Course';

  @override
  String get noCourses => 'No courses, please add one';

  @override
  String get courseName => 'Course Name';

  @override
  String get pleaseEnterCourseName => 'Please enter course name';

  @override
  String get teacherName => 'Teacher';

  @override
  String get pleaseEnterTeacherName => 'Please enter teacher name';

  @override
  String get classroom => 'Classroom';

  @override
  String get pleaseEnterClassroom => 'Please enter classroom location';

  @override
  String deleteCourseConfirm(String courseName) {
    return 'Delete course \"$courseName\"?';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String teacherPrefix(String name) {
    return 'Teacher: $name';
  }

  @override
  String classroomPrefix(String name) {
    return 'Classroom: $name';
  }

  @override
  String importSuccess(String stats) {
    return 'Imported: $stats';
  }

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get exportSuccess => 'Timetable exported';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get createTimetable => 'Create Timetable';

  @override
  String get selectOrCreateTimetable => 'Select or create a timetable to edit';

  @override
  String get timetableSettings => 'Timetable Settings';

  @override
  String get quickSchedule => 'Quick Schedule';

  @override
  String get deleteTimetable => 'Delete Timetable';

  @override
  String get timetableName => 'Timetable Name';

  @override
  String get copyScheduleTo => 'Copy schedule to...';

  @override
  String copyTo(String day) {
    return 'Copy to $day';
  }

  @override
  String scheduleCopied(String day) {
    return 'Copied schedule to $day';
  }

  @override
  String get noCourse => 'No Course';

  @override
  String get clearCourse => 'Clear Course';

  @override
  String editCourseInfo(String courseName) {
    return 'Edit \"$courseName\"';
  }

  @override
  String get removeFromSlot => 'Remove from slot';

  @override
  String get createGroup => 'Create Group';

  @override
  String get groupName => 'Group Name';

  @override
  String get enterQuickEditMode => 'Entered Quick Edit Mode';

  @override
  String quickEditDoneNextDay(String day) {
    return 'Finished $day, switching to next day';
  }

  @override
  String get quickEditAllDone => 'Weekly schedule finished!';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get defaultTimeLayout => 'Default Layout';

  @override
  String get customTimeLayouts => 'Custom Layouts';

  @override
  String get noCustomLayouts => 'No custom layouts';

  @override
  String get addTimeLayout => 'Add Layout';

  @override
  String get timeLayoutName => 'Layout Name';

  @override
  String get addTimeSlot => 'Add Time Slot';

  @override
  String get editTimeSlot => 'Edit Time Slot';

  @override
  String get noTimeSlots => 'No time slots';

  @override
  String get addTimeSlotHint => 'Add time slots to define schedule';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get timePointType => 'Type';

  @override
  String get typeClass => 'Class';

  @override
  String get typeBreak => 'Break';

  @override
  String get typeDivider => 'Divider';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get exampleTimeLayoutName => 'e.g., Weekend Layout';

  @override
  String get exampleScheduleName => 'e.g., Summer Schedule';

  @override
  String get exampleTimeSlotName => 'e.g., 1st Period';

  @override
  String get name => 'Name';

  @override
  String get create => 'Create';

  @override
  String get exampleGroupName => 'e.g., Semester 1';

  @override
  String timePointsCount(int count) {
    return '$count time points';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get addFirstCountdown =>
      'Click the button below to add your first countdown';

  @override
  String deleteCountdownConfirm(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get editCountdown => 'Edit Countdown';

  @override
  String get addCountdown => 'Add Countdown';

  @override
  String get title => 'Title';

  @override
  String get enterTitle => 'Enter countdown title';

  @override
  String get pleaseEnterTitle => 'Please enter title';

  @override
  String get description => 'Description';

  @override
  String get optionalDescription => '(Optional) Enter description';

  @override
  String get targetDate => 'Target Date';

  @override
  String get category => 'Category';

  @override
  String get noCategory => 'No Category';

  @override
  String get type => 'Type';

  @override
  String get appName => 'Time Widgets';

  @override
  String get developerInfo => 'Developer Info';

  @override
  String get developer => 'Developer';

  @override
  String get email => 'Email';

  @override
  String get githubProject => 'GitHub Project';

  @override
  String get copyright => '© 2025 ziyi127. All rights reserved.';

  @override
  String get license => 'Open sourced under Apache License 2.0';

  @override
  String get desktopWidgetConfigTitle => 'Desktop Widget Config';

  @override
  String get resetPositions => 'Reset Positions';

  @override
  String get usageGuide => 'Usage Guide';

  @override
  String get usageGuideContent =>
      '• Toggle switches to control widget visibility\n• Click \"Edit Layout\" on desktop widget screen to drag and resize\n• Click \"Reset Positions\" to restore default layout';

  @override
  String get widgetManagement => 'Widget Management';

  @override
  String positionInfo(int x, int y, int width, int height) {
    return 'Pos: ($x, $y) • Size: $width×$height';
  }

  @override
  String get todayCourses => 'Today\'s Courses';

  @override
  String get weekSchedule => 'Weekly Schedule';

  @override
  String weekNumber(int week) {
    return 'Week $week';
  }

  @override
  String get dayView => 'Day';

  @override
  String get weekView => 'Week';

  @override
  String get noCourseToday => 'No courses today';

  @override
  String get enjoyFreeTime => 'Enjoy your free time ☕';

  @override
  String get statusOngoing => 'Ongoing';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusEnded => 'Ended';

  @override
  String get loadingWeekSchedule => 'Loading weekly schedule...';

  @override
  String get copyToOtherTime => 'Copy to other time';

  @override
  String get setReminder => 'Set reminder';
}
