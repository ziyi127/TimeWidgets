import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'dart:io';
import 'dart:async';
import 'package:time_widgets/utils/logger.dart';

/// 增强的窗口管理器
/// 提供可靠的窗口初始化、定位和状态管�?
class EnhancedWindowManager {
  static bool _isInitialized = false;
  static Size? _lastScreenSize;
  static VoidCallback? _onScreenSizeChanged;
  
  /// 初始化窗�?
  static Future<bool> initializeWindow({VoidCallback? onScreenSizeChanged}) async {
    if (_isInitialized) return true;
    
    _onScreenSizeChanged = onScreenSizeChanged;
    
    try {
      // 确保窗口管理器已初始�?
      await windowManager.ensureInitialized();
      
      // 等待一帧以确保Flutter完全初始�?
      await Future.delayed(const Duration(milliseconds: 100));
      
      // 获取屏幕信息
      final screenInfo = await _getScreenInfo();
      if (screenInfo == null) {
        Logger.w('Failed to get screen info, using default size');
        return await _initializeWithDefaultSize();
      }
      
      _lastScreenSize = screenInfo;
      
      // 计算窗口尺寸和位�?
      final windowBounds = _calculateWindowBounds(screenInfo);
      
      // 设置窗口属�?
      await _configureWindow(windowBounds);
      
      // 初始化bitsdojo_window
      _initializeBitsdojoWindow();
      
      // 监听屏幕变化
      _startScreenMonitoring();
      
      _isInitialized = true;
      Logger.i('Window initialized successfully: ${windowBounds.size} at ${windowBounds.topLeft}');
      return true;
      
    } catch (e) {
      Logger.e('Window initialization failed: $e');
      return await _initializeWithDefaultSize();
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
      // 使用PowerShell获取屏幕分辨�?
      final result = await Process.run('powershell', [
        '-Command',
        'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds'
      ]);
      
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final regex = RegExp(r'Width=(\d+).*Height=(\d+)');
        final match = regex.firstMatch(output);
        
        if (match != null) {
          final width = double.parse(match.group(1)!);
          final height = double.parse(match.group(2)!);
          return Size(width, height);
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
    final windowY = 0.0;
    
    // 确保最小尺�?
    final minWidth = 300.0;
    final minHeight = 600.0;
    
    final finalWidth = windowWidth.clamp(minWidth, screenSize.width);
    final finalHeight = windowHeight.clamp(minHeight, screenSize.height);
    final finalX = (screenSize.width - finalWidth).clamp(0.0, screenSize.width);
    
    return Rect.fromLTWH(finalX, windowY, finalWidth, finalHeight);
  }

  /// 配置窗口属�?
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
      
      // 设置窗口层级 - 不要设置为最底层，这会影响交�?
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      
      // 设置窗口可调整大小（可选）
      await windowManager.setResizable(false);
      
      // 确保窗口可见
      await windowManager.show();
      
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

  /// 使用默认尺寸初始�?
  static Future<bool> _initializeWithDefaultSize() async {
    try {
      const defaultSize = Size(480, 1080);
      const defaultPosition = Offset(1440, 0); // 假设1920x1080屏幕
      
      await windowManager.setSize(defaultSize);
      await windowManager.setPosition(defaultPosition);
      await windowManager.setAsFrameless();
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(false);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      await windowManager.show();
      
      _initializeBitsdojoWindow();
      _isInitialized = true;
      
      Logger.i('Window initialized with default size: $defaultSize at $defaultPosition');
      return true;
    } catch (e) {
      Logger.e('Failed to initialize with default size: $e');
      return false;
    }
  }

  /// 开始屏幕监�?
  static void _startScreenMonitoring() {
    // 定期检查屏幕尺寸变�?
    Timer.periodic(const Duration(seconds: 5), (timer) async {
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

  /// 检查窗口是否已初始�?
  static bool get isInitialized => _isInitialized;

  /// 获取最后记录的屏幕尺寸
  static Size? get lastScreenSize => _lastScreenSize;
}
