import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/timetable_edit_service.dart';
import '../services/timetable_storage_service.dart';
import '../services/classisland_import_service.dart';
import '../services/timetable_export_service.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_navigation_styles.dart';
import '../utils/md3_typography_styles.dart';
import 'course_edit_screen.dart';
import 'time_slot_edit_screen.dart';
import 'daily_course_edit_screen.dart';
import 'json_data_viewer_screen.dart';

class TimetableEditScreen extends StatefulWidget {
  const TimetableEditScreen({super.key});

  @override
  State<TimetableEditScreen> createState() => _TimetableEditScreenState();
}

class _TimetableEditScreenState extends State<TimetableEditScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TimetableEditService _timetableEditService;
  late TimetableStorageService _storageService;
  final TimetableExportService _exportService = TimetableExportService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _timetableEditService = TimetableEditService();
    _storageService = TimetableStorageService();
    _loadTimetableData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTimetableData() async {
    final data = await _storageService.loadTimetableData();
    _timetableEditService.loadTimetableData(data);
  }

  Future<void> _saveTimetableData() async {
    try {
      await _timetableEditService.saveTimetableData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('课表数据已保存')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    }
  }

  Future<void> _importFromClassisland() async {
    try {
      final importedData = await ClassislandImportService.importFromFile();
      if (importedData != null) {
        // 更新编辑服务中的数据
        _timetableEditService.loadTimetableData(importedData);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已成功导入Classisland数据')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  Future<void> _exportToFile() async {
    try {
      final data = _timetableEditService.getTimetableData();
      final success = await _exportService.exportToFile(data);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('课表数据已导出')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    }
  }

  Future<void> _importFromFile() async {
    try {
      final importedData = await _exportService.importFromFile();
      if (importedData != null) {
        _timetableEditService.loadTimetableData(importedData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('课表数据已导入')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ChangeNotifierProvider.value(
      value: _timetableEditService,
      child: Scaffold(
        appBar: MD3NavigationStyles.appBar(
          context: context,
          title: Text(
            '课表编辑',
            style: MD3TypographyStyles.titleLarge(context),
          ),
          bottom: MD3NavigationStyles.tabBar(
            context: context,
            controller: _tabController,
            tabs: const [
              Tab(text: '课程表'),
              Tab(text: '时间表'),
              Tab(text: '日课表'),
            ],
          ),
          actions: [
            MD3ButtonStyles.icon(
              icon: const Icon(Icons.today),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              tooltip: '返回今日课表',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String result) {
                if (result == 'export_json') {
                  _exportToFile();
                } else if (result == 'import_json') {
                  _importFromFile();
                } else if (result == 'import_classisland') {
                  _importFromClassisland();
                } else if (result == 'view_json') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JsonDataViewerScreen(),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'export_json',
                  child: ListTile(
                    leading: Icon(Icons.file_download_outlined),
                    title: Text('导出课表'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'import_json',
                  child: ListTile(
                    leading: Icon(Icons.file_upload_outlined),
                    title: Text('导入课表'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'import_classisland',
                  child: ListTile(
                    leading: Icon(Icons.sync_alt),
                    title: Text('从Classisland导入'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'view_json',
                  child: ListTile(
                    leading: Icon(Icons.code),
                    title: Text('查看JSON数据'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            MD3ButtonStyles.icon(
              icon: const Icon(Icons.save),
              onPressed: _saveTimetableData,
              tooltip: '保存课表',
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CourseEditScreen(),
            TimeSlotEditScreen(),
            DailyCourseEditScreen(),
          ],
        ),
      ),
    );
  }
}