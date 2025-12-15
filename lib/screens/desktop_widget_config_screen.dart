import 'package:flutter/material.dart';
import 'package:time_widgets/services/desktop_widget_service.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';

/// 桌面小组件配置屏�?
/// 允许用户管理小组件的可见性和位置
class DesktopWidgetConfigScreen extends StatefulWidget {
  const DesktopWidgetConfigScreen({super.key});

  @override
  State<DesktopWidgetConfigScreen> createState() => _DesktopWidgetConfigScreenState();
}

class _DesktopWidgetConfigScreenState extends State<DesktopWidgetConfigScreen> {
  Map<WidgetType, WidgetPosition> _widgetPositions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWidgetPositions();
  }

  Future<void> _loadWidgetPositions() async {
    final positions = await DesktopWidgetService.loadWidgetPositions();
    setState(() {
      _widgetPositions = positions;
      _isLoading = false;
    });
  }

  Future<void> _toggleWidgetVisibility(WidgetType type) async {
    await DesktopWidgetService.toggleWidgetVisibility(type);
    await _loadWidgetPositions();
  }

  Future<void> _resetPositions() async {
    await DesktopWidgetService.resetWidgetPositions();
    await _loadWidgetPositions();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationService.getString('reset_settings')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getWidgetName(WidgetType type) {
    switch (type) {
      case WidgetType.time:
        return '时间显示';
      case WidgetType.date:
        return '日期显示';
      case WidgetType.week:
        return '周次显示';
      case WidgetType.weather:
        return LocalizationService.getString('weather_info');
      case WidgetType.currentClass:
        return LocalizationService.getString('current_class');
      case WidgetType.countdown:
        return LocalizationService.getString('countdown_events');
      case WidgetType.timetable:
        return '课程�?;
      case WidgetType.settings:
        return LocalizationService.getString('settings');
    }
  }

  IconData _getWidgetIcon(WidgetType type) {
    switch (type) {
      case WidgetType.time:
        return Icons.access_time_rounded;
      case WidgetType.date:
        return Icons.calendar_today_rounded;
      case WidgetType.week:
        return Icons.event_note_rounded;
      case WidgetType.weather:
        return Icons.wb_cloudy_rounded;
      case WidgetType.currentClass:
        return Icons.school_rounded;
      case WidgetType.countdown:
        return Icons.timer_rounded;
      case WidgetType.timetable:
        return Icons.schedule_rounded;
      case WidgetType.settings:
        return Icons.settings_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '桌面小组件配�?,
          style: MD3TypographyStyles.headlineSmall(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          MD3ButtonStyles.text(
            onPressed: _resetPositions,
            child: const Text('重置位置'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildConfigContent(context),
    );
  }

  Widget _buildConfigContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 说明文字
          MD3CardStyles.surfaceContainer(
            context: context,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '使用说明',
                      style: MD3TypographyStyles.titleMedium(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '�?切换开关控制小组件的显�?隐藏\n'
                  '�?在桌面小组件界面点击"编辑布局"可拖拽调整位置\n'
                  '�?点击"重置位置"恢复默认布局',
                  style: MD3TypographyStyles.bodyMedium(context, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            '小组件管�?,
            style: MD3TypographyStyles.titleLarge(context),
          ),
          
          const SizedBox(height: 16),
          
          // 小组件列�?
          ...WidgetType.values.map((type) {
            final position = _widgetPositions[type];
            if (position == null) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWidgetConfigItem(context, type, position),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWidgetConfigItem(
    BuildContext context,
    WidgetType type,
    WidgetPosition position,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MD3CardStyles.surfaceContainer(
      context: context,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: position.isVisible 
                  ? colorScheme.primaryContainer 
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getWidgetIcon(type),
              color: position.isVisible 
                  ? colorScheme.onPrimaryContainer 
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getWidgetName(type),
                  style: MD3TypographyStyles.titleMedium(context),
                ),
                const SizedBox(height: 4),
                Text(
                  '位置: (${position.x.toInt()}, ${position.y.toInt()}) �?'
                  '尺寸: ${position.width.toInt()}×${position.height.toInt()}',
                  style: MD3TypographyStyles.bodySmall(context, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          
          // 开�?
          Switch(
            value: position.isVisible,
            onChanged: (value) => _toggleWidgetVisibility(type),
          ),
        ],
      ),
    );
  }
}
