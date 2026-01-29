import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:time_widgets/plugins/models/plugin_manifest.dart';
import 'package:time_widgets/plugins/core/plugin_interface.dart';
import 'package:time_widgets/plugins/security/signature_verifier.dart';
import 'package:time_widgets/plugins/impl/json_plugin.dart';

/// Manages the lifecycle, installation, and loading of plugins.
class PluginManager extends ChangeNotifier {
  static final PluginManager _instance = PluginManager._internal();
  factory PluginManager() => _instance;
  PluginManager._internal();

  final Map<String, TimeWidgetsPlugin> _activePlugins = {};
  final Map<String, PluginManifest> _installedManifests = {};
  
  String? _pluginsDir;

  bool _isInitialized = false;

  /// Getter for installed plugin manifests
  Map<String, PluginManifest> get installedManifests => _installedManifests;

  /// Getter for active plugins
  List<TimeWidgetsPlugin> get activePlugins => _activePlugins.values.toList();

  Future<void> init() async {
    if (_isInitialized) return;
    
    final appDocDir = await getApplicationDocumentsDirectory();
    _pluginsDir = path.join(appDocDir.path, 'plugins');
    final dir = Directory(_pluginsDir!);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    await _loadInstalledPlugins();
    _isInitialized = true;
  }

  /// Scans the plugins directory and loads manifest files.
  Future<void> _loadInstalledPlugins() async {
    if (_pluginsDir == null) return;
    final dir = Directory(_pluginsDir!);
    
    _installedManifests.clear();
    
    await for (final entity in dir.list()) {
      if (entity is Directory) {
        try {
          final manifestFile = File(path.join(entity.path, 'plugin.json'));
          if (await manifestFile.exists()) {
            final jsonStr = await manifestFile.readAsString();
            final manifest = PluginManifest.parse(jsonStr);
            _installedManifests[manifest.id] = manifest;
          }
        } catch (e) {
          debugPrint('Failed to load plugin manifest at ${entity.path}: $e');
        }
      }
    }
    notifyListeners();
  }

