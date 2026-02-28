import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 平台检测枚举
enum PlatformType {
  windows,
  macos,
  linux,
  web,
  android,
  ios,
  unknown,
}

/// 跨平台工具类
/// 提供统一的平台检测和功能适配
class PlatformUtils {
  PlatformUtils._();

  /// 获取当前平台类型
  static PlatformType get platformType {
    if (kIsWeb) return PlatformType.web;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isMacOS) return PlatformType.macos;
    if (Platform.isLinux) return PlatformType.linux;
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.ios;
    return PlatformType.unknown;
  }

  /// 是否为桌面平台
  static bool get isDesktop {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  }

  /// 是否为移动平台
  static bool get isMobile {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  /// 是否为 Windows
  static bool get isWindows => Platform.isWindows;

  /// 是否为 macOS
  static bool get isMacOS => Platform.isMacOS;

  /// 是否为 Linux
  static bool get isLinux => Platform.isLinux;

  /// 是否为 Web
  static bool get isWeb => kIsWeb;

  /// 获取平台名称（用于显示）
  static String get platformName {
    switch (platformType) {
      case PlatformType.windows:
        return 'Windows';
      case PlatformType.macos:
        return 'macOS';
      case PlatformType.linux:
        return 'Linux';
      case PlatformType.web:
        return 'Web';
      case PlatformType.android:
        return 'Android';
      case PlatformType.ios:
        return 'iOS';
      case PlatformType.unknown:
        return 'Unknown';
    }
  }

  /// 获取平台图标
  static IconData get platformIcon {
    switch (platformType) {
      case PlatformType.windows:
        return Icons.window;
      case PlatformType.macos:
        return Icons.laptop_mac;
      case PlatformType.linux:
        return Icons.dns;
      case PlatformType.web:
        return Icons.language;
      case PlatformType.android:
        return Icons.android;
      case PlatformType.ios:
        return Icons.phone_iphone;
      case PlatformType.unknown:
        return Icons.help_outline;
    }
  }

  /// 是否支持系统托盘
  static bool get supportsSystemTray {
    return isWindows || isMacOS;
  }

  /// 是否支持开机自启
  static bool get supportsAutoStart {
    return isWindows || isLinux || isMacOS;
  }

  /// 是否支持原生窗口装饰
  static bool get supportsNativeWindowDecorations {
    return isWindows || isMacOS;
  }

  /// 是否支持透明效果
  static bool get supportsTransparency {
    return isWindows || isMacOS;
  }

  /// 获取默认窗口标题栏高度
  static double get defaultTitleBarHeight {
    if (isMacOS) return 38.0;
    if (isWindows) return 32.0;
    if (isLinux) return 40.0;
    return 56.0; // 移动端默认
  }

  /// 获取平台特定的快捷键修饰键
  static String get shortcutModifier {
    if (isMacOS) return '⌘';
    return 'Ctrl';
  }

  /// 获取 LogicalKeyboardKey 修饰键
  static LogicalKeyboardKey get logicalModifierKey {
    if (isMacOS) return LogicalKeyboardKey.meta;
    return LogicalKeyboardKey.control;
  }

  /// 获取平台特定的文件扩展名
  static String get executableExtension {
    if (isWindows) return '.exe';
    if (isMacOS) return '.app';
    return '';
  }

  /// 获取平台特定的路径分隔符
  static String get pathSeparator {
    if (isWindows) return '\\';
    return '/';
  }

  /// 检查是否支持特定功能
  static bool supportsFeature(PlatformFeature feature) {
    switch (feature) {
      case PlatformFeature.systemTray:
        return supportsSystemTray;
      case PlatformFeature.autoStart:
        return supportsAutoStart;
      case PlatformFeature.nativeWindowDecorations:
        return supportsNativeWindowDecorations;
      case PlatformFeature.transparency:
        return supportsTransparency;
      case PlatformFeature.globalShortcuts:
        return isDesktop;
      case PlatformFeature.fileSystemAccess:
        return isDesktop;
    }
  }

  /// 获取平台特定的样式调整
  static PlatformStyles getPlatformStyles() {
    switch (platformType) {
      case PlatformType.windows:
        return const WindowsStyles();
      case PlatformType.macos:
        return const MacOSStyles();
      case PlatformType.linux:
        return const LinuxStyles();
      default:
        return const DefaultStyles();
    }
  }
}

/// 平台特性枚举
enum PlatformFeature {
  systemTray,
  autoStart,
  nativeWindowDecorations,
  transparency,
  globalShortcuts,
  fileSystemAccess,
}

/// 平台样式基类
abstract class PlatformStyles {
  const PlatformStyles();

  double get windowBorderRadius;
  double get cardBorderRadius;
  double get buttonBorderRadius;
  bool get useElevation;
  bool get useRippleEffect;
  double get defaultPadding;
  double get iconSize;
}

/// Windows 样式
class WindowsStyles extends PlatformStyles {
  const WindowsStyles();

  @override
  double get windowBorderRadius => 8.0;

  @override
  double get cardBorderRadius => 8.0;

  @override
  double get buttonBorderRadius => 4.0;

  @override
  bool get useElevation => true;

  @override
  bool get useRippleEffect => true;

  @override
  double get defaultPadding => 16.0;

  @override
  double get iconSize => 20.0;
}

/// macOS 样式
class MacOSStyles extends PlatformStyles {
  const MacOSStyles();

  @override
  double get windowBorderRadius => 10.0;

  @override
  double get cardBorderRadius => 10.0;

  @override
  double get buttonBorderRadius => 6.0;

  @override
  bool get useElevation => false;

  @override
  bool get useRippleEffect => false;

  @override
  double get defaultPadding => 16.0;

  @override
  double get iconSize => 22.0;
}

/// Linux 样式
class LinuxStyles extends PlatformStyles {
  const LinuxStyles();

  @override
  double get windowBorderRadius => 6.0;

  @override
  double get cardBorderRadius => 6.0;

  @override
  double get buttonBorderRadius => 4.0;

  @override
  bool get useElevation => true;

  @override
  bool get useRippleEffect => true;

  @override
  double get defaultPadding => 14.0;

  @override
  double get iconSize => 20.0;
}

/// 默认样式
class DefaultStyles extends PlatformStyles {
  const DefaultStyles();

  @override
  double get windowBorderRadius => 8.0;

  @override
  double get cardBorderRadius => 8.0;

  @override
  double get buttonBorderRadius => 4.0;

  @override
  bool get useElevation => true;

  @override
  bool get useRippleEffect => true;

  @override
  double get defaultPadding => 16.0;

  @override
  double get iconSize => 24.0;
}
