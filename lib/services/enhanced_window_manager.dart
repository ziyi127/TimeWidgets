import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'dart:io';
import 'dart:async';

/// 增强的窗口管理器
/// 提供可靠的窗口初始化、定位和状态管理
class EnhancedWindowManager {
  static bool _isInitialized = false;
  static Size? _lastScreenSize;
  static VoidCallback? _onScreenSizeChanged;
  
  /// 初始化窗口
  static Future<bool> initializeWindow({VoidCallback? onScreenSizeChanged}) async {
    if (_isInitialized) return true;
    
    _onScreenSizeChanged = onScreenSizeChanged;
    
    try {
      // 确保窗口管理器已初始化
      await windowManager.ensureInitialized();
      
      // 等待一帧以确保Flutter完全初始化
      await Future.delayed(const Duration(milliseconds: 100));
      
      // 获取屏幕信息
      final screenInfo = await _getScreenInfo();
      if (screenInfo == null) {
        print('Failed to get screen info, using default size');
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
      print('Window initialized successfully: ${windowBounds.size} at ${windowBounds.topLeft}');
      return true;
      
    } catch (e) {
      print('Window initialization failed: $e');
      return await _initializeWithDefaultSize();
    }
  }

  /// 获取屏幕信息
  static Future<Size?> _getScreenInfo() async {
    try {
      // 尝试多种方法获取屏幕尺寸
      
      // 方法1: 使用window_manager
      try {
        final bounds = await windowManager.getBounds();
        if (bounds.size.width > 0 && bounds.size.height > 0) {
          // 获取主屏幕尺寸（假设窗口在主屏幕上）
          return Size(1920, 1080); // 临时使用常见分辨率，后续可以改进
        }
      } catch (e) {
        print('Failed to get bounds from window_manager: $e');
      }
      
      // 方法2: 使用系统调用（Windows）
      if (Platform.isWindows) {
        return await _getWindowsScreenSize();
      }
      
      return null;
    } catch (e) {
      print('Error getting screen info: $e');
      return null;
    }
  }

  /// 获取Windows屏幕尺寸
  static Future<Size?> _getWindowsScreenSize() async {
    try {
      // 使用PowerShell获取屏幕分辨率
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
      print('Failed to get Windows screen size: $e');
    }
    
    return null;
  }

  /// 计算窗口边界
  static Rect _calculateWindowBounds(Size screenSize) {
    // 窗口宽度为屏幕宽度的1/4
    final windowWidth = screenSize.width / 4;
    final windowHeight = screenSize.height;
    
    // 窗口位置在屏幕右侧
    final windowX = screenSize.width - windowWidth;
    final windowY = 0.0;
    
    // 确保最小尺寸
    final minWidth = 300.0;
    final minHeight = 600.0;
    
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
      
      // 设置窗口层级 - 不要设置为最底层，这会影响交互
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      
      // 设置窗口可调整大小（可选）
      await windowManager.setResizable(false);
      
      // 确保窗口可见
      await windowManager.show();
      
    } catch (e) {
      print('Error configuring window: $e');
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
      print('Error initializing bitsdojo_window: $e');
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
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setAlwaysOnBottom(false);
      await windowManager.show();
      
      _initializeBitsdojoWindow();
      _isInitialized = true;
      
      print('Window initialized with default size: $defaultSize at $defaultPosition');
      return true;
    } catch (e) {
      print('Failed to initialize with default size: $e');
      return false;
    }
  }

  /// 开始屏幕监听
  static void _startScreenMonitoring() {
    // 定期检查屏幕尺寸变化
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final currentSize = await _getScreenInfo();
        if (currentSize != null && 
            _lastScreenSize != null && 
            currentSize != _lastScreenSize) {
          
          print('Screen size changed from $_lastScreenSize to $currentSize');
          _lastScreenSize = currentSize;
          
          // 重新计算窗口位置
          final newBounds = _calculateWindowBounds(currentSize);
          await _configureWindow(newBounds);
          
          // 通知应用程序
          _onScreenSizeChanged?.call();
        }
      } catch (e) {
        print('Error monitoring screen changes: $e');
      }
    });
  }

  /// 获取当前窗口边界
  static Future<Rect?> getCurrentBounds() async {
    try {
      final bounds = await windowManager.getBounds();
      return bounds;
    } catch (e) {
      print('Error getting current bounds: $e');
      return null;
    }
  }

  /// 更新窗口位置
  static Future<void> updatePosition(Offset position) async {
    try {
      await windowManager.setPosition(position);
    } catch (e) {
      print('Error updating window position: $e');
    }
  }

  /// 更新窗口尺寸
  static Future<void> updateSize(Size size) async {
    try {
      await windowManager.setSize(size);
    } catch (e) {
      print('Error updating window size: $e');
    }
  }

  /// 显示窗口
  static Future<void> showWindow() async {
    try {
      await windowManager.show();
    } catch (e) {
      print('Error showing window: $e');
    }
  }

  /// 隐藏窗口
  static Future<void> hideWindow() async {
    try {
      await windowManager.hide();
    } catch (e) {
      print('Error hiding window: $e');
    }
  }

  /// 检查窗口是否已初始化
  static bool get isInitialized => _isInitialized;

  /// 获取最后记录的屏幕尺寸
  static Size? get lastScreenSize => _lastScreenSize;
}