import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_widgets/screens/settings_screen.dart';
import 'package:time_widgets/screens/timetable_edit_screen.dart';
import 'package:time_widgets/services/countdown_storage_service.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';
import 'package:time_widgets/services/global_animation_service.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/services/md3_tray_menu_service.dart';
import 'package:time_widgets/services/performance_optimization_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/utils/page_transitions.dart';
import 'package:time_widgets/utils/responsive_utils.dart';
import 'package:time_widgets/widgets/dialogs/temp_schedule_menu_dialog.dart';

class DesktopController extends ChangeNotifier {
  DesktopController({
    required SettingsService settingsService,
    required this.navigatorKey,
  }) : _settingsService = settingsService {
    _settingsService.addListener(_onSettingsChanged);
  }
  final SettingsService _settingsService;
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isWindowVisible = true;
  bool _isWindowInitialized = false;
  bool _showTrayMenu = false;
  bool _isEditMode = false;

  bool get isWindowVisible => _isWindowVisible;
  bool get isWindowInitialized => _isWindowInitialized;
  bool get showTrayMenu => _showTrayMenu;
  bool get isEditMode => _isEditMode;

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    MD3TrayMenuService.instance.destroy();

    GlobalAnimationService.instance.dispose();
    EnhancedWindowManager.dispose();
    PerformanceOptimizationService.stopMemoryMonitoring();
    PerformanceOptimizationService.stopPerformanceMonitoring();
    CountdownStorageService().dispose();

    super.dispose();
  }

  void _onSettingsChanged() {
    final settings = _settingsService.currentSettings;

    if (ResponsiveUtils.scaleFactor != settings.uiScale) {
      ResponsiveUtils.scaleFactor = settings.uiScale;
      notifyListeners();
    }

    // 只在窗口初始化后处理显示/隐藏
    if (!_isWindowInitialized) return;

    if (!settings.enableDesktopWidgets && !_showTrayMenu && !_isEditMode) {
      if (_isWindowVisible) {
        hideMainWindow();
      }
    } else if (settings.enableDesktopWidgets) {
      if (!_isWindowVisible) {
        showMainWindow();
      }
    }
  }

  Future<void> initializeWindow() async {
    if (_isWindowInitialized) return;

    try {
      final success = await EnhancedWindowManager.initializeWindow(
        onScreenSizeChanged: notifyListeners,
      );

      if (!success) {
        Logger.w(
            'Enhanced window initialization failed, falling back to default');
      }

      _isWindowInitialized = true;
      notifyListeners();
      Logger.i('窗口初始化成功');
    } catch (e) {
      Logger.e('窗口初始化失败: $e');
      _isWindowInitialized = true;
      notifyListeners();
    }
  }

  Future<void> initializeSystemTray() async {
    try {
      final trayService = MD3TrayMenuService.instance;

      trayService.onShowSettings = navigateToSettings;
      trayService.onShowTimetableEdit = navigateToTimetableEdit;
      trayService.onToggleWindow = toggleMainWindow;
      trayService.onToggleEditMode = toggleEditMode;
      trayService.onExit = exitApplication;
      trayService.onTempScheduleChange = showTempScheduleChangeMenu;
      trayService.onShowMD3Menu = showMD3TrayMenu;

      final success = await trayService.initialize();
      if (success) {
        Logger.i('系统托盘初始化成功');
      } else {
        Logger.w('系统托盘初始化失败，已降级为无托盘模式');
      }
    } catch (e) {
      Logger.e('系统托盘初始化失败: $e');
    }
  }

  void showMD3TrayMenu() {
    if (!_isWindowVisible) showMainWindow();
    _showTrayMenu = true;
    notifyListeners();
  }

  void hideMD3TrayMenu() {
    _showTrayMenu = false;
    notifyListeners();

    if (!_settingsService.currentSettings.enableDesktopWidgets &&
        !_isEditMode) {
      hideMainWindow();
    }
  }

  void toggleMainWindow() {
    hideMD3TrayMenu();
    if (_isWindowVisible) {
      hideMainWindow();
    } else {
      showMainWindow();
    }
  }

  void toggleEditMode() {
    hideMD3TrayMenu();
    if (!_isWindowVisible) showMainWindow();

    _isEditMode = !_isEditMode;
    notifyListeners();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? LocalizationService.getString('enter_edit_mode')
                : LocalizationService.getString('exit_edit_mode'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      if (!_isEditMode &&
          !_settingsService.currentSettings.enableDesktopWidgets) {
        hideMainWindow();
      }
    }
  }

  void showMainWindow() {
    unawaited(EnhancedWindowManager.showWindow());
    _isWindowVisible = true;
    notifyListeners();
  }

  void hideMainWindow() {
    unawaited(EnhancedWindowManager.hideWindow());
    _isWindowVisible = false;
    notifyListeners();
  }

  Future<void> exitApplication() async {
    await MD3TrayMenuService.instance.destroy();
    exit(0);
  }

  Future<void> onWindowClose() async {
    final settings = _settingsService.currentSettings;
    if (settings.minimizeToTray) {
      await EnhancedWindowManager.hideWindow();
      _isWindowVisible = false;
      notifyListeners();
    } else {
      await exitApplication();
    }
  }

  void navigateToSettings() {
    hideMD3TrayMenu();
    final context = navigatorKey.currentContext;
    if (context == null) return;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => const Dialog.fullscreen(
          child: SettingsScreen(),
        ),
      ),
    );
  }

  Future<void> navigateToTimetableEdit() async {
    hideMD3TrayMenu();
    await EnhancedWindowManager.createEditWindow('课表编辑');
    await EnhancedWindowManager.setIgnoreMouseEvents(false);

    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.push(
        SmoothPageRoute<void>(
          builder: (context) => const TimetableEditScreen(),
        ),
      );
      await EnhancedWindowManager.restoreMainWindow();
    }
  }

  void showTempScheduleChangeMenu() {
    hideMD3TrayMenu();
    if (!_isWindowVisible) showMainWindow();

    final context = navigatorKey.currentContext;
    if (context == null) return;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => const TempScheduleMenuDialog(),
      ),
    );
  }
}
