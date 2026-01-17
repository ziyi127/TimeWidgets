import 'package:flutter/material.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/screens/desktop_widget_config_screen.dart';
import 'package:time_widgets/screens/about_screen.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/widgets/city_search_dialog.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';
import 'package:time_widgets/widgets/window_controls.dart';

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
        const SnackBar(content: Text('设置已保存')),
      );
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await MD3DialogStyles.showConfirmDialog(
      context: context,
      title: '重置设置',
      message: '确定要将所有设置恢复为默认值吗？此操作无法撤销。',
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
          const SnackBar(content: Text('设置已重置')),
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
    // 预设颜色列表
    const presetColors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.deepPurple,
      Colors.deepOrange,
    ];

    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择种子颜色'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // 预设颜色网格
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: presetColors.length,
                itemBuilder: (context, index) {
                  final color = presetColors[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: color == _settings.themeSettings.seedColor
                            ? Border.all(width: 3, color: Theme.of(context).colorScheme.onSurface)
                            : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // 保持不变选项
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_settings.themeSettings.seedColor),
                child: const Text('保持不变'),
              ),
            ],
          ),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 恢复主窗口原始尺寸和位置
            EnhancedWindowManager.restoreMainWindow();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: '重置为默认值',
          ),
          // 窗口控制按钮
          const SizedBox(width: 8),
          const WindowControls(restoreMainWindowOnClose: true),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 主题设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '外观设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // 主题模式选择
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonFormField<ThemeMode>(
                    initialValue: _settings.themeSettings.themeMode,
                    decoration: const InputDecoration(
                      labelText: '主题模式',
                      prefixIcon: Icon(Icons.brightness_6_outlined),
                      border: OutlineInputBorder(),
                    ),
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
                
                // 动态颜色开关
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome_outlined),
                  title: const Text('动态颜色'),
                  subtitle: const Text('使用 Material You 动态取色'),
                  value: _settings.themeSettings.useDynamicColor,
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings.copyWith(useDynamicColor: value);
                    await _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
                
                // 系统颜色开关
                SwitchListTile(
                  secondary: const Icon(Icons.wallpaper),
                  title: const Text('跟随系统颜色'),
                  subtitle: const Text('使用系统的强调色'),
                  value: _settings.themeSettings.useSystemColor,
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings.copyWith(useSystemColor: value);
                    await _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
                
                // 种子颜色选择
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('种子颜色'),
                  subtitle: const Text('自定义应用主题颜色'),
                  enabled: !_settings.themeSettings.useSystemColor, // 如果跟随系统，禁用手动选择
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
                      ElevatedButton(
                        onPressed: _settings.themeSettings.useSystemColor ? null : _showColorPicker,
                        child: const Text('选择'),
                      ),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                
                // 字体大小缩放
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_fields_outlined),
                          const SizedBox(width: 16),
                          Text(
                            '字体大小: ${_settings.themeSettings.fontSizeScale.toStringAsFixed(1)}x',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _settings.themeSettings.fontSizeScale,
                        min: 0.7,
                        max: 1.5,
                        divisions: 8,
                        label: _settings.themeSettings.fontSizeScale.toStringAsFixed(1),
                        onChanged: (value) {
                          final newThemeSettings = _settings.themeSettings.copyWith(fontSizeScale: value);
                          _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                        },
                      ),
                    ],
                  ),
                ),
                
                // 圆角大小
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.rounded_corner_outlined),
                          const SizedBox(width: 16),
                          Text(
                            '圆角大小: ${_settings.themeSettings.borderRadiusScale.toStringAsFixed(1)}x',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _settings.themeSettings.borderRadiusScale,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: _settings.themeSettings.borderRadiusScale.toStringAsFixed(1),
                        onChanged: (value) {
                          final newThemeSettings = _settings.themeSettings.copyWith(borderRadiusScale: value);
                          _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                        },
                      ),
                    ],
                  ),
                ),
                
                // 组件透明度
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.opacity_outlined),
                          const SizedBox(width: 16),
                          Text(
                            '组件透明度: ${(_settings.themeSettings.componentOpacity * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _settings.themeSettings.componentOpacity,
                        min: 0.7,
                        max: 1.0,
                        divisions: 3,
                        label: '${(_settings.themeSettings.componentOpacity * 100).toStringAsFixed(0)}%',
                        onChanged: (value) {
                          final newThemeSettings = _settings.themeSettings.copyWith(componentOpacity: value);
                          _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                        },
                      ),
                    ],
                  ),
                ),
                
                // 阴影强度
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.light_mode_outlined),
                          const SizedBox(width: 16),
                          Text(
                            '阴影强度: ${_settings.themeSettings.shadowStrength.toStringAsFixed(1)}x',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _settings.themeSettings.shadowStrength,
                        min: 0.0,
                        max: 2.0,
                        divisions: 20,
                        label: _settings.themeSettings.shadowStrength.toStringAsFixed(1),
                        onChanged: (value) {
                          final newThemeSettings = _settings.themeSettings.copyWith(shadowStrength: value);
                          _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                        },
                      ),
                    ],
                  ),
                ),
                
                // 启用渐变效果
                SwitchListTile(
                  secondary: const Icon(Icons.gradient_outlined),
                  title: const Text('启用渐变效果'),
                  subtitle: const Text('为按钮和卡片添加渐变效果'),
                  value: _settings.themeSettings.enableGradients,
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings.copyWith(enableGradients: value);
                    await _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
                
                // UI缩放
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.display_settings_outlined),
                          const SizedBox(width: 16),
                          Text(
                            '界面缩放: ${_settings.uiScale.toStringAsFixed(1)}x',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _settings.uiScale,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: _settings.uiScale.toStringAsFixed(1),
                        onChanged: (value) {
                          _saveSettings(_settings.copyWith(uiScale: value));
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 小部件显示设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '小部件显示',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.access_time_outlined),
                  title: const Text('时间显示'),
                  subtitle: const Text('在主屏幕显示时间'),
                  value: _settings.showTimeDisplayWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showTimeDisplayWidget: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.calendar_today_outlined),
                  title: const Text('日期显示'),
                  subtitle: const Text('在主屏幕显示日期'),
                  value: _settings.showDateDisplayWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showDateDisplayWidget: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.calendar_view_week_outlined),
                  title: const Text('周数显示'),
                  subtitle: const Text('在主屏幕显示当前周数'),
                  value: _settings.showWeekDisplayWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showWeekDisplayWidget: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_outlined),
                  title: const Text('天气显示'),
                  subtitle: const Text('在主屏幕显示天气信息'),
                  value: _settings.showWeatherWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showWeatherWidget: value));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('天气地区'),
                  subtitle: Text(_settings.cityName ?? '未设置'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final city = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (context) => const CitySearchDialog(),
                      );
                      if (city != null) {
                        await _saveSettings(_settings.copyWith(
                          latitude: city['latitude'],
                          longitude: city['longitude'],
                          cityName: city['name'],
                        ));
                      }
                    },
                    child: const Text('更改'),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.timer_outlined),
                  title: const Text('倒计时显示'),
                  subtitle: const Text('在主屏幕显示倒计时'),
                  value: _settings.showCountdownWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showCountdownWidget: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.school_outlined),
                  title: const Text('当前课程显示'),
                  subtitle: const Text('在主屏幕显示当前课程'),
                  value: _settings.showCurrentClassWidget,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(showCurrentClassWidget: value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 桌面小组件设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '桌面小组件',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.desktop_windows_outlined),
                  title: const Text('启用桌面小组件'),
                  subtitle: const Text('在桌面上显示小组件'),
                  value: _settings.enableDesktopWidgets,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enableDesktopWidgets: value));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.widgets_outlined),
                  title: const Text('小组件配置'),
                  subtitle: const Text('管理桌面小组件的显示和位置'),
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
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '学期设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('学期开始日期'),
                  subtitle: Text(
                    () {
                      final date = _settings.semesterStartDate;
                      return date != null
                          ? '${date.year}年${date.month}月${date.day}日'
                          : '未设置';
                    }(),
                  ),
                  trailing: ElevatedButton(
                    onPressed: _selectSemesterStartDate,
                    child: const Text('选择'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 刷新间隔设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '刷新间隔',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined),
                  title: const Text('天气刷新间隔'),
                  subtitle: Text('${_settings.weatherRefreshInterval} 分钟'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _settings.weatherRefreshInterval > 5 
                              ? () => _saveSettings(_settings.copyWith(weatherRefreshInterval: _settings.weatherRefreshInterval - 5))
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _settings.weatherRefreshInterval < 120
                              ? () => _saveSettings(_settings.copyWith(weatherRefreshInterval: _settings.weatherRefreshInterval + 5))
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('倒计时刷新间隔'),
                  subtitle: Text('${_settings.countdownRefreshInterval} 秒'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _settings.countdownRefreshInterval > 10 
                              ? () => _saveSettings(_settings.copyWith(countdownRefreshInterval: _settings.countdownRefreshInterval - 10))
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _settings.countdownRefreshInterval < 300
                              ? () => _saveSettings(_settings.copyWith(countdownRefreshInterval: _settings.countdownRefreshInterval + 10))
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 时间同步设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '时间同步',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.sync_rounded),
                  title: const Text('自动NTP同步'),
                  subtitle: const Text('开启后将自动校准系统时间'),
                  value: _settings.enableNtpSync,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enableNtpSync: value));
                    // If disabling, NtpService handles it via listener
                    // If enabling, NtpService handles it via listener
                  },
                ),
                if (_settings.enableNtpSync) ...[
                  ListTile(
                    leading: const Icon(Icons.dns_outlined),
                    title: const Text('NTP服务器'),
                    subtitle: Text(_settings.ntpServer),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                         final controller = TextEditingController(text: _settings.ntpServer);
                         final result = await showDialog<String>(
                           context: context,
                           builder: (context) => AlertDialog(
                             title: const Text('修改NTP服务器'),
                             content: TextField(
                               controller: controller,
                               decoration: const InputDecoration(
                                 labelText: '服务器地址',
                                 hintText: '例如: ntp.aliyun.com',
                               ),
                             ),
                             actions: [
                               TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
                               TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('确定')),
                             ],
                           ),
                         );
                         if (result != null && result.isNotEmpty) {
                           await _saveSettings(_settings.copyWith(ntpServer: result));
                           // Trigger sync manually to give immediate feedback
                           await NtpService().syncTime();
                           setState(() {});
                         }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: const Text('同步间隔'),
                    subtitle: Text('${_settings.ntpSyncInterval} 分钟'),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _settings.ntpSyncInterval > 10 
                                ? () => _saveSettings(_settings.copyWith(ntpSyncInterval: _settings.ntpSyncInterval - 10))
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _settings.ntpSyncInterval < 1440
                                ? () => _saveSettings(_settings.copyWith(ntpSyncInterval: _settings.ntpSyncInterval + 10))
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('当前状态'),
                    subtitle: Text('时间偏移: ${NtpService().offset}ms'),
                    trailing: TextButton(
                        onPressed: () async {
                            await NtpService().syncTime();
                            setState((){});
                        },
                        child: const Text('立即同步'),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 通知设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '通知设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('启用通知'),
                  subtitle: const Text('接收课程和倒计时提醒'),
                  value: _settings.enableNotifications,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enableNotifications: value));
                  },
                ),
                if (_settings.enableNotifications) ...[
                  SwitchListTile(
                    secondary: const Icon(Icons.access_time_outlined),
                    title: const Text('课程提醒'),
                    subtitle: const Text('开启后将在课程开始前提醒'),
                    value: _settings.enableCourseReminder,
                    onChanged: (value) {
                      _saveSettings(_settings.copyWith(enableCourseReminder: value));
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: const Text('语音提醒'),
                    subtitle: const Text('开启后将使用系统语音播报课程提醒'),
                    value: _settings.enableTtsForReminder,
                    onChanged: (value) {
                      _saveSettings(_settings.copyWith(enableTtsForReminder: value));
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.class_outlined),
                    title: const Text('课程开始通知'),
                    subtitle: const Text('在课程开始时发送通知'),
                    value: _settings.showNotificationOnClassStart,
                    onChanged: (value) {
                      _saveSettings(_settings.copyWith(showNotificationOnClassStart: value));
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.class_outlined),
                    title: const Text('课程结束通知'),
                    subtitle: const Text('在课程结束时发送通知'),
                    value: _settings.showNotificationOnClassEnd,
                    onChanged: (value) {
                      _saveSettings(_settings.copyWith(showNotificationOnClassEnd: value));
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.timer_outlined),
                    title: const Text('倒计时通知'),
                    subtitle: const Text('在倒计时结束时发送通知'),
                    value: _settings.showNotificationForCountdown,
                    onChanged: (value) {
                      _saveSettings(_settings.copyWith(showNotificationForCountdown: value));
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 启动行为设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '启动行为',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.start_outlined),
                  title: const Text('开机自启'),
                  subtitle: const Text('随系统启动时自动运行应用'),
                  value: _settings.startWithWindows,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(startWithWindows: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.minimize_outlined),
                  title: const Text('最小化到托盘'),
                  subtitle: const Text('关闭窗口时最小化到系统托盘'),
                  value: _settings.minimizeToTray,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(minimizeToTray: value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 高级设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '高级设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.developer_mode_outlined),
                  title: const Text('调试模式'),
                  subtitle: const Text('显示调试信息和日志'),
                  value: _settings.enableDebugMode,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enableDebugMode: value));
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.speed_outlined),
                  title: const Text('性能监控'),
                  subtitle: const Text('监控应用性能指标'),
                  value: _settings.enablePerformanceMonitoring,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(enablePerformanceMonitoring: value));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.api_outlined),
                  title: const Text('API基础地址'),
                  subtitle: Text(_settings.apiBaseUrl),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                       final controller = TextEditingController(text: _settings.apiBaseUrl);
                       final result = await showDialog<String>(
                         context: context,
                         builder: (context) => AlertDialog(
                           title: const Text('修改API基础地址'),
                           content: TextField(
                             controller: controller,
                             decoration: const InputDecoration(
                               labelText: 'API地址',
                               hintText: '例如: http://localhost:3000/api',
                             ),
                           ),
                           actions: [
                             TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
                             TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('确定')),
                           ],
                         ),
                       );
                       if (result != null && result.isNotEmpty) {
                         await _saveSettings(_settings.copyWith(apiBaseUrl: result));
                       }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 关于
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '关于',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('关于应用'),
                  subtitle: const Text('查看应用版本、开发者信息等'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 主题预览组件
class ThemePreview extends StatelessWidget {
  final Color seedColor;
  final bool isDark;

  const ThemePreview({
    super.key,
    required this.seedColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          isDark ? '深色模式' : '浅色模式',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}