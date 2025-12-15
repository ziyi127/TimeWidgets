import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/md3_button_styles.dart';

class CountdownEditDialog extends StatefulWidget {
  final CountdownData? countdown;

  const CountdownEditDialog({super.key, this.countdown});

  @override
  State<CountdownEditDialog> createState() => _CountdownEditDialogState();
}

class _CountdownEditDialogState extends State<CountdownEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _targetDate;
  late String _type;
  late String? _category;

  final List<String> _types = ['exam', 'deadline', 'event', 'task'];
  final List<String> _categories = ['Academic', 'Personal', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.countdown?.title ?? '');
    _descriptionController = TextEditingController(text: widget.countdown?.description ?? '');
    _targetDate = widget.countdown?.targetDate ?? DateTime.now().add(const Duration(days: 7));
    _type = widget.countdown?.type ?? 'event';
    _category = widget.countdown?.category ?? 'Academic';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (date != null) {
      setState(() => _targetDate = date);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final countdown = CountdownData(
        id: widget.countdown?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        targetDate: _targetDate,
        type: _type,
        progress: widget.countdown?.progress ?? 0.0,
        category: _category,
      );
      Navigator.pop(context, countdown);
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'exam': return '考试';
      case 'deadline': return '截止';
      case 'event': return '事件';
      case 'task': return '任务';
      default: return type;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'Academic': return '学业';
      case 'Personal': return '个人';
      case 'Work': return '工作';
      case 'Other': return '其他';
      default: return category;
    }
  }


  @override
  Widget build(BuildContext context) {
    final isEditing = widget.countdown != null;

    return AlertDialog(
      title: Text(isEditing ? '编辑倒计�? : '添加倒计�?),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '标题',
                    hintText: '例如：期末考试',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入标�?;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '描述',
                    hintText: '例如：计算机科学期末考试',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('目标日期'),
                  subtitle: Text(
                    '${_targetDate.year}�?{_targetDate.month}�?{_targetDate.day}�?,
                  ),
                  trailing: FilledButton.tonal(
                    onPressed: _selectDate,
                    child: const Text('选择'),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: '类型',
                    border: OutlineInputBorder(),
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeLabel(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _type = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: '分类',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryLabel(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _category = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        MD3ButtonStyles.text(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        MD3ButtonStyles.filled(
          onPressed: _save,
          child: Text(isEditing ? '保存' : '添加'),
        ),
      ],
    );
  }
}
