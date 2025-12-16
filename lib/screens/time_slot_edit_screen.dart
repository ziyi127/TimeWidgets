import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timetable_edit_model.dart';
import '../services/timetable_edit_service.dart';

class TimeSlotEditScreen extends StatefulWidget {
  const TimeSlotEditScreen({super.key});

  @override
  State<TimeSlotEditScreen> createState() => _TimeSlotEditScreenState();
}

class _TimeSlotEditScreenState extends State<TimeSlotEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime({required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime ?? const TimeOfDay(hour: 8, minute: 0) 
                           : _endTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _showAddTimeSlotDialog() {
    _nameController.clear();
    _startTime = null;
    _endTime = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加时间段'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '时间段名称',
                      hintText: '例如：第1节课',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入时间段名称';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(isStart: true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '开始时间',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _startTime != null 
                                  ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
                                  : '选择开始时间',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(isStart: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '结束时间',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _endTime != null 
                                  ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
                                  : '选择结束时间',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && 
                  _startTime != null && 
                  _endTime != null) {
                
                // Convert TimeOfDay to string format "HH:MM"
                final startTime = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
                final endTime = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
                
                if (_endTime!.hour < _startTime!.hour || 
                    (_endTime!.hour == _startTime!.hour && _endTime!.minute <= _startTime!.minute)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('结束时间必须晚于开始时间')),
                  );
                  return;
                }
                
                final timeSlot = TimeSlot(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  startTime: startTime,
                  endTime: endTime,
                );
                
                Provider.of<TimetableEditService>(context, listen: false)
                    .addTimeSlot(timeSlot);
                
                Navigator.of(context).pop();
              } else if (_startTime == null || _endTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请选择开始时间和结束时间')),
                );
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showEditTimeSlotDialog(TimeSlot timeSlot) {
    _nameController.text = timeSlot.name;
    
    // Parse time strings to TimeOfDay
    final startParts = timeSlot.startTime.split(':');
    final endParts = timeSlot.endTime.split(':');
    
    _startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );
    _endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑时间段'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '时间段名称',
                      hintText: '例如：第1节课',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入时间段名称';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
                            );
                            
                            if (picked != null) {
                              setState(() {
                                _startTime = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '开始时间',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _startTime != null 
                                  ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
                                  : '选择开始时间',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _endTime ?? const TimeOfDay(hour: 9, minute: 0),
                            );
                            
                            if (picked != null) {
                              setState(() {
                                _endTime = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '结束时间',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _endTime != null 
                                  ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
                                  : '选择结束时间',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && 
                  _startTime != null && 
                  _endTime != null) {
                
                // Convert TimeOfDay to string format "HH:MM"
                final startTime = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
                final endTime = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
                
                if (_endTime!.hour < _startTime!.hour || 
                    (_endTime!.hour == _startTime!.hour && _endTime!.minute <= _startTime!.minute)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('结束时间必须晚于开始时间')),
                  );
                  return;
                }
                
                final updatedTimeSlot = TimeSlot(
                  id: timeSlot.id,
                  name: _nameController.text,
                  startTime: startTime,
                  endTime: endTime,
                );
                
                Provider.of<TimetableEditService>(context, listen: false)
                    .updateTimeSlot(updatedTimeSlot);
                
                Navigator.of(context).pop();
              } else if (_startTime == null || _endTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请选择开始时间和结束时间')),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeString) {
    // Assuming timeString is in format "HH:MM"
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableEditService>(
      builder: (context, service, child) {
        final timeSlots = service.timeSlots;
        
        // Sort time slots by start time
        final sortedTimeSlots = List<TimeSlot>.from(timeSlots)
          ..sort((a, b) {
            // Parse time strings "HH:MM" and compare
            final aParts = a.startTime.split(':');
            final bParts = b.startTime.split(':');
            
            final aHour = int.parse(aParts[0]);
            final aMinute = int.parse(aParts[1]);
            final bHour = int.parse(bParts[0]);
            final bMinute = int.parse(bParts[1]);
            
            final aTotalMinutes = aHour * 60 + aMinute;
            final bTotalMinutes = bHour * 60 + bMinute;
            
            return aTotalMinutes.compareTo(bTotalMinutes);
          });
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '时间段列表 (${timeSlots.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddTimeSlotDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('添加时间段'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: timeSlots.isEmpty
                  ? const Center(
                      child: Text('暂无时间段，请添加时间段'),
                    )
                  : ListView.builder(
                      itemCount: sortedTimeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = sortedTimeSlots[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(timeSlot.name),
                            subtitle: Text(
                              '${_formatTime(timeSlot.startTime)} - ${_formatTime(timeSlot.endTime)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditTimeSlotDialog(timeSlot),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('确认删除'),
                                        content: Text(
                                            '确定要删除时间段"${timeSlot.name}"吗？'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('取消'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              service.deleteTimeSlot(timeSlot.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('删除'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
