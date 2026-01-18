import 'dart:async';
import 'package:ntp/ntp.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/logger.dart';

class NtpService {
  factory NtpService() => _instance;
  NtpService._internal();
  static final NtpService _instance = NtpService._internal();

  final SettingsService _settingsService = SettingsService();
  Timer? _syncTimer;
  StreamSubscription<dynamic>? _settingsSubscription;
  int _ntpOffset = 0; // Offset in milliseconds
  bool _isSyncing = false;

  /// Get current offset in milliseconds
  int get offset => _ntpOffset;

  /// Get the current time corrected by NTP offset
  /// If NTP sync is disabled, returns system time
  DateTime get now {
    if (!_settingsService.currentSettings.enableNtpSync) {
      return DateTime.now();
    }
    return DateTime.now().add(Duration(milliseconds: _ntpOffset));
  }

  Future<void> initialize() async {
    // Listen to settings changes to restart sync if needed
    _settingsSubscription = _settingsService.settingsStream.listen((settings) {
      // Check if relevant settings changed to avoid unnecessary restarts
      // But simple restart is fine
      _restartSync();
    });

    // Initial sync if enabled
    if (_settingsService.currentSettings.enableNtpSync) {
      await syncTime();
      _startTimer();
    }
  }

  void dispose() {
    _syncTimer?.cancel();
    _settingsSubscription?.cancel();
    Logger.i('NtpService disposed');
  }

  void _startTimer() {
    _syncTimer?.cancel();
    if (!_settingsService.currentSettings.enableNtpSync) return;

    final intervalMinutes = _settingsService.currentSettings.ntpSyncInterval;
    // Ensure minimum interval of 1 minute
    final safeInterval = intervalMinutes < 1 ? 1 : intervalMinutes;

    Logger.i('Starting NTP sync timer with interval: $safeInterval minutes');
    _syncTimer = Timer.periodic(Duration(minutes: safeInterval), (timer) {
      syncTime();
    });
  }

  void _restartSync() {
    _syncTimer?.cancel();
    if (_settingsService.currentSettings.enableNtpSync) {
      _startTimer();
      // Also sync immediately if we just enabled it or changed server
      // But maybe we should debounce this if it's called frequently
      // For now, let's just sync.
      syncTime();
    } else {
      _ntpOffset = 0; // Reset offset if disabled
      Logger.i('NTP Sync disabled, resetting offset');
    }
  }

  Future<void> syncTime() async {
    if (_isSyncing) return;
    if (!_settingsService.currentSettings.enableNtpSync) return;

    _isSyncing = true;
    try {
      final server = _settingsService.currentSettings.ntpServer;
      Logger.i('Syncing time with NTP server: $server');

      final offset = await NTP.getNtpOffset(
        lookUpAddress: server,
        timeout: const Duration(seconds: 10),
      );

      _ntpOffset = offset;
      Logger.i(
        'NTP Sync successful. Offset: $_ntpOffset ms. Corrected time: $now',
      );
    } catch (e) {
      Logger.e('NTP Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
