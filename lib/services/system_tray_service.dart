import 'package:flutter/material.dart';
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

  /// 菜单项选择回调
  void Function(TrayMenuItem)? onMenuItemSelected;

  /// 窗口显示/隐藏回调
  VoidCallback? onToggleWindow;

  /// 应用退出回调
  VoidCallback? onExitApplication;

  /// 初始化系统托盘
  Future<void> initializeSystemTray() async {
    Logger.i('System tray is disabled in Flutter-only mode');
  }

  /// 更新托盘图标
  Future<void> updateTrayIcon(String iconPath) async {
    Logger.d('updateTrayIcon ignored in Flutter-only mode: $iconPath');
  }

  /// 设置托盘工具提示
  Future<void> setTrayTooltip(String tooltip) async {
    Logger.d('setTrayTooltip ignored in Flutter-only mode: $tooltip');
  }

  /// 显示托盘菜单（程序化调用）
  Future<void> showTrayMenu() async {
    Logger.d('showTrayMenu ignored in Flutter-only mode');
  }

  /// 销毁系统托盘
  Future<void> destroy() async {
    Logger.i('System tray destroyed (Flutter-only mode)');
  }

  /// 检查系统托盘是否可用
  static bool isSystemTrayAvailable() {
    return false;
  }
}
