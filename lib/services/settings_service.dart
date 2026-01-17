import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/utils/logger.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';
  
  // 单例模式实现
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  
  SettingsService._internal();
  
  final StreamController<AppSettings> _settingsController = 
      StreamController<AppSettings>.broadcast();
  
  AppSettings _currentSettings = AppSettings.defaultSettings();
  bool _isInitialized = false;

  Stream<AppSettings> get settingsStream => _settingsController.stream;
  AppSettings get currentSettings => _currentSettings;

  Future<AppSettings> loadSettings() async {
    if (_isInitialized) {
      return _currentSettings;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);
      
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        _currentSettings = AppSettings.fromJson(jsonData);
      } else {
        _currentSettings = AppSettings.defaultSettings();
      }
      
      _isInitialized = true;
      _settingsController.add(_currentSettings);
      return _currentSettings;
    } catch (e) {
      Logger.e('Error loading settings: $e');
      _currentSettings = AppSettings.defaultSettings();
      _isInitialized = true;
      return _currentSettings;
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = settings.toJson();
      await prefs.setString(_settingsKey, jsonEncode(jsonData));
      _currentSettings = settings;
      _settingsController.add(_currentSettings);
    } catch (e) {
      Logger.e('Error saving settings: $e');
      throw Exception('Failed to save settings');
    }
  }

  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
      _currentSettings = AppSettings.defaultSettings();
      _settingsController.add(_currentSettings);
    } catch (e) {
      Logger.e('Error resetting settings: $e');
      throw Exception('Failed to reset settings');
    }
  }

  /// 释放资源
  /// 用于测试环境，重置单例状态
  void dispose() {
    // 测试环境下重置状态
    _isInitialized = false;
    _currentSettings = AppSettings.defaultSettings();
    _settingsController.close();
    Logger.i('SettingsService disposed');
  }
}
