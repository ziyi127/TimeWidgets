import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_dialog_styles.dart';
import '../utils/md3_form_styles.dart';
import '../utils/md3_typography_styles.dart';

/// 时间表编辑标签页 - 时间轴视图
class TimeLayoutEditTab extends StatefulWidget {
  const TimeLayoutEditTab({super.key});

  @override
  State<TimeLayoutEditTab> createState() => _TimeLayoutEditTabState();
}

class _TimeLayoutEditTabState extends State<TimeLayoutEditTab> {
  String? _selectedLayoutId;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final layouts = service.timeLayouts;
        // If no layouts, show the default time slots
        final timeSlots = service.timeSlots;

        return Row(
          children: [
            // 左侧: 时间表列表
            SizedBox(
              width: 280,
              child: _buildLayoutList(context, layouts, timeSlots, service),
            ),
            const VerticalDivider(width: 1),
            // 右侧: 时间轴编辑器
            Expanded(
              child: _buildTimelineEditor(context, service, timeSlots),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLayoutList(BuildContext context, List<TimeLayout> layouts,
      List<TimeSlot> timeSlots, TimetableEditService service) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // 列表头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('时间表', style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              MD3ButtonStyles.iconFilledTonal(
                context: context,
                icon: const Icon(Icons.add),
                onPressed: () => _showAddLayoutDialog(context, service),
                tooltip: '添加时间表',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 默认时间表
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('默认时间表'),
          subtitle: Text('${timeSlots.length} 个时间点'),
          selected: _selectedLayoutId == null,
          selectedTileColor: colorScheme.secondaryContainer,
          onTap: () {
            setState(() {
              _selectedLayoutId = null;
            });
          },
        ),
        const Divider(height: 1),
        // 自定义时间表列表
        Expanded(
          child: layouts.isEmpty
              ? Center(
                  child: Text(
                    '暂无自定义时间表',
                    style: MD3TypographyStyles.bodyMedium(context).copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: layouts.length,
                  itemBuilder: (context, index) {
                    final layout = layouts[index];
                    final isSelected = layout.id == _selectedLayoutId;

                    return ListTile(
                      leading: const Icon(Icons.view_timeline),
                      title: Text(layout.name),
                      subtitle: Text('${layout.timeSlots.length} 个时间点'),
                      selected: isSelected,
                      selectedTileColor: colorScheme.secondaryContainer,
                      trailing: MD3ButtonStyles.icon(
                        context: context,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _deleteLayout(context, service, layout),
                        tooltip: '删除',
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLayoutId = layout.id;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTimelineEditor(BuildContext context,
      TimetableEditService service, List<TimeSlot> defaultTimeSlots) {
    // Get the time slots to display
    List<TimeSlot> timeSlots;
    String title;

    if (_selectedLayoutId == null) {
      timeSlots = defaultTimeSlots;
      title = '默认时间表';
    } else {
      final layout = service.getTimeLayoutById(_selectedLayoutId!);
      if (layout == null) {
        timeSlots = defaultTimeSlots;
        title = '默认时间表';
      } else {
        timeSlots = layout.timeSlots;
        title = layout.name;
      }
    }

    // Sort by start time
    final sortedSlots = List<TimeSlot>.from(timeSlots)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      children: [
        // 头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(title, style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              MD3ButtonStyles.filledTonalButton(
                context: context,
                onPressed: () => _showAddTimeSlotDialog(context, service),
                icon: const Icon(Icons.add, size: 18),
                text: '添加时间段',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 时间轴
        Expanded(
          child: sortedSlots.isEmpty
              ? _buildEmptyTimelineState(context, service)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedSlots.length,
                  itemBuilder: (context, index) {
                    final slot = sortedSlots[index];
                    return _TimeSlotCard(
                      timeSlot: slot,
                      onEdit: () =>
                          _showEditTimeSlotDialog(context, service, slot),
                      onDelete: () => _deleteTimeSlot(context, service, slot),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyTimelineState(
      BuildContext context, TimetableEditService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无时间点',
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '添加时间点来定义课程时间',
            style: MD3TypographyStyles.bodyMedium(context).copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          MD3ButtonStyles.filledTonalButton(
            context: context,
            onPressed: () => _showAddTimeSlotDialog(context, service),
            text: '添加时间段',
          ),
        ],
      ),
    );
  }

  Future<void> _showAddLayoutDialog(
      BuildContext context, TimetableEditService service) async {
    final result = await MD3DialogStyles.showInputDialog(
      context: context,
      title: '添加时间表',
      labelText: '时间表名称',
      hintText: '例如: 周末时间表',
    );

    if (result != null && result.isNotEmpty) {
      final newLayout = TimeLayout(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result,
        timeSlots: [],
      );
      service.addTimeLayout(newLayout);
      setState(() {
        _selectedLayoutId = newLayout.id;
      });
    }
  }

  Future<void> _deleteLayout(BuildContext context, TimetableEditService service,
      TimeLayout layout) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: layout.name,
    );

    if (confirmed ?? false) {
      service.deleteTimeLayout(layout.id);
      if (_selectedLayoutId == layout.id) {
        setState(() {
          _selectedLayoutId = null;
        });
      }
    }
  }

  Future<void> _showAddTimeSlotDialog(
      BuildContext context, TimetableEditService service) async {
    final nameController = TextEditingController();
    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 8, minute: 45);
    TimePointType type = TimePointType.classTime;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => MD3DialogStyles.dialog(
          context: context,
          title: '添加时间点',
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: nameController,
                label: '名称',
                hint: '例如: 第一节',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MD3FormStyles.timePickerButton(
                      context: context,
                      time: startTime,
                      label: '开始时间',
                      onChanged: (time) {
                        setState(() {
                          startTime = time;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MD3FormStyles.timePickerButton(
                      context: context,
                      time: endTime,
                      label: '结束时间',
                      onChanged: (time) {
                        setState(() {
                          endTime = time;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MD3FormStyles.dropdown<TimePointType>(
                context: context,
                value: type,
                label: '类型',
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(
                      value: TimePointType.classTime, child: Text('上课')),
                  DropdownMenuItem(
                      value: TimePointType.breakTime, child: Text('课间休息')),
                  DropdownMenuItem(
                      value: TimePointType.divider, child: Text('分割线')),
                ],
              ),
            ],
          ),
          actions: [
            MD3ButtonStyles.textButton(
              context: context,
              onPressed: () => Navigator.pop(context, false),
              text: '取消',
            ),
            MD3ButtonStyles.filledButton(
              context: context,
              onPressed: () => Navigator.pop(context, true),
              text: '添加',
            ),
          ],
        ),
      ),
    );

    if ((result ?? false) && nameController.text.isNotEmpty) {
      final newSlot = TimeSlot(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        startTime:
            '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
        endTime:
            '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
        type: type,
      );
      service.addTimeSlot(newSlot);
    }
  }

  Future<void> _showEditTimeSlotDialog(
      BuildContext context, TimetableEditService service, TimeSlot slot) async {
    final nameController = TextEditingController(text: slot.name);
    final startParts = slot.startTime.split(':');
    final endParts = slot.endTime.split(':');
    TimeOfDay startTime = TimeOfDay(
        hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
    TimeOfDay endTime =
        TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
    TimePointType type = slot.type;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => MD3DialogStyles.dialog(
          context: context,
          title: '编辑时间点',
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: nameController,
                label: '名称',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MD3FormStyles.timePickerButton(
                      context: context,
                      time: startTime,
                      label: '开始时间',
                      onChanged: (time) {
                        setState(() {
                          startTime = time;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MD3FormStyles.timePickerButton(
                      context: context,
                      time: endTime,
                      label: '结束时间',
                      onChanged: (time) {
                        setState(() {
                          endTime = time;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MD3FormStyles.dropdown<TimePointType>(
                context: context,
                value: type,
                label: '类型',
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(
                      value: TimePointType.classTime, child: Text('上课')),
                  DropdownMenuItem(
                      value: TimePointType.breakTime, child: Text('课间休息')),
                  DropdownMenuItem(
                      value: TimePointType.divider, child: Text('分割线')),
                ],
              ),
            ],
          ),
          actions: [
            MD3ButtonStyles.textButton(
              context: context,
              onPressed: () => Navigator.pop(context, false),
              text: '取消',
            ),
            MD3ButtonStyles.filledButton(
              context: context,
              onPressed: () => Navigator.pop(context, true),
              text: '保存',
            ),
          ],
        ),
      ),
    );

    if (result ?? false) {
      final updatedSlot = slot.copyWith(
        name: nameController.text,
        startTime:
            '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
        endTime:
            '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
        type: type,
      );
      service.updateTimeSlot(updatedSlot);
    }
  }

  Future<void> _deleteTimeSlot(
      BuildContext context, TimetableEditService service, TimeSlot slot) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: slot.name,
    );

    if (confirmed ?? false) {
      service.deleteTimeSlot(slot.id);
    }
  }
}

/// 时间点卡片
class _TimeSlotCard extends StatelessWidget {
  const _TimeSlotCard({
    required this.timeSlot,
    required this.onEdit,
    required this.onDelete,
  });
  final TimeSlot timeSlot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    IconData icon;
    switch (timeSlot.type) {
      case TimePointType.classTime:
        backgroundColor = colorScheme.primaryContainer;
        icon = Icons.school;
        break;
      case TimePointType.breakTime:
        backgroundColor = colorScheme.surfaceContainerHighest;
        icon = Icons.coffee;
        break;
      case TimePointType.divider:
        backgroundColor = colorScheme.outlineVariant.withOpacity(0.3);
        icon = Icons.remove;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: backgroundColor,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeSlot.name,
                      style: MD3TypographyStyles.titleSmall(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${timeSlot.startTime} - ${timeSlot.endTime}',
                      style: MD3TypographyStyles.bodySmall(context).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${timeSlot.durationMinutes}分钟',
                style: MD3TypographyStyles.labelMedium(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              MD3ButtonStyles.icon(
                context: context,
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                tooltip: '删除',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
