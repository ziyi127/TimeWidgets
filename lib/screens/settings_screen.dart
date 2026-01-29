import 'package:flutter/material.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/screens/about_screen.dart';
import 'package:time_widgets/screens/interconnection_screen.dart';
import 'package:time_widgets/screens/plugin_management_screen.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/startup_service.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/widgets/city_search_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _settings = settings;
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
        SnackBar(content: Text(AppLocalizations.of(context)!.settingsSaved)),
      );
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await MD3DialogStyles.showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.settingsResetTitle,
      message: AppLocalizations.of(context)!.settingsResetMessage,
      confirmText: AppLocalizations.of(context)!.settingsResetConfirm,
      isDestructive: true,
      icon: const Icon(Icons.restore),
    );

    if (confirmed ?? false) {
      await _settingsService.resetToDefaults();
      await _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.settingsResetSuccess)),
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
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectSeedColor),
        content: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 预设颜色网格
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: presetColors.length,
                  itemBuilder: (context, index) {
                    final color = presetColors[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(color),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: color == _settings.themeSettings.seedColor
                              ? Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // 保持不变选项
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(_settings.themeSettings.seedColor),
                  child: Text(AppLocalizations.of(context)!.keepUnchanged),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );

    if (selectedColor != null &&
        selectedColor != _settings.themeSettings.seedColor) {
      final newThemeSettings =
          _settings.themeSettings.copyWith(seedColor: selectedColor);
      await _saveSettings(_settings.copyWith(themeSettings: newThemeSettings));
      // 同时更新 ThemeService
      await _themeService.saveSettings(newThemeSettings);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: AppLocalizations.of(context)!.resetToDefault,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGeneralSettings(theme),
          const SizedBox(height: 16),
          _buildThemeSettings(theme),
          const SizedBox(height: 16),
          _buildWidgetSettings(theme),
          const SizedBox(height: 16),
          _buildSemesterSettings(theme),
          const SizedBox(height: 16),
          _buildRefreshSettings(theme),
          const SizedBox(height: 16),
          _buildTimeSyncSettings(theme),
          const SizedBox(height: 16),
          _buildNotificationSettings(theme),
          const SizedBox(height: 16),
          _buildStartupSettings(theme),
          const SizedBox(height: 16),
          _buildAdvancedSettings(theme),
          const SizedBox(height: 16),
          _buildInterconnectionSettings(theme),
          const SizedBox(height: 16),
          _buildAboutSettings(theme),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.generalSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(_settings.language == 'zh' 
              ? AppLocalizations.of(context)!.languageZh 
              : AppLocalizations.of(context)!.languageEn),
            trailing: DropdownButton<String>(
              value: _settings.language,
              underline: const SizedBox(),
              onChanged: (newValue) {
                if (newValue != null) {
                  _saveSettings(_settings.copyWith(language: newValue));
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'zh',
                  child: Text(AppLocalizations.of(context)!.languageZh),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(AppLocalizations.of(context)!.languageEn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.appearanceSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<ThemeMode>(
              initialValue: _settings.themeSettings.themeMode,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.themeMode,
                prefixIcon: const Icon(Icons.brightness_6_outlined),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) async {
                if (value != null) {
                  final newThemeSettings =
                      _settings.themeSettings.copyWith(themeMode: value);
                  await _saveSettings(
                    _settings.copyWith(
                      themeSettings: newThemeSettings,
                    ),
                  );
                  await _themeService.saveSettings(newThemeSettings);
                }
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(AppLocalizations.of(context)!.themeModeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(AppLocalizations.of(context)!.themeModeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(AppLocalizations.of(context)!.themeModeDark),
                ),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.auto_awesome_outlined),
            title: Text(AppLocalizations.of(context)!.dynamicColor),
            subtitle: Text(AppLocalizations.of(context)!.dynamicColorSubtitle),
            value: _settings.themeSettings.useDynamicColor,
            onChanged: (value) async {
              final newThemeSettings =
                  _settings.themeSettings.copyWith(useDynamicColor: value);
              await _saveSettings(
                _settings.copyWith(themeSettings: newThemeSettings),
              );
              await _themeService.saveSettings(newThemeSettings);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wallpaper),
            title: Text(AppLocalizations.of(context)!.followSystemColor),
            subtitle: Text(AppLocalizations.of(context)!.followSystemColorSubtitle),
            value: _settings.themeSettings.useSystemColor,
            onChanged: (value) async {
              final newThemeSettings =
                  _settings.themeSettings.copyWith(useSystemColor: value);
              await _saveSettings(
                _settings.copyWith(
                  themeSettings: newThemeSettings,
                  followSystemColor: value,
                ),
              );
              await _themeService.saveSettings(newThemeSettings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(AppLocalizations.of(context)!.seedColor),
            subtitle: Text(AppLocalizations.of(context)!.seedColorSubtitle),
            enabled: !_settings.themeSettings.useSystemColor,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _settings.themeSettings.seedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _settings.themeSettings.useSystemColor
                      ? null
                      : _showColorPicker,
                  child: Text(AppLocalizations.of(context)!.select),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
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
                      '${AppLocalizations.of(context)!.fontSize}: ${_settings.themeSettings.fontSizeScale.toStringAsFixed(1)}x',
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
                  onChanged: (value) async {
                    final newThemeSettings =
                        _settings.themeSettings.copyWith(fontSizeScale: value);
                    await _saveSettings(
                      _settings.copyWith(
                        themeSettings: newThemeSettings,
                      ),
                    );
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
              ],
            ),
          ),
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
                      '${AppLocalizations.of(context)!.borderRadius}: ${_settings.themeSettings.borderRadiusScale.toStringAsFixed(1)}x',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _settings.themeSettings.borderRadiusScale,
                  min: 0.5,
                  max: 2,
                  divisions: 15,
                  label: _settings.themeSettings.borderRadiusScale
                      .toStringAsFixed(1),
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings
                        .copyWith(borderRadiusScale: value);
                    await _saveSettings(
                      _settings.copyWith(
                        themeSettings: newThemeSettings,
                      ),
                    );
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
              ],
            ),
          ),
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
                      '${AppLocalizations.of(context)!.componentOpacity}: ${(_settings.themeSettings.componentOpacity * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _settings.themeSettings.componentOpacity,
                  min: 0.7,
                  divisions: 3,
                  label:
                      '${(_settings.themeSettings.componentOpacity * 100).toStringAsFixed(0)}%',
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings
                        .copyWith(componentOpacity: value);
                    await _saveSettings(
                      _settings.copyWith(
                        themeSettings: newThemeSettings,
                      ),
                    );
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
              ],
            ),
          ),
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
                      '${AppLocalizations.of(context)!.shadowStrength}: ${_settings.themeSettings.shadowStrength.toStringAsFixed(1)}x',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _settings.themeSettings.shadowStrength,
                  max: 2,
                  divisions: 20,
                  label: _settings.themeSettings.shadowStrength
                      .toStringAsFixed(1),
                  onChanged: (value) async {
                    final newThemeSettings = _settings.themeSettings
                        .copyWith(shadowStrength: value);
                    await _saveSettings(
                      _settings.copyWith(
                        themeSettings: newThemeSettings,
                      ),
                    );
                    await _themeService.saveSettings(newThemeSettings);
                  },
                ),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.gradient_outlined),
            title: Text(AppLocalizations.of(context)!.enableGradients),
            subtitle: Text(AppLocalizations.of(context)!.enableGradientsSubtitle),
            value: _settings.themeSettings.enableGradients,
            onChanged: (value) async {
              final newThemeSettings = _settings.themeSettings
                  .copyWith(enableGradients: value);
              await _saveSettings(
                _settings.copyWith(themeSettings: newThemeSettings),
              );
              await _themeService.saveSettings(newThemeSettings);
            },
          ),
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
                      '${AppLocalizations.of(context)!.uiScale}: ${_settings.uiScale.toStringAsFixed(1)}x',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _settings.uiScale,
                  min: 0.5,
                  max: 2,
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
    );
  }

  Widget _buildWidgetSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.widgetDisplaySettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.access_time_outlined),
            title: Text(AppLocalizations.of(context)!.timeDisplay),
            subtitle: Text(AppLocalizations.of(context)!.timeDisplaySubtitle),
            value: _settings.showTimeDisplayWidget,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(showTimeDisplayWidget: value),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.calendar_today_outlined),
            title: Text(AppLocalizations.of(context)!.dateDisplay),
            subtitle: Text(AppLocalizations.of(context)!.dateDisplaySubtitle),
            value: _settings.showDateDisplayWidget,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(showDateDisplayWidget: value),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.calendar_view_week_outlined),
            title: Text(AppLocalizations.of(context)!.weekDisplay),
            subtitle: Text(AppLocalizations.of(context)!.weekDisplaySubtitle),
            value: _settings.showWeekDisplayWidget,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(showWeekDisplayWidget: value),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_outlined),
            title: Text(AppLocalizations.of(context)!.weatherDisplay),
            subtitle: Text(AppLocalizations.of(context)!.weatherDisplaySubtitle),
            value: _settings.showWeatherWidget,
            onChanged: (value) {
              _saveSettings(_settings.copyWith(showWeatherWidget: value));
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(AppLocalizations.of(context)!.weatherLocation),
            subtitle: Text(_settings.cityName ?? AppLocalizations.of(context)!.notSet),
            trailing: ElevatedButton(
              onPressed: () async {
                final city = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => const CitySearchDialog(),
                );
                if (city != null) {
                  await _saveSettings(
                    _settings.copyWith(
                      latitude: city['latitude'] as double?,
                      longitude: city['longitude'] as double?,
                      cityName: city['name'] as String?,
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.change),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.timer_outlined),
            title: Text(AppLocalizations.of(context)!.countdownDisplay),
            subtitle: Text(AppLocalizations.of(context)!.countdownDisplaySubtitle),
            value: _settings.showCountdownWidget,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(showCountdownWidget: value),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.school_outlined),
            title: Text(AppLocalizations.of(context)!.currentClassDisplay),
            subtitle: Text(AppLocalizations.of(context)!.currentClassDisplaySubtitle),
            value: _settings.showCurrentClassWidget,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(showCurrentClassWidget: value),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.desktopWidgets,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.desktop_windows_outlined),
            title: Text(AppLocalizations.of(context)!.enableDesktopWidgets),
            subtitle: Text(AppLocalizations.of(context)!.enableDesktopWidgetsSubtitle),
            value: _settings.enableDesktopWidgets,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(enableDesktopWidgets: value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.semesterSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(AppLocalizations.of(context)!.semesterStartDate),
            subtitle: Text(
              () {
                final date = _settings.semesterStartDate;
                return date != null
                    ? '${date.year}年${date.month}月${date.day}日'
                    : AppLocalizations.of(context)!.notSet;
              }(),
            ),
            trailing: ElevatedButton(
              onPressed: _selectSemesterStartDate,
              child: Text(AppLocalizations.of(context)!.select),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.refreshSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: Text(AppLocalizations.of(context)!.weatherRefreshInterval),
            subtitle: Text('${_settings.weatherRefreshInterval} ${AppLocalizations.of(context)!.minutes}'),
            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _settings.weatherRefreshInterval > 5
                        ? () => _saveSettings(
                              _settings.copyWith(
                                weatherRefreshInterval:
                                    _settings.weatherRefreshInterval - 5,
                              ),
                            )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _settings.weatherRefreshInterval < 120
                        ? () => _saveSettings(
                              _settings.copyWith(
                                weatherRefreshInterval:
                                    _settings.weatherRefreshInterval + 5,
                              ),
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(AppLocalizations.of(context)!.countdownRefreshInterval),
            subtitle: Text('${_settings.countdownRefreshInterval} ${AppLocalizations.of(context)!.seconds}'),
            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _settings.countdownRefreshInterval > 10
                        ? () => _saveSettings(
                              _settings.copyWith(
                                countdownRefreshInterval:
                                    _settings.countdownRefreshInterval - 10,
                              ),
                            )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _settings.countdownRefreshInterval < 300
                        ? () => _saveSettings(
                              _settings.copyWith(
                                countdownRefreshInterval:
                                    _settings.countdownRefreshInterval + 10,
                              ),
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSyncSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.timeSyncSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.sync_rounded),
            title: Text(AppLocalizations.of(context)!.autoNtpSync),
            subtitle: Text(AppLocalizations.of(context)!.autoNtpSyncSubtitle),
            value: _settings.enableNtpSync,
            onChanged: (value) {
              _saveSettings(_settings.copyWith(enableNtpSync: value));
            },
          ),
          if (_settings.enableNtpSync) ...[
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(AppLocalizations.of(context)!.ntpServer),
              subtitle: Text(_settings.ntpServer),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final controller =
                      TextEditingController(text: _settings.ntpServer);
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.modifyNtpServer),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.serverAddress,
                          hintText: AppLocalizations.of(context)!.ntpServerHint,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, controller.text),
                          child: Text(AppLocalizations.of(context)!.confirm),
                        ),
                      ],
                    ),
                  );
                  if (result != null && result.isNotEmpty) {
                    await _saveSettings(
                      _settings.copyWith(ntpServer: result),
                    );
                    await NtpService().syncTime();
                    setState(() {});
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text(AppLocalizations.of(context)!.syncInterval),
              subtitle: Text('${_settings.ntpSyncInterval} ${AppLocalizations.of(context)!.minutes}'),
              trailing: SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _settings.ntpSyncInterval > 10
                          ? () => _saveSettings(
                                _settings.copyWith(
                                  ntpSyncInterval:
                                      _settings.ntpSyncInterval - 10,
                                ),
                              )
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _settings.ntpSyncInterval < 1440
                          ? () => _saveSettings(
                                _settings.copyWith(
                                  ntpSyncInterval:
                                      _settings.ntpSyncInterval + 10,
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(AppLocalizations.of(context)!.currentStatus),
              subtitle: Text('${AppLocalizations.of(context)!.timeOffset}: ${NtpService().offset}ms'),
              trailing: TextButton(
                onPressed: () async {
                  await NtpService().syncTime();
                  setState(() {});
                },
                child: Text(AppLocalizations.of(context)!.syncNow),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.notificationSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(AppLocalizations.of(context)!.enableNotifications),
            subtitle: Text(AppLocalizations.of(context)!.enableNotificationsSubtitle),
            value: _settings.enableNotifications,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(enableNotifications: value),
              );
            },
          ),
          if (_settings.enableNotifications) ...[
            SwitchListTile(
              secondary: const Icon(Icons.access_time_outlined),
              title: Text(AppLocalizations.of(context)!.courseReminder),
              subtitle: Text(AppLocalizations.of(context)!.courseReminderSubtitle),
              value: _settings.enableCourseReminder,
              onChanged: (value) {
                _saveSettings(
                  _settings.copyWith(enableCourseReminder: value),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: Text(AppLocalizations.of(context)!.voiceReminder),
              subtitle: Text(AppLocalizations.of(context)!.voiceReminderSubtitle),
              value: _settings.enableTtsForReminder,
              onChanged: (value) {
                _saveSettings(
                  _settings.copyWith(enableTtsForReminder: value),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.class_outlined),
              title: Text(AppLocalizations.of(context)!.classStartNotification),
              subtitle: Text(AppLocalizations.of(context)!.classStartNotificationSubtitle),
              value: _settings.showNotificationOnClassStart,
              onChanged: (value) {
                _saveSettings(
                  _settings.copyWith(
                    showNotificationOnClassStart: value,
                  ),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.class_outlined),
              title: Text(AppLocalizations.of(context)!.classEndNotification),
              subtitle: Text(AppLocalizations.of(context)!.classEndNotificationSubtitle),
              value: _settings.showNotificationOnClassEnd,
              onChanged: (value) {
                _saveSettings(
                  _settings.copyWith(
                    showNotificationOnClassEnd: value,
                  ),
                );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.timer_outlined),
              title: Text(AppLocalizations.of(context)!.countdownNotification),
              subtitle: Text(AppLocalizations.of(context)!.countdownNotificationSubtitle),
              value: _settings.showNotificationForCountdown,
              onChanged: (value) {
                _saveSettings(
                  _settings.copyWith(
                    showNotificationForCountdown: value,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStartupSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.startupSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.start_outlined),
            title: Text(AppLocalizations.of(context)!.startWithWindows),
            subtitle: Text(AppLocalizations.of(context)!.startWithWindowsSubtitle),
            value: _settings.startWithWindows,
            onChanged: (value) async {
              if (value) {
                await StartupService().enable();
              } else {
                await StartupService().disable();
              }
              await _saveSettings(_settings.copyWith(startWithWindows: value));
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.minimize_outlined),
            title: Text(AppLocalizations.of(context)!.minimizeToTray),
            subtitle: Text(AppLocalizations.of(context)!.minimizeToTraySubtitle),
            value: _settings.minimizeToTray,
            onChanged: (value) {
              _saveSettings(_settings.copyWith(minimizeToTray: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.advancedSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.developer_mode_outlined),
            title: Text(AppLocalizations.of(context)!.debugMode),
            subtitle: Text(AppLocalizations.of(context)!.debugModeSubtitle),
            value: _settings.enableDebugMode,
            onChanged: (value) {
              _saveSettings(_settings.copyWith(enableDebugMode: value));
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.speed_outlined),
            title: Text(AppLocalizations.of(context)!.performanceMonitoring),
            subtitle: Text(AppLocalizations.of(context)!.performanceMonitoringSubtitle),
            value: _settings.enablePerformanceMonitoring,
            onChanged: (value) {
              _saveSettings(
                _settings.copyWith(enablePerformanceMonitoring: value),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.api_outlined),
            title: Text(AppLocalizations.of(context)!.apiBaseUrl),
            subtitle: Text(_settings.apiBaseUrl),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final controller =
                    TextEditingController(text: _settings.apiBaseUrl);
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.modifyApiBaseUrl),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.apiUrl,
                        hintText: AppLocalizations.of(context)!.apiUrlHint,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, controller.text),
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ],
                  ),
                );
                if (result != null && result.isNotEmpty) {
                  await _saveSettings(
                    _settings.copyWith(apiBaseUrl: result),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterconnectionSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.interconnectionSettings,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.experimental,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.devices_other),
            title: Text(AppLocalizations.of(context)!.interconnectionSettings),
            subtitle: Text(AppLocalizations.of(context)!.interconnectionSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final confirm = await MD3DialogStyles.showConfirmDialog(
                context: context,
                title: AppLocalizations.of(context)!.securityWarning,
                message: AppLocalizations.of(context)!.securityWarningMessage,
                confirmText: AppLocalizations.of(context)!.securityWarningConfirm,
                icon: Icon(Icons.warning_amber_rounded,
                    color: theme.colorScheme.error,),
              );

              if (confirm ?? false) {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const InterconnectionScreen(),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: const Text('插件管理'),
            subtitle: const Text('安装和管理第三方插件'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final confirm = await MD3DialogStyles.showConfirmDialog(
                context: context,
                title: AppLocalizations.of(context)!.securityWarning,
                message: '插件可能会访问您的设备数据，请注意安全。仅安装来自可信来源的插件。',
                confirmText: AppLocalizations.of(context)!.securityWarningConfirm,
                icon: Icon(Icons.warning_amber_rounded,
                    color: theme.colorScheme.error,),
              );

              if (confirm ?? false) {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const PluginManagementScreen(),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings(ThemeData theme) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.aboutSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.aboutApp),
            subtitle: Text(AppLocalizations.of(context)!.aboutAppSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.seedColor,
    required this.isDark,
  });
  final Color seedColor;
  final bool isDark;

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
          isDark ? AppLocalizations.of(context)!.themeModeDark : AppLocalizations.of(context)!.themeModeLight,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
