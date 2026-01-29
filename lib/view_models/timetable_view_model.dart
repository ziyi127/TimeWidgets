import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/services/ntp_service.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/timetable_service.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableViewModel extends ChangeNotifier {
  final TimetableService _timetableService;
  final SettingsService _settingsService;
  final NtpService _ntpService;

  Timetable? _timetable;
  Course? _currentCourse;
  bool _isLoading = true;
  String? _error;
  
  Timer? _refreshTimer;

  TimetableViewModel({
    TimetableService? timetableService,
    SettingsService? settingsService,
    NtpService? ntpService,
  })  : _timetableService = timetableService ?? TimetableService(),
        _settingsService = settingsService ?? SettingsService(),
        _ntpService = ntpService ?? NtpService() {
    _init();
  }

  Timetable? get timetable => _timetable;
  Course? get currentCourse => _currentCourse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _init() {
    _loadTimetable();
    _settingsService.addListener(_onSettingsChanged);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    // 如果设置变更（如当前课程显示开关），可以在此处理
    // 目前主要是确保定时器运行
  }

  Future<void> refreshTimetable() async {
    await _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = _ntpService.now;
      final timetable = await _timetableService.getTimetable(now);
      _timetable = timetable;
      _updateCurrentCourse();
      _error = null;
    } catch (e) {
      Logger.e('Error loading timetable: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateCurrentCourse() {
    if (_timetable == null || _timetable!.courses.isEmpty) {
      _currentCourse = null;
      return;
    }

    try {
      // 查找当前正在进行的课程
      final currentCourses = _timetable!.courses.where((c) => c.isCurrent).toList();
      if (currentCourses.isNotEmpty) {
        _currentCourse = currentCourses.first;
      } else {
        _currentCourse = null;
      }
    } catch (e) {
      _currentCourse = null;
    }
  }

  void _startAutoRefresh() {
    _stopAutoRefresh();
    // 每分钟检查一次课程状态
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        // 不需要每次都重新加载完整课表，只需要重新计算当前课程状态
        // 但由于Course对象的isCurrent依赖于时间，最好是重新获取或更新状态
        // 这里简单起见，重新加载
        refreshTimetable();
      },
    );
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
