import 'package:flutter/material.dart';
import 'package:time_widgets/models/theme_settings_model.dart';

class AppSettings {
  final ThemeSettings themeSettings;
  final String apiBaseUrl;
  final bool enableNotifications;
  final DateTime? semesterStartDate;
  final String language;
  final int weatherRefreshInterval;
  final int countdownRefreshInterval;
  final double? latitude;
  final double? longitude;
  final String? cityName;
  final bool enableNtpSync;
  final int ntpSyncInterval;
  final String ntpServer;
  final double uiScale;
  final bool followSystemColor;
  // 新增加的自定义选项
  final bool showWeatherWidget;
  final bool showCountdownWidget;
  final bool showCurrentClassWidget;
  final bool showTimeDisplayWidget;
  final bool showDateDisplayWidget;
  final bool showWeekDisplayWidget;
  final bool enableDesktopWidgets;
  final bool startWithWindows;
  final bool minimizeToTray;
  final bool showNotificationOnClassStart;
  final bool showNotificationOnClassEnd;
  final bool showNotificationForCountdown;
  final int maxRecentCities;
  final bool enableDebugMode;
  final bool enablePerformanceMonitoring;
  // 课程提醒相关设置
  final bool enableCourseReminder;
  final bool enableTtsForReminder;

  const AppSettings({
    required this.themeSettings,
    this.apiBaseUrl = 'http://localhost:3000/api',
    this.enableNotifications = true,
    this.semesterStartDate,
    this.language = 'zh',
    this.weatherRefreshInterval = 30,
    this.countdownRefreshInterval = 60,
    this.latitude,
    this.longitude,
    this.cityName,
    this.enableNtpSync = true,
    this.ntpSyncInterval = 30,
    this.ntpServer = 'ntp.aliyun.com',
    this.uiScale = 1.0,
    this.followSystemColor = true,
    // 新增加的自定义选项默认值
    this.showWeatherWidget = true,
    this.showCountdownWidget = true,
    this.showCurrentClassWidget = true,
    this.showTimeDisplayWidget = true,
    this.showDateDisplayWidget = true,
    this.showWeekDisplayWidget = true,
    this.enableDesktopWidgets = true,
    this.startWithWindows = false,
    this.minimizeToTray = true,
    this.showNotificationOnClassStart = true,
    this.showNotificationOnClassEnd = false,
    this.showNotificationForCountdown = true,
    this.maxRecentCities = 5,
    this.enableDebugMode = false,
    this.enablePerformanceMonitoring = false,
    // 课程提醒相关设置默认值
    this.enableCourseReminder = false,
    this.enableTtsForReminder = false,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      themeSettings: ThemeSettings.defaultSettings(),
      apiBaseUrl: 'http://localhost:3000/api',
      enableNotifications: true,
      semesterStartDate: null,
      language: 'zh',
      weatherRefreshInterval: 30,
      countdownRefreshInterval: 60,
      latitude: 39.9042, // Beijing
      longitude: 116.4074,
      cityName: 'Beijing',
      enableNtpSync: true,
      ntpSyncInterval: 30,
      ntpServer: 'ntp.aliyun.com',
      uiScale: 1.0,
      followSystemColor: true,
      // 新增加的自定义选项默认值
      showWeatherWidget: true,
      showCountdownWidget: true,
      showCurrentClassWidget: true,
      showTimeDisplayWidget: true,
      showDateDisplayWidget: true,
      showWeekDisplayWidget: true,
      enableDesktopWidgets: true,
      startWithWindows: false,
      minimizeToTray: true,
      showNotificationOnClassStart: true,
      showNotificationOnClassEnd: false,
      showNotificationForCountdown: true,
      maxRecentCities: 5,
      enableDebugMode: false,
      enablePerformanceMonitoring: false,
      // 课程提醒相关设置默认值
      enableCourseReminder: false,
      enableTtsForReminder: false,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeSettings: json['themeSettings'] != null
          ? ThemeSettings.fromJson(json['themeSettings'])
          : ThemeSettings.defaultSettings(),
      apiBaseUrl: json['apiBaseUrl'] ?? 'http://localhost:3000/api',
      enableNotifications: json['enableNotifications'] ?? true,
      semesterStartDate: json['semesterStartDate'] != null
          ? DateTime.parse(json['semesterStartDate'])
          : null,
      language: json['language'] ?? 'zh',
      weatherRefreshInterval: json['weatherRefreshInterval'] ?? 30,
      countdownRefreshInterval: json['countdownRefreshInterval'] ?? 60,
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityName: json['cityName'],
      enableNtpSync: json['enableNtpSync'] ?? true,
      ntpSyncInterval: json['ntpSyncInterval'] ?? 30,
      ntpServer: json['ntpServer'] ?? 'ntp.aliyun.com',
      uiScale: (json['uiScale'] ?? 1.0).toDouble(),
      followSystemColor: json['followSystemColor'] ?? true,
      // 新增加的自定义选项
      showWeatherWidget: json['showWeatherWidget'] ?? true,
      showCountdownWidget: json['showCountdownWidget'] ?? true,
      showCurrentClassWidget: json['showCurrentClassWidget'] ?? true,
      showTimeDisplayWidget: json['showTimeDisplayWidget'] ?? true,
      showDateDisplayWidget: json['showDateDisplayWidget'] ?? true,
      showWeekDisplayWidget: json['showWeekDisplayWidget'] ?? true,
      enableDesktopWidgets: json['enableDesktopWidgets'] ?? true,
      startWithWindows: json['startWithWindows'] ?? false,
      minimizeToTray: json['minimizeToTray'] ?? true,
      showNotificationOnClassStart: json['showNotificationOnClassStart'] ?? true,
      showNotificationOnClassEnd: json['showNotificationOnClassEnd'] ?? false,
      showNotificationForCountdown: json['showNotificationForCountdown'] ?? true,
      maxRecentCities: json['maxRecentCities'] ?? 5,
      enableDebugMode: json['enableDebugMode'] ?? false,
      enablePerformanceMonitoring: json['enablePerformanceMonitoring'] ?? false,
      // 课程提醒相关设置
      enableCourseReminder: json['enableCourseReminder'] ?? false,
      enableTtsForReminder: json['enableTtsForReminder'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeSettings': themeSettings.toJson(),
      'apiBaseUrl': apiBaseUrl,
      'enableNotifications': enableNotifications,
      'semesterStartDate': semesterStartDate?.toIso8601String(),
      'language': language,
      'weatherRefreshInterval': weatherRefreshInterval,
      'countdownRefreshInterval': countdownRefreshInterval,
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'enableNtpSync': enableNtpSync,
      'ntpSyncInterval': ntpSyncInterval,
      'ntpServer': ntpServer,
      'uiScale': uiScale,
      'followSystemColor': followSystemColor,
      // 新增加的自定义选项
      'showWeatherWidget': showWeatherWidget,
      'showCountdownWidget': showCountdownWidget,
      'showCurrentClassWidget': showCurrentClassWidget,
      'showTimeDisplayWidget': showTimeDisplayWidget,
      'showDateDisplayWidget': showDateDisplayWidget,
      'showWeekDisplayWidget': showWeekDisplayWidget,
      'enableDesktopWidgets': enableDesktopWidgets,
      'startWithWindows': startWithWindows,
      'minimizeToTray': minimizeToTray,
      'showNotificationOnClassStart': showNotificationOnClassStart,
      'showNotificationOnClassEnd': showNotificationOnClassEnd,
      'showNotificationForCountdown': showNotificationForCountdown,
      'maxRecentCities': maxRecentCities,
      'enableDebugMode': enableDebugMode,
      'enablePerformanceMonitoring': enablePerformanceMonitoring,
      // 课程提醒相关设置
      'enableCourseReminder': enableCourseReminder,
      'enableTtsForReminder': enableTtsForReminder,
    };
  }

  AppSettings copyWith({
    ThemeSettings? themeSettings,
    String? apiBaseUrl,
    bool? enableNotifications,
    DateTime? semesterStartDate,
    String? language,
    int? weatherRefreshInterval,
    int? countdownRefreshInterval,
    double? latitude,
    double? longitude,
    String? cityName,
    bool? enableNtpSync,
    int? ntpSyncInterval,
    String? ntpServer,
    double? uiScale,
    bool? followSystemColor,
    // 新增加的自定义选项
    bool? showWeatherWidget,
    bool? showCountdownWidget,
    bool? showCurrentClassWidget,
    bool? showTimeDisplayWidget,
    bool? showDateDisplayWidget,
    bool? showWeekDisplayWidget,
    bool? enableDesktopWidgets,
    bool? startWithWindows,
    bool? minimizeToTray,
    bool? showNotificationOnClassStart,
    bool? showNotificationOnClassEnd,
    bool? showNotificationForCountdown,
    int? maxRecentCities,
    bool? enableDebugMode,
    bool? enablePerformanceMonitoring,
    // 课程提醒相关设置
    bool? enableCourseReminder,
    bool? enableTtsForReminder,
  }) {
    return AppSettings(
      themeSettings: themeSettings ?? this.themeSettings,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      semesterStartDate: semesterStartDate ?? this.semesterStartDate,
      language: language ?? this.language,
      weatherRefreshInterval: weatherRefreshInterval ?? this.weatherRefreshInterval,
      countdownRefreshInterval: countdownRefreshInterval ?? this.countdownRefreshInterval,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      enableNtpSync: enableNtpSync ?? this.enableNtpSync,
      ntpSyncInterval: ntpSyncInterval ?? this.ntpSyncInterval,
      ntpServer: ntpServer ?? this.ntpServer,
      uiScale: uiScale ?? this.uiScale,
      followSystemColor: followSystemColor ?? this.followSystemColor,
      // 新增加的自定义选项
      showWeatherWidget: showWeatherWidget ?? this.showWeatherWidget,
      showCountdownWidget: showCountdownWidget ?? this.showCountdownWidget,
      showCurrentClassWidget: showCurrentClassWidget ?? this.showCurrentClassWidget,
      showTimeDisplayWidget: showTimeDisplayWidget ?? this.showTimeDisplayWidget,
      showDateDisplayWidget: showDateDisplayWidget ?? this.showDateDisplayWidget,
      showWeekDisplayWidget: showWeekDisplayWidget ?? this.showWeekDisplayWidget,
      enableDesktopWidgets: enableDesktopWidgets ?? this.enableDesktopWidgets,
      startWithWindows: startWithWindows ?? this.startWithWindows,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      showNotificationOnClassStart: showNotificationOnClassStart ?? this.showNotificationOnClassStart,
      showNotificationOnClassEnd: showNotificationOnClassEnd ?? this.showNotificationOnClassEnd,
      showNotificationForCountdown: showNotificationForCountdown ?? this.showNotificationForCountdown,
      maxRecentCities: maxRecentCities ?? this.maxRecentCities,
      enableDebugMode: enableDebugMode ?? this.enableDebugMode,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      // 课程提醒相关设置
      enableCourseReminder: enableCourseReminder ?? this.enableCourseReminder,
      enableTtsForReminder: enableTtsForReminder ?? this.enableTtsForReminder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeSettings == themeSettings &&
        other.apiBaseUrl == apiBaseUrl &&
        other.enableNotifications == enableNotifications &&
        other.semesterStartDate == semesterStartDate &&
        other.language == language &&
        other.weatherRefreshInterval == weatherRefreshInterval &&
        other.countdownRefreshInterval == countdownRefreshInterval &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.enableNtpSync == enableNtpSync &&
        other.ntpSyncInterval == ntpSyncInterval &&
        other.ntpServer == ntpServer &&
        other.uiScale == uiScale &&
        other.followSystemColor == followSystemColor &&
        // 新增加的自定义选项
        other.showWeatherWidget == showWeatherWidget &&
        other.showCountdownWidget == showCountdownWidget &&
        other.showCurrentClassWidget == showCurrentClassWidget &&
        other.showTimeDisplayWidget == showTimeDisplayWidget &&
        other.showDateDisplayWidget == showDateDisplayWidget &&
        other.showWeekDisplayWidget == showWeekDisplayWidget &&
        other.enableDesktopWidgets == enableDesktopWidgets &&
        other.startWithWindows == startWithWindows &&
        other.minimizeToTray == minimizeToTray &&
        other.showNotificationOnClassStart == showNotificationOnClassStart &&
        other.showNotificationOnClassEnd == showNotificationOnClassEnd &&
        other.showNotificationForCountdown == showNotificationForCountdown &&
        other.maxRecentCities == maxRecentCities &&
        other.enableDebugMode == enableDebugMode &&
        other.enablePerformanceMonitoring == enablePerformanceMonitoring &&
        // 课程提醒相关设置
        other.enableCourseReminder == enableCourseReminder &&
        other.enableTtsForReminder == enableTtsForReminder;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      themeSettings,
      apiBaseUrl,
      enableNotifications,
      semesterStartDate,
      language,
      weatherRefreshInterval,
      countdownRefreshInterval,
      latitude,
      longitude,
      cityName,
      enableNtpSync,
      ntpSyncInterval,
      ntpServer,
      uiScale,
      followSystemColor,
      // 新增加的自定义选项
      showWeatherWidget,
      showCountdownWidget,
      showCurrentClassWidget,
      showTimeDisplayWidget,
      showDateDisplayWidget,
      showWeekDisplayWidget,
      enableDesktopWidgets,
      startWithWindows,
      minimizeToTray,
      showNotificationOnClassStart,
      showNotificationOnClassEnd,
      showNotificationForCountdown,
      maxRecentCities,
      enableDebugMode,
      enablePerformanceMonitoring,
      // 课程提醒相关设置
      enableCourseReminder,
      enableTtsForReminder,
    ]);
  }

  /// 便捷方法：获取主题模式
  ThemeMode get themeMode => themeSettings.themeMode;

  /// 便捷方法：获取种子颜色
  Color get seedColor => themeSettings.seedColor;
}