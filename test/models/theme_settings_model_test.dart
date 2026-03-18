import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/theme_settings_model.dart';

void main() {
  group('ThemeSettings', () {
    group('defaultSettings', () {
      test('creates valid defaults', () {
        final settings = ThemeSettings.defaultSettings();

        expect(settings.seedColor, const Color(0xFF6750A4));
        expect(settings.themeMode, ThemeMode.system);
        expect(settings.useDynamicColor, false);
        expect(settings.useSystemColor, false);
        expect(settings.fontSizeScale, 1.0);
        expect(settings.borderRadiusScale, 1.0);
        expect(settings.componentOpacity, 1.0);
        expect(settings.shadowStrength, 1.0);
        expect(settings.enableGradients, false);
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'seedColor': 0xFFFF5722,
          'themeMode': 'ThemeMode.dark',
          'useDynamicColor': true,
          'useSystemColor': true,
          'fontSizeScale': 1.2,
          'borderRadiusScale': 0.8,
          'componentOpacity': 0.9,
          'shadowStrength': 0.5,
          'enableGradients': true,
        };

        final settings = ThemeSettings.fromJson(json);

        expect(settings.seedColor, const Color(0xFFFF5722));
        expect(settings.themeMode, ThemeMode.dark);
        expect(settings.useDynamicColor, true);
        expect(settings.useSystemColor, true);
        expect(settings.fontSizeScale, 1.2);
        expect(settings.borderRadiusScale, 0.8);
        expect(settings.componentOpacity, 0.9);
        expect(settings.shadowStrength, 0.5);
        expect(settings.enableGradients, true);
      });

      test('handles light theme mode', () {
        final json = {
          'seedColor': 0xFF6750A4,
          'themeMode': 'ThemeMode.light',
          'useDynamicColor': false,
          'useSystemColor': false,
        };

        final settings = ThemeSettings.fromJson(json);

        expect(settings.themeMode, ThemeMode.light);
      });

      test('handles unknown theme mode with fallback', () {
        final json = {
          'seedColor': 0xFF6750A4,
          'themeMode': 'ThemeMode.unknown',
          'useDynamicColor': false,
          'useSystemColor': false,
        };

        final settings = ThemeSettings.fromJson(json);

        expect(settings.themeMode, ThemeMode.system);
      });

      test('handles missing optional fields with defaults', () {
        final json = {
          'seedColor': 0xFF6750A4,
          'themeMode': 'ThemeMode.system',
        };

        final settings = ThemeSettings.fromJson(json);

        expect(settings.useDynamicColor, true);
        expect(settings.useSystemColor, false);
        expect(settings.fontSizeScale, 1.0);
        expect(settings.borderRadiusScale, 1.0);
        expect(settings.componentOpacity, 1.0);
        expect(settings.shadowStrength, 1.0);
        expect(settings.enableGradients, true);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        const settings = ThemeSettings(
          seedColor: Color(0xFFFF5722),
          themeMode: ThemeMode.dark,
          useDynamicColor: true,
          useSystemColor: false,
          fontSizeScale: 1.1,
          borderRadiusScale: 0.9,
          componentOpacity: 0.95,
          shadowStrength: 0.7,
        );

        final json = settings.toJson();

        expect(json['seedColor'], 0xFFFF5722);
        expect(json['themeMode'], 'ThemeMode.dark');
        expect(json['useDynamicColor'], true);
        expect(json['useSystemColor'], false);
        expect(json['fontSizeScale'], 1.1);
        expect(json['borderRadiusScale'], 0.9);
        expect(json['componentOpacity'], 0.95);
        expect(json['shadowStrength'], 0.7);
        expect(json['enableGradients'], true);
      });
    });

    group('JSON round-trip', () {
      test('fromJson(toJson()) preserves data', () {
        const original = ThemeSettings(
          seedColor: Color(0xFF2196F3),
          themeMode: ThemeMode.dark,
          useDynamicColor: true,
          useSystemColor: true,
          fontSizeScale: 1.3,
          borderRadiusScale: 0.7,
          componentOpacity: 0.85,
          shadowStrength: 0.6,
          enableGradients: false,
        );

        final restored = ThemeSettings.fromJson(original.toJson());

        expect(restored, equals(original));
      });
    });

    group('copyWith', () {
      test('copies with changed seedColor', () {
        final original = ThemeSettings.defaultSettings();
        final copied = original.copyWith(seedColor: const Color(0xFFFF0000));

        expect(copied.seedColor, const Color(0xFFFF0000));
        expect(copied.themeMode, original.themeMode);
        expect(copied.fontSizeScale, original.fontSizeScale);
      });

      test('copies with changed themeMode', () {
        final original = ThemeSettings.defaultSettings();
        final copied = original.copyWith(themeMode: ThemeMode.dark);

        expect(copied.themeMode, ThemeMode.dark);
        expect(copied.seedColor.toARGB32(), original.seedColor.toARGB32());
      });

      test('copies with no changes returns equal object', () {
        final original = ThemeSettings.defaultSettings();
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        const a = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.system,
          useDynamicColor: false,
          useSystemColor: false,
        );
        const b = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.system,
          useDynamicColor: false,
          useSystemColor: false,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different seedColor produces inequality', () {
        const a = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.system,
          useDynamicColor: false,
          useSystemColor: false,
        );
        const b = ThemeSettings(
          seedColor: Color(0xFFFF5722),
          themeMode: ThemeMode.system,
          useDynamicColor: false,
          useSystemColor: false,
        );

        expect(a, isNot(equals(b)));
      });

      test('different themeMode produces inequality', () {
        const a = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.light,
          useDynamicColor: false,
          useSystemColor: false,
        );
        const b = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.dark,
          useDynamicColor: false,
          useSystemColor: false,
        );

        expect(a, isNot(equals(b)));
      });

      test('identical returns true', () {
        const a = ThemeSettings(
          seedColor: Color(0xFF6750A4),
          themeMode: ThemeMode.system,
          useDynamicColor: false,
          useSystemColor: false,
        );

        expect(a, equals(a));
      });
    });

    group('toString', () {
      test('contains key fields', () {
        final settings = ThemeSettings.defaultSettings();
        final str = settings.toString();

        expect(str, contains('ThemeSettings'));
        expect(str, contains('themeMode'));
      });
    });
  });
}
