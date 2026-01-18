import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:time_widgets/utils/logger.dart';
import 'package:window_manager/window_manager.dart';

/// 增强的窗口管理器
/// 提供可靠的窗口初始化、定位和状态管理
class EnhancedWindowManager {
  static bool _isInitialized = false;
  static Size? _lastScreenSize;
  static VoidCallback? _onScreenSizeChanged;
  static Timer? _screenMonitorTimer;

  /// 初始化窗口
  static Future<bool> initializeWindow(
      {VoidCallback? onScreenSizeChanged}) async {
    if (_isInitialized) return true;

    _onScreenSizeChanged = onScreenSizeChanged;

    try {
      // 确保窗口管理器已初始化
      await windowManager.ensureInitialized();

      // 等待一帧以确保Flutter完全初始化
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 获取屏幕信息
      final screenInfo = await _getScreenInfo();
      if (screenInfo == null) {
        Logger.w('Failed to get screen info, using default size');
        return await _initializeWithDefaultSize();
      }

      _lastScreenSize = screenInfo;

      // 计算窗口尺寸和位置
      final windowBounds = _calculateWindowBounds(screenInfo);

      // 设置窗口属性
      await _configureWindow(windowBounds);

      // 初始化bitsdojo_window
      _initializeBitsdojoWindow();

      // 监听屏幕变化
      _startScreenMonitoring();

      _isInitialized = true;
      Logger.i(
          'Window initialized successfully: ${windowBounds.size} at ${windowBounds.topLeft}');
      return true;
    } catch (e) {
      Logger.e('Window initialization failed: $e');
      return _initializeWithDefaultSize();
    }
  }

  /// 保存主窗口原始尺寸和位置
  static Size? _mainWindowSize;
  static Offset? _mainWindowPosition;

  /// 创建独立的16:9窗口
  /// 用于编辑页面，如设置、课表编辑等
  static Future<void> createEditWindow(String title) async {
    try {
      // 确保窗口管理器已初始化
      await windowManager.ensureInitialized();

      // 保存主窗口原始尺寸和位置
      _mainWindowSize ??= await windowManager.getSize();
      _mainWindowPosition ??= await windowManager.getPosition();

      // 获取屏幕尺寸
      final screenSize = await _getScreenInfo() ?? const Size(1920, 1080);

      // 计算16:9窗口尺寸（基于屏幕高度的80%）
      final windowHeight = screenSize.height * 0.8;
      final windowWidth = windowHeight * (16 / 9);

      // 确保窗口尺寸不超过屏幕尺寸
      final finalWidth = windowWidth.clamp(800.0, screenSize.width - 100);
      final finalHeight = finalWidth * (9 / 16);

      // 计算窗口位置（居中）
      final windowX = (screenSize.width - finalWidth) / 2;
      final windowY = (screenSize.height - finalHeight) / 2;

      // 创建新窗口配置
      final bounds = Rect.fromLTWH(windowX, windowY, finalWidth, finalHeight);

      // 设置窗口属性
      await windowManager.setSize(bounds.size);
      await windowManager.setPosition(bounds.topLeft);

      // 使用系统默认窗口样式，带边框和标题栏
      // 不要设置为无框窗口
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(true);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      await windowManager.setResizable(true);
      await windowManager.show();

      // 设置窗口标题
      appWindow.title = title;

      Logger.i(
          'Created edit window: $title, size: ${bounds.size} at ${bounds.topLeft}');
    } catch (e) {
      Logger.e('Error creating edit window: $e');
      rethrow;
    }
  }

  /// 恢复主窗口原始尺寸和位置
  static Future<void> restoreMainWindow() async {
    try {
      if (_mainWindowSize != null && _mainWindowPosition != null) {
        await windowManager.setSize(_mainWindowSize!);
        await windowManager.setPosition(_mainWindowPosition!);
        await windowManager.setAsFrameless();
        await windowManager.setResizable(false);
        await windowManager.setHasShadow(false);
        await windowManager.setBackgroundColor(Colors.transparent);

        // 设置窗口层级 - 确保主窗口回到桌面背景层
        await windowManager.setAlwaysOnTop(false);
        await windowManager.setAlwaysOnBottom(true);

        // 重置保存的主窗口信息
        _mainWindowSize = null;
        _mainWindowPosition = null;

        Logger.i('Restored main window to original size and position');
      }
    } catch (e) {
      Logger.e('Error restoring main window: $e');
    }
  }

