import 'package:flutter/material.dart';
import '../../models/timetable_edit_model.dart';
import '../../utils/md3_typography_styles.dart';
import '../../utils/md3_dialog_styles.dart';
import '../../utils/md3_form_styles.dart';
import '../../utils/md3_button_styles.dart';

class TimetableTreeWidget extends StatefulWidget {
  const TimetableTreeWidget({
    super.key,
    required this.schedules,
    required this.groups,
    required this.selectedScheduleId,
    required this.selectedDayIndex,
    required this.onScheduleSelected,
    required this.onDaySelected,
    required this.onAddSchedule,
    required this.onAddGroup,
    required this.onDeleteGroup,
    required this.onUpdateGroup,
  });

  final List<Schedule> schedules;
  final List<ScheduleGroup> groups;
  final String? selectedScheduleId;
  final int? selectedDayIndex;
  final ValueChanged<String> onScheduleSelected;
  final void Function(String scheduleId, int dayIndex) onDaySelected;
  final void Function(String? groupId) onAddSchedule;
  final void Function(String? parentId) onAddGroup;
  final ValueChanged<String> onDeleteGroup;
  final ValueChanged<ScheduleGroup> onUpdateGroup;

  @override
  State<TimetableTreeWidget> createState() => _TimetableTreeWidgetState();
}

class _TimetableTreeWidgetState extends State<TimetableTreeWidget> {
  final Set<String> _expandedGroupIds = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('课表文件', style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.create_new_folder_outlined),
                onPressed: () => widget.onAddGroup(null),
                tooltip: '新建分组',
              ),
              IconButton(
                icon: const Icon(Icons.note_add_outlined),
                onPressed: () => widget.onAddSchedule(null),
                tooltip: '新建课表',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Tree List
        Expanded(
          child: SingleChildScrollView(
            child: _buildTree(context, null),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          '暂无课表\n点击上方按钮创建',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }

  Widget _buildTree(BuildContext context, String? parentId) {
    final childrenGroups = widget.groups.where((g) => g.parentId == parentId).toList();
    final childrenSchedules = widget.schedules.where((s) => s.groupId == parentId).toList();

    if (childrenGroups.isEmpty && childrenSchedules.isEmpty) {
        if (parentId == null) return _buildEmptyState(context);
        return const SizedBox(); // Empty folder
    }

    return Column(
      children: [
        ...childrenGroups.map((group) => _buildGroupNode(context, group)),
        ...childrenSchedules.map((schedule) => _buildScheduleNode(context, schedule)),
      ],
    );
  }

  Widget _buildGroupNode(BuildContext context, ScheduleGroup group) {
    final isExpanded = _expandedGroupIds.contains(group.id);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListTile(
          leading: Icon(
            isExpanded ? Icons.folder_open : Icons.folder,
            color: colorScheme.secondary,
          ),
          title: Text(group.name),
          trailing: PopupMenuButton<String>(
             icon: const Icon(Icons.more_vert, size: 20),
             onSelected: (value) {
               if (value == 'add_group') widget.onAddGroup(group.id);
               if (value == 'add_schedule') widget.onAddSchedule(group.id);
               if (value == 'delete') _confirmDeleteGroup(context, group);
               if (value == 'rename') _showRenameGroupDialog(context, group);
             },
             itemBuilder: (context) => [
               const PopupMenuItem(value: 'add_group', child: Text('新建子分组')),
               const PopupMenuItem(value: 'add_schedule', child: Text('新建课表')),
               const PopupMenuItem(value: 'rename', child: Text('重命名')),
               const PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: Colors.red))),
             ],
          ),
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedGroupIds.remove(group.id);
              } else {
                _expandedGroupIds.add(group.id);
              }
            });
          },
          dense: true,
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildTree(context, group.id),
          ),
      ],
    );
  }

  Widget _buildScheduleNode(BuildContext context, Schedule schedule) {
    final isSelected = widget.selectedScheduleId == schedule.id;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        Icons.description_outlined,
        color: isSelected ? colorScheme.primary : null,
      ),
      title: Text(schedule.name),
      selected: isSelected,
      selectedTileColor: colorScheme.secondaryContainer,
      onTap: () {
        widget.onScheduleSelected(schedule.id);
      },
      dense: true,
      contentPadding: const EdgeInsets.only(left: 16, right: 16),
    );
  }
  
  Future<void> _showRenameGroupDialog(BuildContext context, ScheduleGroup group) async {
    final nameController = TextEditingController(text: group.name);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => MD3DialogStyles.dialog(
        context: context,
        title: '重命名分组',
        content: MD3FormStyles.outlinedTextField(
          context: context,
          controller: nameController,
          label: '分组名称',
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
            text: '确定',
          ),
        ],
      ),
    );

    if ((result ?? false) && nameController.text.isNotEmpty) {
      widget.onUpdateGroup(group.copyWith(name: nameController.text));
    }
  }

  Future<void> _confirmDeleteGroup(BuildContext context, ScheduleGroup group) async {
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: group.name,
      additionalMessage: '删除分组将同时删除或移动其子项。',
    );
    if (confirmed ?? false) {
      widget.onDeleteGroup(group.id);
    }
  }
}
