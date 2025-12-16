import 'package:flutter/material.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/responsive_utils.dart';

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
    final width = MediaQuery.sizeOf(context).width;
    final fontMultiplier = ResponsiveUtils.getFontSizeMultiplier(width);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        isEditing ? '编辑倒计时' : '添加倒计时',
        style: TextStyle(
          fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * fontMultiplier,
        ),
      ),
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
                  style: TextStyle(fontSize: 16 * fontMultiplier),
                  decoration: InputDecoration(
                    labelText: '标题',
                    labelStyle: TextStyle(fontSize: 16 * fontMultiplier),
                    hintText: '请输入倒计时标题',
                    hintStyle: TextStyle(fontSize: 14 * fontMultiplier),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(ResponsiveUtils.value(16)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入标题';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveUtils.value(16)),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(fontSize: 16 * fontMultiplier),
                  decoration: InputDecoration(
                    labelText: '描述',
                    labelStyle: TextStyle(fontSize: 16 * fontMultiplier),
                    hintText: '（可选）请输入倒计时描述',
                    hintStyle: TextStyle(fontSize: 14 * fontMultiplier),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(ResponsiveUtils.value(16)),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: ResponsiveUtils.value(16)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '目标日期',
                            style: TextStyle(fontSize: 14 * fontMultiplier),
                          ),
                          SizedBox(height: ResponsiveUtils.value(8)),
                          ElevatedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: Icon(
                              Icons.calendar_today,
                              size: ResponsiveUtils.getIconSize(width, baseSize: 18),
                            ),
                            label: Text(
                              '${_targetDate.year}-${_targetDate.month.toString().padLeft(2, '0')}-${_targetDate.day.toString().padLeft(2, '0')} ${_targetDate.hour.toString().padLeft(2, '0')}:${_targetDate.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 14 * fontMultiplier),
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.value(16),
                                vertical: ResponsiveUtils.value(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.value(16)),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _type,
                        style: TextStyle(
                          fontSize: 16 * fontMultiplier,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: '类型',
                          labelStyle: TextStyle(fontSize: 16 * fontMultiplier),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(ResponsiveUtils.value(16)),
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
                    SizedBox(width: ResponsiveUtils.value(16)),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _category,
                        style: TextStyle(
                          fontSize: 16 * fontMultiplier,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: '分类',
                          labelStyle: TextStyle(fontSize: 16 * fontMultiplier),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(ResponsiveUtils.value(16)),
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
          child: Text(
            '取消',
            style: TextStyle(fontSize: 14 * fontMultiplier),
          ),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(
            isEditing ? '保存' : '添加',
            style: TextStyle(fontSize: 14 * fontMultiplier),
          ),
        ),
      ],
    );
  }
}