  /// 获取屏幕信息
  static Future<Size?> _getScreenInfo() async {
    try {
      // 优先使用系统调用获取准确的屏幕尺寸（Windows）
      if (Platform.isWindows) {
        return await _getWindowsScreenSize();
      }

      // 其他平台暂时返回null，触发默认尺寸回退
      return null;
    } catch (e) {
      Logger.e('Error getting screen info: $e');
      return null;
    }
  }

  /// 获取Windows屏幕尺寸
  static Future<Size?> _getWindowsScreenSize() async {
    try {
      // 使用PowerShell获取屏幕分辨率
      final result = await Process.run('powershell', [
        '-Command',
        'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final regex = RegExp(r'Width=(\d+).*Height=(\d+)');
        final match = regex.firstMatch(output);

        if (match != null) {
          final widthStr = match.group(1);
          final heightStr = match.group(2);
          if (widthStr != null && heightStr != null) {
            final width = double.tryParse(widthStr);
            final height = double.tryParse(heightStr);
            if (width != null && height != null) {
              return Size(width, height);
            }
          }
        }
      }
    } catch (e) {
      Logger.e('Failed to get Windows screen size: $e');
    }

    return null;
  }

  /// 计算窗口边界
  static Rect _calculateWindowBounds(Size screenSize) {
    // 窗口宽度为屏幕宽度的1/4
    final windowWidth = screenSize.width / 4;
    final windowHeight = screenSize.height;

    // 窗口位置在屏幕右
    const windowY = 0.0;

    // 确保最小尺寸
    const minWidth = 300.0;
    const minHeight = 600.0;

    final finalWidth = windowWidth.clamp(minWidth, screenSize.width);
    final finalHeight = windowHeight.clamp(minHeight, screenSize.height);
    final finalX = (screenSize.width - finalWidth).clamp(0.0, screenSize.width);

    return Rect.fromLTWH(finalX, windowY, finalWidth, finalHeight);
  }

  /// 配置窗口属性
  static Future<void> _configureWindow(Rect bounds) async {
    try {
      // 设置窗口尺寸
      await windowManager.setSize(bounds.size);

      // 设置窗口位置
      await windowManager.setPosition(bounds.topLeft);

      // 设置窗口样式
      await windowManager.setAsFrameless();
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(false);

      // 设置窗口层级 - 在桌面背景上显示，但不遮挡其他应用
      // 这样Win+D时会显示，同时不会影响其他应用
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(true);

      // 禁用鼠标穿透，确保小组件可以交互
      await windowManager.setIgnoreMouseEvents(false);

      // 设置窗口可调整大小（可选）
      await windowManager.setResizable(false);

      // 确保窗口可见
      await windowManager.show();

      // 防止窗口直接关闭，交由应用层处理（实现最小化到托盘）
      await windowManager.setPreventClose(true);
    } catch (e) {
      Logger.e('Error configuring window: $e');
      rethrow;
    }
  }

  /// 初始化bitsdojo_window
  static void _initializeBitsdojoWindow() {
    try {
      doWhenWindowReady(() {
        final win = appWindow;
        win.title = "智慧课程表";
        win.show();
      });
    } catch (e) {
      Logger.e('Error initializing bitsdojo_window: $e');
    }
  }

  /// 使用默认尺寸初始化
  static Future<bool> _initializeWithDefaultSize() async {
    try {
      const defaultSize = Size(480, 1080);
      const defaultPosition = Offset(1440, 0); // 假设1920x1080屏幕

      await windowManager.setSize(defaultSize);
      await windowManager.setPosition(defaultPosition);
      await windowManager.setAsFrameless();
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(false);
      // 设置窗口层级 - 在桌面背景上显示，但不遮挡其他应用
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(true);
      // 禁用鼠标穿透，确保小组件可以交互
      await windowManager.setIgnoreMouseEvents(false);
      await windowManager.show();
      await windowManager.setPreventClose(true);

      _initializeBitsdojoWindow();
      _isInitialized = true;

      Logger.i(
          'Window initialized with default size: $defaultSize at $defaultPosition');
      return true;
    } catch (e) {
      Logger.e('Failed to initialize with default size: $e');
      return false;
    }
  }

  /// 开始屏幕监听
  static void _startScreenMonitoring() {
    // 停止之前的定时器
    _screenMonitorTimer?.cancel();

    // 减少检查频率，从5秒改为30秒
    _screenMonitorTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final currentSize = await _getScreenInfo();
        if (currentSize != null &&
            _lastScreenSize != null &&
            currentSize != _lastScreenSize) {
          Logger.i('Screen size changed from $_lastScreenSize to $currentSize');
          _lastScreenSize = currentSize;

          // 重新计算窗口位置
          final newBounds = _calculateWindowBounds(currentSize);
          await _configureWindow(newBounds);

          // 通知应用程序
          _onScreenSizeChanged?.call();
        }
      } catch (e) {
        Logger.e('Error monitoring screen changes: $e');
      }
    });
  }

  /// 获取当前窗口边界
  static Future<Rect?> getCurrentBounds() async {
    try {
      final bounds = await windowManager.getBounds();
      return bounds;
    } catch (e) {
      Logger.e('Error getting current bounds: $e');
      return null;
    }
  }

  /// 更新窗口位置
  static Future<void> updatePosition(Offset position) async {
    try {
      await windowManager.setPosition(position);
    } catch (e) {
      Logger.e('Error updating window position: $e');
    }
  }

  /// 更新窗口尺寸
  static Future<void> updateSize(Size size) async {
    try {
      await windowManager.setSize(size);
    } catch (e) {
      Logger.e('Error updating window size: $e');
    }
  }

  /// 显示窗口
  static Future<void> showWindow() async {
    try {
      await windowManager.show();
    } catch (e) {
      Logger.e('Error showing window: $e');
    }
  }

  /// 隐藏窗口
  static Future<void> hideWindow() async {
    try {
      await windowManager.hide();
    } catch (e) {
      Logger.e('Error hiding window: $e');
    }
  }

  /// 设置窗口是否忽略鼠标事件（指针穿透）
  static Future<void> setIgnoreMouseEvents(bool ignore) async {
    try {
      await windowManager.setIgnoreMouseEvents(ignore);
    } catch (e) {
      Logger.e('Error setting ignore mouse events: $e');
    }
  }

  /// 检查窗口是否已初始化
  static bool get isInitialized => _isInitialized;

  /// 获取最后记录的屏幕尺寸
  static Size? get lastScreenSize => _lastScreenSize;

  static String? _dynamicIslandWindowId;

  /// 切换灵动岛窗口（多窗口共存）
  static Future<void> toggleDynamicIslandWindow() async {
    try {
      if (_dynamicIslandWindowId != null) {
        // 尝试关闭
        try {
          // WindowController.fromWindowId 接收 String 类型的 ID
          // 且没有 close 方法，我们需要发送消息通知窗口关闭
          await WindowController.fromWindowId(_dynamicIslandWindowId!)
              .invokeMethod('close');
        } catch (e) {
          Logger.w('Failed to close window: $e');
        }
        _dynamicIslandWindowId = null;
        Logger.i('Closed Dynamic Island window');
      } else {
        // Create new
        try {
          final controller = await WindowController.create(
            WindowConfiguration(
              arguments: jsonEncode({'type': 'dynamic_island'}),
            ),
          );

          // Ensure we have a string ID. desktop_multi_window 0.3.0 usually has int ID,
          // but WindowController uses String?
          // If controller.windowId is int, toString() handles it.
          // If it is String, toString() is safe.
          _dynamicIslandWindowId = controller.windowId;

          final screenSize = await _getScreenInfo() ?? const Size(1920, 1080);
          const islandWidth = 500.0;
          const islandHeight = 150.0;
          final islandX = (screenSize.width - islandWidth) / 2;
          const islandY = 20.0;

          // Show the window
          await controller.show();

          // Position the window via method call
          await controller.invokeMethod('setFrame', {
            'x': islandX,
            'y': islandY,
            'width': islandWidth,
            'height': islandHeight,
          });

          Logger.i('Created Dynamic Island window: $_dynamicIslandWindowId');
        } catch (e) {
          Logger.e('Failed to create Dynamic Island window: $e');
          _dynamicIslandWindowId = null;
        }
      }
    } catch (e) {
      Logger.e('Error toggling Dynamic Island window: $e');
      _dynamicIslandWindowId = null;
    }
  }

  // 废弃的旧方法，保留为空实现以防调用报错，或直接删除
  static Future<void> switchToDynamicIslandMode() async {}
  static Future<void> exitDynamicIslandMode() async {}

  /// 释放资源
  static void dispose() {
    _screenMonitorTimer?.cancel();
    _screenMonitorTimer = null;
  }
}
