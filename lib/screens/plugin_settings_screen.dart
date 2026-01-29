import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_widgets/plugins/core/plugin_manager.dart';
import 'package:time_widgets/plugins/core/plugin_interface.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class PluginSettingsScreen extends StatefulWidget {
  final String pluginId;

  const PluginSettingsScreen({super.key, required this.pluginId});

  @override
  State<PluginSettingsScreen> createState() => _PluginSettingsScreenState();
}

class _PluginSettingsScreenState extends State<PluginSettingsScreen> {
  final PluginManager _pluginManager = PluginManager();
  TimeWidgetsPlugin? _plugin;
  bool _isLoading = true;
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _loadPlugin();
  }

  Future<void> _loadPlugin() async {
    try {
      // 确保插件管理器已初始化
      await _pluginManager.init();
      
      // 启用插件
      await _pluginManager.enablePlugin(widget.pluginId);
      
      // 获取插件实例
      _plugin = _pluginManager.activePlugins.firstWhere(
        (p) => p.manifest.id == widget.pluginId,
        orElse: () => throw Exception('Plugin not found'),
      );
      
      // 加载插件设置
      _loadPluginSettings();
    } catch (e) {
      print('Error loading plugin: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载插件失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadPluginSettings() {
    if (_plugin == null) return;
    
    // 加载插件的设置定义
    final settings = _plugin!.getSettings();
    // 初始化设置值
    for (final setting in settings) {
      _settings[setting.key] = setting.defaultValue;
    }
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
    
    // 通知插件设置已更改
    _plugin?.onSettingChanged(key, value);
    
    // 处理自动创建桌面小组件
    if (key == 'createDesktopWidget' && value == true) {
      _handleCreateDesktopWidget();
    }
  }

  Future<void> _handleCreateDesktopWidget() async {
    try {
      // TODO: 实现创建桌面小组件的逻辑
      // 这里需要与桌面小组件服务交互
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已为插件创建桌面小组件')),
        );
      }
    } catch (e) {
      print('Error creating desktop widget: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建桌面小组件失败: $e')),
        );
      }
    }
  }

  Future<void> _uninstallPlugin() async {
    try {
      // 显示确认对话框
      final confirm = await MD3DialogStyles.showConfirmDialog(
        context: context,
        title: '移除插件',
        message: '确定要移除这个插件吗？此操作无法撤销。',
        confirmText: '移除',
        cancelText: '取消',
        isDestructive: true,
        icon: const Icon(Icons.delete),
      );

      if (confirm != true) return;

      // 移除插件
      await _pluginManager.uninstallPlugin(widget.pluginId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('插件已成功移除')),
        );
        
        // 返回上一页
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error uninstalling plugin: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('移除失败: $e')),
        );
      }
    }
  }

  Widget _buildSettingWidget(PluginSettingItem setting) {
    final currentValue = _settings[setting.key];
    
    switch (setting.type) {
      case SettingType.boolean:
        return SwitchListTile(
          title: Text(setting.label),
          value: (currentValue as bool?) ?? false,
          onChanged: (value) => _onSettingChanged(setting.key, value),
        );
      case SettingType.string:
        return ListTile(
          title: Text(setting.label),
          subtitle: Text((currentValue as String?) ?? ''),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            // 显示输入对话框
            final result = await MD3DialogStyles.showInputDialog(
              context: context,
              title: setting.label,
              initialValue: currentValue?.toString(),
              maxLines: setting.extra?['multiline'] == true ? 5 : 1,
            );
            if (result != null) {
              _onSettingChanged(setting.key, result);
            }
          },
        );
      case SettingType.number:
        return ListTile(
          title: Text(setting.label),
          subtitle: Text(currentValue?.toString() ?? ''),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            // 显示输入对话框
            final result = await MD3DialogStyles.showInputDialog(
              context: context,
              title: setting.label,
              initialValue: currentValue?.toString(),
              validator: (value) {
                if (value == null || value.isEmpty) return '请输入值';
                if (double.tryParse(value) == null) return '请输入有效的数字';
                return null;
              },
            );
            if (result != null) {
              _onSettingChanged(setting.key, double.parse(result));
            }
          },
        );
      case SettingType.choice:
        return ListTile(
          title: Text(setting.label),
          subtitle: Text(currentValue?.toString() ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            // 显示选择对话框
            if (setting.options == null || setting.options!.isEmpty) return;
            
            // 转换为选择对话框项
            final items = setting.options!.map((option) => {
              'value': option,
              'title': option,
            }).toList();
            
            // TODO: 实现选择对话框
            // 这里需要使用MD3DialogStyles.showSelectionDialog
            
            // 临时实现
            _onSettingChanged(setting.key, setting.options![0]);
          },
        );
      default:
        return ListTile(
          title: Text(setting.label),
          subtitle: Text('不支持的设置类型'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('插件设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_plugin == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('插件设置')),
        body: const Center(child: Text('无法加载插件')),
      );
    }

    final settings = _plugin!.getSettings();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(_plugin!.manifest.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 插件信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _plugin!.manifest.name,
                      style: MD3TypographyStyles.headlineSmall(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _plugin!.manifest.description,
                      style: MD3TypographyStyles.bodyMedium(context),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          '版本: ${_plugin!.manifest.version}',
                          style: MD3TypographyStyles.bodySmall(context, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          '作者: ${_plugin!.manifest.author}',
                          style: MD3TypographyStyles.bodySmall(context, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '最低应用版本: ${_plugin!.manifest.minAppVersion}',
                      style: MD3TypographyStyles.bodySmall(context, color: colorScheme.onSurfaceVariant),
                    ),
                    if (_plugin!.manifest.permissions != null && _plugin!.manifest.permissions!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            '权限: ${_plugin!.manifest.permissions!.join(', ')}',
                            style: MD3TypographyStyles.bodySmall(context, color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 插件设置
            Text(
              '插件设置',
              style: MD3TypographyStyles.headlineMedium(context),
            ),
            const SizedBox(height: 16),

            if (settings.isNotEmpty)
              Expanded(
                child: ListView(
                  children: settings.map((setting) {
                    return _buildSettingWidget(setting);
                  }).toList(),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text('此插件无设置项'),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uninstallPlugin,
                    icon: const Icon(Icons.delete),
                    label: const Text('移除插件'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
