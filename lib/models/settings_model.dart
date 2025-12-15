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

  const AppSettings({
    required this.themeSettings,
    this.apiBaseUrl = 'http://localhost:3000/api',
    this.enableNotifications = true,
    this.semesterStartDate,
    this.language = 'zh',
    this.weatherRefreshInterval = 30,
    this.countdownRefreshInterval = 60,
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
  }) {
    return AppSettings(
      themeSettings: themeSettings ?? this.themeSettings,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      semesterStartDate: semesterStartDate ?? this.semesterStartDate,
      language: language ?? this.language,
      weatherRefreshInterval: weatherRefreshInterval ?? this.weatherRefreshInterval,
      countdownRefreshInterval: countdownRefreshInterval ?? this.countdownRefreshInterval,
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
        other.countdownRefreshInterval == countdownRefreshInterval;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeSettings,
      apiBaseUrl,
      enableNotifications,
      semesterStartDate,
      language,
      weatherRefreshInterval,
      countdownRefreshInterval,
    );
  }

  /// 便捷方法：获取主题模式
  ThemeMode get themeMode => themeSettings.themeMode;

  /// 便捷方法：获取种子颜色
  Color get seedColor => themeSettings.seedColor;
}
