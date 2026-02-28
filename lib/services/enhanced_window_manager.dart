import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_widgets/utils/platform_utils.dart';
import 'package:screen_retriever/screen_retriever.dart';
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
  static Future<bool> initializeWindow({
    VoidCallback? onScreenSizeChanged,
  }) async {
    if (_isInitialized) return true;

    _onScreenSizeChanged = onScreenSizeChanged;

    try {
      // 确保窗口管理器已初始化
      await windowManager.ensureInitialized();

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

      // 监听屏幕变化
      _startScreenMonitoring();

      _isInitialized = true;
      Logger.i(
        'Window initialized successfully: ${windowBounds.size} at ${windowBounds.topLeft}',
      );
      
      // 跨平台窗口显示优化
      await _showWindowWithPlatformOptimization();
      
      return true;
    } catch (e) {
      Logger.e('Window initialization failed: $e');
      return _initializeWithDefaultSize();
    }
  }

  /// 跨平台优化的窗口显示方法
  static Future<void> _showWindowWithPlatformOptimization() async {
    // 根据平台调整延迟时间
    final delayMs = PlatformUtils.isLinux ? 800 : (PlatformUtils.isMacOS ? 600 : 400);
    
    await Future<void>.delayed(Duration(milliseconds: delayMs));
    await windowManager.show();
    
    // macOS 需要额外的 focus 调用
    if (PlatformUtils.isMacOS) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    await windowManager.focus();
  }
      
  }

  /// 保存主窗口原始尺寸和位置
  static Size? _mainWindowSize;
  static Offset? _mainWindowPosition;

  /// 创建独立的 16:9 窗口
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

      // 计算 16:9 窗口尺寸（基于屏幕高度的 80%）
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
      await windowManager.setBackgroundColor(Colors.transparent);
      
      // 设置窗口阴影（仅 Windows 和 macOS 支持）
      if (Platform.isWindows || Platform.isMacOS) {
        try {
          await windowManager.setHasShadow(true);
        } catch (e) {
          Logger.w('setHasShadow not available: $e');
        }
      }
      
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      await windowManager.setResizable(true);
      await windowManager.show();

      // 设置窗口标题
      await windowManager.setTitle(title);

      Logger.i(
        'Created edit window: $title, size: ${bounds.size} at ${bounds.topLeft}',
      );
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
        if (Platform.isWindows) {
          await windowManager.setAsFrameless();
        }
        await windowManager.setResizable(false);
        if (Platform.isWindows || Platform.isMacOS) {
          try {
            await windowManager.setHasShadow(false);
          } catch (e) {
            Logger.w('setHasShadow not available: $e');
          }
        }
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
      // 使用 screen_retriever 获取主屏幕信息 (跨平台)
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      return Size(primaryDisplay.size.width, primaryDisplay.size.height);
    } catch (e) {
      Logger.e('Error getting screen info: $e');
      return null;
    }
  }

  /// 计算窗口边界
  static Rect _calculateWindowBounds(Size screenSize) {
    // 窗口宽度为屏幕宽度的 1/4
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

      // 设置窗口样式 - 不使用无框窗口以提高兼容性
      if (Platform.isWindows) {
        // 仅在 Windows 上使用无框窗口
        try {
          await windowManager.setAsFrameless();
        } catch (e) {
          Logger.w('setAsFrameless not available: $e');
        }
      }
      await windowManager.setBackgroundColor(Colors.transparent);
      
      // 设置窗口阴影（仅 Windows 和 macOS 支持）
      if (Platform.isWindows || Platform.isMacOS) {
        try {
          await windowManager.setHasShadow(true);
        } catch (e) {
          Logger.w('setHasShadow not available: $e');
        }
      }

      // 设置窗口层级 - 普通窗口层级
      try {
        await windowManager.setAlwaysOnTop(false);
      } catch (e) {
        Logger.w('setAlwaysOnTop not available: $e');
      }
      try {
        await windowManager.setAlwaysOnBottom(false);
      } catch (e) {
        Logger.w('setAlwaysOnBottom not available: $e');
      }

      // 禁用鼠标穿透，确保小组件可以交互（仅 Windows 支持）
      if (Platform.isWindows) {
        try {
          await windowManager.setIgnoreMouseEvents(false);
        } catch (e) {
          Logger.w('setIgnoreMouseEvents not available: $e');
        }
      }

      // 设置窗口可调整大小（可选）
      try {
        await windowManager.setResizable(false);
      } catch (e) {
        Logger.w('setResizable not available: $e');
      }

      // 确保窗口可见
      await windowManager.show();
      
      // 在 Linux 上，使用多次 show() 调用确保窗口显示
      if (Platform.isLinux) {
        await Future.delayed(const Duration(milliseconds: 100));
        await windowManager.show();
        await windowManager.focus();
        await Future.delayed(const Duration(milliseconds: 100));
        await windowManager.show();
      } else {
        await windowManager.focus();
      }

      // 防止窗口直接关闭，交由应用层处理（实现最小化到托盘）
      try {
        await windowManager.setPreventClose(true);
      } catch (e) {
        Logger.w('setPreventClose not available: $e');
      }
    } catch (e) {
      Logger.e('Error configuring window: $e');
      rethrow;
    }
  }

  /// 使用默认尺寸初始化
  static Future<bool> _initializeWithDefaultSize() async {
    try {
      const defaultSize = Size(480, 1080);
      const defaultPosition = Offset(1440, 0); // 假设 1920x1080 屏幕

      await windowManager.setSize(defaultSize);
      await windowManager.setPosition(defaultPosition);
      
      // 仅在 Windows 上使用无框窗口
      if (Platform.isWindows) {
        try {
          await windowManager.setAsFrameless();
        } catch (e) {
          Logger.w('setAsFrameless not available: $e');
        }
      }
      
      await windowManager.setBackgroundColor(Colors.transparent);
      
      // 设置窗口阴影（仅 Windows 和 macOS 支持）
      if (Platform.isWindows || Platform.isMacOS) {
        try {
          await windowManager.setHasShadow(true);
        } catch (e) {
          Logger.w('setHasShadow not available: $e');
        }
      }
      
      // 设置窗口层级 - 普通窗口层级
      try {
        await windowManager.setAlwaysOnTop(false);
      } catch (e) {
        Logger.w('setAlwaysOnTop not available: $e');
      }
      try {
        await windowManager.setAlwaysOnBottom(false);
      } catch (e) {
        Logger.w('setAlwaysOnBottom not available: $e');
      }
      
      // 禁用鼠标穿透，确保小组件可以交互（仅 Windows 支持）
      if (Platform.isWindows) {
        try {
          await windowManager.setIgnoreMouseEvents(false);
        } catch (e) {
          Logger.w('setIgnoreMouseEvents not available: $e');
        }
      }
      
      await windowManager.show();
      await windowManager.focus();
      
      try {
        await windowManager.setPreventClose(true);
      } catch (e) {
        Logger.w('setPreventClose not available: $e');
      }

      _isInitialized = true;

      Logger.i(
        'Window initialized with default size: $defaultSize at $defaultPosition',
      );
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

    // 减少检查频率，从 5 秒改为 30 秒
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

  /// 释放资源
  static void dispose() {
    _screenMonitorTimer?.cancel();
    _screenMonitorTimer = null;
  }
}
