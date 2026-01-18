import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/weather_service.dart';
import 'package:time_widgets/utils/error_handler.dart';
import 'package:time_widgets/utils/logger.dart';

class ApiService {
  final WeatherService _weatherService = WeatherService();
  final SettingsService _settingsService = SettingsService();
  final CountdownStorageService _countdownStorage = CountdownStorageService();

  // 获取课程表数据
  // Note: Since we are using local storage, this method is primarily for API sync if we had a server.
  // For now, we throw to indicate no remote source.
  Future<Timetable> getTimetable(DateTime date) async {
    throw Exception('No API server available');
  }

  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    throw Exception('No API server available');
  }

  // 获取天气信息 - Real Implementation
  Future<WeatherData> getWeather() async {
    try {
      await _settingsService.loadSettings();
      final settings = _settingsService.currentSettings;

      if (settings.latitude != null && settings.longitude != null) {
        final weather = await _weatherService.getWeather(
          settings.latitude!,
          settings.longitude!,
          cityName: settings.cityName,
        );
        if (weather != null) return weather;
      }

      // Fallback to Beijing if no settings
      final defaultWeather = await _weatherService.getWeather(
        39.9042,
        116.4074,
        cityName: 'Beijing',
      );
      if (defaultWeather != null) return defaultWeather;

      throw Exception('Failed to fetch weather');
    } catch (e) {
      final appError = ErrorHandler.handleNetworkError(e);
      Logger.e('Failed to fetch weather from API: ${appError.message}');
      return WeatherData(
        cityName: 'Beijing',
        description: 'Unknown',
        temperature: 0,
        temperatureRange: '0°C~0°C',
        aqiLevel: 0,
        humidity: 0,
        wind: 'N/A',
        pressure: 1000,
        sunrise: '06:00',
        sunset: '18:00',
        weatherType: 0,
        weatherIcon: 'weather_0.png',
        feelsLike: 0,
        visibility: '0',
        uvIndex: '0',
        pubTime: DateTime.now().toIso8601String(),
      );
    }
  }

  // 获取倒计时信息 - Real Implementation (Local Storage)
  Future<CountdownData> getCountdown() async {
    try {
      final next = await _countdownStorage.getNextCountdown();
      if (next != null) {
        return next;
      }

      // Return a default "No Countdown" placeholder
      return CountdownData(
        id: 'default',
        title: '暂无倒计时',
        description: '点击添加',
        targetDate: DateTime.now().add(const Duration(days: 1)),
        type: 'other',
        progress: 0,
        category: 'General',
      );
    } catch (e) {
      final appError = ErrorHandler.handleStorageError(e);
      Logger.e('Failed to fetch countdown: ${appError.message}');
      rethrow;
    }
  }
}
