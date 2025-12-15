import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';
import 'package:time_widgets/utils/logger.dart';

/// MD3风格的系统托盘菜单服�?
/// 使用C++实现基础托盘，右键时显示Flutter MD3悬浮菜单
class MD3TrayMenuService {
  static MD3TrayMenuService? _instance;
  static MD3TrayMenuService get instance => _instance ??= MD3TrayMenuService._();
  
  MD3TrayMenuService._();

  SystemTray? _systemTray;
  bool _isInitialized = false;

  // 回调函数
  VoidCallback? onShowSettings;
  VoidCallback? onShowTimetableEdit;
  VoidCallback? onToggleWindow;
  VoidCallback? onExit;
  
  // MD3菜单显示回调 - 由main.dart设置
  VoidCallback? onShowMD3Menu;

  /// 初始化系统托盘（仅图标，不设置原生菜单）
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _systemTray = SystemTray();

      // 初始化托盘图�?
      await _systemTray!.initSystemTray(
        title: '智慧课程�?,
        iconPath: Platform.isWindows ? 'assets/icons/app_icon.ico' : 'assets/icons/app_icon.png',
        toolTip: '智慧课程表\n左键: 显示/隐藏窗口\n右键: 打开菜单',
      );

      // 不设置原生菜单，右键时显示Flutter MD3菜单
      // 设置点击事件
      _systemTray!.registerSystemTrayEventHandler((eventName) {
        if (eventName == kSystemTrayEventClick) {
          // 左键点击显示/隐藏窗口
          onToggleWindow?.call();
        } else if (eventName == kSystemTrayEventRightClick) {
          // 右键点击显示MD3 Flutter菜单
          onShowMD3Menu?.call();
        }
      });

      _isInitialized = true;
      Logger.i('系统托盘初始化成功（MD3模式�?);
      return true;
    } catch (e) {
      Logger.e('系统托盘初始化失�? $e');
      return false;
    }
  }

  /// 更新托盘提示
  Future<void> updateTooltip(String tooltip) async {
    if (_systemTray != null) {
      await _systemTray!.setToolTip(tooltip);
    }
  }

  /// 销毁托�?
  void destroy() {
    _systemTray?.destroy();
    _systemTray = null;
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
}

/// MD3风格的托盘悬浮菜�?
/// 显示在屏幕右下角，靠近系统托盘位�?
class MD3TrayPopupMenu extends StatelessWidget {
  final VoidCallback? onShowSettings;
  final VoidCallback? onShowTimetableEdit;
  final VoidCallback? onToggleWindow;
  final VoidCallback? onExit;
  final VoidCallback? onDismiss;

  const MD3TrayPopupMenu({
    super.key,
    this.onShowSettings,
    this.onShowTimetableEdit,
    this.onToggleWindow,
    this.onExit,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // 菜单定位在右下角
              Positioned(
                right: 16,
                bottom: 60, // 留出任务栏空�?
                child: GestureDetector(
                  onTap: () {}, // 阻止点击穿�?
                  child: Container(
                    width: 240,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 标题
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.schedule_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '智慧课程�?,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '桌面小组�?,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Divider(height: 1, color: colorScheme.outlineVariant),

                        // 菜单�?
                        _buildMenuItem(
                          context: context,
                          icon: Icons.visibility_rounded,
                          label: '显示/隐藏窗口',
                          onTap: () {
                            onDismiss?.call();
                            onToggleWindow?.call();
                          },
                        ),
                        
                        _buildMenuItem(
                          context: context,
                          icon: Icons.settings_rounded,
                          label: '设置',
                          onTap: () {
                            onDismiss?.call();
                            onShowSettings?.call();
                          },
                        ),
                        
                        _buildMenuItem(
                          context: context,
                          icon: Icons.edit_calendar_rounded,
                          label: '编辑课表',
                          onTap: () {
                            onDismiss?.call();
                            onShowTimetableEdit?.call();
                          },
                        ),
                        
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: colorScheme.outlineVariant,
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.exit_to_app_rounded,
                          label: '退出程�?,
                          isDestructive: true,
                          onTap: () {
                            onDismiss?.call();
                            onExit?.call();
                          },
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
