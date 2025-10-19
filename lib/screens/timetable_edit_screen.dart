import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';
import '../services/timetable_storage_service.dart';
import '../services/classisland_import_service.dart';
import 'course_edit_screen.dart';
import 'time_slot_edit_screen.dart';
import 'daily_course_edit_screen.dart';
import 'json_data_viewer_screen.dart';

class TimetableEditScreen extends StatefulWidget {
  const TimetableEditScreen({Key? key}) : super(key: key);

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('课表数据已保存')),
      );
    } catch (e) {
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已成功导入Classisland数据')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _timetableEditService,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('课表编辑'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '课程表'),
              Tab(text: '时间表'),
              Tab(text: '日课表'),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String result) {
                if (result == 'import_classisland') {
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
                  value: 'import_classisland',
                  child: Text('从Classisland导入'),
                ),
                const PopupMenuItem<String>(
                  value: 'view_json',
                  child: Text('查看JSON数据'),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveTimetableData,
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