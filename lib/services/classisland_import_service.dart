import 'dart:convert' show jsonDecode, utf8;
import 'package:file_picker/file_picker.dart';
import '../models/timetable_edit_model.dart';

/// Classisland数据导入服务
class ClassislandImportService {
  /// 导入Classisland数据并转换为本程序格式
  static Future<TimetableData?> importFromFile() async {
    try {
      // 选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true, // 直接读取文件内容
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      // 直接从文件结果中获取内容
      final contents = utf8.decode(result.files.first.bytes!);
      final classislandData = jsonDecode(contents);

      // 转换数据
      final timetableData = _convertClassislandToTimetable(classislandData);

      return timetableData;
    } catch (e) {
      print('导入失败: $e');
      return null;
    }
  }

  /// 将Classisland数据转换为课表数据
  static TimetableData _convertClassislandToTimetable(Map<String, dynamic> data) {
    final courses = <CourseInfo>[];
    final timeSlots = <TimeSlot>[];
    final dailyCourses = <DailyCourse>[];

    // 创建科目ID到课程ID的映射
    final subjectIdToCourseId = <String, String>{};
    
    // 转换科目为课程
    if (data['Subjects'] != null) {
      final subjects = data['Subjects'] as Map<String, dynamic>;
      int idCounter = 1;
      
      subjects.forEach((key, value) {
        final courseId = idCounter.toString();
        subjectIdToCourseId[key] = courseId;
        
        courses.add(CourseInfo(
          id: courseId,
          name: value['Name'] ?? '未知课程',
          teacher: value['TeacherName'] ?? '',
          classroom: '',
          color: _generateColorFromString(value['Name'] ?? ''),
        ));
        idCounter++;
      });
    }

    // 转换时间表为时间段
    if (data['TimeLayouts'] != null) {
      final timeLayouts = data['TimeLayouts'] as Map<String, dynamic>;
      int idCounter = 1;
      
      timeLayouts.forEach((layoutKey, layoutValue) {
        if (layoutValue['Layouts'] != null) {
          final layouts = layoutValue['Layouts'] as List<dynamic>;
          
          for (var i = 0; i < layouts.length; i++) {
            final layout = layouts[i];
            // 仅转换上课时间 (TimeType == 0)
            if (layout['TimeType'] == 0) {
              // 提取时间部分
              final startSecond = layout['StartSecond'] as String? ?? '2024-01-01T08:00:00';
              final endSecond = layout['EndSecond'] as String? ?? '2024-01-01T08:45:00';
              
              final startTime = _extractTime(startSecond);
              final endTime = _extractTime(endSecond);
              
              timeSlots.add(TimeSlot(
                id: idCounter.toString(),
                startTime: startTime,
                endTime: endTime,
                name: layout['Name'] ?? '第${timeSlots.length + 1}节课',
              ));
              
              idCounter++;
            }
          }
        }
      });
    }

    // 转换课表为日课表
    if (data['ClassPlans'] != null) {
      final classPlans = data['ClassPlans'] as Map<String, dynamic>;
      int dailyCourseIdCounter = 1;
      
      classPlans.forEach((planKey, planValue) {
        if (planValue['TimeRule'] != null && planValue['Classes'] != null) {
          final timeRule = planValue['TimeRule'];
          final classes = planValue['Classes'] as List<dynamic>;
          
          // 获取星期几和周类型
          final weekDay = timeRule['WeekDay'] as int? ?? 1;
          final weekCountDiv = timeRule['WeekCountDiv'] as int? ?? 0;
          
          // 转换星期几 (Classisland: 0=周日, 1=周一...; 我们: 0=周一, 1=周二..., 6=周日)
          final dayOfWeek = weekDay == 0 ? 6 : weekDay - 1; // 周日(0)转换为周日(6)
          
          // 转换周类型 (Classisland: 0=全部, 1=单周, 2=双周; 我们: 0=单周, 1=双周, 2=每周)
          final weekType = weekCountDiv == 0 ? 2 : (weekCountDiv == 1 ? 0 : 1);
          
          // 为每个课程创建日课表项
          for (var i = 0; i < classes.length; i++) {
            final classItem = classes[i];
            if (i < timeSlots.length && classItem['SubjectId'] != null) {
              // 获取对应的课程ID
              final subjectId = classItem['SubjectId'] as String;
              final courseId = subjectIdToCourseId[subjectId];
              
              // 确保有有效的课程ID和时间段
              if (courseId != null && timeSlots.isNotEmpty) {
                // 使用索引作为时间段ID（简化处理）
                final timeSlotIndex = i % timeSlots.length;
                
                dailyCourses.add(DailyCourse(
                  id: dailyCourseIdCounter.toString(),
                  dayOfWeek: dayOfWeek < 7 ? DayOfWeek.values[dayOfWeek] : DayOfWeek.monday,
                  timeSlotId: timeSlots[timeSlotIndex].id,
                  courseId: courseId,
                  weekType: weekType < 3 ? WeekType.values[weekType] : WeekType.both,
                ));
                
                dailyCourseIdCounter++;
              }
            }
          }
        }
      });
    }

    return TimetableData(
      courses: courses,
      timeSlots: timeSlots,
      dailyCourses: dailyCourses,
    );
  }

  /// 从日期时间字符串中提取时间部分 (HH:MM)
  static String _extractTime(String dateTimeString) {
    try {
      // 从 "2024-05-25T08:00:00" 提取 "08:00"
      final parts = dateTimeString.split('T');
      if (parts.length > 1) {
        final timePart = parts[1];
        final timeParts = timePart.split(':');
        if (timeParts.length >= 2) {
          return '${timeParts[0]}:${timeParts[1]}';
        }
      }
    } catch (e) {
      // 如果解析失败，返回默认时间
      return '08:00';
    }
    return '08:00';
  }

  /// 根据字符串生成颜色
  static String _generateColorFromString(String input) {
    if (input.isEmpty) return '#2196F3';
    
    // 简单的哈希函数生成颜色
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // 生成HSL颜色值，确保颜色明亮且饱和
    final hue = ((hash & 0xFF) * 360) ~/ 255;
    return 'hsl($hue, 70%, 50%)';
  }

  /// 显示转换警告信息

}