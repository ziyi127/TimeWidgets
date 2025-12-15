import 'package:flutter/material.dart';
import 'package:glados/glados.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/models/theme_settings_model.dart';

void main() {
  group('AppSettings Property Tests', () {
    // **Feature: project-enhancement, Property 4: Settings Persistence Round Trip**
    // **Validates: Requirements 3.2**
    Glados(any.intInRange(0, 2)).test(
      'AppSettings JSON round trip preserves all fields',
      (themeModeIndex) {
        final themeSettings = ThemeSettings(
          seedColor: const Color(0xFF6750A4),
          themeMode: ThemeMode.values[themeModeIndex],
          useDynamicColor: true,
          useSystemColor: false,
        );
        
        final original = AppSettings(
          themeSettings: themeSettings,
          apiBaseUrl: 'http://test.com/api',
          enableNotifications: true,
          semesterStartDate: DateTime(2024, 9, 1),
          language: 'zh',
          weatherRefreshInterval: 30,
          countdownRefreshInterval: 60,
        );

        final json = original.toJson();
        final restored = AppSettings.fromJson(json);

        expect(restored.themeSettings, equals(original.themeSettings));
        expect(restored.themeMode, equals(original.themeMode));
        expect(restored.apiBaseUrl, equals(original.apiBaseUrl));
        expect(restored.enableNotifications, equals(original.enableNotifications));
        expect(restored.semesterStartDate, equals(original.semesterStartDate));
        expect(restored.language, equals(original.language));
        expect(restored.weatherRefreshInterval, equals(original.weatherRefreshInterval));
        expect(restored.countdownRefreshInterval, equals(original.countdownRefreshInterval));
      },
    );

    Glados2(any.bool, any.choose(['zh', 'en'])).test(
      'AppSettings round trip with various notification and language settings',
      (enableNotifications, language) {
        final original = AppSettings(
          themeSettings: ThemeSettings.defaultSettings(),
          apiBaseUrl: 'http://localhost:3000/api',
          enableNotifications: enableNotifications,
          semesterStartDate: null,
          language: language,
          weatherRefreshInterval: 30,
          countdownRefreshInterval: 60,
        );

        final json = original.toJson();
        final restored = AppSettings.fromJson(json);

        expect(restored, equals(original));
      },
    );

    test('AppSettings with null semesterStartDate round trips correctly', () {
      final themeSettings = ThemeSettings(
        seedColor: const Color(0xFFFF0000),
        themeMode: ThemeMode.dark,
        useDynamicColor: false,
        useSystemColor: true,
      );
      
      final original = AppSettings(
        themeSettings: themeSettings,
        apiBaseUrl: 'http://example.com/api',
        enableNotifications: false,
        semesterStartDate: null,
        language: 'en',
        weatherRefreshInterval: 15,
        countdownRefreshInterval: 30,
      );

      final json = original.toJson();
      final restored = AppSettings.fromJson(json);

      expect(restored.semesterStartDate, isNull);
      expect(restored, equals(original));
    });

    test('AppSettings with semesterStartDate round trips correctly', () {
      final testDate = DateTime(2024, 9, 2, 8, 0, 0);
      final themeSettings = ThemeSettings(
        seedColor: const Color(0xFF00FF00),
        themeMode: ThemeMode.light,
        useDynamicColor: true,
        useSystemColor: false,
      );
      
      final original = AppSettings(
        themeSettings: themeSettings,
        apiBaseUrl: 'http://school.edu/api',
        enableNotifications: true,
        semesterStartDate: testDate,
        language: 'zh',
        weatherRefreshInterval: 60,
        countdownRefreshInterval: 120,
      );

      final json = original.toJson();
      final restored = AppSettings.fromJson(json);

      expect(restored.semesterStartDate, equals(testDate));
      expect(restored, equals(original));
    });
  });

  group('Settings Reset Property Tests', () {
    // **Feature: project-enhancement, Property 5: Settings Reset Restores Defaults**
    // **Validates: Requirements 3.3**
    test('defaultSettings returns consistent default values', () {
      final defaults1 = AppSettings.defaultSettings();
      final defaults2 = AppSettings.defaultSettings();

      expect(defaults1, equals(defaults2));
      expect(defaults1.themeSettings, equals(ThemeSettings.defaultSettings()));
      expect(defaults1.themeMode, equals(ThemeMode.system));
      expect(defaults1.seedColor, equals(const Color(0xFF6750A4)));
      expect(defaults1.apiBaseUrl, equals('http://localhost:3000/api'));
      expect(defaults1.enableNotifications, isTrue);
      expect(defaults1.semesterStartDate, isNull);
      expect(defaults1.language, equals('zh'));
      expect(defaults1.weatherRefreshInterval, equals(30));
      expect(defaults1.countdownRefreshInterval, equals(60));
    });

    Glados(any.intInRange(0, 2)).test(
      'modified settings differ from defaults',
      (themeModeIndex) {
        final defaults = AppSettings.defaultSettings();
        final customThemeSettings = ThemeSettings(
          seedColor: const Color(0xFFFF5722),
          themeMode: ThemeMode.values[themeModeIndex],
          useDynamicColor: false,
          useSystemColor: true,
        );
        
        final modified = AppSettings(
          themeSettings: customThemeSettings,
          apiBaseUrl: 'http://custom.com/api',
          enableNotifications: false,
          semesterStartDate: DateTime(2024, 9, 1),
          language: 'en',
          weatherRefreshInterval: 15,
          countdownRefreshInterval: 30,
        );

        // Modified settings should differ from defaults in at least one field
        final isDifferent = modified.themeSettings != defaults.themeSettings ||
            modified.apiBaseUrl != defaults.apiBaseUrl ||
            modified.enableNotifications != defaults.enableNotifications ||
            modified.semesterStartDate != defaults.semesterStartDate ||
            modified.language != defaults.language ||
            modified.weatherRefreshInterval != defaults.weatherRefreshInterval ||
            modified.countdownRefreshInterval != defaults.countdownRefreshInterval;

        expect(isDifferent, isTrue);
      },
    );
  });
}
