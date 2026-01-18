import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';

/// 窗口控制组件
/// 包含最小化、最大化和关闭按钮
class WindowControls extends StatelessWidget {
  
  const WindowControls({
    super.key,
    this.restoreMainWindowOnClose = false,
  });
  /// 是否在关闭时恢复主窗口
  final bool restoreMainWindowOnClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // 最小化按钮
        IconButton(
          icon: const Icon(Icons.minimize),
          onPressed: appWindow.minimize,
          tooltip: '最小化',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          iconSize: 20,
        ),
        
        // 最大化/恢复按钮
        IconButton(
          icon: const Icon(Icons.fullscreen),
          onPressed: appWindow.maximizeOrRestore,
          tooltip: '最大化',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          iconSize: 20,
        ),
        
        // 关闭按钮
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (restoreMainWindowOnClose) {
              // 恢复主窗口原始尺寸和位置
              EnhancedWindowManager.restoreMainWindow();
            }
            // 不要关闭整个应用，而是返回上一页
            Navigator.pop(context);
          },
          tooltip: '关闭',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          hoverColor: Colors.red.withValues(alpha: 0.1),
          iconSize: 20,
        ),
      ],
    );
  }
}
