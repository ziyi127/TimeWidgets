import 'package:flutter/widgets.dart';
import 'package:time_widgets/plugins/models/plugin_manifest.dart';

/// Abstract interface that all plugins must implement (or be adapted to).
/// In a purely dynamic system (e.g. JS/Lua), the Loader would wrap the script
/// in an implementation of this interface.
abstract class TimeWidgetsPlugin {
  final PluginManifest manifest;

  TimeWidgetsPlugin(this.manifest);

  /// Called when the plugin is loaded.
  /// Use this to initialize resources, register services, etc.
  Future<void> onInit();

  /// Called when the plugin is unloaded or the app closes.
  Future<void> onDispose();

  /// Returns a widget to be displayed in the main dashboard/grid.
  /// Returns null if this plugin does not provide a widget.
  Widget? buildWidget(BuildContext context);

  /// Returns a list of menu items to add to the system tray.
  /// The generic type depends on your Tray library (e.g. MenuItem).
  /// For now returning a Map or custom object to decouple.
  List<PluginMenuItem> getTrayMenuItems();

  /// Returns settings definition for the settings screen.
  List<PluginSettingItem> getSettings();

  /// Called when a setting is changed.
  void onSettingChanged(String key, dynamic value);
}

class PluginMenuItem {
  final String label;
  final VoidCallback onTap;
  final List<PluginMenuItem>? subItems;

  PluginMenuItem({
    required this.label,
    required this.onTap,
    this.subItems,
  });
}

enum SettingType { string, boolean, number, choice }

class PluginSettingItem {
  final String key;
  final String label;
  final SettingType type;
  final dynamic defaultValue;
  final List<String>? options; // For choice type
  final Map<String, dynamic> extra; // For extra properties like multiline

  PluginSettingItem({
    required this.key,
    required this.label,
    required this.type,
    this.defaultValue,
    this.options,
    this.extra = const {},
  });
}
