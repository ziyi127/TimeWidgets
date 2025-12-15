import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/settings_model.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';
  
  final StreamController<AppSettings> _settingsController = 
      StreamController<AppSettings>.broadcast();
  
  AppSettings _currentSettings = AppSettings.defaultSettings();

  Stream<AppSettings> get settingsStream => _settingsController.stream;
  AppSettings get currentSettings => _currentSettings;

  Future<AppSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);
      
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        _currentSettings = AppSettings.fromJson(jsonData);
      } else {
        _currentSettings = AppSettings.defaultSettings();
      }
      
      _settingsController.add(_currentSettings);
      return _currentSettings;
    } catch (e) {
      print('Error loading settings: $e');
      _currentSettings = AppSettings.defaultSettings();
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
      print('Error saving settings: $e');
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
      print('Error resetting settings: $e');
      throw Exception('Failed to reset settings');
    }
  }

  void dispose() {
    _settingsController.close();
  }
}
