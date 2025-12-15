import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.warnings = const [],
  });

  factory ValidationResult.valid({List<String> warnings = const []}) {
    return ValidationResult(isValid: true, warnings: warnings);
  }

  factory ValidationResult.invalid(String message) {
    return ValidationResult(isValid: false, errorMessage: message);
  }
}

class TimetableExportService {
  /// 将课表数据导出为 JSON 字符串
  String exportToJson(TimetableData data) {
    final jsonData = data.toJson();
    return const JsonEncoder.withIndent('  ').convert(jsonData);
  }

  /// 从 JSON 字符串导入课表数据
  TimetableData? importFromJson(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);
      return TimetableData.fromJson(jsonData);
    } catch (e) {
      print('Error importing JSON: $e');
      return null;
    }
  }

  /// 验证 JSON 字符串格式
  ValidationResult validateJson(String jsonString) {
    if (jsonString.trim().isEmpty) {
      return ValidationResult.invalid('JSON 内容不能为空');
    }

    dynamic jsonData;
    try {
      jsonData = jsonDecode(jsonString);
    } catch (e) {
      return ValidationResult.invalid('JSON 格式无效: ${e.toString()}');
    }

    if (jsonData is! Map<String, dynamic>) {
      return ValidationResult.invalid('JSON 必须是一个对象');
    }

    final warnings = <String>[];

    // 验证 courses 字段
    if (!jsonData.containsKey('courses')) {
      return ValidationResult.invalid('缺少必需字段: courses');
    }
    if (jsonData['courses'] is! List) {
      return ValidationResult.invalid('courses 必须是数组');
    }
    final courses = jsonData['courses'] as List;
    for (var i = 0; i < courses.length; i++) {
      final course = courses[i];
      if (course is! Map<String, dynamic>) {
        return ValidationResult.invalid('courses[$i] 必须是对象');
      }
      if (!course.containsKey('id') || !course.containsKey('name')) {
        return ValidationResult.invalid('courses[$i] 缺少必需字段 (id, name)');
      }
    }

    // 验证 timeSlots 字段
    if (!jsonData.containsKey('timeSlots')) {
      return ValidationResult.invalid('缺少必需字段: timeSlots');
    }
    if (jsonData['timeSlots'] is! List) {
      return ValidationResult.invalid('timeSlots 必须是数组');
    }
    final timeSlots = jsonData['timeSlots'] as List;
    for (var i = 0; i < timeSlots.length; i++) {
      final slot = timeSlots[i];
      if (slot is! Map<String, dynamic>) {
        return ValidationResult.invalid('timeSlots[$i] 必须是对象');
      }
      if (!slot.containsKey('id') || !slot.containsKey('startTime') || !slot.containsKey('endTime')) {
        return ValidationResult.invalid('timeSlots[$i] 缺少必需字段 (id, startTime, endTime)');
      }
    }

    // 验证 dailyCourses 字段
    if (!jsonData.containsKey('dailyCourses')) {
      return ValidationResult.invalid('缺少必需字段: dailyCourses');
    }
    if (jsonData['dailyCourses'] is! List) {
      return ValidationResult.invalid('dailyCourses 必须是数组');
    }

    // 检查引用完整性
    final courseIds = courses.map((c) => c['id'].toString()).toSet();
    final timeSlotIds = timeSlots.map((t) => t['id'].toString()).toSet();
    final dailyCourses = jsonData['dailyCourses'] as List;

    for (var i = 0; i < dailyCourses.length; i++) {
      final dc = dailyCourses[i];
      if (dc is! Map<String, dynamic>) {
        return ValidationResult.invalid('dailyCourses[$i] 必须是对象');
      }
      
      final courseId = dc['courseId']?.toString();
      final timeSlotId = dc['timeSlotId']?.toString();
      
      if (courseId != null && !courseIds.contains(courseId)) {
        warnings.add('dailyCourses[$i] 引用了不存在的课程 ID: $courseId');
      }
      if (timeSlotId != null && !timeSlotIds.contains(timeSlotId)) {
        warnings.add('dailyCourses[$i] 引用了不存在的时间段 ID: $timeSlotId');
      }
    }

    return ValidationResult.valid(warnings: warnings);
  }

  /// 导出到文件
  Future<bool> exportToFile(TimetableData data) async {
    try {
      final jsonString = exportToJson(data);
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '导出课表数据',
        fileName: 'timetable_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonString);
        return true;
      }
      return false;
    } catch (e) {
      print('Error exporting to file: $e');
      return false;
    }
  }

  /// 从文件导入
  Future<TimetableData?> importFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final bytes = result.files.first.bytes;
        if (bytes != null) {
          final jsonString = utf8.decode(bytes);
          final validation = validateJson(jsonString);
          
          if (!validation.isValid) {
            throw Exception(validation.errorMessage);
          }
          
          return importFromJson(jsonString);
        }
      }
      return null;
    } catch (e) {
      print('Error importing from file: $e');
      rethrow;
    }
  }
}