  /// Installs a plugin from a ZIP file.
  /// [zipFile]: The source .zip file.
  /// [signature]: Optional signature for verification.
  Future<void> installPlugin(File zipFile, {String signature = ''}) async {
    if (_pluginsDir == null) await init();

    debugPrint('Starting plugin installation from: ${zipFile.path}');

    // 1. Security Check
    final isValid = await SignatureVerifier.verify(zipFile, signature);
    if (!isValid) {
      throw Exception('Plugin signature verification failed.');
    }

    // 2. Read Zip
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // 3. Find manifest in zip to get ID
    ArchiveFile? manifestEntry;
    try {
      // 尝试在根目录查找
      manifestEntry = archive.findFile('plugin.json');
      
      // 如果根目录没找到，尝试在一级子目录中查找
      if (manifestEntry == null) {
        for (final file in archive) {
          if (file.name.endsWith('/plugin.json')) {
            manifestEntry = file;
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('Error finding manifest: $e');
    }
    
    if (manifestEntry == null) {
      // 打印所有文件，帮助调试
      debugPrint('All files in zip:');
      for (final file in archive) {
        debugPrint('  ${file.name}');
      }
      throw Exception('Invalid plugin: plugin.json not found in root or first-level directory.');
    }

    final manifestContent = utf8.decode(manifestEntry.content as List<int>);
    final tempManifest = PluginManifest.parse(manifestContent);
    final pluginId = tempManifest.id;
    
    debugPrint('Found plugin: $pluginId (${tempManifest.name})');

    // 4. Extract
    final installPath = path.join(_pluginsDir!, pluginId);
    final installDir = Directory(installPath);
    if (await installDir.exists()) {
      debugPrint('Plugin already exists, deleting old version: $installPath');
      await installDir.delete(recursive: true);
    }
    await installDir.create(recursive: true);
    
    debugPrint('Installing to: $installPath');

    // 确定是否需要处理嵌套目录
    bool hasNestedDirectory = false;
    String nestedDirName = '';
    
    // 检查是否所有文件都在一个共同的子目录中
    for (final file in archive) {
      if (file.isFile && file.name.contains('/')) {
        final parts = file.name.split('/');
        if (parts.length > 1) {
          hasNestedDirectory = true;
          nestedDirName = parts[0];
          break;
        }
      }
    }

    for (final file in archive) {
      final filename = file.name;
      String targetPath;
      
      if (hasNestedDirectory && filename.startsWith('$nestedDirName/')) {
        // 移除嵌套目录前缀
        targetPath = path.join(installPath, filename.substring(nestedDirName.length + 1));
      } else {
        targetPath = path.join(installPath, filename);
      }
      
      if (file.isFile) {
        try {
          final data = file.content as List<int>;
          final targetFile = File(targetPath);
          await targetFile.parent.create(recursive: true);
          await targetFile.writeAsBytes(data);
          debugPrint('Extracted: $filename -> $targetPath');
        } catch (e) {
          debugPrint('Error extracting $filename: $e');
        }
      } else {
        try {
          final targetDir = Directory(targetPath);
          await targetDir.create(recursive: true);
          debugPrint('Created directory: $targetPath');
        } catch (e) {
          debugPrint('Error creating directory $filename: $e');
        }
      }
    }

    // 5. Verify installation
    final installedManifestFile = File(path.join(installPath, 'plugin.json'));
    if (!await installedManifestFile.exists()) {
      throw Exception('Installation failed: plugin.json not found in installed directory.');
    }
    
    debugPrint('Installation verified: plugin.json exists');

    // 6. Reload
    await _loadInstalledPlugins();
    debugPrint('Plugin installation completed successfully');
  }

  /// Uninstalls a plugin.
  Future<void> uninstallPlugin(String pluginId) async {
    if (_activePlugins.containsKey(pluginId)) {
      await disablePlugin(pluginId);
    }
    
    if (_pluginsDir != null) {
      final pluginDir = Directory(path.join(_pluginsDir!, pluginId));
      if (await pluginDir.exists()) {
        await pluginDir.delete(recursive: true);
      }
    }
    
    _installedManifests.remove(pluginId);
    notifyListeners();
  }

  /// Enables and loads a plugin.
  Future<void> enablePlugin(String pluginId) async {
    if (_activePlugins.containsKey(pluginId)) return;
    
    final manifest = _installedManifests[pluginId];
    if (manifest == null) throw Exception('Plugin not found');

    // Here is where the "Dynamic Loading" happens.
    // In a Flutter AOT environment, we cannot simply load a .dart file.
    // We would typically use:
    // 1. A scripting engine (JS/Lua)
    // 2. A bytecode interpreter (dart_eval)
    // 3. Pre-compiled binaries (uncommon for cross-platform widgets)
    
    // For this system, we will assume a "Loader" strategy.
    // Since we don't have a JS engine installed yet, we'll simulate the loader
    // or use a placeholder that would delegate to the specific runtime.
    
    try {
      final plugin = await _loadPluginInstance(manifest);
      await plugin.onInit();
      _activePlugins[pluginId] = plugin;
      notifyListeners();
    } catch (e) {
      debugPrint('Error enabling plugin $pluginId: $e');
      rethrow;
    }
  }

  Future<void> disablePlugin(String pluginId) async {
    final plugin = _activePlugins[pluginId];
    if (plugin != null) {
      await plugin.onDispose();
      _activePlugins.remove(pluginId);
      notifyListeners();
    }
  }

  /// Internal method to instantiate the plugin.
  /// This is the extension point for the Scripting Engine.
  Future<TimeWidgetsPlugin> _loadPluginInstance(PluginManifest manifest) async {
    // For now, we default to the JSON-based plugin implementation.
    // In the future, we can check manifest.entryPoint or other metadata
    // to decide whether to load a JS plugin, a Dart Eval plugin, or a JSON plugin.
    
    final pluginPath = path.join(_pluginsDir!, manifest.id);
    return JsonPlugin(manifest, pluginPath);
  }

  List<PluginManifest> get installedPlugins => _installedManifests.values.toList();
}
