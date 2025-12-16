import 'package:flutter/material.dart';
import 'package:glados/glados.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/services/theme_service.dart';

void main() {
  group('Theme Settings Property Tests', () {
    // **Feature: project-enhancement, Property 13: Theme Settings Persistence Round Trip**
    // **Validates: Requirements 9.5**
    test('ThemeSettings JSON round trip preserves all data', () {
      final original = ThemeSettings(
        seedColor: const Color(0xFF6750A4),
        themeMode: ThemeMode.light,
        useDynamicColor: true,
        useSystemColor: false,
      );

      final json = original.toJson();
      final restored = ThemeSettings.fromJson(json);

      expect(restored, equals(original));
      expect(restored.seedColor.toARGB32(), equals(original.seedColor.toARGB32()));
      expect(restored.themeMode, equals(original.themeMode));
      expect(restored.useDynamicColor, equals(original.useDynamicColor));
      expect(restored.useSystemColor, equals(original.useSystemColor));
    });

    Glados<int>(any.intInRange(0x00000000, 0xFFFFFFFF)).test(
      'round trip preserves seed color',
      (colorValue) {
        final original = ThemeSettings(
          seedColor: Color(colorValue),
          themeMode: ThemeMode.system,
          useDynamicColor: true,
          useSystemColor: false,
        );

        final json = original.toJson();
        final restored = ThemeSettings.fromJson(json);

        expect(restored.seedColor.toARGB32(), equals(original.seedColor.toARGB32()));
      },
    );

    test('round trip preserves all theme modes', () {
      for (final mode in ThemeMode.values) {
        final original = ThemeSettings(
          seedColor: const Color(0xFF6750A4),
          themeMode: mode,
          useDynamicColor: true,
          useSystemColor: false,
        );

        final json = original.toJson();
        final restored = ThemeSettings.fromJson(json);

        expect(restored.themeMode, equals(mode));
      }
    });

    test('round trip preserves boolean flags', () {
      final testCases = [
        (true, true),
        (true, false),
        (false, true),
        (false, false),
      ];

      for (final (useDynamic, useSystem) in testCases) {
        final original = ThemeSettings(
          seedColor: const Color(0xFF6750A4),
          themeMode: ThemeMode.system,
          useDynamicColor: useDynamic,
          useSystemColor: useSystem,
        );

        final json = original.toJson();
        final restored = ThemeSettings.fromJson(json);

        expect(restored.useDynamicColor, equals(useDynamic));
        expect(restored.useSystemColor, equals(useSystem));
      }
    });

    test('default settings are valid', () {
      final defaultSettings = ThemeSettings.defaultSettings();

      expect(defaultSettings.seedColor.toARGB32(), equals(0xFF6750A4));
      expect(defaultSettings.themeMode, equals(ThemeMode.system));
      expect(defaultSettings.useDynamicColor, isTrue);
      expect(defaultSettings.useSystemColor, isFalse);

      // Ensure default settings can be serialized and deserialized
      final json = defaultSettings.toJson();
      final restored = ThemeSettings.fromJson(json);

      expect(restored, equals(defaultSettings));
    });

    test('copyWith creates new instance with updated fields', () {
      final original = ThemeSettings.defaultSettings();

      final updated = original.copyWith(
        seedColor: const Color(0xFFFF0000),
        themeMode: ThemeMode.dark,
      );

      expect(updated.seedColor.toARGB32(), equals(0xFFFF0000));
      expect(updated.themeMode, equals(ThemeMode.dark));
      expect(updated.useDynamicColor, equals(original.useDynamicColor));
      expect(updated.useSystemColor, equals(original.useSystemColor));
    });

    test('equality works correctly', () {
      final settings1 = ThemeSettings(
        seedColor: const Color(0xFF6750A4),
        themeMode: ThemeMode.light,
        useDynamicColor: true,
        useSystemColor: false,
      );

      final settings2 = ThemeSettings(
        seedColor: const Color(0xFF6750A4),
        themeMode: ThemeMode.light,
        useDynamicColor: true,
        useSystemColor: false,
      );

      final settings3 = ThemeSettings(
        seedColor: const Color(0xFFFF0000),
        themeMode: ThemeMode.light,
        useDynamicColor: true,
        useSystemColor: false,
      );

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });

  group('Color Scheme Generation Property Tests', () {
    final themeService = ThemeService();

    // **Feature: project-enhancement, Property 14: Color Scheme Generation Consistency**
    // **Validates: Requirements 9.2**
    Glados<int>(any.intInRange(0x00000000, 0xFFFFFFFF)).test(
      'generating color scheme multiple times produces identical colors',
      (colorValue) {
        final seedColor = Color(colorValue);

        // Generate light scheme multiple times
        final lightScheme1 = themeService.generateColorScheme(seedColor, Brightness.light);
        final lightScheme2 = themeService.generateColorScheme(seedColor, Brightness.light);
        final lightScheme3 = themeService.generateColorScheme(seedColor, Brightness.light);

        // All light schemes should be identical
        expect(lightScheme1.primary.toARGB32(), equals(lightScheme2.primary.toARGB32()));
        expect(lightScheme2.primary.toARGB32(), equals(lightScheme3.primary.toARGB32()));
        expect(lightScheme1.secondary.toARGB32(), equals(lightScheme2.secondary.toARGB32()));
        expect(lightScheme1.tertiary.toARGB32(), equals(lightScheme2.tertiary.toARGB32()));

        // Generate dark scheme multiple times
        final darkScheme1 = themeService.generateColorScheme(seedColor, Brightness.dark);
        final darkScheme2 = themeService.generateColorScheme(seedColor, Brightness.dark);
        final darkScheme3 = themeService.generateColorScheme(seedColor, Brightness.dark);

        // All dark schemes should be identical
        expect(darkScheme1.primary.toARGB32(), equals(darkScheme2.primary.toARGB32()));
        expect(darkScheme2.primary.toARGB32(), equals(darkScheme3.primary.toARGB32()));
        expect(darkScheme1.secondary.toARGB32(), equals(darkScheme2.secondary.toARGB32()));
        expect(darkScheme1.tertiary.toARGB32(), equals(darkScheme2.tertiary.toARGB32()));
      },
    );

    test('same seed color produces same color scheme', () {
      final seedColor = const Color(0xFF6750A4);

      final scheme1 = themeService.generateColorScheme(seedColor, Brightness.light);
      final scheme2 = themeService.generateColorScheme(seedColor, Brightness.light);

      expect(scheme1.primary, equals(scheme2.primary));
      expect(scheme1.secondary, equals(scheme2.secondary));
      expect(scheme1.tertiary, equals(scheme2.tertiary));
      expect(scheme1.error, equals(scheme2.error));
      expect(scheme1.surface, equals(scheme2.surface));
      expect(scheme1.onPrimary, equals(scheme2.onPrimary));
    });

    test('different seed colors produce different color schemes', () {
      final seedColor1 = const Color(0xFF6750A4); // Purple
      final seedColor2 = const Color(0xFFFF0000); // Red

      final scheme1 = themeService.generateColorScheme(seedColor1, Brightness.light);
      final scheme2 = themeService.generateColorScheme(seedColor2, Brightness.light);

      // Primary colors should be different
      expect(scheme1.primary, isNot(equals(scheme2.primary)));
    });

    test('light and dark schemes have different colors', () {
      final seedColor = const Color(0xFF6750A4);

      final lightScheme = themeService.generateColorScheme(seedColor, Brightness.light);
      final darkScheme = themeService.generateColorScheme(seedColor, Brightness.dark);

      // Surface colors should be different (light vs dark)
      expect(lightScheme.surface, isNot(equals(darkScheme.surface)));
      expect(lightScheme.brightness, equals(Brightness.light));
      expect(darkScheme.brightness, equals(Brightness.dark));
    });

    test('generated themes use correct color scheme', () {
      final seedColor = const Color(0xFF6750A4);

      final defaultSettings = ThemeSettings.defaultSettings();
      final lightTheme = themeService.generateLightTheme(seedColor, defaultSettings);
      final darkTheme = themeService.generateDarkTheme(seedColor, defaultSettings);

      expect(lightTheme.colorScheme.brightness, equals(Brightness.light));
      expect(darkTheme.colorScheme.brightness, equals(Brightness.dark));
      expect(lightTheme.useMaterial3, isTrue);
      expect(darkTheme.useMaterial3, isTrue);
    });

    test('generated themes have proper MD3 styling', () {
      final seedColor = const Color(0xFF6750A4);
      final defaultSettings = ThemeSettings.defaultSettings();
      final theme = themeService.generateLightTheme(seedColor, defaultSettings);

      // Check card theme
      expect(theme.cardTheme.elevation, equals(0.0));
      expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());

      // Check button themes
      expect(theme.filledButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.textButtonTheme.style, isNotNull);

      // Check app bar theme
      expect(theme.appBarTheme.elevation, equals(0.0));
      expect(theme.appBarTheme.scrolledUnderElevation, equals(3.0));
    });
  });
}
