import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:time_widgets/utils/logger.dart';

class StartupService {
  factory StartupService() => _instance;
  StartupService._internal();
  static final StartupService _instance = StartupService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 仅在桌面端支持
    if (kIsWeb ||
        (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
      return;
    }

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      launchAtStartup.setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
        // 可选：如果是 Windows，可以设置参数
        // args: <String>['--minimized'],
      );

      _isInitialized = true;
      Logger.i('StartupService initialized for ${packageInfo.appName}');
    } catch (e) {
      Logger.e('Failed to initialize StartupService: $e');
    }
  }

  Future<bool> get isEnabled async {
    if (!_isInitialized) await initialize();
    return launchAtStartup.isEnabled();
  }

  Future<void> enable() async {
    if (!_isInitialized) await initialize();
    await launchAtStartup.enable();
    Logger.i('App auto-start enabled');
  }

  Future<void> disable() async {
    if (!_isInitialized) await initialize();
    await launchAtStartup.disable();
    Logger.i('App auto-start disabled');
  }
}
