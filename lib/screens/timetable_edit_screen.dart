import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/services/timetable_export_service.dart';
import 'package:time_widgets/services/classisland_import_service.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';
import 'package:time_widgets/utils/md3_navigation_styles.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';
import 'package:time_widgets/widgets/schedule_edit_tab.dart';
import 'package:time_widgets/widgets/subject_edit_tab.dart';
import 'package:time_widgets/widgets/time_layout_edit_tab.dart';
import 'package:time_widgets/widgets/window_controls.dart';

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
      _showSuccessSnackBar('课表数据已保存');
    } catch (e) {
      _showErrorSnackBar('保存失败: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: colorScheme.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _importFromThisApp() async {
    try {
      final exportService = TimetableExportService();
      final result = await exportService.importFromFileWithStats();
      
      if (result.success && result.data != null) {
        _timetableEditService.loadTimetableData(result.data!);
        _showSuccessSnackBar('导入成功: ${result.stats}');
      } else {
        _showErrorSnackBar(result.errorMessage ?? '导入失败');
      }
    } catch (e) {
      _showErrorSnackBar('导入失败: $e');
    }
  }

  Future<void> _importFromClassIsland() async {
    try {
      final result = await ClassislandImportService.importFromFileWithStats();
      
      if (result.success && result.data != null) {
        _timetableEditService.loadTimetableData(result.data!);
        _showSuccessSnackBar('导入成功: ${result.stats}');
      } else {
        _showErrorSnackBar(result.errorMessage ?? '导入失败');
      }
    } catch (e) {
      _showErrorSnackBar('导入失败: $e');
    }
  }

  Future<void> _exportToFile() async {
    try {
      final exportService = TimetableExportService();
      final data = _timetableEditService.getTimetableData();
      final success = await exportService.exportToFile(data);
      
      if (success) {
        _showSuccessSnackBar('导出成功');
      } else {
        _showErrorSnackBar('导出失败');
      }
    } catch (e) {
      _showErrorSnackBar('导出失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _timetableEditService,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: MD3NavigationStyles.appBar(
          context: context,
          automaticallyImplyLeading: false,
          title: Text(
            '课表编辑',
            style: MD3TypographyStyles.titleLarge(context),
          ),
          bottom: MD3NavigationStyles.tabBar(
            context: context,
            controller: _tabController,
            tabs: const [
              Tab(text: '课表'),
              Tab(text: '时间表'),
              Tab(text: '科目'),
            ],
          ),
          actions: [
            MD3ButtonStyles.icon(
              context: context,
              icon: const Icon(Icons.save),
              onPressed: _saveTimetableData,
              tooltip: '保存课表',
            ),
            const SizedBox(width: 8),
            PopupMenuButton<void>(
              icon: const Icon(Icons.more_vert),
              tooltip: '更多选项',
              itemBuilder: (context) {
                final List<PopupMenuEntry<void>> items = [];
                
                items.add(
                  PopupMenuItem<void>(
                    onTap: () => _importFromThisApp(),
                    child: Row(
                      children: const [
                        Icon(Icons.file_upload, size: 20),
                        SizedBox(width: 12),
                        Text('导入本程序课表文件'),
                      ],
                    ),
                  ),
                );
                
                items.add(
                  PopupMenuItem<void>(
                    onTap: () => _importFromClassIsland(),
                    child: Row(
                      children: const [
                        Icon(Icons.file_upload, size: 20),
                        SizedBox(width: 12),
                        Text('导入 ClassIsland 课表文件'),
                      ],
                    ),
                  ),
                );
                
                items.add(const PopupMenuDivider());
                
                items.add(
                  PopupMenuItem<void>(
                    onTap: () => _exportToFile(),
                    child: Row(
                      children: const [
                        Icon(Icons.file_download, size: 20),
                        SizedBox(width: 12),
                        Text('导出课表数据为 JSON'),
                      ],
                    ),
                  ),
                );
                
                return items;
              },
            ),
            const SizedBox(width: 8),
            const WindowControls(),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ScheduleEditTab(),
            TimeLayoutEditTab(),
            SubjectEditTab(),
          ],
        ),
      ),
    );
  }
}
