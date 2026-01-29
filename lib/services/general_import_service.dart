import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../models/timetable_edit_model.dart';
import '../utils/color_utils.dart';
import '../utils/logger.dart';

/// 通用导入结果
class GeneralImportResult {
  GeneralImportResult({
    required this.success,
    this.data,
    this.errorMessage,
    this.stats,
  });

  factory GeneralImportResult.success(
    TimetableData data,
    GeneralImportStats stats,
  ) {
    return GeneralImportResult(success: true, data: data, stats: stats);
  }

  factory GeneralImportResult.failure(String message) {
    return GeneralImportResult(success: false, errorMessage: message);
  }

  final bool success;
  final TimetableData? data;
  final String? errorMessage;
  final GeneralImportStats? stats;
}

/// 通用导入统计
class GeneralImportStats {
  GeneralImportStats({
    required this.subjectsCount,
    required this.timeLayoutsCount,
    required this.classPlansCount,
    required this.totalTimeSlotsCount,
  });

  final int subjectsCount;
  final int timeLayoutsCount;
  final int classPlansCount;
  final int totalTimeSlotsCount;

  @override
  String toString() {
    final parts = <String>[];
    if (subjectsCount > 0) {
      parts.add('$subjectsCount 个科目');
    }
    if (timeLayoutsCount > 0) {
      parts.add('$timeLayoutsCount 个时间表');
    }
    if (classPlansCount > 0) {
      parts.add('$classPlansCount 个课表');
    }
    if (totalTimeSlotsCount > 0) {
      parts.add('$totalTimeSlotsCount 个时间点');
    }
    return parts.isEmpty ? '无数据' : parts.join('、');
  }
}

