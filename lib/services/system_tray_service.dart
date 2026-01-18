import 'dart:io';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:time_widgets/utils/logger.dart';

/// 系统托盘菜单项枚举
enum TrayMenuItem {
  settings, // 设置
  timetableEdit, // 课表编辑
  toggleWindow, // 显示/隐藏
  exit // 退出
}

/// 系统托盘服务
/// 管理系统托盘图标、菜单和相关功能
class SystemTrayService {
  factory SystemTrayService() => _instance;
  SystemTrayService._internal();
  static final SystemTrayService _instance = SystemTrayService._internal();

  final SystemTray _systemTray = SystemTray();

  /// 菜单项选择回调
  void Function(TrayMenuItem)? onMenuItemSelected;

  /// 窗口显示/隐藏回调
  VoidCallback? onToggleWindow;

  /// 应用退出回调
  VoidCallback? onExitApplication;

  /// 初始化系统托盘
  Future<void> initializeSystemTray() async {
    try {
      // 设置托盘图标 - 使用PNG文件，因为ICO文件可能有问题
      const String iconPath = 'assets/icons/weather_0.png';

      await _systemTray.initSystemTray(
        title: "智慧课程表",
        iconPath: iconPath,
      );

      // 设置工具提示
      await _systemTray.setToolTip("智慧课程表 - 右键查看菜单");

      // 创建托盘菜单
      await _createTrayMenu();

      // 注册菜单点击事件
      _systemTray.registerSystemTrayEventHandler(_onTrayEvent);

      Logger.i('System tray initialized successfully');
    } catch (e) {
      Logger.e('Failed to initialize system tray: $e');
      throw Exception('系统托盘初始化失败: $e');
    }
  }

  /// 创建托盘菜单
  Future<void> _createTrayMenu() async {
    final Menu menu = Menu();

    // 设置菜单项
    await menu.buildFrom([
      MenuItemLabel(
        label: '设置',
        onClicked: (menuItem) => _handleMenuClick(TrayMenuItem.settings),
      ),
      MenuItemLabel(
        label: '课表编辑',
        onClicked: (menuItem) => _handleMenuClick(TrayMenuItem.timetableEdit),
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: '显示/隐藏',
        onClicked: (menuItem) => _handleMenuClick(TrayMenuItem.toggleWindow),
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: '退出',
        onClicked: (menuItem) => _handleMenuClick(TrayMenuItem.exit),
      ),
    ]);

    // 设置右键菜单
    await _systemTray.setContextMenu(menu);
  }

  /// 处理菜单点击事件
  void _handleMenuClick(TrayMenuItem item) {
    Logger.d('Tray menu item clicked: $item');

    switch (item) {
      case TrayMenuItem.settings:
      case TrayMenuItem.timetableEdit:
        onMenuItemSelected?.call(item);
        break;
      case TrayMenuItem.toggleWindow:
        onToggleWindow?.call();
        break;
      case TrayMenuItem.exit:
        onExitApplication?.call();
        break;
    }
  }

  /// 处理托盘事件
  void _onTrayEvent(String eventName) {
    Logger.d('Tray event: $eventName');

    switch (eventName) {
      case kSystemTrayEventClick:
        // 左键点击 - 显示/隐藏窗口
        onToggleWindow?.call();
        break;
      case kSystemTrayEventRightClick:
        // 右键点击 - 显示菜单（由系统自动处理）
        break;
    }
  }

  /// 更新托盘图标
  Future<void> updateTrayIcon(String iconPath) async {
    try {
      await _systemTray.setImage(iconPath);
    } catch (e) {
      Logger.e('Failed to update tray icon: $e');
    }
  }

  /// 设置托盘工具提示
  Future<void> setTrayTooltip(String tooltip) async {
    try {
      await _systemTray.setToolTip(tooltip);
    } catch (e) {
      Logger.e('Failed to set tray tooltip: $e');
    }
  }

  /// 显示托盘菜单（程序化调用）
  Future<void> showTrayMenu() async {
    try {
      await _systemTray.popUpContextMenu();
    } catch (e) {
      Logger.e('Failed to show tray menu: $e');
    }
  }

  /// 销毁系统托盘
  Future<void> destroy() async {
    try {
      await _systemTray.destroy();
      Logger.i('System tray destroyed');
    } catch (e) {
      Logger.e('Failed to destroy system tray: $e');
    }
  }

  /// 检查系统托盘是否可用
  static bool isSystemTrayAvailable() {
    // 在 Windows 上系统托盘通常可用
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}
