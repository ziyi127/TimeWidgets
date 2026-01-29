import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/plugins/core/plugin_manager.dart';
import 'package:time_widgets/plugins/models/plugin_manifest.dart';
import 'package:time_widgets/screens/plugin_settings_screen.dart';
import 'package:time_widgets/utils/md3_dialog_styles.dart';
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
      // 打开文件选择器
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        dialogTitle: '选择插件ZIP文件',
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = File(result.files.first.path!);

      // 临时解析插件清单以获取信息
      PluginManifest? tempManifest;
      try {
        // 从ZIP文件读取plugin.json
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        
        // 查找plugin.json文件
        ArchiveFile? manifestEntry;
        try {
          manifestEntry = archive.findFile('plugin.json');
          // 如果根目录没找到，尝试在一级子目录中查找
          if (manifestEntry == null) {
            for (final entry in archive) {
              if (entry.name.endsWith('/plugin.json')) {
                manifestEntry = entry;
                break;
              }
            }
          }
        } catch (_) {}
        
        if (manifestEntry != null) {
          final manifestContent = utf8.decode(manifestEntry.content as List<int>);
          tempManifest = PluginManifest.parse(manifestContent);
        } else {
          throw Exception('plugin.json not found');
        }
      } catch (e) {
        debugPrint('Error parsing manifest: $e');
        tempManifest = PluginManifest(
          id: 'temp_id',
          name: '插件',
          version: '1.0.0',
          author: '未知',
          description: '无法解析插件信息，请谨慎安装',
          minAppVersion: '1.0.0',
          entryPoint: 'main.js',
        );
      }

      // 显示安装确认对话框
      final confirm = await MD3DialogStyles.showConfirmDialog(
        context: context,
        title: '安装插件',
        message: '名称: ${tempManifest.name}\n版本: ${tempManifest.version}\n作者: ${tempManifest.author}\n\n${tempManifest.description}\n\n确定要安装此插件吗？请确保插件来自可信来源。',
        confirmText: '安装',
        cancelText: '取消',
        icon: const Icon(Icons.extension),
      );

      if (confirm != true) {
        return;
      }

      // 显示加载状态
      setState(() {
        _isLoading = true;
      });

      // 安装插件
      await _pluginManager.installPlugin(file);

      // 重新加载插件列表
      await _loadPlugins();

      // 显示安装成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('插件安装成功: ${tempManifest.name}')),
        );
      }
    } catch (e) {
      debugPrint('Error installing plugin: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('安装失败: ${e.toString()}')),
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

  Future<Widget?> _loadPluginWidget(String pluginId) async {
    try {
      // 启用插件
      await _pluginManager.enablePlugin(pluginId);
      
      // 获取插件实例
      final plugin = _pluginManager.activePlugins.firstWhere(
        (p) => p.manifest.id == pluginId,
        orElse: () => throw Exception('Plugin not active'),
      );
      
      // 构建widget
      final widget = plugin.buildWidget(context);
      return widget;
    } catch (e) {
      debugPrint('Error loading plugin widget: $e');
      throw e;
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
                                MaterialPageRoute(
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
