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
        other.followSystemColor == followSystemColor;
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
      latitude,
      longitude,
      cityName,
      enableNtpSync,
      ntpSyncInterval,
      ntpServer,
      uiScale,
      followSystemColor,
    );
  }

  /// 便捷方法：获取主题模式
  ThemeMode get themeMode => themeSettings.themeMode;

  /// 便捷方法：获取种子颜色
  Color get seedColor => themeSettings.seedColor;
}