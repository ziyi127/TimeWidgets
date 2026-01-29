import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:time_widgets/plugins/core/plugin_interface.dart';
import 'package:time_widgets/plugins/models/plugin_manifest.dart';
import 'package:time_widgets/plugins/ui/json_widget_builder.dart';
import 'package:path/path.dart' as path;

class JsonPlugin extends TimeWidgetsPlugin {
  final String pluginDir;
  Map<String, dynamic>? _layoutJson;
  List<dynamic>? _trayJson;
  List<dynamic>? _settingsJson;

  JsonPlugin(PluginManifest manifest, this.pluginDir) : super(manifest);

  @override
  Future<void> onInit() async {
    // Load layout.json if exists
    final layoutFile = File(path.join(pluginDir, 'layout.json'));
    if (await layoutFile.exists()) {
      _layoutJson = json.decode(await layoutFile.readAsString()) as Map<String, dynamic>?;
    }

    // Load tray.json if exists
    final trayFile = File(path.join(pluginDir, 'tray.json'));
    if (await trayFile.exists()) {
      _trayJson = json.decode(await trayFile.readAsString()) as List<dynamic>?;
    }

    // Load settings.json if exists
    final settingsFile = File(path.join(pluginDir, 'settings.json'));
    if (await settingsFile.exists()) {
      _settingsJson = json.decode(await settingsFile.readAsString()) as List<dynamic>?;
    }
  }

  @override
  Future<void> onDispose() async {
    // Cleanup if needed
  }

  @override
  Widget? buildWidget(BuildContext context) {
    if (_layoutJson == null) return null;
    try {
      return JsonWidgetBuilder.build(_layoutJson!, context);
    } catch (e) {
      return Text('Error loading plugin widget: $e');
    }
  }

  @override
  List<PluginMenuItem> getTrayMenuItems() {
    if (_trayJson == null) return [];
    
    return _trayJson!.map((item) {
      final map = item as Map<String, dynamic>;
      return PluginMenuItem(
        label: map['label'] as String? ?? 'Menu Item',
        onTap: () {
          print('Plugin menu item tapped: ${map['action']}');
          // Handle actions (url, command, etc.)
        },
      );
    }).toList();
  }

  @override
  List<PluginSettingItem> getSettings() {
    if (_settingsJson == null) return [];

    return _settingsJson!.map((item) {
      final map = item as Map<String, dynamic>;
      
      // 提取额外属性
      final extra = <String, dynamic>{};
      if (map.containsKey('multiline')) {
        extra['multiline'] = map['multiline'];
      }
      
      return PluginSettingItem(
        key: map['key'] as String,
        label: map['label'] as String,
        type: _parseSettingType(map['type'] as String?),
        defaultValue: map['defaultValue'],
        options: (map['options'] as List?)?.map((e) => e.toString()).toList(),
        extra: extra,
      );
    }).toList();
  }

  SettingType _parseSettingType(String? type) {
    switch (type) {
      case 'boolean': return SettingType.boolean;
      case 'number': return SettingType.number;
      case 'choice': return SettingType.choice;
      default: return SettingType.string;
    }
  }

  @override
  void onSettingChanged(String key, dynamic value) {
    // Save to persistent storage or notify plugin logic
    print('Plugin ${manifest.id} setting changed: $key = $value');
  }
}
