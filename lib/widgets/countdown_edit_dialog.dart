import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';

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
    _category = widget.countdown?.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_targetDate),
      );

      if (pickedTime != null) {
        setState(() {
          _targetDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final countdown = CountdownData(
        id: widget.countdown?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? '' : _descriptionController.text,
        targetDate: _targetDate,
        type: _type,
        progress: widget.countdown?.progress ?? 0.0,
        category: _category,
        color: widget.countdown?.color,
      );

      Navigator.pop(context, countdown);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.countdown != null;

    return AlertDialog(
      title: Text(isEditing ? '编辑倒计时' : '添加倒计时'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '标题',
                    hintText: '请输入倒计时标题',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入标题';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '描述',
                    hintText: '（可选）请输入倒计时描述',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('目标日期'),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_targetDate.year}-${_targetDate.month.toString().padLeft(2, '0')}-${_targetDate.day.toString().padLeft(2, '0')} ${_targetDate.hour.toString().padLeft(2, '0')}:${_targetDate.minute.toString().padLeft(2, '0')}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _type,
                        decoration: const InputDecoration(
                          labelText: '类型',
                          border: OutlineInputBorder(),
                        ),
                        items: _types.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _type = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: '分类',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('无分类')),
                          ..._categories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _category = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEditing ? '保存' : '添加'),
        ),
      ],
    );
  }
}