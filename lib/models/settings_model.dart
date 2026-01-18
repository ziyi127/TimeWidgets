import 'package:flutter/material.dart';
import 'package:time_widgets/models/theme_settings_model.dart';

class AppSettings {

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
    
    // Widget display settings
    this.showTimeDisplayWidget = true,
    this.showDateDisplayWidget = true,
    this.showWeekDisplayWidget = true,
    this.showWeatherWidget = true,
    this.showCountdownWidget = true,
    this.showCurrentClassWidget = true,
    
    // Desktop widget settings
    this.enableDesktopWidgets = true,
    
    // Notification settings
    this.enableCourseReminder = true,
    this.enableTtsForReminder = false,
    this.showNotificationOnClassStart = true,
    this.showNotificationOnClassEnd = false,
    this.showNotificationForCountdown = true,
    
    // Startup settings
    this.startWithWindows = false,
    this.minimizeToTray = true,
    
    // Advanced settings
    this.enableDebugMode = false,
    this.enablePerformanceMonitoring = false,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      themeSettings: ThemeSettings.defaultSettings(),
      enableNotifications: false,
      latitude: 39.9042, // Beijing
      longitude: 116.4074,
      cityName: 'Beijing',
      enableNtpSync: false,
      
      // Widget display settings
      showTimeDisplayWidget: false,
      showDateDisplayWidget: false,
      showWeekDisplayWidget: false,
      showWeatherWidget: false,
      showCountdownWidget: false,
      showCurrentClassWidget: false,
      
      // Notification settings
      enableCourseReminder: false,
      showNotificationOnClassStart: false,
      showNotificationForCountdown: false,
      minimizeToTray: false,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeSettings: json['themeSettings'] != null
          ? ThemeSettings.fromJson(json['themeSettings'] as Map<String, dynamic>)
          : ThemeSettings.defaultSettings(),
      apiBaseUrl: json['apiBaseUrl'] as String? ?? 'http://localhost:3000/api',
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      semesterStartDate: json['semesterStartDate'] != null
          ? DateTime.parse(json['semesterStartDate'] as String)
          : null,
      language: json['language'] as String? ?? 'zh',
      weatherRefreshInterval: json['weatherRefreshInterval'] as int? ?? 30,
      countdownRefreshInterval: json['countdownRefreshInterval'] as int? ?? 60,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      cityName: json['cityName'] as String?,
      enableNtpSync: json['enableNtpSync'] as bool? ?? true,
      ntpSyncInterval: json['ntpSyncInterval'] as int? ?? 30,
      ntpServer: json['ntpServer'] as String? ?? 'ntp.aliyun.com',
      uiScale: (json['uiScale'] as num?)?.toDouble() ?? 1.0,
      followSystemColor: json['followSystemColor'] as bool? ?? true,
      
      // Widget display settings
      showTimeDisplayWidget: json['showTimeDisplayWidget'] as bool? ?? true,
      showDateDisplayWidget: json['showDateDisplayWidget'] as bool? ?? true,
      showWeekDisplayWidget: json['showWeekDisplayWidget'] as bool? ?? true,
      showWeatherWidget: json['showWeatherWidget'] as bool? ?? true,
      showCountdownWidget: json['showCountdownWidget'] as bool? ?? true,
      showCurrentClassWidget: json['showCurrentClassWidget'] as bool? ?? true,
      
      // Desktop widget settings
      enableDesktopWidgets: json['enableDesktopWidgets'] as bool? ?? false,
      
      // Notification settings
      enableCourseReminder: json['enableCourseReminder'] as bool? ?? true,
      enableTtsForReminder: json['enableTtsForReminder'] as bool? ?? false,
      showNotificationOnClassStart: json['showNotificationOnClassStart'] as bool? ?? true,
      showNotificationOnClassEnd: json['showNotificationOnClassEnd'] as bool? ?? false,
      showNotificationForCountdown: json['showNotificationForCountdown'] as bool? ?? true,
      
      // Startup settings
      startWithWindows: json['startWithWindows'] as bool? ?? false,
      minimizeToTray: json['minimizeToTray'] as bool? ?? true,
      
