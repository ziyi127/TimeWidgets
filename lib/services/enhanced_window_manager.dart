import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:time_widgets/utils/logger.dart';

/// 跨平台窗口管理适配层（纯 Flutter 实现）
///
/// 说明：
/// 1. 不再依赖 window_manager/screen_retriever 等桌面插件。
/// 2. 所有窗口操作降级为安全的内存状态管理，确保在各平台可运行。
class EnhancedWindowManager {
  static bool _isInitialized = false;
  static Size? _lastScreenSize;
  static VoidCallback? _onScreenSizeChanged;
  static Timer? _screenMonitorTimer;

  static Size? _mainWindowSize;
  static Offset? _mainWindowPosition;

  /// 初始化窗口状态
  static Future<bool> initializeWindow({
    VoidCallback? onScreenSizeChanged,
  }) async {
    if (_isInitialized) return true;

    _onScreenSizeChanged = onScreenSizeChanged;

    try {
      _lastScreenSize = _getCurrentScreenSize();
      _startScreenMonitoring();
      _isInitialized = true;
      Logger.i('EnhancedWindowManager initialized in Flutter-only mode');
      return true;
    } catch (e) {
      Logger.e('EnhancedWindowManager initialize failed: $e');
      return false;
    }
  }

  /// 创建编辑窗口（纯 Flutter 模式下仅记录状态）
  static Future<void> createEditWindow(String title) async {
    _mainWindowSize ??= _getCurrentScreenSize();
    _mainWindowPosition ??= Offset.zero;
    Logger.i('createEditWindow called in Flutter-only mode: $title');
  }

  /// 恢复主窗口（纯 Flutter 模式下仅清理状态）
  static Future<void> restoreMainWindow() async {
    _mainWindowSize = null;
    _mainWindowPosition = null;
    Logger.i('restoreMainWindow called in Flutter-only mode');
  }

  static Future<Rect?> getCurrentBounds() async {
    final size = _getCurrentScreenSize();
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  static Future<void> updatePosition(Offset position) async {
    _mainWindowPosition = position;
  }

  static Future<void> updateSize(Size size) async {
    _mainWindowSize = size;
  }

  static Future<void> showWindow() async {
    Logger.i('showWindow called in Flutter-only mode');
  }

  static Future<void> hideWindow() async {
    Logger.i('hideWindow called in Flutter-only mode');
  }

  static Future<void> setIgnoreMouseEvents(bool ignore) async {
    Logger.i('setIgnoreMouseEvents($ignore) ignored in Flutter-only mode');
  }

  static bool get isInitialized => _isInitialized;
  static Size? get lastScreenSize => _lastScreenSize;

  static void dispose() {
    _screenMonitorTimer?.cancel();
    _screenMonitorTimer = null;
  }

  static void _startScreenMonitoring() {
    _screenMonitorTimer?.cancel();
    _screenMonitorTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final current = _getCurrentScreenSize();
      if (_lastScreenSize != null && current != _lastScreenSize) {
        Logger.i('Screen size changed from $_lastScreenSize to $current');
        _lastScreenSize = current;
        _onScreenSizeChanged?.call();
      }
    });
  }

  static Size _getCurrentScreenSize() {
    final dispatcher = ui.PlatformDispatcher.instance;
    final views = dispatcher.views;
    if (views.isEmpty) {
      return const Size(1280, 720);
    }

    final view = views.first;
    final pixelRatio = view.devicePixelRatio == 0 ? 1.0 : view.devicePixelRatio;
    final physical = view.physicalSize;
    return Size(physical.width / pixelRatio, physical.height / pixelRatio);
  }
}
