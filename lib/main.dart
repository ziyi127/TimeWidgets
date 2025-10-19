import 'package:flutter/material.dart';
import 'package:time_widgets/screens/home_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:tray_manager/tray_manager.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化窗口
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(400, 800);
    win.size = initialSize;
    win.minSize = const Size(400, 600);
    win.maxSize = const Size(400, 1000);
    win.alignment = Alignment.topRight;
    win.title = "智慧课程表";
    win.show();
  });
  
  // 初始化系统托盘
  await setupTrayManager();
  
  runApp(const TimeWidgetsApp());
}

// 设置系统托盘
Future<void> setupTrayManager() async {
  try {
    await trayManager.setIcon(
      Platform.isWindows ? 'assets/icons/app_icon.ico' : 'assets/icons/app_icon.png'
    );
    
    Menu menu = Menu(
      items: [
        MenuItem(label: '显示窗口', onClick: (_) => appWindow.show()),
        MenuItem.separator(),
        MenuItem(label: '退出', onClick: (_) => exit(0)),
      ],
    );
    
    await trayManager.setContextMenu(menu);
    await trayManager.setToolTip('智慧课程表');
  } catch (e) {
    // 托盘初始化失败，静默处理避免影响应用启动
    // 在生产环境中可以考虑使用日志服务
  }
}

class TimeWidgetsApp extends StatelessWidget {
  const TimeWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Schedule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DesktopWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 桌面模式包装器
class DesktopWrapper extends StatefulWidget {
  const DesktopWrapper({super.key});

  @override
  State<DesktopWrapper> createState() => _DesktopWrapperState();
}

class _DesktopWrapperState extends State<DesktopWrapper> with TrayListener {
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() async {
    // 点击托盘图标时显示/隐藏窗口
    if (appWindow.isVisible) {
      appWindow.hide();
    } else {
      appWindow.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    return HomeScreen(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }
}