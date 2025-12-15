import 'package:flutter/material.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/screens/desktop_widget_config_screen.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';
import 'package:time_widgets/utils/md3_card_styles.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/utils/md3_form_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/widgets/color_picker_widget.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final ThemeService _themeService = ThemeService();
  late AppSettings _settings;
  bool _isLoading = true;
  final TextEditingController _apiUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _settings = settings;
      _apiUrlController.text = settings.apiBaseUrl;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings(AppSettings newSettings) async {
    await _settingsService.saveSettings(newSettings);
    setState(() {
      _settings = newSettings;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保�?)),
      );
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await MD3DialogStyles.showConfirmDialog(
      context: context,
      title: '重置设置',
      message: '确定要将所有设置恢复为默认值吗？此操作无法撤销�?,
      confirmText: '重置',
      cancelText: '取消',
      isDestructive: true,
      icon: const Icon(Icons.restore),
    );

    if (confirmed == true) {
      await _settingsService.resetToDefaults();
      await _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设置已重�?)),
        );
      }
    }
  }


  Future<void> _selectSemesterStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _settings.semesterStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      await _saveSettings(_settings.copyWith(semesterStartDate: date));
    }
  }

  Future<void> _showColorPicker() async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: _settings.themeSettings.seedColor,
        title: '选择种子颜色',
      ),
    );

    if (selectedColor != null) {
      final newThemeSettings = _settings.themeSettings.copyWith(seedColor: selectedColor);
      await _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
      // 同时更新 ThemeService
      await _themeService.setSeedColor(selectedColor);
    }
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _settingsService.dispose();
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        actions: [
          MD3ButtonStyles.icon(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: '重置为默�?,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 主题设置
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('外观设置', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                
                // 主题模式选择
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MD3FormStyles.dropdown<ThemeMode>(
                    context: context,
                    value: _settings.themeSettings.themeMode,
                    label: '主题模式',
                    prefixIcon: const Icon(Icons.brightness_6_outlined),
                    onChanged: (value) {
                      if (value != null) {
                        final newThemeSettings = _settings.themeSettings.copyWith(themeMode: value);
                        _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('跟随系统')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('浅色')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('深色')),
                    ],
                  ),
                ),
                
                // 动态颜色开�?
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome_outlined),
                  title: const Text('动态颜�?),
                  subtitle: const Text('使用 Material You 动态取�?),
                  value: _settings.themeSettings.useDynamicColor,
                  onChanged: (value) {
                    final newThemeSettings = _settings.themeSettings.copyWith(useDynamicColor: value);
                    _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                  },
                ),
                
                // 种子颜色选择
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('种子颜色'),
                  subtitle: const Text('自定义应用主题颜�?),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 当前颜色显示
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _settings.themeSettings.seedColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MD3ButtonStyles.filledTonal(
                        onPressed: _showColorPicker,
                        child: const Text('选择'),
                        isCompact: true,
                      ),
                    ],
                  ),
                ),
                
                // 主题预览
                const SizedBox(height: 16),
                Text('主题预览', style: MD3TypographyStyles.titleSmall(context)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ThemePreview(
                        seedColor: _settings.themeSettings.seedColor,
                        isDark: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ThemePreview(
                        seedColor: _settings.themeSettings.seedColor,
                        isDark: true,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 语言设置
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MD3FormStyles.dropdown<String>(
                    context: context,
                    value: _settings.language,
                    label: '语言',
                    prefixIcon: const Icon(Icons.language),
                    onChanged: (value) {
                      if (value != null) {
                        _saveSettings(_settings.copyWith(language: value));
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'zh', child: Text('中文')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 桌面小组件设�?
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('桌面小组�?, style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.widgets_outlined),
                  title: const Text('小组件配�?),
                  subtitle: const Text('管理桌面小组件的显示和位�?),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DesktopWidgetConfigScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 学期设置
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('学期设置', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('学期开始日�?),
                  subtitle: Text(
                    _settings.semesterStartDate != null
                        ? '${_settings.semesterStartDate!.year}�?{_settings.semesterStartDate!.month}�?{_settings.semesterStartDate!.day}�?
                        : '未设�?,
                  ),
                  trailing: MD3ButtonStyles.filledTonal(
                    onPressed: _selectSemesterStartDate,
                    child: const Text('选择'),
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 通知设置
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('通知设置', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('启用通知'),
                  subtitle: const Text('接收课程和倒计时提�?),
                  value: _settings.enableNotifications,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enableNotifications: value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 数据刷新设置
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('数据刷新', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MD3FormStyles.dropdown<int>(
                    context: context,
                    value: _settings.weatherRefreshInterval,
                    label: '天气刷新间隔',
                    prefixIcon: const Icon(Icons.cloud_outlined),
                    onChanged: (value) {
                      if (value != null) {
                        _saveSettings(_settings.copyWith(weatherRefreshInterval: value));
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 15, child: Text('15分钟')),
                      DropdownMenuItem(value: 30, child: Text('30分钟')),
                      DropdownMenuItem(value: 60, child: Text('60分钟')),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: MD3FormStyles.dropdown<int>(
                    context: context,
                    value: _settings.countdownRefreshInterval,
                    label: '倒计时刷新间�?,
                    prefixIcon: const Icon(Icons.timer_outlined),
                    onChanged: (value) {
                      if (value != null) {
                        _saveSettings(_settings.copyWith(countdownRefreshInterval: value));
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('30�?)),
                      DropdownMenuItem(value: 60, child: Text('60�?)),
                      DropdownMenuItem(value: 120, child: Text('2分钟')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
    }
  }
}