/// 通用导入服务
/// 通过字符串匹配和启发式规则尝试解析未知格式的课表数据
class GeneralImportService {
  /// 导入文件并尝试解析
  static Future<GeneralImportResult> importFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['json', 'txt', 'conf', 'cfg'],
      );

      if (result == null || result.files.isEmpty) {
        return GeneralImportResult.failure('未选择文件');
      }

      final bytes = result.files.first.bytes;
      if (bytes == null) {
        return GeneralImportResult.failure('无法读取文件内容');
      }

      final contents = utf8.decode(bytes);
      
      // 尝试解析 JSON
      try {
        final jsonData = jsonDecode(contents);
        return _heuristicParseJson(jsonData);
      } catch (e) {
        // 如果不是 JSON，目前暂不支持其他文本格式的复杂解析
        // 可以扩展支持 XML, YAML 等，或者简单的正则提取
        return GeneralImportResult.failure('仅支持 JSON 格式文件的模糊解析');
      }
    } catch (e) {
      Logger.e('通用导入失败: $e');
      return GeneralImportResult.failure('导入失败: $e');
    }
  }

  /// 启发式解析 JSON 数据
  static GeneralImportResult _heuristicParseJson(dynamic json) {
    if (json is! Map<String, dynamic> && json is! List<dynamic>) {
      return GeneralImportResult.failure('无效的 JSON 结构');
    }

    final courses = <CourseInfo>[];
    final timeLayouts = <TimeLayout>[];
    final schedules = <Schedule>[];
    final timeSlots = <TimeSlot>[]; // 收集所有时间点

    // 递归搜索整个 JSON 树
    _traverseJson(json, (key, value) {
      // 1. 尝试识别课程列表
      if (_isCourseList(key, value)) {
        _parseCourses(value as List, courses);
      }
      // 2. 尝试识别时间表/时间点
      else if (_isTimeLayoutOrSlotList(key, value)) {
        _parseTimeLayoutsAndSlots(value as List, timeLayouts, timeSlots);
      }
      // 3. 尝试识别课表/日程
      else if (_isScheduleList(key, value)) {
        // 课表的解析比较复杂，依赖于已经解析的课程和时间表
        // 这里先收集候选项，稍后统一处理?
        // 实际上递归是一次性的，我们可能需要多遍扫描，或者在解析 Schedule 时容错
      }
    });

    // 由于 Schedule 的解析依赖 Course ID 和 TimeSlot ID，我们可能需要
    // 第二遍扫描来解析 Schedule，或者在第一遍中如果遇到 Schedule 但依赖未就绪时进行缓存
    // 为简单起见，我们在第一遍扫描中也尝试解析 Schedule，
    // 如果解析出的 Schedule 引用了尚未发现的 ID，我们尝试模糊匹配名称

    // 重新扫描以解析 Schedule (因为可能在 Courses 之前出现)
    _traverseJson(json, (key, value) {
      if (_isScheduleList(key, value)) {
        _parseSchedules(value as List, schedules, courses, timeLayouts, timeSlots);
      }
    });

    // 如果没有找到时间表，但找到了零散的时间点，创建一个默认时间表
    if (timeLayouts.isEmpty && timeSlots.isNotEmpty) {
      timeLayouts.add(TimeLayout(
        id: 'imported_layout_default',
        name: '导入时间表',
        timeSlots: timeSlots,
      ),);
    }
    
    // 如果找到了时间表但没有找到时间点列表(可能时间点直接在时间表里)，
    // 上面的 _parseTimeLayoutsAndSlots 应该已经处理了

    return GeneralImportResult.success(
      TimetableData(
        courses: courses,
        timeSlots: timeSlots, // 兼容旧字段
        dailyCourses: [], // 暂时留空，由 schedules 转换
        timeLayouts: timeLayouts,
        schedules: schedules,
      ),
      GeneralImportStats(
        subjectsCount: courses.length,
        timeLayoutsCount: timeLayouts.length,
        classPlansCount: schedules.length,
        totalTimeSlotsCount: timeSlots.length,
      ),
    );
  }

  static void _traverseJson(dynamic data, void Function(String key, dynamic value) onVisit) {
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        onVisit(key.toString(), value);
        _traverseJson(value, onVisit);
      });
    } else if (data is List<dynamic>) {
      for (final item in data) {
        _traverseJson(item, onVisit);
      }
    }
  }

  // --- 识别规则 ---

  static bool _isCourseList(String key, dynamic value) {
    if (value is! List<dynamic> || value.isEmpty) {
      return false;
    }
    final lowerKey = key.toLowerCase();
    // 关键词匹配
    if (lowerKey.contains('subject') || 
        lowerKey.contains('course') || 
        lowerKey.contains('lesson')) {
      // 检查列表项是否像课程
      return _itemsLookLikeCourses(value);
    }
    return false;
  }

  static bool _itemsLookLikeCourses(List<dynamic> list) {
    if (list.isEmpty) {
      return false;
    }
    final first = list.first;
    if (first is! Map<String, dynamic>) {
      return false;
    }
    // 必须包含类似 name 的字段
    return _hasField(first, ['name', 'title', 'subject', 'courseName', 'lesson', 'kemu', 'mingcheng']);
  }

  static bool _isTimeLayoutOrSlotList(String key, dynamic value) {
    if (value is! List<dynamic> || value.isEmpty) {
      return false;
    }
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains('time') || 
        lowerKey.contains('layout') || 
        lowerKey.contains('slot') || 
        lowerKey.contains('section') ||
        lowerKey.contains('jie')) {
      return _itemsLookLikeTimeSlots(value) || _itemsLookLikeTimeLayouts(value);
    }
    return false;
  }

  static bool _itemsLookLikeTimeSlots(List<dynamic> list) {
    if (list.isEmpty) {
      return false;
    }
    final first = list.first;
    if (first is! Map<String, dynamic>) {
      return false;
    }
    // 必须包含时间字段
    return (_hasField(first, ['start', 'begin', 'from', 'kssj', 'kaishi']) && 
            _hasField(first, ['end', 'stop', 'to', 'jssj', 'jieshu'])) ||
           (_hasField(first, ['startTime', 'start_time']) && 
            _hasField(first, ['endTime', 'end_time']));
  }
  
  static bool _itemsLookLikeTimeLayouts(List<dynamic> list) {
    if (list.isEmpty) {
      return false;
    }
    final first = list.first;
    if (first is! Map<String, dynamic>) {
      return false;
    }
    // 包含时间点列表
    return first.keys.any((k) => _isTimeLayoutOrSlotList(k.toString(), first[k]));
  }

  static bool _isScheduleList(String key, dynamic value) {
    if (value is! List<dynamic> || value.isEmpty) {
      return false;
    }
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains('schedule') || 
        lowerKey.contains('plan') || 
        lowerKey.contains('table') ||
        lowerKey.contains('daily') ||
        lowerKey.contains('kebiao')) {
      return _itemsLookLikeSchedules(value) || _itemsLookLikeDailyCourses(value);
    }
    return false;
  }

  static bool _itemsLookLikeSchedules(List<dynamic> list) {
    if (list.isEmpty) {
      return false;
    }
    final first = list.first;
    if (first is! Map<String, dynamic>) {
      return false;
    }
    // 包含课程列表
    return first.keys.any((k) => k.toString().toLowerCase().contains('course') || k.toString().toLowerCase().contains('class'));
  }
  
  static bool _itemsLookLikeDailyCourses(List<dynamic> list) {
    if (list.isEmpty) {
      return false;
    }
    final first = list.first;
    if (first is! Map<String, dynamic>) {
      return false;
    }
    return _hasField(first, ['day', 'week', 'weekday', 'xingqi', 'zhou', 'xq']) && 
           _hasField(first, ['course', 'subject', 'class', 'kemu', 'kc']);
  }

  static bool _hasField(Map<dynamic, dynamic> map, List<String> candidates) {
    for (final key in map.keys) {
      final lowerKey = key.toString().toLowerCase();
      if (candidates.any((c) => lowerKey.contains(c.toLowerCase()))) {
        return true;
      }
    }
    return false;
  }

  // --- 解析逻辑 ---

  static void _parseCourses(List<dynamic> list, List<CourseInfo> result) {
    for (final item in list) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      
      final id = _getString(item, ['id', 'code', 'uid']) ?? DateTime.now().millisecondsSinceEpoch.toString();
      final name = _getString(item, ['name', 'title', 'subjectname', 'coursename', 'lesson', 'kemu', 'mingcheng']) ?? '未知课程';
      final teacher = _getString(item, ['teacher', 'instructor', 'professor', 'laoshi', 'js', 'jiaoshi']) ?? '';
      final classroom = _getString(item, ['classroom', 'room', 'location', 'place', 'site', 'address', 'didian', 'jiaoshi']) ?? '';
      final abbreviation = _getString(item, ['abbr', 'short', 'code', 'jiancheng', 'jc']) ?? '';
      final color = _getString(item, ['color', 'bg', 'background', 'yanse', 'ys']) ?? 
                    ColorUtils.toHexString(ColorUtils.generateColorFromName(name));
      
      // 避免重复
      if (!result.any((c) => c.id == id || c.name == name)) {
        result.add(CourseInfo(
          id: id,
          name: name,
          abbreviation: abbreviation,
          teacher: teacher,
          classroom: classroom,
          color: color,
        ),);
      }
    }
  }

  static void _parseTimeLayoutsAndSlots(List<dynamic> list, List<TimeLayout> layouts, List<TimeSlot> slots) {
    // 检查是 Layout 列表还是 Slot 列表
    if (_itemsLookLikeTimeSlots(list)) {
      // 这是一个 Slot 列表，直接解析为 Slots
      for (final item in list) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final slot = _parseTimeSlot(item, slots.length + 1);
        if (slot != null) {
           slots.add(slot);
        }
      }
    } else if (_itemsLookLikeTimeLayouts(list)) {
      // 这是一个 Layout 列表
      for (final item in list) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final id = _getString(item, ['id', 'uid']) ?? DateTime.now().millisecondsSinceEpoch.toString();
        final name = _getString(item, ['name', 'title']) ?? '时间表';
        
        final layoutSlots = <TimeSlot>[];
        // 查找内部的 Slots
        item.forEach((k, v) {
          if (v is List<dynamic> && _itemsLookLikeTimeSlots(v)) {
            for (final slotItem in v) {
               if (slotItem is Map<String, dynamic>) {
                 final slot = _parseTimeSlot(slotItem, layoutSlots.length + 1);
                 if (slot != null) {
                   layoutSlots.add(slot);
                 }
               }
            }
          }
        });

        layouts.add(TimeLayout(
          id: id,
          name: name,
          timeSlots: layoutSlots,
        ),);
        
        // 也添加到全局 slots 以备后用（去重）
        for (final s in layoutSlots) {
           if (!slots.any((existing) => existing.id == s.id)) {
             slots.add(s);
           }
        }
      }
    }
  }

  static TimeSlot? _parseTimeSlot(Map<String, dynamic> item, int index) {
    final start = _getTimeString(item, ['start', 'begin', 'from', 'kssj', 'kaishi', 'startTime', 'start_time']);
    final end = _getTimeString(item, ['end', 'stop', 'to', 'jssj', 'jieshu', 'endTime', 'end_time']);
    
    if (start == null || end == null) {
      return null;
    }

    final id = _getString(item, ['id', 'uid']) ?? 'slot_$index';
    final name = _getString(item, ['name', 'title', 'label', 'index', 'jie', 'jc']) ?? '第$index节';
    
    return TimeSlot(
      id: id,
      startTime: start,
      endTime: end,
      name: name,
    );
  }

  static void _parseSchedules(
    List<dynamic> list, 
    List<Schedule> schedules, 
    List<CourseInfo> courses,
    List<TimeLayout> layouts,
    List<TimeSlot> slots,
  ) {
     // 简单处理：假设列表里的每个对象是一个 Schedule
     // 如果列表项看起来像 DailyCourse，那么整个列表可能是一个 Schedule 的内容
     if (_itemsLookLikeDailyCourses(list)) {
       // 创建一个默认 Schedule 包含这些课程
       final dailyCourses = <DailyCourse>[];
       for (final item in list) {
         if (item is Map<String, dynamic>) {
           final dc = _parseDailyCourse(item, courses, slots);
           if (dc != null) {
             dailyCourses.add(dc);
           }
         }
       }
       if (dailyCourses.isNotEmpty) {
         schedules.add(Schedule(
           id: 'imported_schedule_default',
           name: '导入课表',
           triggers: [
             const TriggerCondition(id: 'default_trigger', weekDays: [1]),
           ],
           courses: dailyCourses,
           timeLayoutId: layouts.isNotEmpty ? layouts.first.id : null,
         ),);
       }
     } else {
       // 列表项是 Schedule 对象
       for (final item in list) {
         if (item is! Map<String, dynamic>) {
           continue;
         }
         
         final id = _getString(item, ['id']) ?? DateTime.now().millisecondsSinceEpoch.toString();
         final name = _getString(item, ['name']) ?? '课表';
         
         final scheduleCourses = <DailyCourse>[];
         // 查找内部的 Courses/Classes
         item.forEach((k, v) {
           if (v is List<dynamic> && _itemsLookLikeDailyCourses(v)) {
             for (final courseItem in v) {
               if (courseItem is Map<String, dynamic>) {
                 final dc = _parseDailyCourse(courseItem, courses, slots);
                 if (dc != null) {
                   scheduleCourses.add(dc);
                 }
               }
             }
           }
         });
         
         if (scheduleCourses.isNotEmpty) {
           schedules.add(Schedule(
             id: id,
             name: name,
             triggers: [
               TriggerCondition(id: 'trigger_$id', weekDays: const [1]),
             ],
             courses: scheduleCourses,
             timeLayoutId: layouts.isNotEmpty ? layouts.first.id : null,
           ),);
         }
       }
     }
  }

  static DailyCourse? _parseDailyCourse(Map<String, dynamic> item, List<CourseInfo> courses, List<TimeSlot> slots) {
    // 解析 Course
    String? courseId = _getString(item, ['courseId', 'subjectId', 'kcid']);
    if (courseId == null) {
      // 尝试按名称匹配
      final courseName = _getString(item, ['courseName', 'subjectName', 'name', 'course', 'subject', 'kemu', 'kc', 'mingcheng']);
      if (courseName != null) {
        final course = courses.firstWhere((c) => c.name == courseName, orElse: () => const CourseInfo(id: '', name: '', teacher: ''));
        if (course.id.isNotEmpty) {
          courseId = course.id;
        } else {
          // 如果没找到，创建一个新课程? 或者忽略
          // 这里简单起见，创建一个
          final newId = 'auto_${courses.length + 1}';
          final newCourse = CourseInfo(id: newId, name: courseName, teacher: '');
          courses.add(newCourse);
          courseId = newId;
        }
      }
    }
    
    if (courseId == null) {
      return null;
    }

    // 解析 TimeSlot
    String? timeSlotId = _getString(item, ['timeSlotId', 'slotId', 'section', 'jie', 'jc']);
    if (timeSlotId == null) {
       // 尝试按名称或索引匹配
       // 暂不支持复杂的索引匹配，需要更多上下文
       // 如果 item 有 startTime，可以尝试匹配 slots
       final startTime = _getTimeString(item, ['startTime', 'start', 'begin', 'kssj']);
       if (startTime != null) {
         final slot = slots.firstWhere((s) => s.startTime == startTime, orElse: () => const TimeSlot(id: '', startTime: '', endTime: '', name: ''));
         if (slot.id.isNotEmpty) {
           timeSlotId = slot.id;
         }
       }
    }
    
    // 如果还是没找到 TimeSlotId，尝试读取 index
    if (timeSlotId == null) {
      final index = _getInt(item, ['index', 'order', 'num', 'jie', 'jc']);
      if (index != null && index > 0 && index <= slots.length) {
        timeSlotId = slots[index - 1].id;
      }
    }

    if (timeSlotId == null && slots.isNotEmpty) {
      // 最后的 fallback: 默认第一个 slot? 不，这样太乱了。
      // 如果没有 slot 信息，可能这个数据结构是按顺序排列的，这里丢失了顺序信息
      return null;
    }

    // 解析 DayOfWeek
    final dayInt = _getInt(item, ['day', 'week', 'weekday', 'xingqi', 'zhou', 'xq']);
    final dayOfWeek = (dayInt != null && dayInt >= 0 && dayInt <= 6) 
        ? DayOfWeek.values[dayInt == 0 ? 6 : dayInt - 1] // 假设 0 是周日，转为 6
        : DayOfWeek.monday;

    return DailyCourse(
      id: DateTime.now().millisecondsSinceEpoch.toString() + (item.hashCode.toString()),
      dayOfWeek: dayOfWeek,
      timeSlotId: timeSlotId!,
      courseId: courseId,
    );
  }

  // --- 辅助方法 ---

  static String? _getString(Map<dynamic, dynamic> map, List<String> keys) {
    for (final key in keys) {
      for (final mapKey in map.keys) {
        if (mapKey.toString().toLowerCase().contains(key.toLowerCase())) {
          final val = map[mapKey];
          if (val is String && val.isNotEmpty) return val;
        }
      }
    }
    return null;
  }
  
  static int? _getInt(Map<dynamic, dynamic> map, List<String> keys) {
    for (final key in keys) {
      for (final mapKey in map.keys) {
        if (mapKey.toString().toLowerCase() == key.toLowerCase()) { // Int 最好精确匹配 key
           final val = map[mapKey];
           if (val is int) return val;
           if (val is String) return int.tryParse(val);
        }
      }
    }
    return null;
  }

  static String? _getTimeString(Map<dynamic, dynamic> map, List<String> keys) {
    final val = _getString(map, keys);
    if (val == null) return null;
    // 简单提取 HH:MM
    try {
      final parts = val.split(RegExp(r'[T\s]')); // split by T or space
      for (final part in parts) {
        if (part.contains(':')) {
           final timeParts = part.split(':');
           if (timeParts.length >= 2) {
             return '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
           }
        }
      }
    } catch (_) {
      // Ignore parsing errors
    }
    return null;
  }
}
