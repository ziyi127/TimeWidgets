import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_widgets/l10n/app_localizations.dart';
import 'package:time_widgets/services/theme_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_widgets/widgets/dynamic_color_builder.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:window_manager/window_manager.dart';

class SubWindowScreen extends StatefulWidget {
  final int windowId;
  final Map<String, dynamic>? arguments;

  const SubWindowScreen({
    super.key,
    required this.windowId,
    this.arguments,
  });

  @override
  State<SubWindowScreen> createState() => _SubWindowScreenState();
}

class _SubWindowScreenState extends State<SubWindowScreen> {
  @override
  void initState() {
    super.initState();
    /*
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      debugPrint('[SubWindow ${widget.windowId}] Received method call: ${call.method} from $fromWindowId');
      // Handle methods here
      return null;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    // We need to provide basic services like Theme for the sub-window
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsService()..loadSettings()),
        ChangeNotifierProvider(create: (_) => ThemeService()..loadSettings()),
      ],
      child: DynamicColorBuilder(
        builder: (lightTheme, darkTheme) {
          return Consumer<ThemeService>(
            builder: (context, themeService, _) {
              final themeSettings = themeService.currentSettings;
              
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('zh', 'CN'),
                  Locale('en', 'US'),
                ],
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeSettings.themeMode,
                home: Scaffold(
                  appBar: AppBar(
                    title: Text('Sub Window ${widget.windowId}'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          // Close this window using window_manager
                          await windowManager.close();
                        },
                      ),
                    ],
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Window ID: ${widget.windowId}'),
                        if (widget.arguments != null)
                          Text('Arguments: ${jsonEncode(widget.arguments)}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                             // Example: Send message back to main window (usually window 0)
                             // DesktopMultiWindow.invokeMethod(0, 'fromSubWindow', 'Hello from ${widget.windowId}');
                          },
                          child: const Text('Send Message to Main Window'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
