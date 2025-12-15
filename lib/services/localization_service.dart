import 'package:intl/intl.dart';

/// 本地化服�?
/// 提供中文字符串映射和日期时间格式化功�?
class LocalizationService {
  /// 中文字符串映�?
  static const Map<String, String> chineseStrings = {
    // 应用标题
    'app_title': '智慧课程�?,
    'app_subtitle': '智能课程管理助手',
    
    // 主界�?
    'home': '首页',
    'today': '今天',
    'current_week': '当前周次',
    'odd_week': '单周',
    'even_week': '双周',
    'week_format': '第{week}�?,
    'no_classes_today': '今天没有课程',
    'current_class': '当前课程',
    'next_class': '下节课程',
    'class_in_progress': '正在上课',
    'class_break': '课间休息',
    
    // 导航和菜�?
    'settings': '设置',
    'timetable_edit': '课表编辑',
    'countdown_list': '倒计时列�?,
    'show_hide': '显示/隐藏',
    'exit': '退�?,
    'back': '返回',
    'save': '保存',
    'cancel': '取消',
    'delete': '删除',
    'edit': '编辑',
    'add': '添加',
    'confirm': '确认',
    'close': '关闭',
    
    // 设置页面
    'theme_settings': '主题设置',
    'theme_mode': '主题模式',
    'theme_light': '浅色模式',
    'theme_dark': '深色模式',
    'theme_system': '跟随系统',
    'seed_color': '种子颜色',
    'custom_color': '自定义颜�?,
    'dynamic_color': '动态颜�?,
    'enable_dynamic_color': '启用动态颜�?,
    'api_settings': 'API设置',
    'api_base_url': 'API基础地址',
    'notification_settings': '通知设置',
    'enable_notifications': '启用通知',
    'semester_start_date': '学期开始日�?,
    'weather_refresh_interval': '天气刷新间隔',
    'countdown_refresh_interval': '倒计时刷新间�?,
    'language_settings': '语言设置',
    'reset_settings': '重置设置',
    'reset_settings_confirm': '确定要重置所有设置吗�?,
    
    // 课表编辑
    'timetable_management': '课表管理',
    'course_management': '课程管理',
    'time_slot_management': '时间段管�?,
    'daily_schedule': '每日安排',
    'course_name': '课程名称',
    'teacher_name': '教师姓名',
    'classroom': '教室',
    'course_color': '课程颜色',
    'start_time': '开始时�?,
    'end_time': '结束时间',
    'time_slot_name': '时间段名�?,
    'day_of_week': '星期',
    'week_type': '周次类型',
    'week_type_odd': '单周',
    'week_type_even': '双周',
    'week_type_both': '每周',
    'monday': '星期一',
    'tuesday': '星期�?,
    'wednesday': '星期�?,
    'thursday': '星期�?,
    'friday': '星期�?,
    'saturday': '星期�?,
    'sunday': '星期�?,
    
    // 倒计�?
    'countdown_events': '倒计时事�?,
    'add_countdown': '添加倒计�?,
    'edit_countdown': '编辑倒计�?,
    'countdown_title': '事件标题',
    'countdown_description': '事件描述',
    'target_date': '目标日期',
    'event_category': '事件类别',
    'category_exam': '考试',
    'category_deadline': '截止日期',
    'category_event': '事件',
    'category_task': '任务',
    'days_remaining': '剩余{days}�?,
    'hours_remaining': '剩余{hours}小时',
    'minutes_remaining': '剩余{minutes}分钟',
    'event_passed': '事件已过�?,
    'view_all_countdowns': '查看全部',
    'no_countdowns': '暂无倒计时事�?,
    
    // 天气
    'weather_info': '天气信息',
    'temperature': '温度',
    'weather_condition': '天气状况',
    'humidity': '湿度',
    'wind_speed': '风�?,
    'weather_loading': '天气加载�?..',
    'weather_error': '天气信息获取失败',
    
    // 数据导入导出
    'import_export': '导入导出',
    'export_timetable': '导出课表',
    'import_timetable': '导入课表',
    'import_from_classisland': '�?ClassIsland 导入',
    'export_success': '导出成功',
    'import_success': '导入成功',
    'select_file': '选择文件',
    'file_format_error': '文件格式错误',
    'export_location': '导出位置',
    
    // 错误消息
    'error': '错误',
    'warning': '警告',
    'info': '信息',
    'success': '成功',
    'network_error': '网络连接失败',
    'network_timeout': '网络连接超时',
    'no_internet': '无法连接到网�?,
    'file_not_found': '文件未找�?,
    'invalid_format': '文件格式无效',
    'storage_full': '存储空间不足',
    'permission_denied': '没有文件访问权限',
    'tray_init_failed': '系统托盘初始化失�?,
    'window_show_failed': '窗口显示失败',
    'localization_error': '本地化资源加载失�?,
    'unknown_error': '未知错误',
    
    // 错误解决建议
    'check_network_connection': '请检查网络连接后重试',
    'check_network_settings': '请检查网络设�?,
    'ensure_valid_json': '请确保文件是有效�?JSON 格式',
    'free_storage_space': '请清理存储空间后重试',
    'grant_file_permission': '请授予应用文件访问权�?,
    'restart_application': '请重启应用程�?,
    'check_window_manager': '请检查窗口管理器设置',
    'reinstall_application': '请重新安装应用程�?,
    
    // 对话�?
    'dialog_title_confirm': '确认',
    'dialog_title_error': '错误',
    'dialog_title_warning': '警告',
    'dialog_title_info': '信息',
    'dialog_button_ok': '确定',
    'dialog_button_cancel': '取消',
    'dialog_button_yes': '�?,
    'dialog_button_no': '�?,
    'dialog_button_retry': '重试',
    
    // 时间格式
    'time_format_24h': 'HH:mm',
    'date_format_short': 'MM-dd',
    'date_format_long': 'yyyy年MM月dd�?,
    'datetime_format': 'yyyy年MM月dd�?HH:mm',
    'weekday_format': 'EEEE',
    
    // 单位
    'unit_minutes': '分钟',
    'unit_hours': '小时',
    'unit_days': '�?,
    'unit_weeks': '�?,
    'unit_celsius': '°C',
    'unit_fahrenheit': '°F',
    'unit_percent': '%',
    'unit_kmh': 'km/h',
    
    // 状�?
    'status_loading': '加载�?..',
    'status_saving': '保存�?..',
    'status_syncing': '同步�?..',
    'status_offline': '离线',
    'status_online': '在线',
    'status_connected': '已连�?,
    'status_disconnected': '已断开',
    
    // 空状�?
    'empty_courses': '暂无课程',
    'empty_schedule': '今日无课程安�?,
    'empty_search_results': '未找到相关内�?,
    'empty_data': '暂无数据',
  };

