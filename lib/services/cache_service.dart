import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/logger.dart';

class CacheService {
  static const String _weatherKey = 'cached_weather_data';
  static const String _countdownKey = 'cached_countdown_data';
  static const String _weatherTimestampKey = 'weather_cache_timestamp';
  static const String _countdownTimestampKey = 'countdown_cache_timestamp';
  
  static const Duration _weatherCacheDuration = Duration(minutes: 30); // 天气数据缓存30分钟
  static const Duration _countdownCacheDuration = Duration(hours: 1); // 倒计时数据缓�?小时

  // 缓存天气数据
  static Future<void> cacheWeatherData(WeatherData weatherData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherJson = jsonEncode(weatherData.toJson());
      await prefs.setString(_weatherKey, weatherJson);
      await prefs.setInt(_weatherTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      Logger.e('缓存天气数据失败: $e');
    }
  }

  // 获取缓存的天气数�?  static Future<WeatherData?> getCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherJson = prefs.getString(_weatherKey);
      final timestamp = prefs.getInt(_weatherTimestampKey);
      
      if (weatherJson == null || timestamp == null) {
        return null;
      }
      
      // 检查缓存是否过�?      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _weatherCacheDuration) {
        return null;
      }
      
      final weatherMap = jsonDecode(weatherJson);
      return WeatherData.fromJson(weatherMap);
    } catch (e) {
      Logger.e('获取缓存天气数据失败: $e');
      return null;
    }
  }

  // 缓存倒计时数�?  static Future<void> cacheCountdownData(CountdownData countdownData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countdownJson = jsonEncode(countdownData.toJson());
      await prefs.setString(_countdownKey, countdownJson);
      await prefs.setInt(_countdownTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      Logger.e('缓存倒计时数据失�? $e');
    }
  }

  // 获取缓存的倒计时数�?  static Future<CountdownData?> getCachedCountdownData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countdownJson = prefs.getString(_countdownKey);
      final timestamp = prefs.getInt(_countdownTimestampKey);
      
      if (countdownJson == null || timestamp == null) {
        return null;
      }
      
      // 检查缓存是否过�?      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _countdownCacheDuration) {
        return null;
      }
      
      final countdownMap = jsonDecode(countdownJson);
      return CountdownData.fromJson(countdownMap);
    } catch (e) {
      Logger.e('获取缓存倒计时数据失�? $e');
      return null;
    }
  }

  // 清除所有缓�?  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_weatherKey);
      await prefs.remove(_weatherTimestampKey);
      await prefs.remove(_countdownKey);
      await prefs.remove(_countdownTimestampKey);
    } catch (e) {
      Logger.e('清除所有缓存失�? $e');
    }
  }

  // 清除天气缓存
  static Future<void> clearWeatherCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_weatherKey);
      await prefs.remove(_weatherTimestampKey);
    } catch (e) {
      Logger.e('清除天气缓存失败: $e');
    }
  }

  // 清除倒计时缓�?  static Future<void> clearCountdownCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_countdownKey);
      await prefs.remove(_countdownTimestampKey);
    } catch (e) {
      Logger.e('清除倒计时缓存失�? $e');
    }
  }
}
