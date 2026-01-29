import 'package:flutter/material.dart';
import '../../models/timetable_edit_model.dart';
import '../../utils/md3_button_styles.dart';
import '../../utils/md3_card_styles.dart';
import '../../utils/md3_chip_styles.dart';
import '../../utils/md3_form_styles.dart';
import '../../utils/md3_typography_styles.dart';

class TriggerConditionEditor extends StatefulWidget {
  const TriggerConditionEditor({
    super.key,
    required this.triggers,
    required this.onChanged,
  });

  final List<TriggerCondition> triggers;
  final ValueChanged<List<TriggerCondition>> onChanged;

  @override
  State<TriggerConditionEditor> createState() => _TriggerConditionEditorState();
}

class _TriggerConditionEditorState extends State<TriggerConditionEditor> {
  void _addCondition() {
    final newCondition = TriggerCondition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      weekDays: [], // Default empty
    );
    widget.onChanged([...widget.triggers, newCondition]);
  }

  void _removeCondition(int index) {
    final newList = List<TriggerCondition>.from(widget.triggers);
    newList.removeAt(index);
    widget.onChanged(newList);
  }

  void _updateCondition(int index, TriggerCondition condition) {
    final newList = List<TriggerCondition>.from(widget.triggers);
    newList[index] = condition;
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('生效条件', style: MD3TypographyStyles.titleMedium(context)),
            MD3ButtonStyles.iconFilledTonal(
              context: context,
              icon: const Icon(Icons.add),
              onPressed: _addCondition,
              tooltip: '添加条件',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '满足以下任意一个条件的日期，该课表将生效',
          style: MD3TypographyStyles.bodySmall(context).copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.triggers.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('未设置条件 (默认不生效)')),
          )
        else
          ...widget.triggers.asMap().entries.map((entry) {
            final index = entry.key;
            final condition = entry.value;
            return _ConditionCard(
              condition: condition,
              onChanged: (c) => _updateCondition(index, c),
              onDelete: () => _removeCondition(index),
            );
          }),
      ],
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.condition,
    required this.onChanged,
    required this.onDelete,
  });

  final TriggerCondition condition;
  final ValueChanged<TriggerCondition> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MD3CardStyles.surfaceContainer(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rule, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('条件组', style: MD3TypographyStyles.titleSmall(context)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                    tooltip: '删除此条件',
                  ),
                ],
              ),
              const Divider(),
              // WeekDays Selector
              Text('星期', style: MD3TypographyStyles.labelMedium(context)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(7, (index) {
                  // 0=Sun, 1=Mon... in some systems. 
                  // Model: 0=Sun, 1=Mon? 
                  // Let's check model again. 
                  // ScheduleTriggerRule had 0=Sun. 
                  // Let's assume standard DateTime: 1=Mon, 7=Sun.
                  // But `DayOfWeek` enum usually is 0-based.
                  // The previous code `days[rule.weekDay]` where `days` started with Sunday implies 0=Sun.
                  // Wait, `const days = ['周日', '周一'...]`
                  // Let's stick to 0=Sun, 1=Mon, ..., 6=Sat for storage to match `DateTime.weekday % 7`.
                  final dayLabel = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][index];
                  final isSelected = condition.weekDays?.contains(index) ?? false;
                  
                  return MD3ChipStyles.filterChip(
                    context: context,
                    label: dayLabel,
                    selected: isSelected,
                    onSelected: (selected) {
                      final current = List<int>.from(condition.weekDays ?? []);
                      if (selected) {
                        current.add(index);
                      } else {
                        current.remove(index);
                      }
                      onChanged(condition.copyWith(weekDays: current));
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              
              // Week Numbers
              Text('周次', style: MD3TypographyStyles.labelMedium(context)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: MD3FormStyles.outlinedTextField(
                      context: context,
                      controller: TextEditingController(text: condition.startWeek?.toString()),
                      label: '开始周',
                      onChanged: (v) {
                        final val = int.tryParse(v);
                        onChanged(condition.copyWith(startWeek: val));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MD3FormStyles.outlinedTextField(
                      context: context,
                      controller: TextEditingController(text: condition.endWeek?.toString()),
                      label: '结束周',
                      onChanged: (v) {
                        final val = int.tryParse(v);
                        onChanged(condition.copyWith(endWeek: val));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MD3FormStyles.outlinedTextField(
                context: context,
                controller: TextEditingController(text: condition.weekNumbers?.join(',')),
                label: '指定周次 (用逗号分隔)',
                hint: '例如: 1,3,5',
                onChanged: (v) {
                  if (v.isEmpty) {
                    onChanged(condition.copyWith(weekNumbers: []));
                    return;
                  }
                  try {
                    final list = v.split(',')
                        .map((e) => int.parse(e.trim()))
                        .toList();
                    onChanged(condition.copyWith(weekNumbers: list));
                  } catch (_) {
                    // Ignore parse error
                  }
                },
              ),

              const SizedBox(height: 16),
              // Dates
              Text('特定日期', style: MD3TypographyStyles.labelMedium(context)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ...?condition.dates?.map((date) {
                    return MD3ChipStyles.chip(
                      context: context,
                      label: '${date.year}-${date.month}-${date.day}',
                      onDeleted: () {
                        final newDates = List<DateTime>.from(condition.dates!);
                        newDates.remove(date);
                        onChanged(condition.copyWith(dates: newDates));
                      },
                    );
                  }),
                  MD3ChipStyles.actionChip(
                    context: context,
                    avatar: const Icon(Icons.add, size: 16),
                    label: '添加日期',
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        final newDates = List<DateTime>.from(condition.dates ?? []);
                        if (!newDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) {
                          newDates.add(date);
                          onChanged(condition.copyWith(dates: newDates));
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
