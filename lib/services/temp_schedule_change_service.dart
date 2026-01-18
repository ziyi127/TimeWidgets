import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/temp_schedule_change_model.dart';
import 'package:time_widgets/utils/logger.dart';

/// 临时调课服务
class TempScheduleChangeService {
  static const String _prefsKey = 'temp_schedule_changes';

  /// 加载所有临时调课记录
  Future<List<TempScheduleChange>> loadChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);

      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList
            .map((json) =>
                TempScheduleChange.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      Logger.e('加载临时调课记录失败: $e');
      return [];
    }
  }

  /// 保存所有临时调课记录
  Future<void> saveChanges(List<TempScheduleChange> changes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = changes.map((c) => c.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(jsonList));
    } catch (e) {
      Logger.e('保存临时调课记录失败: $e');
      throw Exception('保存临时调课记录失败');
    }
  }

  /// 添加临时调课记录
  Future<void> addChange(TempScheduleChange change) async {
    final changes = await loadChanges();
    changes.add(change);
    await saveChanges(changes);
  }

  /// 删除临时调课记录
  Future<void> removeChange(String id) async {
    final changes = await loadChanges();
    changes.removeWhere((c) => c.id == id);
    await saveChanges(changes);
  }

  /// 获取指定日期的临时调课记录
  Future<List<TempScheduleChange>> getChangesForDate(DateTime date) async {
    final changes = await loadChanges();
    final targetDate = DateTime(date.year, date.month, date.day);

    return changes.where((c) {
      final changeDate = DateTime(c.date.year, c.date.month, c.date.day);
      return changeDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  /// 获取指定日期和节次的临时调课记录
  Future<TempScheduleChange?> getChangeForPeriod(
      DateTime date, String timeSlotId) async {
    final changes = await getChangesForDate(date);

    try {
      return changes.firstWhere(
        (c) => c.type == TempChangeType.period && c.timeSlotId == timeSlotId,
      );
    } catch (e) {
      return null;
    }
  }

  /// 获取指定日期的按天调课记录
  Future<TempScheduleChange?> getDayChangeForDate(DateTime date) async {
    final changes = await getChangesForDate(date);

    try {
      return changes.firstWhere((c) => c.type == TempChangeType.day);
    } catch (e) {
      return null;
    }
  }

  /// 清理过期的临时调课记录 (保留最近30天)
  Future<void> cleanupOldChanges() async {
    final changes = await loadChanges();
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    final validChanges =
        changes.where((c) => c.date.isAfter(cutoffDate)).toList();

    if (validChanges.length != changes.length) {
      await saveChanges(validChanges);
      Logger.i('清理了 ${changes.length - validChanges.length} 条过期的临时调课记录');
    }
  }
}
