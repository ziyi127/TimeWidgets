import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/logger.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final SettingsService _settingsService;
  
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;

  WeatherViewModel({
    ApiService? apiService,
    SettingsService? settingsService,
  })  : _apiService = apiService ?? ApiService(),
        _settingsService = settingsService ?? SettingsService() {
    _init();
  }

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _init() {
    _loadCachedData();
    // 监听设置变化，如刷新间隔或城市变更
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    final settings = _settingsService.currentSettings;
    if (settings.showWeatherWidget) {
      // 如果启用了天气组件，确保刷新定时器运行
      _startAutoRefresh();
      // 如果城市变了，可能需要重新加载
      // 这里简化处理，每次设置变更且显示天气时，如果数据为空或强制刷新策略，可以刷新
    } else {
      _stopAutoRefresh();
    }
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedWeather = await CacheService.getCachedWeatherData();
      if (cachedWeather != null) {
        _weatherData = cachedWeather;
        notifyListeners();
      }
      // 加载完缓存后，尝试获取最新数据
      if (_settingsService.currentSettings.showWeatherWidget) {
        refreshWeather();
      }
    } catch (e) {
      Logger.e('Failed to load cached weather: $e');
    }
  }

  Future<void> refreshWeather() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherData = await _apiService.getWeather();
      _weatherData = weatherData;
      await CacheService.cacheWeatherData(weatherData);
      _error = null;
    } catch (e) {
      Logger.e('Error refreshing weather: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startAutoRefresh() {
    _stopAutoRefresh();
    final intervalMinutes = _settingsService.currentSettings.weatherRefreshInterval;
    if (intervalMinutes > 0) {
      _refreshTimer = Timer.periodic(
        Duration(minutes: intervalMinutes),
        (_) => refreshWeather(),
      );
    }
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