  /// 获取本地化字符串
  /// 
  /// [key] 字符串键
  /// [params] 参数映射，用于替换字符串中的占位�?
  /// 
  /// 返回本地化后的字符串，如果键不存在则返回键本�?
  static String getString(String key, {Map<String, dynamic>? params}) {
    String text = chineseStrings[key] ?? key;
    
    // 替换参数占位�?
    if (params != null) {
      params.forEach((paramKey, value) {
        text = text.replaceAll('{$paramKey}', value.toString());
      });
    }
    
    return text;
  }

  /// 格式化日期为中文格式
  /// 
  /// [date] 要格式化的日�?
  /// [format] 格式类型，可选值：'short', 'long', 'datetime'
  /// 
  /// 返回格式化后的中文日期字符串
  static String formatDate(DateTime date, {String format = 'long'}) {
    try {
      switch (format) {
        case 'short':
          return DateFormat('MM-dd').format(date);
        case 'long':
          return DateFormat('yyyy年M月d�?).format(date);
        case 'datetime':
          return DateFormat('yyyy年M月d�?HH:mm').format(date);
        case 'weekday':
          return _getChineseWeekday(date.weekday);
        default:
          return DateFormat('yyyy年M月d�?).format(date);
      }
    } catch (e) {
      // 如果格式化失败，返回默认格式
      return '${date.year}�?{date.month}�?{date.day}�?;
    }
  }

  /// 格式化时间为中文格式
  /// 
  /// [time] 要格式化的时�?
  /// [use24Hour] 是否使用24小时制，默认为true
  /// 
  /// 返回格式化后的中文时间字符串
  static String formatTime(DateTime time, {bool use24Hour = true}) {
    try {
      if (use24Hour) {
        return DateFormat('HH:mm').format(time);
      } else {
        return DateFormat('ah:mm').format(time);
      }
    } catch (e) {
      // 如果格式化失败，返回默认格式
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  /// 格式化周次显�?
  /// 
  /// [weekNumber] 周次数字
  /// 
  /// 返回格式化后的周次字符串
  static String formatWeek(int weekNumber) {
    return getString('week_format', params: {'week': weekNumber});
  }

  /// 获取中文星期名称
  /// 
  /// [weekday] 星期数字�?-7�?为星期一�?
  /// 
  /// 返回中文星期名称
  static String _getChineseWeekday(int weekday) {
    const weekdays = [
      '星期一', '星期�?, '星期�?, '星期�?, 
      '星期�?, '星期�?, '星期�?
    ];
    
    if (weekday >= 1 && weekday <= 7) {
      return weekdays[weekday - 1];
    }
    
    return '星期一'; // 默认�?
  }

  /// 获取中文星期名称（通过日期�?
  /// 
  /// [date] 日期
  /// 
  /// 返回中文星期名称
  static String getChineseWeekday(DateTime date) {
    return _getChineseWeekday(date.weekday);
  }

  /// 格式化倒计时显�?
  /// 
  /// [targetDate] 目标日期
  /// [currentDate] 当前日期，默认为现在
  /// 
  /// 返回格式化后的倒计时字符串
  static String formatCountdown(DateTime targetDate, {DateTime? currentDate}) {
    currentDate ??= DateTime.now();
    final difference = targetDate.difference(currentDate);
    
    if (difference.isNegative) {
      return getString('event_passed');
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    if (days > 0) {
      return getString('days_remaining', params: {'days': days});
    } else if (hours > 0) {
      return getString('hours_remaining', params: {'hours': hours});
    } else {
      return getString('minutes_remaining', params: {'minutes': minutes});
    }
  }

  /// 获取错误消息
  /// 
  /// [errorCode] 错误代码
  /// [context] 错误上下文信�?
  /// 
  /// 返回本地化的错误消息
  static String getErrorMessage(String errorCode, {String? context}) {
    final message = getString(errorCode);
    if (context != null && context.isNotEmpty) {
      return '$message: $context';
    }
    return message;
  }

  /// 获取错误解决建议
  /// 
  /// [errorCode] 错误代码
  /// 
  /// 返回本地化的解决建议
  static String getErrorResolution(String errorCode) {
    final resolutionKey = '${errorCode}_resolution';
    return getString(resolutionKey);
  }

  /// 检查字符串是否为中�?
  /// 
  /// [text] 要检查的文本
  /// 
  /// 返回是否包含中文字符
  static bool isChineseText(String text) {
    final chineseRegex = RegExp(r'[\u4e00-\u9fa5]');
    return chineseRegex.hasMatch(text);
  }

  /// 获取所有可用的字符串键
  /// 
  /// 返回所有字符串键的列表
  static List<String> getAllKeys() {
    return chineseStrings.keys.toList();
  }

  /// 检查字符串键是否存�?
  /// 
  /// [key] 字符串键
  /// 
  /// 返回键是否存�?
  static bool hasKey(String key) {
    return chineseStrings.containsKey(key);
  }
}
