import 'package:flutter/material.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/temp_schedule_change_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';

/// 临时调课管理页面
class TempScheduleManageScreen extends StatefulWidget {
  const TempScheduleManageScreen({super.key});

  @override
  State<TempScheduleManageScreen> createState() =>
      _TempScheduleManageScreenState();
}

class _TempScheduleManageScreenState extends State<TempScheduleManageScreen> {
  final TempScheduleChangeService _tempService = TempScheduleChangeService();
  final TimetableStorageService _storageService = TimetableStorageService();

  List<TempScheduleChange> _changes = [];
  TimetableData? _timetableData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final changes = await _tempService.loadChanges();
      final timetableData = await _storageService.loadTimetableData();

      // 按日期排序
      changes.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        _changes = changes;
        _timetableData = timetableData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteChange(String id) async {
    try {
      await _tempService.removeChange(id);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已删除临时调课记录')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cleanupOldChanges() async {
    try {
      await _tempService.cleanupOldChanges();
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已清理过期记录')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('清理失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getChangeDescription(TempScheduleChange change) {
    if (_timetableData == null) return '';

    if (change.type == TempChangeType.day) {
      // 按天调课
      final schedule = _timetableData!.schedules
          .where((s) => s.id == change.newScheduleId)
          .firstOrNull;
      return schedule != null ? '使用课表: ${schedule.name}' : '未知课表';
    } else {
      // 按节调课
      final timeSlot = _timetableData!.timeSlots
          .where((t) => t.id == change.timeSlotId)
          .firstOrNull;
      final course = _timetableData!.courses
          .where((c) => c.id == change.newCourseId)
          .firstOrNull;

      final slotName = timeSlot?.name ?? '未知节次';
      final courseName = course?.name ?? '未知课程';

      return '$slotName → $courseName';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('管理临时调课'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: '清理过期记录',
            onPressed: _cleanupOldChanges,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _changes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无临时调课记录',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '通过托盘菜单可以添加临时调课',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _changes.length,
                  itemBuilder: (context, index) {
                    final change = _changes[index];
                    final isPast = change.date.isBefore(DateTime.now());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPast
                              ? colorScheme.surfaceContainerHighest
                              : change.type == TempChangeType.day
                                  ? colorScheme.primaryContainer
                                  : colorScheme.secondaryContainer,
                          child: Icon(
                            change.type == TempChangeType.day
                                ? Icons.today
                                : Icons.schedule,
                            color: isPast
                                ? colorScheme.onSurfaceVariant
                                : change.type == TempChangeType.day
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSecondaryContainer,
                          ),
                        ),
                        title: Text(
                          '${change.date.year}-${change.date.month.toString().padLeft(2, '0')}-${change.date.day.toString().padLeft(2, '0')}',
                          style: isPast
                              ? TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getChangeDescription(change)),
                            if (isPast)
                              Text(
                                '已过期',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('确认删除'),
                                content: const Text('确定要删除这条临时调课记录吗？'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('取消'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      _deleteChange(change.id);
                                    },
                                    child: const Text('删除'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
