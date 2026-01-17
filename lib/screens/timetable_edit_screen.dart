import 'package:flutter/material.dart';
import 'package:time_widgets/services/timetable_edit_service.dart';
import 'package:time_widgets/widgets/timetable_edit/course_list_tab.dart';
import 'package:time_widgets/widgets/timetable_edit/time_slot_tab.dart';
import 'package:time_widgets/widgets/timetable_edit/timetable_grid_tab.dart';
import 'package:time_widgets/services/enhanced_window_manager.dart';
import 'package:time_widgets/widgets/window_controls.dart';


class TimetableEditScreen extends StatefulWidget {
  const TimetableEditScreen({super.key});

  @override
  State<TimetableEditScreen> createState() => _TimetableEditScreenState();
}

class _TimetableEditScreenState extends State<TimetableEditScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TimetableEditService _editService = TimetableEditService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await _editService.refreshData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _editService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑课表'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 恢复主窗口原始尺寸和位置
            EnhancedWindowManager.restoreMainWindow();
            Navigator.pop(context);
          },
        ),
        actions: [
          // 窗口控制按钮
          const SizedBox(width: 8),
          const WindowControls(restoreMainWindowOnClose: true),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '科目管理', icon: Icon(Icons.class_outlined)),
            Tab(text: '作息时间', icon: Icon(Icons.access_time)),
            Tab(text: '课程表', icon: Icon(Icons.grid_on)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListenableBuilder(
              listenable: _editService,
              builder: (context, child) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    CourseListTab(service: _editService),
                    TimeSlotTab(service: _editService),
                    TimetableGridTab(service: _editService),
                  ],
                );
              },
            ),
    );
  }
}
