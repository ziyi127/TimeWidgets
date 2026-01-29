import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_widgets/plugins/core/plugin_manager.dart';

class PluginContainer extends StatelessWidget {
  final String pluginId;

  const PluginContainer({super.key, required this.pluginId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PluginManager>(
      builder: (context, manager, child) {
        final plugin = manager.activePlugins.firstWhere(
          (p) => p.manifest.id == pluginId,
          orElse: () => throw Exception('Plugin not active'),
        );

        // If plugin is not found or not active, we might want to show error or empty
        // But the firstWhere with orElse above handles it roughly. 
        // Better safety:
        try {
          final widget = plugin.buildWidget(context);
          if (widget == null) {
            return const Center(child: Text('This plugin provides no widget.'));
          }
          return widget;
        } catch (e) {
          return Center(child: Text('Error rendering plugin: $e'));
        }
      },
    );
  }
}
