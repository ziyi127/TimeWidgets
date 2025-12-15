import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/utils/logger.dart';

/// 主题服务
/// 管理应用的主题设置，包括种子颜色、主题模式等
/// 支持 Material You 动态取�?
class ThemeService {
  static const String _themeSettingsKey = 'theme_settings';

  final StreamController<ThemeSettings> _themeController =
      StreamController<ThemeSettings>.broadcast();

  ThemeSettings _currentSettings = ThemeSettings.defaultSettings();

  /// 主题设置�?
  Stream<ThemeSettings> get themeStream => _themeController.stream;

  /// 当前主题设置
  ThemeSettings get currentSettings => _currentSettings;

  /// 获取种子颜色
  Future<Color> getSeedColor() async {
    final settings = await loadSettings();
    return settings.seedColor;
  }

  /// 设置种子颜色
  Future<void> setSeedColor(Color color) async {
    final newSettings = _currentSettings.copyWith(seedColor: color);
    await saveSettings(newSettings);
  }

  /// 加载主题设置
  Future<ThemeSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_themeSettingsKey);

      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        _currentSettings = ThemeSettings.fromJson(jsonData);
      } else {
        _currentSettings = ThemeSettings.defaultSettings();
      }

      _themeController.add(_currentSettings);
      return _currentSettings;
    } catch (e) {
      Logger.e('Error loading theme settings: $e');
      _currentSettings = ThemeSettings.defaultSettings();
      return _currentSettings;
    }
  }

  /// 保存主题设置
  Future<void> saveSettings(ThemeSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = settings.toJson();
      await prefs.setString(_themeSettingsKey, jsonEncode(jsonData));
      _currentSettings = settings;
      _themeController.add(_currentSettings);
    } catch (e) {
      Logger.e('Error saving theme settings: $e');
      throw Exception('Failed to save theme settings');
    }
  }

  /// 生成浅色主题
  /// 使用 Material 3 �?ColorScheme.fromSeed 生成完整配色方案
  ThemeData generateLightTheme(Color seedColor) {
    final colorScheme = generateColorScheme(seedColor, Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// 生成深色主题
  /// 使用 Material 3 �?ColorScheme.fromSeed 生成完整配色方案
  ThemeData generateDarkTheme(Color seedColor) {
    final colorScheme = generateColorScheme(seedColor, Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// 生成配色方案
  /// 使用 Material You 算法从种子颜色生成完整的配色方案
  ColorScheme generateColorScheme(Color seedColor, Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  }

  /// 释放资源
  void dispose() {
    _themeController.close();
  }
}
