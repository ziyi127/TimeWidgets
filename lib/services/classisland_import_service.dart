import 'dart:convert' show jsonDecode, utf8;

import 'package:file_picker/file_picker.dart';

import '../models/timetable_edit_model.dart';
import '../utils/color_utils.dart';
import '../utils/logger.dart';

/// ClassIsland导入结果
class ClassIslandImportResult {

  ClassIslandImportResult({
    required this.success,
    this.data,
    this.errorMessage,
    this.stats,
  });

  factory ClassIslandImportResult.success(TimetableData data, ClassIslandImportStats stats) {
    return ClassIslandImportResult(success: true, data: data, stats: stats);
  }

  factory ClassIslandImportResult.failure(String message) {
    return ClassIslandImportResult(success: false, errorMessage: message);
  }
  final bool success;
  final TimetableData? data;
  final String? errorMessage;
  final ClassIslandImportStats? stats;
}

/// ClassIsland导入统计
class ClassIslandImportStats {

  ClassIslandImportStats({
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
    if (subjectsCount > 0) parts.add('$subjectsCount 个科目');
    if (timeLayoutsCount > 0) parts.add('$timeLayoutsCount 个时间表');
    if (classPlansCount > 0) parts.add('$classPlansCount 个课表');
    if (totalTimeSlotsCount > 0) parts.add('$totalTimeSlotsCount 个时间点');
    return parts.isEmpty ? '无数据' : parts.join('、');
  }
}

/// Classisland数据导入服务
class ClassislandImportService {
  /// 导入Classisland数据并转换为本程序格式
  static Future<TimetableData?> importFromFile() async {
    final result = await importFromFileWithStats();
    return result.data;
  }

  /// 导入Classisland数据并转换为本程序格式(带统计)
  static Future<ClassIslandImportResult> importFromFileWithStats() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return ClassIslandImportResult.failure('未选择文件');
      }

      final bytes = result.files.first.bytes;
      if (bytes == null) {
        return ClassIslandImportResult.failure('无法读取文件内容');
      }

      final contents = utf8.decode(bytes);
      final classislandData = jsonDecode(contents) as Map<String, dynamic>;

