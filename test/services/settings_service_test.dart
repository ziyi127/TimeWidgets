import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/services/settings_service.dart';

void main() {
  group('SettingsService', () {
    late SettingsService settingsService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      // Reset the singleton state by creating a fresh instance via factory
      settingsService = SettingsService();
    });

    test('loadSettings returns default settings when no data stored', () async {
      final settings = await settingsService.loadSettings();

      expect(settings.language, 'zh');
      expect(settings.enableDebugMode, false);
    });

    test('saveSettings persists and broadcasts settings', () async {
      final customSettings = AppSettings.defaultSettings().copyWith(
        language: 'en',
        enableDebugMode: true,
        uiScale: 1.5,
      );

      await settingsService.saveSettings(customSettings);

      final loaded = settingsService.currentSettings;

      expect(loaded.language, 'en');
      expect(loaded.enableDebugMode, true);
      expect(loaded.uiScale, 1.5);
    });

    test('resetToDefaults clears stored settings', () async {
      // Save custom settings first
      final customSettings = AppSettings.defaultSettings().copyWith(
        language: 'en',
        enableDebugMode: true,
      );
      await settingsService.saveSettings(customSettings);

      // Reset
      await settingsService.resetToDefaults();

      final current = settingsService.currentSettings;
      final defaults = AppSettings.defaultSettings();

      expect(current.language, defaults.language);
      expect(current.enableDebugMode, defaults.enableDebugMode);
    });

    test('currentSettings returns latest saved settings', () async {
      final settings1 = AppSettings.defaultSettings().copyWith(language: 'en');
      await settingsService.saveSettings(settings1);
      expect(settingsService.currentSettings.language, 'en');

      final settings2 = settings1.copyWith(language: 'ja');
      await settingsService.saveSettings(settings2);
      expect(settingsService.currentSettings.language, 'ja');
    });

    test('settingsStream emits on save', () async {
      final future = settingsService.settingsStream.first;

      final settings = AppSettings.defaultSettings().copyWith(
        cityName: 'Tokyo',
      );
      await settingsService.saveSettings(settings);

      final emitted = await future;
      expect(emitted.cityName, 'Tokyo');
    });

    test('settingsStream emits on reset', () async {
      // Save first so stream has something to emit on reset
      await settingsService.saveSettings(
        AppSettings.defaultSettings().copyWith(cityName: 'London'),
      );

      final future = settingsService.settingsStream.first;
      await settingsService.resetToDefaults();

      final emitted = await future;
      expect(emitted.cityName, AppSettings.defaultSettings().cityName);
    });
  });
}
