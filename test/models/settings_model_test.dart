import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/models/theme_settings_model.dart';

void main() {
  group('AppSettings', () {
    group('defaultSettings', () {
      test('creates valid defaults', () {
        final settings = AppSettings.defaultSettings();

        expect(settings.language, 'zh');
        expect(settings.enableNotifications, false);
        expect(settings.latitude, 39.9042);
        expect(settings.longitude, 116.4074);
        expect(settings.cityName, 'Beijing');
        expect(settings.enableNtpSync, false);
        expect(settings.showTimeDisplayWidget, false);
        expect(settings.showDateDisplayWidget, false);
        expect(settings.showWeekDisplayWidget, false);
        expect(settings.showWeatherWidget, false);
        expect(settings.showCountdownWidget, false);
        expect(settings.showCurrentClassWidget, false);
        expect(settings.enableCourseReminder, false);
        expect(settings.minimizeToTray, false);
        expect(settings.enableDebugMode, false);
        expect(settings.enablePerformanceMonitoring, false);
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'themeSettings': ThemeSettings.defaultSettings().toJson(),
          'apiBaseUrl': 'http://example.com/api',
          'enableNotifications': true,
          'semesterStartDate': '2026-09-01T00:00:00.000',
          'language': 'en',
          'weatherRefreshInterval': 60,
          'countdownRefreshInterval': 120,
          'latitude': 31.2304,
          'longitude': 121.4737,
          'cityName': 'Shanghai',
          'enableNtpSync': true,
          'ntpSyncInterval': 60,
          'ntpServer': 'pool.ntp.org',
          'uiScale': 1.5,
          'followSystemColor': false,
          'showTimeDisplayWidget': true,
          'showDateDisplayWidget': true,
          'showWeekDisplayWidget': false,
          'showWeatherWidget': true,
          'showCountdownWidget': false,
          'showCurrentClassWidget': true,
          'enableDesktopWidgets': true,
          'enableCourseReminder': true,
          'enableTtsForReminder': true,
          'showNotificationOnClassStart': true,
          'showNotificationOnClassEnd': true,
          'showNotificationForCountdown': false,
          'startWithWindows': true,
          'minimizeToTray': true,
          'enableDebugMode': true,
          'enablePerformanceMonitoring': true,
        };

        final settings = AppSettings.fromJson(json);

        expect(settings.apiBaseUrl, 'http://example.com/api');
        expect(settings.enableNotifications, true);
        expect(settings.semesterStartDate, DateTime(2026, 9, 1));
        expect(settings.language, 'en');
        expect(settings.weatherRefreshInterval, 60);
        expect(settings.countdownRefreshInterval, 120);
        expect(settings.latitude, 31.2304);
        expect(settings.longitude, 121.4737);
        expect(settings.cityName, 'Shanghai');
        expect(settings.enableNtpSync, true);
        expect(settings.ntpSyncInterval, 60);
        expect(settings.ntpServer, 'pool.ntp.org');
        expect(settings.uiScale, 1.5);
        expect(settings.followSystemColor, false);
        expect(settings.showTimeDisplayWidget, true);
        expect(settings.showDateDisplayWidget, true);
        expect(settings.showWeekDisplayWidget, false);
        expect(settings.showWeatherWidget, true);
        expect(settings.showCountdownWidget, false);
        expect(settings.showCurrentClassWidget, true);
        expect(settings.enableDesktopWidgets, true);
        expect(settings.enableCourseReminder, true);
        expect(settings.enableTtsForReminder, true);
        expect(settings.showNotificationOnClassStart, true);
        expect(settings.showNotificationOnClassEnd, true);
        expect(settings.showNotificationForCountdown, false);
        expect(settings.startWithWindows, true);
        expect(settings.minimizeToTray, true);
        expect(settings.enableDebugMode, true);
        expect(settings.enablePerformanceMonitoring, true);
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{};

        final settings = AppSettings.fromJson(json);

        expect(settings.apiBaseUrl, 'http://localhost:3000/api');
        expect(settings.enableNotifications, true);
        expect(settings.semesterStartDate, isNull);
        expect(settings.language, 'zh');
        expect(settings.weatherRefreshInterval, 30);
        expect(settings.uiScale, 1.0);
        expect(settings.followSystemColor, true);
        expect(settings.showTimeDisplayWidget, true);
        expect(settings.enableCourseReminder, true);
        expect(settings.enableDebugMode, false);
      });

      test('handles null semesterStartDate', () {
        final json = {
          'semesterStartDate': null,
        };

        final settings = AppSettings.fromJson(json);

        expect(settings.semesterStartDate, isNull);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        final settings = AppSettings(
          themeSettings: ThemeSettings.defaultSettings(),
          apiBaseUrl: 'http://test.com/api',
          language: 'en',
          semesterStartDate: DateTime(2026, 9, 1),
        );

        final json = settings.toJson();

        expect(json['apiBaseUrl'], 'http://test.com/api');
        expect(json['language'], 'en');
        expect(json['semesterStartDate'], '2026-09-01T00:00:00.000');
        expect(json['themeSettings'], isA<Map<String, dynamic>>());
      });

      test('serializes null semesterStartDate as null', () {
        final settings = AppSettings(
          themeSettings: ThemeSettings.defaultSettings(),
        );

        final json = settings.toJson();

        expect(json['semesterStartDate'], isNull);
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves data', () {
        final original = AppSettings(
          themeSettings: ThemeSettings.defaultSettings(),
          apiBaseUrl: 'http://round-trip.com/api',
          language: 'en',
          latitude: 40.7128,
          longitude: -74.006,
          cityName: 'New York',
          uiScale: 1.25,
          enableDebugMode: true,
        );

        final restored = AppSettings.fromJson(original.toJson());

        expect(restored.apiBaseUrl, original.apiBaseUrl);
        expect(restored.language, original.language);
        expect(restored.latitude, original.latitude);
        expect(restored.longitude, original.longitude);
        expect(restored.cityName, original.cityName);
        expect(restored.uiScale, original.uiScale);
        expect(restored.enableDebugMode, original.enableDebugMode);
      });
    });

    group('copyWith', () {
      test('copies with changed language', () {
        final original = AppSettings.defaultSettings();
        final copied = original.copyWith(language: 'en');

        expect(copied.language, 'en');
        expect(copied.enableNotifications, original.enableNotifications);
        expect(copied.uiScale, original.uiScale);
      });

      test('copies with changed widget visibility', () {
        final original = AppSettings.defaultSettings();
        final copied = original.copyWith(
          showTimeDisplayWidget: true,
          showWeatherWidget: true,
        );

        expect(copied.showTimeDisplayWidget, true);
        expect(copied.showWeatherWidget, true);
        expect(copied.showDateDisplayWidget, original.showDateDisplayWidget);
      });

      test('copies with no changes returns equal object', () {
        final original = AppSettings.defaultSettings();
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        final a = AppSettings.defaultSettings();
        final b = AppSettings.defaultSettings();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different language produces inequality', () {
        final a = AppSettings.defaultSettings();
        final b = a.copyWith(language: 'en');

        expect(a, isNot(equals(b)));
      });
    });

    group('convenience getters', () {
      test('themeMode delegates to themeSettings', () {
        final settings = AppSettings(
          themeSettings: const ThemeSettings(
            seedColor: Color(0xFF6750A4),
            themeMode: ThemeMode.dark,
            useDynamicColor: false,
            useSystemColor: false,
          ),
        );

        expect(settings.themeMode, ThemeMode.dark);
      });

      test('seedColor delegates to themeSettings', () {
        final settings = AppSettings(
          themeSettings: const ThemeSettings(
            seedColor: Color(0xFFFF5722),
            themeMode: ThemeMode.system,
            useDynamicColor: false,
            useSystemColor: false,
          ),
        );

        expect(settings.seedColor, const Color(0xFFFF5722));
      });
    });
  });
}
