import 'package:flutter/material.dart';
import 'package:time_widgets/models/course_model.dart';

/// 快速添加课程底部抽屉
/// 
/// UX 优化：
/// 1. 简化表单，仅显示核心字段
/// 2. 自动补全历史输入
/// 3. 快速时间选择器
/// 4. 成功动画反馈
class QuickAddCourseSheet extends StatefulWidget {
  const QuickAddCourseSheet({
    super.key,
    this.onCourseAdded,
  });

  final void Function(Course)? onCourseAdded;

  @override
  State<QuickAddCourseSheet> createState() => _QuickAddCourseSheetState();
}

class _QuickAddCourseSheetState extends State<QuickAddCourseSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _classroomController = TextEditingController();
  final _teacherController = TextEditingController();

  String _selectedTimeSlot = '08:00~09:40';
  bool _showAdvanced = false;
  bool _isSaving = false;

  late AnimationController _successController;
  late Animation<double> _successAnimation;

  // 常用时间段
  final List<String> _commonTimeSlots = [
    '08:00~09:40',
    '10:00~11:40',
    '14:00~15:40',
    '16:00~17:40',
    '19:00~20:40',
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _classroomController.dispose();
    _teacherController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    // 模拟保存延迟
    await Future.delayed(const Duration(milliseconds: 500));

    // 创建课程对象
    final course = Course(
      subject: _subjectController.text,
      classroom: _classroomController.text,
      teacher: _teacherController.text,
      time: _selectedTimeSlot,
    );

    // 播放成功动画
    await _successController.forward();

    if (mounted) {
      widget.onCourseAdded?.call(course);
      Navigator.pop(context, course);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, colorScheme),
                const SizedBox(height: 24),
                _buildCoreFields(theme, colorScheme),
                if (_showAdvanced) ...[
                  const SizedBox(height: 16),
                  _buildAdvancedFields(theme, colorScheme),
                ],
                const SizedBox(height: 16),
                _buildAdvancedToggle(theme, colorScheme),
                const SizedBox(height: 24),
                _buildActionButtons(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 头部
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: colorScheme.onPrimaryContainer,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '快速添加课程',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '填写核心信息即可保存',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  /// 核心字段
  Widget _buildCoreFields(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // 课程名称
        TextFormField(
          controller: _subjectController,
          decoration: InputDecoration(
            labelText: '课程名称',
            hintText: '例如：高等数学',
            prefixIcon: const Icon(Icons.book_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入课程名称';
            }
            return null;
          },
          autofocus: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        // 时间段选择
        DropdownButtonFormField<String>(
          initialValue: _selectedTimeSlot,
          decoration: InputDecoration(
            labelText: '上课时间',
            prefixIcon: const Icon(Icons.access_time_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          items: _commonTimeSlots.map((slot) {
            return DropdownMenuItem(
              value: slot,
              child: Text(slot),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedTimeSlot = value);
            }
          },
        ),
        const SizedBox(height: 16),
        // 教室
        TextFormField(
          controller: _classroomController,
          decoration: InputDecoration(
            labelText: '教室',
            hintText: '例如：A101',
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入教室';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  /// 高级字段（折叠）
  Widget _buildAdvancedFields(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          TextFormField(
            controller: _teacherController,
            decoration: InputDecoration(
              labelText: '教师',
              hintText: '例如：张老师',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 高级选项切换
  Widget _buildAdvancedToggle(ThemeData theme, ColorScheme colorScheme) {
    return TextButton.icon(
      onPressed: () {
        setState(() => _showAdvanced = !_showAdvanced);
      },
      icon: Icon(
        _showAdvanced ? Icons.expand_less : Icons.expand_more,
      ),
      label: Text(_showAdvanced ? '收起高级选项' : '展开高级选项'),
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
    );
  }

  /// 操作按钮
  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: _isSaving ? null : _saveCourse,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSaving
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : ScaleTransition(
                    scale: _successAnimation,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 20),
                        SizedBox(width: 8),
                        Text('保存课程'),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
