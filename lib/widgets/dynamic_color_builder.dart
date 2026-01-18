import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart' as plugin;
import 'package:flutter/material.dart';
import 'package:time_widgets/models/theme_settings_model.dart';
import 'package:time_widgets/services/theme_service.dart';

/// 动态颜色构建器
/// 根据当前的主题设置动态生成浅色和深色主题
/// 支持实时主题更新和系统动态取色
class DynamicColorBuilder extends StatefulWidget {
  const DynamicColorBuilder({
    super.key,
    required this.builder,
    this.defaultSeedColor,
    this.themeService,
  });

  /// 构建器函数，接收生成的浅色和深色主题
  final Widget Function(ThemeData lightTheme, ThemeData darkTheme) builder;

  /// 默认种子颜色，当无法获取设置时使用
  final Color? defaultSeedColor;

  /// 主题服务实例，用于获取主题设置
  final ThemeService? themeService;

  @override
  State<DynamicColorBuilder> createState() => _DynamicColorBuilderState();
}

class _DynamicColorBuilderState extends State<DynamicColorBuilder> {
  late ThemeService _themeService;
  ThemeSettings? _themeSettings;
  StreamSubscription<ThemeSettings>? _themeSubscription;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
    _initializeSettings();
  }

  /// 初始化设置
  Future<void> _initializeSettings() async {
    try {
      final settings = await _themeService.loadSettings();
      if (mounted) {
        setState(() {
          _themeSettings = settings;
        });
      }

      _themeSubscription = _themeService.themeStream.listen((settings) {
        if (mounted) {
          setState(() {
            _themeSettings = settings;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _themeSettings = ThemeSettings.defaultSettings();
        });
      }
    }
  }

  @override
  void dispose() {
    _themeSubscription?.cancel();
    if (widget.themeService == null) {
      _themeService.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用当前设置或默认设置
    final themeSettings = _themeSettings ?? ThemeSettings.defaultSettings();

    return plugin.DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        Color seedColor = themeSettings.seedColor;

        // 如果启用了系统取色且可用，使用系统颜色
        if (themeSettings.useSystemColor && lightDynamic != null) {
          seedColor = lightDynamic.primary;
        }

        final lightTheme = _themeService.generateLightTheme(seedColor);
        final darkTheme = _themeService.generateDarkTheme(seedColor);

        return widget.builder(lightTheme, darkTheme);
      },
    );
  }
}

/// 简化版的动态颜色构建器
/// 用于只需要当前主题的场景
class SimpleDynamicColorBuilder extends StatelessWidget {
  const SimpleDynamicColorBuilder({
    super.key,
    required this.builder,
    this.defaultSeedColor,
    this.forceBrightness,
  });

  /// 构建器函数，接收当前主题
  final Widget Function(ThemeData theme) builder;

  /// 默认种子颜色
  final Color? defaultSeedColor;

  /// 强制使用的亮度模式
  final Brightness? forceBrightness;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      defaultSeedColor: defaultSeedColor,
      builder: (lightTheme, darkTheme) {
        // 根据当前系统亮度或强制亮度选择主题
        final brightness =
            forceBrightness ?? MediaQuery.of(context).platformBrightness;

        final theme = brightness == Brightness.dark ? darkTheme : lightTheme;
        return builder(theme);
      },
    );
  }
}

/// 主题预览 widget
/// 用于在设置界面预览不同的主题效果
class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.seedColor,
    this.isDark = false,
    this.child,
  });

  /// 种子颜色
  final Color seedColor;

  /// 是否为深色模式
  final bool isDark;

  /// 预览内容
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();
    final theme = isDark
        ? themeService.generateDarkTheme(seedColor)
        : themeService.generateLightTheme(seedColor);

    return Theme(
      data: theme,
      child: child ?? _buildDefaultPreview(theme),
    );
  }

  /// 构建默认预览内容
  Widget _buildDefaultPreview(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Text(
            isDark ? '深色主题' : '浅色主题',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // 按钮示例
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('主要'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('次要'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('文本'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 卡片示例
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.palette,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '这是一个示例卡片',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
