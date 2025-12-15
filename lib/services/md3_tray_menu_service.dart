import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';

/// MD3风格的系统托盘菜单服务
/// 使用Flutter Overlay实现MD3风格的弹出菜单
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

  /// 初始化系统托盘
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _systemTray = SystemTray();

      // 初始化托盘图标
      await _systemTray!.initSystemTray(
        title: '智慧课程表',
        iconPath: Platform.isWindows ? 'assets/icons/app_icon.ico' : 'assets/icons/app_icon.png',
        toolTip: '智慧课程表 - 点击显示菜单',
      );

      // 设置托盘菜单
      final menu = Menu();
      await menu.buildFrom([
        MenuItemLabel(
          label: '⚙️ 设置',
          onClicked: (menuItem) => onShowSettings?.call(),
        ),
        MenuItemLabel(
          label: '📅 课表编辑',
          onClicked: (menuItem) => onShowTimetableEdit?.call(),
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: '👁️ 显示/隐藏',
          onClicked: (menuItem) => onToggleWindow?.call(),
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: '❌ 退出',
          onClicked: (menuItem) => onExit?.call(),
        ),
      ]);

      await _systemTray!.setContextMenu(menu);

      // 设置点击事件
      _systemTray!.registerSystemTrayEventHandler((eventName) {
        if (eventName == kSystemTrayEventClick) {
          // 左键点击显示/隐藏窗口
          onToggleWindow?.call();
        } else if (eventName == kSystemTrayEventRightClick) {
          // 右键点击显示菜单
          _systemTray!.popUpContextMenu();
        }
      });

      _isInitialized = true;
      print('MD3 Tray Menu Service initialized successfully');
      return true;
    } catch (e) {
      print('Failed to initialize MD3 Tray Menu Service: $e');
      return false;
    }
  }

  /// 更新托盘提示
  Future<void> updateTooltip(String tooltip) async {
    if (_systemTray != null) {
      await _systemTray!.setToolTip(tooltip);
    }
  }

  /// 销毁托盘
  void destroy() {
    _systemTray?.destroy();
    _systemTray = null;
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
}

/// MD3风格的浮动菜单组件
/// 可以在应用内显示，作为托盘菜单的补充
class MD3FloatingMenu extends StatelessWidget {
  final VoidCallback? onShowSettings;
  final VoidCallback? onShowTimetableEdit;
  final VoidCallback? onToggleWindow;
  final VoidCallback? onExit;
  final VoidCallback? onDismiss;

  const MD3FloatingMenu({
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
          color: Colors.black26,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 阻止点击穿透
              child: Container(
                width: 280,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '智慧课程表',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Divider(
                      height: 1,
                      color: colorScheme.outlineVariant,
                    ),

                    // 菜单项
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
                      label: '课表编辑',
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
                      icon: Icons.visibility_rounded,
                      label: '显示/隐藏窗口',
                      onTap: () {
                        onDismiss?.call();
                        onToggleWindow?.call();
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
                      label: '退出程序',
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 显示MD3浮动菜单的辅助方法
void showMD3FloatingMenu(
  BuildContext context, {
  VoidCallback? onShowSettings,
  VoidCallback? onShowTimetableEdit,
  VoidCallback? onToggleWindow,
  VoidCallback? onExit,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => MD3FloatingMenu(
      onShowSettings: onShowSettings,
      onShowTimetableEdit: onShowTimetableEdit,
      onToggleWindow: onToggleWindow,
      onExit: onExit,
      onDismiss: () => Navigator.of(context).pop(),
    ),
  );
}
