import 'package:time_widgets/utils/logger.dart';

class StartupService {
  factory StartupService() => _instance;
  StartupService._internal();
  static final StartupService _instance = StartupService._internal();

  bool _isInitialized = false;
  bool _isEnabled = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;
    Logger.i('StartupService initialized in Flutter-only mode');
  }

  Future<bool> get isEnabled async {
    if (!_isInitialized) await initialize();
    return _isEnabled;
  }

  Future<void> enable() async {
    if (!_isInitialized) await initialize();
    _isEnabled = true;
    Logger.i('App auto-start enabled');
  }

  Future<void> disable() async {
    if (!_isInitialized) await initialize();
    _isEnabled = false;
    Logger.i('App auto-start disabled');
  }
}
