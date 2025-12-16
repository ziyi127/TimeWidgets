import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'dart:io';
import 'package:time_widgets/utils/logger.dart';
import 'package:time_widgets/services/global_animation_service.dart';

/// MD3风格的系统托盘菜单服务
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
  VoidCallback? onToggleEditMode;
  VoidCallback? onExit;
  
  // MD3菜单显示回调 - 由main.dart设置
  VoidCallback? onShowMD3Menu;

  /// 初始化系统托盘（仅图标，不设置原生菜单）
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _systemTray = SystemTray();

      // 初始化托盘图标
      await _systemTray!.initSystemTray(
        title: '智慧课程表',
        iconPath: Platform.isWindows ? 'assets/icons/tray_icon.ico' : 'assets/icons/app_icon.png',
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
      Logger.i('系统托盘初始化成功（MD3模式）');
      return true;
    } catch (e) {
      Logger.e('系统托盘初始化失败: $e');
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

/// MD3风格的托盘悬浮菜单
/// 显示在屏幕右下角，靠近系统托盘位置
class MD3TrayPopupMenu extends StatefulWidget {
  final VoidCallback? onShowSettings;
  final VoidCallback? onShowTimetableEdit;
  final VoidCallback? onToggleWindow;
  final VoidCallback? onToggleEditMode;
  final VoidCallback? onExit;
  final VoidCallback? onDismiss;

  const MD3TrayPopupMenu({
    super.key,
    this.onShowSettings,
    this.onShowTimetableEdit,
    this.onToggleWindow,
    this.onToggleEditMode,
    this.onExit,
    this.onDismiss,
  });

  @override
  State<MD3TrayPopupMenu> createState() => _MD3TrayPopupMenuState();
}

class _MD3TrayPopupMenuState extends State<MD3TrayPopupMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 使用全局动画服务初始化动画控制器
    _animationController = GlobalAnimationService.instance.getAnimationController(
      key: 'tray_menu_animation',
      vsync: this,
      duration: GlobalAnimationService.defaultDuration,
    );
    
    // 使用全局动画服务创建淡入动画
    _opacityAnimation = GlobalAnimationService.instance.createFadeAnimation(
      key: 'tray_menu',
      controller: _animationController,
      begin: 0.0,
      end: 1.0,
      curve: GlobalAnimationService.defaultCurve,
    );
    
    // 使用全局动画服务创建缩放动画
    _scaleAnimation = GlobalAnimationService.instance.createScaleAnimation(
      key: 'tray_menu',
      controller: _animationController,
      begin: 0.95,
      end: 1.0,
      curve: GlobalAnimationService.popCurve,
    );
    
    // 开始动画
    GlobalAnimationService.instance.smartAnimate(
      controller: _animationController,
      target: 1.0,
    );
  }

  @override
  void dispose() {
    // 不在这里dispose，因为动画控制器可能被缓存重用
    // _animationController.dispose();
    super.dispose();
  }

  /// 安全关闭菜单，带反向动画效果
  void _safeCloseMenu(VoidCallback? action) {
    // 使用全局动画服务的智能反向动画
    GlobalAnimationService.instance.smartReverse(
      controller: _animationController,
    );
    // 直接执行操作，不等待动画结束
    action?.call();
    // 调用关闭回调
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          // 点击外部关闭菜单，使用智能反向动画
          GlobalAnimationService.instance.smartReverse(
            controller: _animationController,
          );
          widget.onDismiss?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // 菜单定位在右下角，根据屏幕尺寸动态调整
              Positioned(
                right: MediaQuery.of(context).size.width * 0.02, // 屏幕宽度的2%
                bottom: MediaQuery.of(context).size.height * 0.03, // 屏幕高度的3%
                child: GestureDetector(
                  onTap: () {}, // 阻止点击穿透
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withAlpha(51),
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
                                          '智慧课程表',
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '桌面小组件',
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

                            // 菜单项 - 按功能分组
                            // 窗口控制
                            _buildMenuItem(
                              context: context,
                              icon: Icons.visibility_rounded,
                              label: '显示/隐藏窗口',
                              onTap: () {
                                _safeCloseMenu(widget.onToggleWindow);
                              },
                            ),
                            
                            // 功能设置
                            _buildMenuItem(
                              context: context,
                              icon: Icons.edit_calendar_rounded,
                              label: '编辑课表',
                              onTap: () {
                                _safeCloseMenu(widget.onShowTimetableEdit);
                              },
                            ),
                            
                            _buildMenuItem(
                              context: context,
                              icon: Icons.dashboard_customize_rounded,
                              label: '编辑布局',
                              onTap: () {
                                _safeCloseMenu(widget.onToggleEditMode);
                              },
                            ),
                            
                            _buildMenuItem(
                              context: context,
                              icon: Icons.settings_rounded,
                              label: '设置',
                              onTap: () {
                                _safeCloseMenu(widget.onShowSettings);
                              },
                            ),
                            
                            // 分隔线
                            Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: colorScheme.outlineVariant,
                            ),

                            // 程序控制
                            _buildMenuItem(
                              context: context,
                              icon: Icons.exit_to_app_rounded,
                              label: '退出程序',
                              isDestructive: true,
                              onTap: () {
                                _safeCloseMenu(widget.onExit);
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
    final hoverColor = isDestructive ? colorScheme.errorContainer.withOpacity(0.2) : colorScheme.surfaceContainerHighest;
    final focusColor = colorScheme.onSurface.withOpacity(0.1);

    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isHovered = false;
            });
          },
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            hoverColor: hoverColor,
            focusColor: focusColor,
            highlightColor: colorScheme.onSurface.withOpacity(0.1),
            splashColor: colorScheme.onSurface.withOpacity(0.15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isHovered ? hoverColor : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      icon, 
                      color: color,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}