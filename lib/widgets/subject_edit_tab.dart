import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';
import '../utils/md3_button_styles.dart';
import '../utils/md3_card_styles.dart';
import '../utils/md3_dialog_styles.dart';
import '../utils/md3_form_styles.dart';
import '../utils/md3_typography_styles.dart';
import '../utils/color_utils.dart';

/// 科目编辑标签�?- 主从布局
class SubjectEditTab extends StatefulWidget {
  const SubjectEditTab({super.key});

  @override
  State<SubjectEditTab> createState() => _SubjectEditTabState();
}

class _SubjectEditTabState extends State<SubjectEditTab> {
  String? _selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final subjects = service.courses;
        
        return Row(
          children: [
            // 左侧: 科目列表
            SizedBox(
              width: 280,
              child: _buildSubjectList(context, subjects, service),
            ),
            const VerticalDivider(width: 1),
            // 右侧: 科目详情编辑面板
            Expanded(
              child: _buildDetailPanel(context, service),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubjectList(BuildContext context, List<CourseInfo> subjects, TimetableEditService service) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // 列表头部
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('科目列表', style: MD3TypographyStyles.titleMedium(context)),
              const Spacer(),
              MD3ButtonStyles.iconFilledTonal(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddSubjectDialog(context, service),
                tooltip: '添加科目',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 科目列表
        Expanded(
          child: subjects.isEmpty
              ? _buildEmptyState(context, service)
              : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final isSelected = subject.id == _selectedSubjectId;
                    final subjectColor = ColorUtils.parseHexColor(subject.color) ?? 
                        ColorUtils.generateColorFromName(subject.name);
                    
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: subjectColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            subject.displayName.isNotEmpty 
                                ? subject.displayName[0] 
                                : subject.name[0],
                            style: TextStyle(
                              color: ColorUtils.getContrastTextColor(subjectColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(subject.name),
                      subtitle: subject.teacher.isNotEmpty 
                          ? Text(subject.teacher) 
                          : null,
                      selected: isSelected,
                      selectedTileColor: colorScheme.secondaryContainer,
                      onTap: () {
                        setState(() {
                          _selectedSubjectId = subject.id;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, TimetableEditService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无科目',
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击上方按钮添加科目',
            style: MD3TypographyStyles.bodyMedium(context).copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          MD3ButtonStyles.filledTonal(
            onPressed: () => _showAddSubjectDialog(context, service),
            child: const Text('添加科目'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(BuildContext context, TimetableEditService service) {
    if (_selectedSubjectId == null) {
      return _buildNoSelectionState(context);
    }
    
    final subject = service.getCourseById(_selectedSubjectId!);
    if (subject == null) {
      return _buildNoSelectionState(context);
    }
    
    return _SubjectDetailEditor(
      subject: subject,
      service: service,
      onDelete: () {
        setState(() {
          _selectedSubjectId = null;
        });
      },
    );
  }

  Widget _buildNoSelectionState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '选择一个科目进行编�?,
            style: MD3TypographyStyles.bodyLarge(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSubjectDialog(BuildContext context, TimetableEditService service) async {
    final nameController = TextEditingController();
    final abbreviationController = TextEditingController();
    final teacherController = TextEditingController();
    Color selectedColor = ColorUtils.subjectColors[service.courses.length % ColorUtils.subjectColors.length];
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => MD3DialogStyles.dialog(
          context: context,
          title: '添加科目',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: nameController,
                label: '科目名称',
                hint: '例如: 数学',
                autofocus: true,
              ),
              const SizedBox(height: 16),
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: abbreviationController,
                label: '简�?(可�?',
                hint: '例如: �?,
              ),
              const SizedBox(height: 16),
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: teacherController,
                label: '教师 (可�?',
                hint: '例如: 张老师',
              ),
              const SizedBox(height: 16),
              MD3FormStyles.colorPickerButton(
                context: context,
                color: selectedColor,
                label: '科目颜色',
                onChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
          actions: [
            MD3ButtonStyles.text(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            MD3ButtonStyles.filled(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
    
    if (result == true && nameController.text.isNotEmpty) {
      final newSubject = CourseInfo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        abbreviation: abbreviationController.text,
        teacher: teacherController.text,
        color: ColorUtils.toHexString(selectedColor),
      );
      service.addCourse(newSubject);
      setState(() {
        _selectedSubjectId = newSubject.id;
      });
    }
  }
}


/// 科目详情编辑�?
class _SubjectDetailEditor extends StatefulWidget {
  final CourseInfo subject;
  final TimetableEditService service;
  final VoidCallback onDelete;

  const _SubjectDetailEditor({
    required this.subject,
    required this.service,
    required this.onDelete,
  });

  @override
  State<_SubjectDetailEditor> createState() => _SubjectDetailEditorState();
}

class _SubjectDetailEditorState extends State<_SubjectDetailEditor> {
  late TextEditingController _nameController;
  late TextEditingController _abbreviationController;
  late TextEditingController _teacherController;
  late TextEditingController _classroomController;
  late Color _selectedColor;
  late bool _isOutdoor;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(_SubjectDetailEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subject.id != widget.subject.id) {
      _initControllers();
    }
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.subject.name);
    _abbreviationController = TextEditingController(text: widget.subject.abbreviation);
    _teacherController = TextEditingController(text: widget.subject.teacher);
    _classroomController = TextEditingController(text: widget.subject.classroom);
    _selectedColor = ColorUtils.parseHexColor(widget.subject.color) ?? 
        ColorUtils.generateColorFromName(widget.subject.name);
    _isOutdoor = widget.subject.isOutdoor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _teacherController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedSubject = widget.subject.copyWith(
      name: _nameController.text,
      abbreviation: _abbreviationController.text,
      teacher: _teacherController.text,
      classroom: _classroomController.text,
      color: ColorUtils.toHexString(_selectedColor),
      isOutdoor: _isOutdoor,
    );
    widget.service.updateCourse(updatedSubject);
    _showSuccessSnackBar('科目已更�?);
  }

  void _showSuccessSnackBar(String message) {
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

  Future<void> _deleteSubject() async {
    // Check if subject is in use
    if (!widget.service.canDeleteCourse(widget.subject.id)) {
      final usages = widget.service.findSubjectUsages(widget.subject.id);
      await MD3DialogStyles.showConfirmDialog(
        context: context,
        title: '无法删除',
        message: '该科目正在被 ${usages.length} 个课程安排使用，请先移除相关课程安排后再删除�?,
        confirmText: '知道�?,
        cancelText: '',
      );
      return;
    }
    
    final confirmed = await MD3DialogStyles.showDeleteConfirmDialog(
      context: context,
      itemName: widget.subject.name,
    );
    
    if (confirmed == true) {
      widget.service.deleteCourse(widget.subject.id);
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和操作按�?
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.subject.displayName.isNotEmpty 
                        ? widget.subject.displayName[0] 
                        : widget.subject.name[0],
                    style: TextStyle(
                      color: ColorUtils.getContrastTextColor(_selectedColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subject.name,
                      style: MD3TypographyStyles.headlineSmall(context),
                    ),
                    if (widget.subject.teacher.isNotEmpty)
                      Text(
                        widget.subject.teacher,
                        style: MD3TypographyStyles.bodyMedium(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              MD3ButtonStyles.iconOutlined(
                icon: const Icon(Icons.delete_outline),
                onPressed: _deleteSubject,
                tooltip: '删除科目',
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // 编辑表单
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('基本信息', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                MD3FormStyles.outlinedTextField(
                  context: context,
                  controller: _nameController,
                  label: '科目名称',
                ),
                const SizedBox(height: 16),
                MD3FormStyles.outlinedTextField(
                  context: context,
                  controller: _abbreviationController,
                  label: '简�?,
                  hint: '用于在课表中显示',
                ),
                const SizedBox(height: 16),
                MD3FormStyles.outlinedTextField(
                  context: context,
                  controller: _teacherController,
                  label: '教师',
                ),
                const SizedBox(height: 16),
                MD3FormStyles.outlinedTextField(
                  context: context,
                  controller: _classroomController,
                  label: '教室',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 外观设置
          MD3CardStyles.surfaceContainer(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('外观设置', style: MD3TypographyStyles.titleMedium(context)),
                const SizedBox(height: 16),
                MD3FormStyles.colorPickerButton(
                  context: context,
                  color: _selectedColor,
                  label: '科目颜色',
                  onChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                const SizedBox(height: 16),
                MD3FormStyles.switchListTile(
                  context: context,
                  value: _isOutdoor,
                  onChanged: (value) {
                    setState(() {
                      _isOutdoor = value;
                    });
                  },
                  title: '户外课程',
                  subtitle: '标记为户外课�?,
                  secondary: const Icon(Icons.wb_sunny_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // 保存按钮
          SizedBox(
            width: double.infinity,
            child: MD3ButtonStyles.filled(
              onPressed: _saveChanges,
              child: const Text('保存更改'),
            ),
          ),
        ],
      ),
    );
  }
}