      // Advanced settings
      enableDebugMode: json['enableDebugMode'] as bool? ?? false,
      enablePerformanceMonitoring: json['enablePerformanceMonitoring'] as bool? ?? false,
    );
  }
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
  
  // Widget display settings
  final bool showTimeDisplayWidget;
  final bool showDateDisplayWidget;
  final bool showWeekDisplayWidget;
  final bool showWeatherWidget;
  final bool showCountdownWidget;
  final bool showCurrentClassWidget;
  
  // Desktop widget settings
  final bool enableDesktopWidgets;
  
  // Notification settings
  final bool enableCourseReminder;
  final bool enableTtsForReminder;
  final bool showNotificationOnClassStart;
  final bool showNotificationOnClassEnd;
  final bool showNotificationForCountdown;
  
  // Startup settings
  final bool startWithWindows;
  final bool minimizeToTray;
  
  // Advanced settings
  final bool enableDebugMode;
  final bool enablePerformanceMonitoring;

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
      
      // Widget display settings
      'showTimeDisplayWidget': showTimeDisplayWidget,
      'showDateDisplayWidget': showDateDisplayWidget,
      'showWeekDisplayWidget': showWeekDisplayWidget,
      'showWeatherWidget': showWeatherWidget,
      'showCountdownWidget': showCountdownWidget,
      'showCurrentClassWidget': showCurrentClassWidget,
      
      // Desktop widget settings
      'enableDesktopWidgets': enableDesktopWidgets,
      
      // Notification settings
      'enableCourseReminder': enableCourseReminder,
      'enableTtsForReminder': enableTtsForReminder,
      'showNotificationOnClassStart': showNotificationOnClassStart,
      'showNotificationOnClassEnd': showNotificationOnClassEnd,
      'showNotificationForCountdown': showNotificationForCountdown,
      
      // Startup settings
      'startWithWindows': startWithWindows,
      'minimizeToTray': minimizeToTray,
      
      // Advanced settings
      'enableDebugMode': enableDebugMode,
      'enablePerformanceMonitoring': enablePerformanceMonitoring,
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
    
    // Widget display settings
    bool? showTimeDisplayWidget,
    bool? showDateDisplayWidget,
    bool? showWeekDisplayWidget,
    bool? showWeatherWidget,
    bool? showCountdownWidget,
    bool? showCurrentClassWidget,
    
    // Desktop widget settings
    bool? enableDesktopWidgets,
    
    // Notification settings
    bool? enableCourseReminder,
    bool? enableTtsForReminder,
    bool? showNotificationOnClassStart,
    bool? showNotificationOnClassEnd,
    bool? showNotificationForCountdown,
    
    // Startup settings
    bool? startWithWindows,
    bool? minimizeToTray,
    
    // Advanced settings
    bool? enableDebugMode,
    bool? enablePerformanceMonitoring,
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
      
      // Widget display settings
      showTimeDisplayWidget: showTimeDisplayWidget ?? this.showTimeDisplayWidget,
      showDateDisplayWidget: showDateDisplayWidget ?? this.showDateDisplayWidget,
      showWeekDisplayWidget: showWeekDisplayWidget ?? this.showWeekDisplayWidget,
      showWeatherWidget: showWeatherWidget ?? this.showWeatherWidget,
      showCountdownWidget: showCountdownWidget ?? this.showCountdownWidget,
      showCurrentClassWidget: showCurrentClassWidget ?? this.showCurrentClassWidget,
      
      // Desktop widget settings
      enableDesktopWidgets: enableDesktopWidgets ?? this.enableDesktopWidgets,
      
      // Notification settings
      enableCourseReminder: enableCourseReminder ?? this.enableCourseReminder,
      enableTtsForReminder: enableTtsForReminder ?? this.enableTtsForReminder,
      showNotificationOnClassStart: showNotificationOnClassStart ?? this.showNotificationOnClassStart,
      showNotificationOnClassEnd: showNotificationOnClassEnd ?? this.showNotificationOnClassEnd,
      showNotificationForCountdown: showNotificationForCountdown ?? this.showNotificationForCountdown,
      
      // Startup settings
      startWithWindows: startWithWindows ?? this.startWithWindows,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      
      // Advanced settings
      enableDebugMode: enableDebugMode ?? this.enableDebugMode,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
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
        other.showTimeDisplayWidget == showTimeDisplayWidget &&
        other.showDateDisplayWidget == showDateDisplayWidget &&
        other.showWeekDisplayWidget == showWeekDisplayWidget &&
        other.showWeatherWidget == showWeatherWidget &&
        other.showCountdownWidget == showCountdownWidget &&
        other.showCurrentClassWidget == showCurrentClassWidget &&
        other.enableDesktopWidgets == enableDesktopWidgets &&
        other.enableCourseReminder == enableCourseReminder &&
        other.enableTtsForReminder == enableTtsForReminder &&
        other.showNotificationOnClassStart == showNotificationOnClassStart &&
        other.showNotificationOnClassEnd == showNotificationOnClassEnd &&
        other.showNotificationForCountdown == showNotificationForCountdown &&
        other.startWithWindows == startWithWindows &&
        other.minimizeToTray == minimizeToTray &&
        other.enableDebugMode == enableDebugMode &&
        other.enablePerformanceMonitoring == enablePerformanceMonitoring;
  }

  @override
  int get hashCode {
    // 使用组合哈希计算，因为Object.hash只允许20个参数
    return Object.hash(
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
      Object.hash(
        showTimeDisplayWidget,
        showDateDisplayWidget,
        showWeekDisplayWidget,
        showWeatherWidget,
        showCountdownWidget,
        showCurrentClassWidget,
        enableDesktopWidgets,
        enableCourseReminder,
        enableTtsForReminder,
        showNotificationOnClassStart,
        showNotificationOnClassEnd,
        showNotificationForCountdown,
        startWithWindows,
        minimizeToTray,
        enableDebugMode,
        enablePerformanceMonitoring,
      ),
    );
  }

  /// 便捷方法：获取主题模式
  ThemeMode get themeMode => themeSettings.themeMode;

  /// 便捷方法：获取种子颜色
  Color get seedColor => themeSettings.seedColor;
}
