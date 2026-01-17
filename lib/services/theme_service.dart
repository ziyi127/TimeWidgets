import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/utils/logger.dart';

/// 主题服务
/// 管理应用的主题设置，包括种子颜色、主题模式等
/// 支持 Material You 动态取色
class ThemeService {
  static const String _themeSettingsKey = 'theme_settings';

  // 单例模式实现
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  
  ThemeService._internal();

  final StreamController<ThemeSettings> _themeController = 
      StreamController<ThemeSettings>.broadcast();

  ThemeSettings _currentSettings = ThemeSettings.defaultSettings();
  bool _isInitialized = false;

  /// 主题设置流
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
    if (_isInitialized) {
      return _currentSettings;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_themeSettingsKey);

      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        _currentSettings = ThemeSettings.fromJson(jsonData);
      } else {
        _currentSettings = ThemeSettings.defaultSettings();
      }

      _isInitialized = true;
      _themeController.add(_currentSettings);
      return _currentSettings;
    } catch (e) {
      Logger.e('Error loading theme settings: $e');
      _currentSettings = ThemeSettings.defaultSettings();
      _isInitialized = true;
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
  /// 使用 Material 3 完整生成符合 MD3 规范的主题
  ThemeData generateLightTheme(Color seedColor) {
    final colorScheme = generateColorScheme(seedColor, Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        surfaceTintColor: colorScheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// 生成深色主题
  /// 使用 Material 3 完整生成符合 MD3 规范的主题
  ThemeData generateDarkTheme(Color seedColor) {
    final colorScheme = generateColorScheme(seedColor, Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        surfaceTintColor: colorScheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// 生成配色方案
  /// 使用 Material You 算法从种子颜色生成完整的 MD3 配色方案
  ColorScheme generateColorScheme(Color seedColor, Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surfaceTint: seedColor,
      // 为 MD3 完整配置所有颜色角色
      // Flutter 3.16+ 会自动处理 MD3 颜色角色映射
    );
  }

  /// 释放资源
  void dispose() {
    _themeController.close();
    Logger.i('ThemeService disposed');
  }
}
