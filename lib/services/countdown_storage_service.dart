import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/logger.dart';

class CountdownStorageService {
  factory CountdownStorageService() => _instance;
  CountdownStorageService._internal();
  static const String _countdownListKey = 'countdown_list';

  // 单例模式
  static final CountdownStorageService _instance =
      CountdownStorageService._internal();

  // 数据变更流
  final _changeController = StreamController<void>.broadcast();
  Stream<void> get onChange => _changeController.stream;

  void dispose() {
    _changeController.close();
  }

  Future<List<CountdownData>> loadAllCountdowns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_countdownListKey);

      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
        return jsonList
            .map((json) => CountdownData.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      Logger.e('Error loading countdowns: $e');
      return [];
    }
  }

  Future<void> saveCountdown(CountdownData countdown) async {
    try {
      final countdowns = await loadAllCountdowns();
      final existingIndex = countdowns.indexWhere((c) => c.id == countdown.id);

      if (existingIndex >= 0) {
        countdowns[existingIndex] = countdown;
      } else {
        countdowns.add(countdown);
      }

      await saveAllCountdowns(countdowns);
      _changeController.add(null); // 通知变更
    } catch (e) {
      Logger.e('Error saving countdown: $e');
      throw Exception('Failed to save countdown');
    }
  }

  Future<void> updateCountdown(CountdownData countdown) async {
    try {
      final countdowns = await loadAllCountdowns();
      final index = countdowns.indexWhere((c) => c.id == countdown.id);

      if (index >= 0) {
        countdowns[index] = countdown;
        await saveAllCountdowns(countdowns);
        _changeController.add(null); // 通知变更
      } else {
        throw Exception('Countdown not found');
      }
    } catch (e) {
      Logger.e('Error updating countdown: $e');
      throw Exception('Failed to update countdown');
    }
  }

  Future<void> deleteCountdown(String id) async {
    try {
      final countdowns = await loadAllCountdowns();
      countdowns.removeWhere((c) => c.id == id);
      await saveAllCountdowns(countdowns);
      _changeController.add(null); // 通知变更
    } catch (e) {
      Logger.e('Error deleting countdown: $e');
      throw Exception('Failed to delete countdown');
    }
  }

  Future<void> saveAllCountdowns(List<CountdownData> countdowns) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = countdowns.map((c) => c.toJson()).toList();
      await prefs.setString(_countdownListKey, jsonEncode(jsonList));
    } catch (e) {
      Logger.e('Error saving all countdowns: $e');
      throw Exception('Failed to save countdowns');
    }
  }

  Future<CountdownData?> getCountdownById(String id) async {
    final countdowns = await loadAllCountdowns();
    try {
      return countdowns.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取按目标日期排序的倒计时列�?
  Future<List<CountdownData>> getSortedCountdowns() async {
    final countdowns = await loadAllCountdowns();
    countdowns.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    return countdowns;
  }

  /// 获取最近的倒计时事�?
  Future<CountdownData?> getNextCountdown() async {
    final countdowns = await getSortedCountdowns();
    final now = DateTime.now();

    try {
      return countdowns.firstWhere(
        (c) => c.targetDate.isAfter(now),
      );
    } catch (e) {
      return countdowns.isNotEmpty ? countdowns.first : null;
    }
  }
}
