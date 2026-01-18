import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/services/theme_service.dart';

void main() {
  group('ThemeService Tests', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
      // 清理 SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      themeService.dispose();
    });

    test('should save and load seed color correctly', () async {
      const testColor = Color(0xFFFF5722); // Orange color

      // 设置种子颜色
      await themeService.setSeedColor(testColor);

      // 获取种子颜色
      final loadedColor = await themeService.getSeedColor();

      expect(loadedColor.toARGB32(), equals(testColor.toARGB32()));
    });

    test('should persist theme settings across service instances', () async {
      const testColor = Color(0xFF2196F3); // Blue color
      const testSettings = ThemeSettings(
        seedColor: testColor,
        themeMode: ThemeMode.dark,
        useDynamicColor: false,
        useSystemColor: true,
      );

      // 保存设置
      await themeService.saveSettings(testSettings);

      // 创建新的服务实例
      final newThemeService = ThemeService();
      final loadedSettings = await newThemeService.loadSettings();

      expect(loadedSettings.seedColor.toARGB32(), equals(testColor.toARGB32()));
      expect(loadedSettings.themeMode, equals(ThemeMode.dark));
      expect(loadedSettings.useDynamicColor, isFalse);
      expect(loadedSettings.useSystemColor, isTrue);

      newThemeService.dispose();
    });

    test('should use default settings when no saved settings exist', () async {
      final loadedSettings = await themeService.loadSettings();
      final defaultSettings = ThemeSettings.defaultSettings();

      expect(loadedSettings.seedColor.toARGB32(), equals(defaultSettings.seedColor.toARGB32()));
      expect(loadedSettings.themeMode, equals(defaultSettings.themeMode));
      expect(loadedSettings.useDynamicColor, equals(defaultSettings.useDynamicColor));
      expect(loadedSettings.useSystemColor, equals(defaultSettings.useSystemColor));
    });

    test('should emit theme changes through stream', () async {
      const testColor1 = Color(0xFFE91E63); // Pink
      const testColor2 = Color(0xFF4CAF50); // Green

      final streamEvents = <ThemeSettings>[];
      final subscription = themeService.themeStream.listen(streamEvents.add);

      // 设置第一个颜色
      await themeService.setSeedColor(testColor1);
      await Future.delayed(const Duration(milliseconds: 10));

      // 设置第二个颜色
      await themeService.setSeedColor(testColor2);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(streamEvents.length, greaterThanOrEqualTo(2));
      expect(streamEvents.last.seedColor.toARGB32(), equals(testColor2.toARGB32()));

      await subscription.cancel();
    });

    test('should generate consistent themes for same seed color', () {
      const seedColor = Color(0xFF9C27B0); // Purple
      final defaultSettings = ThemeSettings.defaultSettings();

      final theme1 = themeService.generateLightTheme(seedColor, defaultSettings);
      final theme2 = themeService.generateLightTheme(seedColor, defaultSettings);

      expect(theme1.colorScheme.primary, equals(theme2.colorScheme.primary));
      expect(theme1.colorScheme.secondary, equals(theme2.colorScheme.secondary));
      expect(theme1.useMaterial3, isTrue);
      expect(theme2.useMaterial3, isTrue);
    });

    test('should generate different themes for different seed colors', () {
      const seedColor1 = Color(0xFF9C27B0); // Purple
      const seedColor2 = Color(0xFFFF9800); // Orange
      final defaultSettings = ThemeSettings.defaultSettings();

      final theme1 = themeService.generateLightTheme(seedColor1, defaultSettings);
      final theme2 = themeService.generateLightTheme(seedColor2, defaultSettings);

      expect(theme1.colorScheme.primary, isNot(equals(theme2.colorScheme.primary)));
    });

    test('should handle invalid saved data gracefully', () async {
      // 设置无效的 JSON 数据
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_settings', 'invalid json');

      final loadedSettings = await themeService.loadSettings();
      final defaultSettings = ThemeSettings.defaultSettings();

      // 应该回退到默认设置
      expect(loadedSettings.seedColor.toARGB32(), equals(defaultSettings.seedColor.toARGB32()));
      expect(loadedSettings.themeMode, equals(defaultSettings.themeMode));
    });
  });
}