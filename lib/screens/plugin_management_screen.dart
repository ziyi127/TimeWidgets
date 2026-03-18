import 'package:flutter/material.dart';
import 'package:time_widgets/plugins/core/plugin_manager.dart';
import 'package:time_widgets/screens/plugin_settings_screen.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class PluginManagementScreen extends StatefulWidget {
  const PluginManagementScreen({super.key});

  @override
  State<PluginManagementScreen> createState() => _PluginManagementScreenState();
}

class _PluginManagementScreenState extends State<PluginManagementScreen> {
  final PluginManager _pluginManager = PluginManager();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlugins();
  }

  Future<void> _loadPlugins() async {
    try {
      await _pluginManager.init();
    } catch (e) {
      debugPrint('Error loading plugins: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _installPlugin() async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('当前版本不支持本地插件文件安装。'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error installing plugin: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('安装失败: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('插件管理'),
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
            // 实验性功能提示
            Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '插件功能仍处于实验阶段，可能存在安全风险。请仅安装来自可信来源的插件。',
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 标题
            Text(
              '插件管理',
              style: MD3TypographyStyles.headlineMedium(context),
            ),
            const SizedBox(height: 8),
            Text(
              '安装和管理第三方插件',
              style: MD3TypographyStyles.bodyMedium(context, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),

            // 插件列表
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    // 已安装插件
                    if (_pluginManager.installedManifests.isNotEmpty)
                      ..._pluginManager.installedManifests.entries.map((entry) {
                        final manifest = entry.value;
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.extension),
                            title: Text(manifest.name),
                            subtitle: Text('版本: ${manifest.version}'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              // 导航到插件设置页面
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => PluginSettingsScreen(pluginId: manifest.id),
                                ),
                              );
                            },
                          ),
                        );
                      })
                    else
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.extension_off, size: 64, color: colorScheme.onSurfaceVariant),
                                const SizedBox(height: 16),
                                Text(
                                  '暂无已安装的插件',
                                  style: MD3TypographyStyles.bodyLarge(context),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '点击下方按钮安装插件',
                                  style: MD3TypographyStyles.bodyMedium(context, color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // 安装插件按钮
                    FilledButton.icon(
                      onPressed: () async {
                        await _installPlugin();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('安装插件'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