      return _convertClassislandToTimetable(classislandData);
    } catch (e) {
      Logger.e('导入失败: $e');
      return ClassIslandImportResult.failure('导入失败: $e');
    }
  }

  /// 将Classisland数据转换为课表数据
  static ClassIslandImportResult _convertClassislandToTimetable(Map<String, dynamic> data) {
    final courses = <CourseInfo>[];
    final timeSlots = <TimeSlot>[];
    final dailyCourses = <DailyCourse>[];
    final timeLayouts = <TimeLayout>[];
    final schedules = <Schedule>[];

    final subjectIdToCourseId = <String, String>{};
    final timeLayoutIdMap = <String, String>{};
    
    int subjectsCount = 0;
    int timeLayoutsCount = 0;
    int classPlansCount = 0;
    int totalTimeSlotsCount = 0;
    
    // 转换科目为课程
    if (data['Subjects'] != null) {
      final subjects = data['Subjects'] as Map<String, dynamic>;
      int idCounter = 1;
      
      subjects.forEach((key, value) {
        final courseId = idCounter.toString();
        subjectIdToCourseId[key] = courseId;
        
        final initialName = value['InitialName'] as String? ?? '';
        final isOutdoor = value['IsOutDoor'] as bool? ?? false;
        
        courses.add(CourseInfo(
          id: courseId,
          name: value['Name'] as String? ?? '未知课程',
          abbreviation: initialName,
          teacher: value['TeacherName'] as String? ?? '',
          color: ColorUtils.toHexString(ColorUtils.generateColorFromName(value['Name'] as String? ?? '')),
          isOutdoor: isOutdoor,
        ),);
        idCounter++;
        subjectsCount++;
      });
    }

    // 转换时间表(TimeLayouts)
    if (data['TimeLayouts'] != null) {
      final classIslandTimeLayouts = data['TimeLayouts'] as Map<String, dynamic>;
      int layoutIdCounter = 1;
      
      classIslandTimeLayouts.forEach((layoutKey, layoutValue) {
        final layoutId = layoutIdCounter.toString();
        timeLayoutIdMap[layoutKey] = layoutId;
        
        final layoutTimeSlots = <TimeSlot>[];
        int slotIdCounter = 1;
        
        if (layoutValue['Layouts'] != null) {
          final layouts = layoutValue['Layouts'] as List<dynamic>;
          
          for (var i = 0; i < layouts.length; i++) {
            final layout = layouts[i];
            final startSecond = layout['StartSecond'] as String? ?? '2024-01-01T08:00:00';
            final endSecond = layout['EndSecond'] as String? ?? '2024-01-01T08:45:00';
            
            final startTime = _extractTime(startSecond);
            final endTime = _extractTime(endSecond);
            
            // 转换时间点类型(ClassIsland: 0=上课, 1=课间, 2=分割线)
            final timeType = layout['TimeType'] as int? ?? 0;
            final type = TimePointType.values[timeType.clamp(0, 2)];
            
            final defaultSubjectId = layout['DefaultClassId'] as String?;
            final mappedSubjectId = defaultSubjectId != null 
                ? subjectIdToCourseId[defaultSubjectId] 
                : null;
            
            final slot = TimeSlot(
              id: '${layoutId}_$slotIdCounter',
              startTime: startTime,
              endTime: endTime,
              name: (layout['Name'] ?? '第${layoutTimeSlots.length + 1}节').toString(),
              type: type,
              defaultSubjectId: mappedSubjectId,
              isHiddenByDefault: layout['IsHideDefault'] as bool? ?? false,
            );
            
            layoutTimeSlots.add(slot);
            
            if (type == TimePointType.classTime && timeSlots.length < 20) {
              timeSlots.add(slot.copyWith(id: slotIdCounter.toString()));
            }
            
            slotIdCounter++;
            totalTimeSlotsCount++;
          }
        }
        
        timeLayouts.add(TimeLayout(
          id: layoutId,
          name: (layoutValue['Name'] ?? '时间表$layoutIdCounter').toString(),
          timeSlots: layoutTimeSlots,
        ),);
        
        layoutIdCounter++;
        timeLayoutsCount++;
      });
    }

    // 转换课表 (ClassPlans)
    if (data['ClassPlans'] != null) {
      final classPlans = data['ClassPlans'] as Map<String, dynamic>;
      int scheduleIdCounter = 1;
      int dailyCourseIdCounter = 1;
      
      classPlans.forEach((planKey, planValue) {
        if (planValue['TimeRule'] != null) {
          final timeRule = planValue['TimeRule'];
          final classes = planValue['Classes'] as List<dynamic>? ?? [];
          
          final weekDay = timeRule['WeekDay'] as int? ?? 1;
          final weekCountDiv = timeRule['WeekCountDiv'] as int? ?? 0;
          
          // 转换周类型(ClassIsland: 0=全部, 1=单周, 2=双周)
          final weekType = weekCountDiv == 0 
              ? WeekType.both 
              : (weekCountDiv == 1 ? WeekType.single : WeekType.double);
          
          final timeLayoutKey = planValue['TimeLayoutId'] as String?;
          final mappedTimeLayoutId = timeLayoutKey != null 
              ? timeLayoutIdMap[timeLayoutKey] 
              : null;
          
          final scheduleCourses = <DailyCourse>[];
          
          // 转换星期几(ClassIsland: 0=周日, 1=周一...; 我们: 0=周一, 1=周二..., 6=周日)
          final dayOfWeek = weekDay == 0 ? 6 : weekDay - 1;
          
          for (var i = 0; i < classes.length; i++) {
            final classItem = classes[i];
            final subjectId = classItem['SubjectId'] as String?;
            
            if (subjectId != null && subjectIdToCourseId.containsKey(subjectId)) {
              final courseId = subjectIdToCourseId[subjectId]!;
              
              String timeSlotId;
              if (mappedTimeLayoutId != null && i < timeLayouts.length) {
                final layout = timeLayouts.firstWhere(
                  (l) => l.id == mappedTimeLayoutId,
                  orElse: () => timeLayouts.first,
                );
                if (i < layout.timeSlots.length) {
                  timeSlotId = layout.timeSlots[i].id;
                } else {
                  timeSlotId = (i + 1).toString();
                }
              } else if (i < timeSlots.length) {
                timeSlotId = timeSlots[i].id;
              } else {
                timeSlotId = (i + 1).toString();
              }
              
              final dailyCourse = DailyCourse(
                id: dailyCourseIdCounter.toString(),
                dayOfWeek: dayOfWeek < 7 ? DayOfWeek.values[dayOfWeek] : DayOfWeek.monday,
                timeSlotId: timeSlotId,
                courseId: courseId,
                weekType: weekType,
              );
              
              scheduleCourses.add(dailyCourse);
              dailyCourses.add(dailyCourse);
              dailyCourseIdCounter++;
            }
          }
          
          schedules.add(Schedule(
            id: scheduleIdCounter.toString(),
            name: (planValue['Name'] ?? '课表 $scheduleIdCounter').toString(),
            timeLayoutId: mappedTimeLayoutId,
            triggerRule: ScheduleTriggerRule(
              weekDay: weekDay,
              weekType: weekType,
              isEnabled: planValue['IsEnabled'] as bool? ?? true,
            ),
            courses: scheduleCourses,
            isAutoEnabled: planValue['IsEnabled'] as bool? ?? true,
            priority: scheduleIdCounter,
          ),);
          
          scheduleIdCounter++;
          classPlansCount++;
        }
      });
    }

    final timetableData = TimetableData(
      courses: courses,
      timeSlots: timeSlots,
      dailyCourses: dailyCourses,
      timeLayouts: timeLayouts,
      schedules: schedules,
    );

    final stats = ClassIslandImportStats(
      subjectsCount: subjectsCount,
      timeLayoutsCount: timeLayoutsCount,
      classPlansCount: classPlansCount,
      totalTimeSlotsCount: totalTimeSlotsCount,
    );

    return ClassIslandImportResult.success(timetableData, stats);
  }

  /// 从日期时间字符串中提取时间部分(HH:MM)
  static String _extractTime(String dateTimeString) {
    try {
      final parts = dateTimeString.split('T');
      if (parts.length > 1) {
        final timePart = parts[1];
        final timeParts = timePart.split(':');
        if (timeParts.length >= 2) {
          return '${timeParts[0]}:${timeParts[1]}';
        }
      }
    } catch (e) {
      return '08:00';
    }
    return '08:00';
  }
}
