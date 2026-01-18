import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/utils/logger.dart';

class ValidationResult {
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
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;
}

/// 导入结果
class ImportResult {
  ImportResult({
    required this.success,
    this.data,
    this.errorMessage,
    this.stats,
  });

  factory ImportResult.success(TimetableData data, ImportStats stats) {
    return ImportResult(success: true, data: data, stats: stats);
  }

  factory ImportResult.failure(String message) {
    return ImportResult(success: false, errorMessage: message);
  }
  final bool success;
  final TimetableData? data;
  final String? errorMessage;
  final ImportStats? stats;
}

/// 导入统计
class ImportStats {
  ImportStats({
    required this.coursesCount,
    required this.timeSlotsCount,
    required this.dailyCoursesCount,
    required this.timeLayoutsCount,
    required this.schedulesCount,
  });
  final int coursesCount;
  final int timeSlotsCount;
  final int dailyCoursesCount;
  final int timeLayoutsCount;
  final int schedulesCount;

  @override
  String toString() {
    final parts = <String>[];
    if (coursesCount > 0) parts.add('$coursesCount 个科目');
    if (timeSlotsCount > 0) parts.add('$timeSlotsCount 个时间点');
    if (dailyCoursesCount > 0) parts.add('$dailyCoursesCount 个课程安排');
    if (timeLayoutsCount > 0) parts.add('$timeLayoutsCount 个时间表');
    if (schedulesCount > 0) parts.add('$schedulesCount 个课表');
    return parts.isEmpty ? '无数据' : parts.join('、');
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
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return TimetableData.fromJson(jsonData);
    } catch (e) {
      Logger.e('Error importing JSON: $e');
      return null;
    }
  }

  /// 从 JSON 字符串导入课表数据(带统计)
  ImportResult importFromJsonWithStats(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final data = TimetableData.fromJson(jsonData);
      final stats = ImportStats(
        coursesCount: data.courses.length,
        timeSlotsCount: data.timeSlots.length,
        dailyCoursesCount: data.dailyCourses.length,
        timeLayoutsCount: data.timeLayouts.length,
        schedulesCount: data.schedules.length,
      );
      return ImportResult.success(data, stats);
    } catch (e) {
      Logger.e('Error importing JSON: $e');
      return ImportResult.failure('导入失败: $e');
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
      return ValidationResult.invalid('JSON 格式无效: $e');
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
      if (!slot.containsKey('id') ||
          !slot.containsKey('startTime') ||
          !slot.containsKey('endTime')) {
        return ValidationResult.invalid(
            'timeSlots[$i] 缺少必需字段 (id, startTime, endTime)');
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

    // 验证 timeLayouts 字段 (可选)
    if (jsonData.containsKey('timeLayouts')) {
      if (jsonData['timeLayouts'] is! List) {
        return ValidationResult.invalid('timeLayouts 必须是数组');
      }
      final timeLayouts = jsonData['timeLayouts'] as List;
      for (var i = 0; i < timeLayouts.length; i++) {
        final layout = timeLayouts[i];
        if (layout is! Map<String, dynamic>) {
          return ValidationResult.invalid('timeLayouts[$i] 必须是对象');
        }
        if (!layout.containsKey('id') || !layout.containsKey('name')) {
          return ValidationResult.invalid('timeLayouts[$i] 缺少必需字段 (id, name)');
        }
      }
    }

    // 验证 schedules 字段 (可选)
    if (jsonData.containsKey('schedules')) {
      if (jsonData['schedules'] is! List) {
        return ValidationResult.invalid('schedules 必须是数组');
      }
      final schedules = jsonData['schedules'] as List;
      for (var i = 0; i < schedules.length; i++) {
        final schedule = schedules[i];
        if (schedule is! Map<String, dynamic>) {
          return ValidationResult.invalid('schedules[$i] 必须是对象');
        }
        if (!schedule.containsKey('id') || !schedule.containsKey('name')) {
          return ValidationResult.invalid('schedules[$i] 缺少必需字段 (id, name)');
        }
        if (!schedule.containsKey('triggerRule')) {
          return ValidationResult.invalid('schedules[$i] 缺少必需字段 (triggerRule)');
        }
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
      Logger.e('Error exporting to file: $e');
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
      Logger.e('Error importing from file: $e');
      rethrow;
    }
  }

  /// 从文件导入(带统计)
  Future<ImportResult> importFromFileWithStats() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult.failure('未选择文件');
      }

      final bytes = result.files.first.bytes;
      if (bytes == null) {
        return ImportResult.failure('无法读取文件内容');
      }

      final jsonString = utf8.decode(bytes);
      final validation = validateJson(jsonString);

      if (!validation.isValid) {
        return ImportResult.failure(validation.errorMessage ?? '验证失败');
      }

      return importFromJsonWithStats(jsonString);
    } catch (e) {
      Logger.e('Error importing from file: $e');
      return ImportResult.failure('导入失败: $e');
    }
  }
}
