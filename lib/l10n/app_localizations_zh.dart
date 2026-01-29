// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '智慧课程表';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get error => '错误';

  @override
  String get weatherTitle => '天气';

  @override
  String get weatherLoading => '获取天气中...';

  @override
  String get weatherLoadFailed => '天气加载失败';

  @override
  String get weatherUnknown => '未知';

  @override
  String get countdownTitle => '倒计时';

  @override
  String get countdownEmpty => '暂无倒计时';

  @override
  String get countdownAddHint => '点击添加重要事件';

  @override
  String get countdownLoadFailed => '倒计时加载失败';

  @override
  String get deleteSuccess => '已删除';

  @override
  String get undo => '撤销';

  @override
  String get days => '天';

  @override
  String get eventExam => '考试';

  @override
  String get eventAssignment => '作业';

  @override
  String get eventProject => '项目';

  @override
  String get eventHoliday => '假期';

  @override
  String get eventDefault => '事件';

  @override
  String get desktopWidgetDisabled => '桌面小组件已禁用';

  @override
  String get desktopWidgetDisabledHint => '请在设置中启用，或右键托盘图标进行设置';

  @override
  String get currentClassTitle => '当前课程';

  @override
  String get currentClassEmpty => '当前无课程';

  @override
  String get currentClassNext => '下一节';

  @override
  String get currentClassLocation => '地点';

  @override
  String get currentClassTime => '时间';

  @override
  String get currentClassTeacher => '教师';

  @override
  String get currentClassLoading => '加载课程中...';

  @override
  String get currentClassLoadFailed => '课程加载失败';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get settingsResetTitle => '重置设置';

  @override
  String get settingsResetMessage => '确定要将所有设置恢复为默认值吗？此操作无法撤销。';

  @override
  String get settingsResetConfirm => '重置';

  @override
  String get settingsResetSuccess => '设置已重置';

  @override
  String get resetToDefault => '重置为默认值';

  @override
  String get select => '选择';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get change => '更改';

  @override
  String get notSet => '未设置';

  @override
  String get keepUnchanged => '保持不变';

  @override
  String get generalSettings => '常规设置';

  @override
  String get language => '语言';

  @override
  String get languageZh => '简体中文';

  @override
  String get languageEn => 'English';

  @override
  String get appearanceSettings => '外观设置';

  @override
  String get themeMode => '主题模式';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get dynamicColor => '动态颜色';

  @override
  String get dynamicColorSubtitle => '使用 Material You 动态取色';

  @override
  String get followSystemColor => '跟随系统颜色';

  @override
  String get followSystemColorSubtitle => '使用系统的强调色';

  @override
  String get seedColor => '种子颜色';

  @override
  String get seedColorSubtitle => '自定义应用主题颜色';

  @override
  String get selectSeedColor => '选择种子颜色';

  @override
  String get fontSize => '字体大小';

  @override
  String get borderRadius => '圆角大小';

  @override
  String get componentOpacity => '组件透明度';

  @override
  String get shadowStrength => '阴影强度';

  @override
  String get enableGradients => '启用渐变效果';

  @override
  String get enableGradientsSubtitle => '为按钮和卡片添加渐变效果';

  @override
  String get uiScale => '界面缩放';

  @override
  String get widgetDisplaySettings => '小部件显示';

  @override
  String get timeDisplay => '时间显示';

  @override
  String get timeDisplaySubtitle => '在主屏幕显示时间';

  @override
  String get dateDisplay => '日期显示';

  @override
  String get dateDisplaySubtitle => '在主屏幕显示日期';

  @override
  String get weekDisplay => '周数显示';

  @override
  String get weekDisplaySubtitle => '在主屏幕显示当前周数';

  @override
  String get weatherDisplay => '天气显示';

  @override
  String get weatherDisplaySubtitle => '在主屏幕显示天气信息';

  @override
  String get weatherLocation => '天气地区';

  @override
  String get countdownDisplay => '倒计时显示';

  @override
  String get countdownDisplaySubtitle => '在主屏幕显示倒计时';

  @override
  String get currentClassDisplay => '当前课程显示';

  @override
  String get currentClassDisplaySubtitle => '在主屏幕显示当前课程';

  @override
  String get desktopWidgets => '桌面小组件';

  @override
  String get enableDesktopWidgets => '启用桌面小组件';

  @override
  String get enableDesktopWidgetsSubtitle => '在桌面上显示小组件';

  @override
  String get semesterSettings => '学期设置';

  @override
  String get semesterStartDate => '学期开始日期';

  @override
  String get refreshSettings => '刷新间隔';

  @override
  String get weatherRefreshInterval => '天气刷新间隔';

  @override
  String get countdownRefreshInterval => '倒计时刷新间隔';

  @override
  String get timeSyncSettings => '时间同步';

  @override
  String get autoNtpSync => '自动NTP同步';

  @override
  String get autoNtpSyncSubtitle => '开启后将自动校准系统时间';

  @override
  String get ntpServer => 'NTP服务器';

  @override
  String get modifyNtpServer => '修改NTP服务器';

  @override
  String get serverAddress => '服务器地址';

  @override
  String get syncInterval => '同步间隔';

  @override
  String get currentStatus => '当前状态';

  @override
  String get timeOffset => '时间偏移';

  @override
  String get syncNow => '立即同步';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get enableNotificationsSubtitle => '接收课程和倒计时提醒';

  @override
  String get courseReminder => '课程提醒';

  @override
  String get courseReminderSubtitle => '开启后将在课程开始前提醒';

  @override
  String get voiceReminder => '语音提醒';

  @override
  String get voiceReminderSubtitle => '开启后将使用系统语音播报课程提醒';

  @override
  String get classStartNotification => '课程开始通知';

  @override
  String get classStartNotificationSubtitle => '在课程开始时发送通知';

  @override
  String get classEndNotification => '课程结束通知';

  @override
  String get classEndNotificationSubtitle => '在课程结束时发送通知';

  @override
  String get countdownNotification => '倒计时通知';

  @override
  String get countdownNotificationSubtitle => '在倒计时结束时发送通知';

  @override
  String get startupSettings => '启动行为';

  @override
  String get startWithWindows => '开机自启';

  @override
  String get startWithWindowsSubtitle => '随系统启动时自动运行应用';

  @override
  String get minimizeToTray => '最小化到托盘';

  @override
  String get minimizeToTraySubtitle => '关闭窗口时最小化到系统托盘';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get debugMode => '调试模式';

  @override
  String get debugModeSubtitle => '显示调试信息和日志';

  @override
  String get performanceMonitoring => '性能监控';

  @override
  String get performanceMonitoringSubtitle => '监控应用性能指标';

  @override
  String get apiBaseUrl => 'API基础地址';

  @override
  String get modifyApiBaseUrl => '修改API基础地址';

  @override
  String get apiUrl => 'API地址';

  @override
  String get interconnectionSettings => '设备互联';

  @override
  String get experimental => '实验性';

  @override
  String get interconnectionSubtitle => '连接其他设备以同步课表和设置';

  @override
  String get securityWarning => '安全警告';

  @override
  String get securityWarningMessage =>
      '设备互联功能使用未加密的局域网广播和传输协议。\n\n开启此功能后，您的设备名称、IP地址以及同步的课表数据可能会被局域网内的其他用户获取。\n\n请确保您仅在受信任的网络环境（如家庭WiFi）中使用此功能。是否继续？';

  @override
  String get securityWarningConfirm => '我已知晓，继续';

  @override
  String get aboutSettings => '关于';

  @override
  String get aboutApp => '关于应用';

  @override
  String get aboutAppSubtitle => '查看应用版本、开发者信息等';

  @override
  String get minutes => '分钟';

  @override
  String get seconds => '秒';

  @override
  String get ntpServerHint => '例如: ntp.aliyun.com';

  @override
  String get apiUrlHint => '例如: http://localhost:3000/api';

  @override
  String get timetableEditTitle => '课表编辑';

  @override
  String get tabSchedule => '课表';

  @override
  String get tabTimeLayout => '时间表';

  @override
  String get tabSubjects => '科目';

  @override
  String get saveTimetable => '保存课表';

  @override
  String get timetableSaved => '课表数据已保存';

  @override
  String saveFailed(String error) {
    return '保存失败: $error';
  }

  @override
  String courseListTitle(int count) {
    return '课程列表 ($count)';
  }

  @override
  String get addCourse => '添加课程';

  @override
  String get editCourse => '编辑课程';

  @override
  String get noCourses => '暂无课程，请添加课程';

  @override
  String get courseName => '课程名称';

  @override
  String get pleaseEnterCourseName => '请输入课程名称';

  @override
  String get teacherName => '授课教师';

  @override
  String get pleaseEnterTeacherName => '请输入教师姓名';

  @override
  String get classroom => '教室';

  @override
  String get pleaseEnterClassroom => '请输入教室位置';

  @override
  String deleteCourseConfirm(String courseName) {
    return '确定要删除课程\"$courseName\"吗？';
  }

  @override
  String get confirmDelete => '确认删除';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get add => '添加';

  @override
  String teacherPrefix(String name) {
    return '教师: $name';
  }

  @override
  String classroomPrefix(String name) {
    return '教室: $name';
  }

  @override
  String importSuccess(String stats) {
    return '已导入: $stats';
  }

  @override
  String importFailed(String error) {
    return '导入失败: $error';
  }

  @override
  String get exportSuccess => '课表数据已导出';

  @override
  String exportFailed(String error) {
    return '导出失败: $error';
  }

  @override
  String get createTimetable => '创建课表';

  @override
  String get selectOrCreateTimetable => '选择或创建一个课表开始编辑';

  @override
  String get timetableSettings => '课表设置';

  @override
  String get quickSchedule => '快速排课';

  @override
  String get deleteTimetable => '删除课表';

  @override
  String get timetableName => '课表名称';

  @override
  String get copyScheduleTo => '复制课程到...';

  @override
  String copyTo(String day) {
    return '复制到 $day';
  }

  @override
  String scheduleCopied(String day) {
    return '已复制课程到 $day';
  }

  @override
  String get noCourse => '无课程';

  @override
  String get clearCourse => '清除课程';

  @override
  String editCourseInfo(String courseName) {
    return '编辑 \"$courseName\" 信息';
  }

  @override
  String get removeFromSlot => '从此时间段移除';

  @override
  String get createGroup => '创建分组';

  @override
  String get groupName => '分组名称';

  @override
  String get enterQuickEditMode => '已进入快速排课模式';

  @override
  String quickEditDoneNextDay(String day) {
    return '已完成 $day 排课，切换至下一天';
  }

  @override
  String get quickEditAllDone => '本周排课已完成！';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

  @override
  String get sunday => '周日';

  @override
  String get defaultTimeLayout => '默认时间表';

  @override
  String get customTimeLayouts => '自定义时间表列表';

  @override
  String get noCustomLayouts => '暂无自定义时间表';

  @override
  String get addTimeLayout => '添加时间表';

  @override
  String get timeLayoutName => '时间表名称';

  @override
  String get addTimeSlot => '添加时间段';

  @override
  String get editTimeSlot => '编辑时间点';

  @override
  String get noTimeSlots => '暂无时间点';

  @override
  String get addTimeSlotHint => '添加时间点来定义课程时间';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get timePointType => '类型';

  @override
  String get typeClass => '上课';

  @override
  String get typeBreak => '课间休息';

  @override
  String get typeDivider => '分割线';

  @override
  String durationMinutes(int minutes) {
    return '$minutes分钟';
  }

  @override
  String get exampleTimeLayoutName => '例如: 周末时间表';

  @override
  String get exampleScheduleName => '例如: 夏季作息';

  @override
  String get exampleTimeSlotName => '例如: 第一节';

  @override
  String get name => '名称';

  @override
  String get create => '创建';

  @override
  String get exampleGroupName => '例如: 第一学期';

  @override
  String timePointsCount(int count) {
    return '$count 个时间点';
  }

  @override
  String get refresh => '刷新';

  @override
  String get addFirstCountdown => '点击右下角按钮添加第一个倒计时';

  @override
  String deleteCountdownConfirm(String title) {
    return '确定要删除\"$title\"吗？';
  }

  @override
  String get editCountdown => '编辑倒计时';

  @override
  String get addCountdown => '添加倒计时';

  @override
  String get title => '标题';

  @override
  String get enterTitle => '请输入倒计时标题';

  @override
  String get pleaseEnterTitle => '请输入标题';

  @override
  String get description => '描述';

  @override
  String get optionalDescription => '（可选）请输入倒计时描述';

  @override
  String get targetDate => '目标日期';

  @override
  String get category => '分类';

  @override
  String get noCategory => '无分类';

  @override
  String get type => '类型';

  @override
  String get appName => '时间小组件';

  @override
  String get developerInfo => '开发者信息';

  @override
  String get developer => '开发者';

  @override
  String get email => '联系邮箱';

  @override
  String get githubProject => 'GitHub项目';

  @override
  String get copyright => '© 2025 ziyi127. 保留所有权利。';

  @override
  String get license => '基于 Apache License 2.0 开源';

  @override
  String get desktopWidgetConfigTitle => '桌面小组件配置';

  @override
  String get resetPositions => '重置位置';

  @override
  String get usageGuide => '使用说明';

  @override
  String get usageGuideContent =>
      '• 切换开关控制小组件的显示隐藏\n• 在桌面小组件界面点击\"编辑布局\"可拖拽调整位置\n• 点击\"重置位置\"恢复默认布局';

  @override
  String get widgetManagement => '小组件管理';

  @override
  String positionInfo(int x, int y, int width, int height) {
    return '位置: ($x, $y) • 尺寸: $width×$height';
  }

  @override
  String get todayCourses => '今日课程';

  @override
  String get weekSchedule => '本周课表';

  @override
  String weekNumber(int week) {
    return '第 $week 周';
  }

  @override
  String get dayView => '日';

  @override
  String get weekView => '周';

  @override
  String get noCourseToday => '今天没有课程';

  @override
  String get enjoyFreeTime => '好好享受自由时光吧 ☕';

  @override
  String get statusOngoing => '进行中';

  @override
  String get statusUpcoming => '即将开始';

  @override
  String get statusEnded => '已结束';

  @override
  String get loadingWeekSchedule => '正在加载周课表...';

  @override
  String get copyToOtherTime => '复制到其他时间';

  @override
  String get setReminder => '设置提醒';
}
