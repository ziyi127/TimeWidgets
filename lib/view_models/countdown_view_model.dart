import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/logger.dart';

class CountdownViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final SettingsService _settingsService;
  final CountdownStorageService _storageService;

  CountdownData? _countdownData;
  bool _isLoading = true;
  String? _error;
  
  StreamSubscription<dynamic>? _storageSubscription;
  Timer? _refreshTimer;

  CountdownViewModel({
    ApiService? apiService,
    SettingsService? settingsService,
    CountdownStorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _settingsService = settingsService ?? SettingsService(),
        _storageService = storageService ?? CountdownStorageService() {
    _init();
  }

  CountdownData? get countdownData => _countdownData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _init() {
    _loadCachedData();
    _startListeningToChanges();
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    _storageSubscription?.cancel();
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _startListeningToChanges() {
    _storageSubscription = _storageService.onChange.listen((_) {
      refreshCountdown();
    });
  }

  void _onSettingsChanged() {
    final settings = _settingsService.currentSettings;
    if (settings.showCountdownWidget) {
      _startAutoRefresh();
    } else {
      _stopAutoRefresh();
    }
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedCountdown = await CacheService.getCachedCountdownData();
      if (cachedCountdown != null) {
        _countdownData = cachedCountdown;
        _isLoading = false;
        notifyListeners();
      }
      
      if (_settingsService.currentSettings.showCountdownWidget) {
        refreshCountdown();
      }
    } catch (e) {
      Logger.e('Failed to load cached countdown: $e');
    }
  }

  Future<void> refreshCountdown() async {
    // 如果没有缓存且正在加载，保持加载状态
    // 如果已有数据，则静默更新
    if (_countdownData == null) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final countdownData = await _apiService.getCountdown();
      _countdownData = countdownData;
      await CacheService.cacheCountdownData(countdownData);
      _error = null;
    } catch (e) {
      Logger.e('Error refreshing countdown: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startAutoRefresh() {
    _stopAutoRefresh();
    final intervalSeconds = _settingsService.currentSettings.countdownRefreshInterval;
    if (intervalSeconds > 0) {
      _refreshTimer = Timer.periodic(
        Duration(seconds: intervalSeconds),
        (_) => refreshCountdown(),
      );
    }
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
