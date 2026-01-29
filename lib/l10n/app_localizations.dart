import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'智慧课程表'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// No description provided for @weatherTitle.
  ///
  /// In zh, this message translates to:
  /// **'天气'**
  String get weatherTitle;

  /// No description provided for @weatherLoading.
  ///
  /// In zh, this message translates to:
  /// **'获取天气中...'**
  String get weatherLoading;

  /// No description provided for @weatherLoadFailed.
  ///
  /// In zh, this message translates to:
  /// **'天气加载失败'**
  String get weatherLoadFailed;

  /// No description provided for @weatherUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get weatherUnknown;

  /// No description provided for @countdownTitle.
  ///
  /// In zh, this message translates to:
  /// **'倒计时'**
  String get countdownTitle;

  /// No description provided for @countdownEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无倒计时'**
  String get countdownEmpty;

  /// No description provided for @countdownAddHint.
  ///
  /// In zh, this message translates to:
  /// **'点击添加重要事件'**
  String get countdownAddHint;

  /// No description provided for @countdownLoadFailed.
  ///
  /// In zh, this message translates to:
  /// **'倒计时加载失败'**
  String get countdownLoadFailed;

  /// No description provided for @deleteSuccess.
  ///
  /// In zh, this message translates to:
  /// **'已删除'**
  String get deleteSuccess;

  /// No description provided for @undo.
  ///
  /// In zh, this message translates to:
  /// **'撤销'**
  String get undo;

  /// No description provided for @days.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get days;

  /// No description provided for @eventExam.
  ///
  /// In zh, this message translates to:
  /// **'考试'**
  String get eventExam;

  /// No description provided for @eventAssignment.
  ///
  /// In zh, this message translates to:
  /// **'作业'**
  String get eventAssignment;

  /// No description provided for @eventProject.
  ///
  /// In zh, this message translates to:
  /// **'项目'**
  String get eventProject;

  /// No description provided for @eventHoliday.
  ///
  /// In zh, this message translates to:
  /// **'假期'**
  String get eventHoliday;

  /// No description provided for @eventDefault.
  ///
  /// In zh, this message translates to:
  /// **'事件'**
  String get eventDefault;

  /// No description provided for @desktopWidgetDisabled.
  ///
  /// In zh, this message translates to:
  /// **'桌面小组件已禁用'**
  String get desktopWidgetDisabled;

  /// No description provided for @desktopWidgetDisabledHint.
  ///
  /// In zh, this message translates to:
  /// **'请在设置中启用，或右键托盘图标进行设置'**
  String get desktopWidgetDisabledHint;

  /// No description provided for @currentClassTitle.
  ///
  /// In zh, this message translates to:
  /// **'当前课程'**
  String get currentClassTitle;

  /// No description provided for @currentClassEmpty.
  ///
  /// In zh, this message translates to:
  /// **'当前无课程'**
  String get currentClassEmpty;

  /// No description provided for @currentClassNext.
  ///
  /// In zh, this message translates to:
  /// **'下一节'**
  String get currentClassNext;

  /// No description provided for @currentClassLocation.
  ///
  /// In zh, this message translates to:
  /// **'地点'**
  String get currentClassLocation;

  /// No description provided for @currentClassTime.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get currentClassTime;

  /// No description provided for @currentClassTeacher.
  ///
  /// In zh, this message translates to:
  /// **'教师'**
  String get currentClassTeacher;

  /// No description provided for @currentClassLoading.
  ///
  /// In zh, this message translates to:
  /// **'加载课程中...'**
  String get currentClassLoading;

  /// No description provided for @currentClassLoadFailed.
  ///
  /// In zh, this message translates to:
  /// **'课程加载失败'**
  String get currentClassLoadFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsSaved.
  ///
  /// In zh, this message translates to:
  /// **'设置已保存'**
  String get settingsSaved;

  /// No description provided for @settingsResetTitle.
  ///
  /// In zh, this message translates to:
  /// **'重置设置'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定要将所有设置恢复为默认值吗？此操作无法撤销。'**
  String get settingsResetMessage;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get settingsResetConfirm;

  /// No description provided for @settingsResetSuccess.
  ///
  /// In zh, this message translates to:
  /// **'设置已重置'**
  String get settingsResetSuccess;

  /// No description provided for @resetToDefault.
  ///
  /// In zh, this message translates to:
  /// **'重置为默认值'**
  String get resetToDefault;

  /// No description provided for @select.
  ///
  /// In zh, this message translates to:
  /// **'选择'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @change.
  ///
  /// In zh, this message translates to:
  /// **'更改'**
  String get change;

  /// No description provided for @notSet.
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get notSet;

  /// No description provided for @keepUnchanged.
  ///
  /// In zh, this message translates to:
  /// **'保持不变'**
  String get keepUnchanged;

  /// No description provided for @generalSettings.
  ///
  /// In zh, this message translates to:
  /// **'常规设置'**
  String get generalSettings;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @languageZh.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get languageZh;

  /// No description provided for @languageEn.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @appearanceSettings.
  ///
  /// In zh, this message translates to:
  /// **'外观设置'**
  String get appearanceSettings;

  /// No description provided for @themeMode.
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get themeMode;

  /// No description provided for @themeModeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeModeDark;

  /// No description provided for @dynamicColor.
  ///
  /// In zh, this message translates to:
  /// **'动态颜色'**
  String get dynamicColor;

  /// No description provided for @dynamicColorSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'使用 Material You 动态取色'**
  String get dynamicColorSubtitle;

  /// No description provided for @followSystemColor.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统颜色'**
  String get followSystemColor;

  /// No description provided for @followSystemColorSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'使用系统的强调色'**
  String get followSystemColorSubtitle;

  /// No description provided for @seedColor.
  ///
  /// In zh, this message translates to:
  /// **'种子颜色'**
  String get seedColor;

  /// No description provided for @seedColorSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'自定义应用主题颜色'**
  String get seedColorSubtitle;

  /// No description provided for @selectSeedColor.
  ///
  /// In zh, this message translates to:
  /// **'选择种子颜色'**
  String get selectSeedColor;

  /// No description provided for @fontSize.
  ///
  /// In zh, this message translates to:
  /// **'字体大小'**
  String get fontSize;

  /// No description provided for @borderRadius.
  ///
  /// In zh, this message translates to:
  /// **'圆角大小'**
  String get borderRadius;

  /// No description provided for @componentOpacity.
  ///
  /// In zh, this message translates to:
  /// **'组件透明度'**
  String get componentOpacity;

  /// No description provided for @shadowStrength.
  ///
  /// In zh, this message translates to:
  /// **'阴影强度'**
  String get shadowStrength;

  /// No description provided for @enableGradients.
  ///
  /// In zh, this message translates to:
  /// **'启用渐变效果'**
  String get enableGradients;

  /// No description provided for @enableGradientsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'为按钮和卡片添加渐变效果'**
  String get enableGradientsSubtitle;

  /// No description provided for @uiScale.
  ///
  /// In zh, this message translates to:
  /// **'界面缩放'**
  String get uiScale;

  /// No description provided for @widgetDisplaySettings.
  ///
  /// In zh, this message translates to:
  /// **'小部件显示'**
  String get widgetDisplaySettings;

  /// No description provided for @timeDisplay.
  ///
  /// In zh, this message translates to:
  /// **'时间显示'**
  String get timeDisplay;

  /// No description provided for @timeDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示时间'**
  String get timeDisplaySubtitle;

  /// No description provided for @dateDisplay.
  ///
  /// In zh, this message translates to:
  /// **'日期显示'**
  String get dateDisplay;

  /// No description provided for @dateDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示日期'**
  String get dateDisplaySubtitle;

  /// No description provided for @weekDisplay.
  ///
  /// In zh, this message translates to:
  /// **'周数显示'**
  String get weekDisplay;

  /// No description provided for @weekDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示当前周数'**
  String get weekDisplaySubtitle;

  /// No description provided for @weatherDisplay.
  ///
  /// In zh, this message translates to:
  /// **'天气显示'**
  String get weatherDisplay;

  /// No description provided for @weatherDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示天气信息'**
  String get weatherDisplaySubtitle;

  /// No description provided for @weatherLocation.
  ///
  /// In zh, this message translates to:
  /// **'天气地区'**
  String get weatherLocation;

  /// No description provided for @countdownDisplay.
  ///
  /// In zh, this message translates to:
  /// **'倒计时显示'**
  String get countdownDisplay;

  /// No description provided for @countdownDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示倒计时'**
  String get countdownDisplaySubtitle;

  /// No description provided for @currentClassDisplay.
  ///
  /// In zh, this message translates to:
  /// **'当前课程显示'**
  String get currentClassDisplay;

  /// No description provided for @currentClassDisplaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在主屏幕显示当前课程'**
  String get currentClassDisplaySubtitle;

  /// No description provided for @desktopWidgets.
  ///
  /// In zh, this message translates to:
  /// **'桌面小组件'**
  String get desktopWidgets;

  /// No description provided for @enableDesktopWidgets.
  ///
  /// In zh, this message translates to:
  /// **'启用桌面小组件'**
  String get enableDesktopWidgets;

  /// No description provided for @enableDesktopWidgetsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在桌面上显示小组件'**
  String get enableDesktopWidgetsSubtitle;

  /// No description provided for @semesterSettings.
  ///
  /// In zh, this message translates to:
  /// **'学期设置'**
  String get semesterSettings;

  /// No description provided for @semesterStartDate.
  ///
  /// In zh, this message translates to:
  /// **'学期开始日期'**
  String get semesterStartDate;

  /// No description provided for @refreshSettings.
  ///
  /// In zh, this message translates to:
  /// **'刷新间隔'**
  String get refreshSettings;

  /// No description provided for @weatherRefreshInterval.
  ///
  /// In zh, this message translates to:
  /// **'天气刷新间隔'**
  String get weatherRefreshInterval;

  /// No description provided for @countdownRefreshInterval.
  ///
  /// In zh, this message translates to:
  /// **'倒计时刷新间隔'**
  String get countdownRefreshInterval;

  /// No description provided for @timeSyncSettings.
  ///
  /// In zh, this message translates to:
  /// **'时间同步'**
  String get timeSyncSettings;

  /// No description provided for @autoNtpSync.
  ///
  /// In zh, this message translates to:
  /// **'自动NTP同步'**
  String get autoNtpSync;

  /// No description provided for @autoNtpSyncSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'开启后将自动校准系统时间'**
  String get autoNtpSyncSubtitle;

  /// No description provided for @ntpServer.
  ///
  /// In zh, this message translates to:
  /// **'NTP服务器'**
  String get ntpServer;

  /// No description provided for @modifyNtpServer.
  ///
  /// In zh, this message translates to:
  /// **'修改NTP服务器'**
  String get modifyNtpServer;

  /// No description provided for @serverAddress.
  ///
  /// In zh, this message translates to:
  /// **'服务器地址'**
  String get serverAddress;

  /// No description provided for @syncInterval.
  ///
  /// In zh, this message translates to:
  /// **'同步间隔'**
  String get syncInterval;

  /// No description provided for @currentStatus.
  ///
  /// In zh, this message translates to:
  /// **'当前状态'**
  String get currentStatus;

  /// No description provided for @timeOffset.
  ///
  /// In zh, this message translates to:
  /// **'时间偏移'**
  String get timeOffset;

  /// No description provided for @syncNow.
  ///
  /// In zh, this message translates to:
  /// **'立即同步'**
  String get syncNow;

  /// No description provided for @notificationSettings.
  ///
  /// In zh, this message translates to:
  /// **'通知设置'**
  String get notificationSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In zh, this message translates to:
  /// **'启用通知'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'接收课程和倒计时提醒'**
  String get enableNotificationsSubtitle;

  /// No description provided for @courseReminder.
  ///
  /// In zh, this message translates to:
  /// **'课程提醒'**
  String get courseReminder;

  /// No description provided for @courseReminderSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'开启后将在课程开始前提醒'**
  String get courseReminderSubtitle;

  /// No description provided for @voiceReminder.
  ///
  /// In zh, this message translates to:
  /// **'语音提醒'**
  String get voiceReminder;

  /// No description provided for @voiceReminderSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'开启后将使用系统语音播报课程提醒'**
  String get voiceReminderSubtitle;

  /// No description provided for @classStartNotification.
  ///
  /// In zh, this message translates to:
  /// **'课程开始通知'**
  String get classStartNotification;

  /// No description provided for @classStartNotificationSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在课程开始时发送通知'**
  String get classStartNotificationSubtitle;

  /// No description provided for @classEndNotification.
  ///
  /// In zh, this message translates to:
  /// **'课程结束通知'**
  String get classEndNotification;

  /// No description provided for @classEndNotificationSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在课程结束时发送通知'**
  String get classEndNotificationSubtitle;

  /// No description provided for @countdownNotification.
  ///
  /// In zh, this message translates to:
  /// **'倒计时通知'**
  String get countdownNotification;

  /// No description provided for @countdownNotificationSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在倒计时结束时发送通知'**
  String get countdownNotificationSubtitle;

  /// No description provided for @startupSettings.
  ///
  /// In zh, this message translates to:
  /// **'启动行为'**
  String get startupSettings;

  /// No description provided for @startWithWindows.
  ///
  /// In zh, this message translates to:
  /// **'开机自启'**
  String get startWithWindows;

  /// No description provided for @startWithWindowsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'随系统启动时自动运行应用'**
  String get startWithWindowsSubtitle;

  /// No description provided for @minimizeToTray.
  ///
  /// In zh, this message translates to:
  /// **'最小化到托盘'**
  String get minimizeToTray;

  /// No description provided for @minimizeToTraySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'关闭窗口时最小化到系统托盘'**
  String get minimizeToTraySubtitle;

  /// No description provided for @advancedSettings.
  ///
  /// In zh, this message translates to:
  /// **'高级设置'**
  String get advancedSettings;

  /// No description provided for @debugMode.
  ///
  /// In zh, this message translates to:
  /// **'调试模式'**
  String get debugMode;

  /// No description provided for @debugModeSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'显示调试信息和日志'**
  String get debugModeSubtitle;

  /// No description provided for @performanceMonitoring.
  ///
  /// In zh, this message translates to:
  /// **'性能监控'**
  String get performanceMonitoring;

  /// No description provided for @performanceMonitoringSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'监控应用性能指标'**
  String get performanceMonitoringSubtitle;

  /// No description provided for @apiBaseUrl.
  ///
  /// In zh, this message translates to:
  /// **'API基础地址'**
  String get apiBaseUrl;

  /// No description provided for @modifyApiBaseUrl.
  ///
  /// In zh, this message translates to:
  /// **'修改API基础地址'**
  String get modifyApiBaseUrl;

  /// No description provided for @apiUrl.
  ///
  /// In zh, this message translates to:
  /// **'API地址'**
  String get apiUrl;

  /// No description provided for @interconnectionSettings.
  ///
  /// In zh, this message translates to:
  /// **'设备互联'**
  String get interconnectionSettings;

  /// No description provided for @experimental.
  ///
  /// In zh, this message translates to:
  /// **'实验性'**
  String get experimental;

  /// No description provided for @interconnectionSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'连接其他设备以同步课表和设置'**
  String get interconnectionSubtitle;

  /// No description provided for @securityWarning.
  ///
  /// In zh, this message translates to:
  /// **'安全警告'**
  String get securityWarning;

  /// No description provided for @securityWarningMessage.
  ///
  /// In zh, this message translates to:
  /// **'设备互联功能使用未加密的局域网广播和传输协议。\n\n开启此功能后，您的设备名称、IP地址以及同步的课表数据可能会被局域网内的其他用户获取。\n\n请确保您仅在受信任的网络环境（如家庭WiFi）中使用此功能。是否继续？'**
  String get securityWarningMessage;

  /// No description provided for @securityWarningConfirm.
  ///
  /// In zh, this message translates to:
  /// **'我已知晓，继续'**
  String get securityWarningConfirm;

  /// No description provided for @aboutSettings.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get aboutSettings;

  /// No description provided for @aboutApp.
  ///
  /// In zh, this message translates to:
  /// **'关于应用'**
  String get aboutApp;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'查看应用版本、开发者信息等'**
  String get aboutAppSubtitle;

  /// No description provided for @minutes.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get seconds;

  /// No description provided for @ntpServerHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: ntp.aliyun.com'**
  String get ntpServerHint;

  /// No description provided for @apiUrlHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: http://localhost:3000/api'**
  String get apiUrlHint;

  /// No description provided for @timetableEditTitle.
  ///
  /// In zh, this message translates to:
  /// **'课表编辑'**
  String get timetableEditTitle;

  /// No description provided for @tabSchedule.
  ///
  /// In zh, this message translates to:
  /// **'课表'**
  String get tabSchedule;

  /// No description provided for @tabTimeLayout.
  ///
  /// In zh, this message translates to:
  /// **'时间表'**
  String get tabTimeLayout;

  /// No description provided for @tabSubjects.
  ///
  /// In zh, this message translates to:
  /// **'科目'**
  String get tabSubjects;

  /// No description provided for @saveTimetable.
  ///
  /// In zh, this message translates to:
  /// **'保存课表'**
  String get saveTimetable;

  /// No description provided for @timetableSaved.
  ///
  /// In zh, this message translates to:
  /// **'课表数据已保存'**
  String get timetableSaved;

  /// No description provided for @saveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败: {error}'**
  String saveFailed(String error);

  /// No description provided for @courseListTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程列表 ({count})'**
  String courseListTitle(int count);

  /// No description provided for @addCourse.
  ///
  /// In zh, this message translates to:
  /// **'添加课程'**
  String get addCourse;

  /// No description provided for @editCourse.
  ///
  /// In zh, this message translates to:
  /// **'编辑课程'**
  String get editCourse;

  /// No description provided for @noCourses.
  ///
  /// In zh, this message translates to:
  /// **'暂无课程，请添加课程'**
  String get noCourses;

  /// No description provided for @courseName.
  ///
  /// In zh, this message translates to:
  /// **'课程名称'**
  String get courseName;

  /// No description provided for @pleaseEnterCourseName.
  ///
  /// In zh, this message translates to:
  /// **'请输入课程名称'**
  String get pleaseEnterCourseName;

  /// No description provided for @teacherName.
  ///
  /// In zh, this message translates to:
  /// **'授课教师'**
  String get teacherName;

  /// No description provided for @pleaseEnterTeacherName.
  ///
  /// In zh, this message translates to:
  /// **'请输入教师姓名'**
  String get pleaseEnterTeacherName;

  /// No description provided for @classroom.
  ///
  /// In zh, this message translates to:
  /// **'教室'**
  String get classroom;

  /// No description provided for @pleaseEnterClassroom.
  ///
  /// In zh, this message translates to:
  /// **'请输入教室位置'**
  String get pleaseEnterClassroom;

  /// No description provided for @deleteCourseConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除课程\"{courseName}\"吗？'**
  String deleteCourseConfirm(String courseName);

  /// No description provided for @confirmDelete.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDelete;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @teacherPrefix.
  ///
  /// In zh, this message translates to:
  /// **'教师: {name}'**
  String teacherPrefix(String name);

  /// No description provided for @classroomPrefix.
  ///
  /// In zh, this message translates to:
  /// **'教室: {name}'**
  String classroomPrefix(String name);

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'已导入: {stats}'**
  String importSuccess(String stats);

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'导入失败: {error}'**
  String importFailed(String error);

  /// No description provided for @exportSuccess.
  ///
  /// In zh, this message translates to:
  /// **'课表数据已导出'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败: {error}'**
  String exportFailed(String error);

  /// No description provided for @createTimetable.
  ///
  /// In zh, this message translates to:
  /// **'创建课表'**
  String get createTimetable;

  /// No description provided for @selectOrCreateTimetable.
  ///
  /// In zh, this message translates to:
  /// **'选择或创建一个课表开始编辑'**
  String get selectOrCreateTimetable;

  /// No description provided for @timetableSettings.
  ///
  /// In zh, this message translates to:
  /// **'课表设置'**
  String get timetableSettings;

  /// No description provided for @quickSchedule.
  ///
  /// In zh, this message translates to:
  /// **'快速排课'**
  String get quickSchedule;

  /// No description provided for @deleteTimetable.
  ///
  /// In zh, this message translates to:
  /// **'删除课表'**
  String get deleteTimetable;

  /// No description provided for @timetableName.
  ///
  /// In zh, this message translates to:
  /// **'课表名称'**
  String get timetableName;

  /// No description provided for @copyScheduleTo.
  ///
  /// In zh, this message translates to:
  /// **'复制课程到...'**
  String get copyScheduleTo;

  /// No description provided for @copyTo.
  ///
  /// In zh, this message translates to:
  /// **'复制到 {day}'**
  String copyTo(String day);

  /// No description provided for @scheduleCopied.
  ///
  /// In zh, this message translates to:
  /// **'已复制课程到 {day}'**
  String scheduleCopied(String day);

  /// No description provided for @noCourse.
  ///
  /// In zh, this message translates to:
  /// **'无课程'**
  String get noCourse;

  /// No description provided for @clearCourse.
  ///
  /// In zh, this message translates to:
  /// **'清除课程'**
  String get clearCourse;

  /// No description provided for @editCourseInfo.
  ///
  /// In zh, this message translates to:
  /// **'编辑 \"{courseName}\" 信息'**
  String editCourseInfo(String courseName);

  /// No description provided for @removeFromSlot.
  ///
  /// In zh, this message translates to:
  /// **'从此时间段移除'**
  String get removeFromSlot;

  /// No description provided for @createGroup.
  ///
  /// In zh, this message translates to:
  /// **'创建分组'**
  String get createGroup;

  /// No description provided for @groupName.
  ///
  /// In zh, this message translates to:
  /// **'分组名称'**
  String get groupName;

  /// No description provided for @enterQuickEditMode.
  ///
  /// In zh, this message translates to:
  /// **'已进入快速排课模式'**
  String get enterQuickEditMode;

  /// No description provided for @quickEditDoneNextDay.
  ///
  /// In zh, this message translates to:
  /// **'已完成 {day} 排课，切换至下一天'**
  String quickEditDoneNextDay(String day);

  /// No description provided for @quickEditAllDone.
  ///
  /// In zh, this message translates to:
  /// **'本周排课已完成！'**
  String get quickEditAllDone;

  /// No description provided for @monday.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get sunday;

  /// No description provided for @defaultTimeLayout.
  ///
  /// In zh, this message translates to:
  /// **'默认时间表'**
  String get defaultTimeLayout;

  /// No description provided for @customTimeLayouts.
  ///
  /// In zh, this message translates to:
  /// **'自定义时间表列表'**
  String get customTimeLayouts;

  /// No description provided for @noCustomLayouts.
  ///
  /// In zh, this message translates to:
  /// **'暂无自定义时间表'**
  String get noCustomLayouts;

  /// No description provided for @addTimeLayout.
  ///
  /// In zh, this message translates to:
  /// **'添加时间表'**
  String get addTimeLayout;

  /// No description provided for @timeLayoutName.
  ///
  /// In zh, this message translates to:
  /// **'时间表名称'**
  String get timeLayoutName;

  /// No description provided for @addTimeSlot.
  ///
  /// In zh, this message translates to:
  /// **'添加时间段'**
  String get addTimeSlot;

  /// No description provided for @editTimeSlot.
  ///
  /// In zh, this message translates to:
  /// **'编辑时间点'**
  String get editTimeSlot;

  /// No description provided for @noTimeSlots.
  ///
  /// In zh, this message translates to:
  /// **'暂无时间点'**
  String get noTimeSlots;

  /// No description provided for @addTimeSlotHint.
  ///
  /// In zh, this message translates to:
  /// **'添加时间点来定义课程时间'**
  String get addTimeSlotHint;

  /// No description provided for @startTime.
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In zh, this message translates to:
  /// **'结束时间'**
  String get endTime;

  /// No description provided for @timePointType.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get timePointType;

  /// No description provided for @typeClass.
  ///
  /// In zh, this message translates to:
  /// **'上课'**
  String get typeClass;

  /// No description provided for @typeBreak.
  ///
  /// In zh, this message translates to:
  /// **'课间休息'**
  String get typeBreak;

  /// No description provided for @typeDivider.
  ///
  /// In zh, this message translates to:
  /// **'分割线'**
  String get typeDivider;

  /// No description provided for @durationMinutes.
  ///
  /// In zh, this message translates to:
  /// **'{minutes}分钟'**
  String durationMinutes(int minutes);

  /// No description provided for @exampleTimeLayoutName.
  ///
  /// In zh, this message translates to:
  /// **'例如: 周末时间表'**
  String get exampleTimeLayoutName;

  /// No description provided for @exampleScheduleName.
  ///
  /// In zh, this message translates to:
  /// **'例如: 夏季作息'**
  String get exampleScheduleName;

  /// No description provided for @exampleTimeSlotName.
  ///
  /// In zh, this message translates to:
  /// **'例如: 第一节'**
  String get exampleTimeSlotName;

  /// No description provided for @name.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get name;

  /// No description provided for @create.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get create;

  /// No description provided for @exampleGroupName.
  ///
  /// In zh, this message translates to:
  /// **'例如: 第一学期'**
  String get exampleGroupName;

  /// No description provided for @timePointsCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个时间点'**
  String timePointsCount(int count);

  /// No description provided for @refresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get refresh;

  /// No description provided for @addFirstCountdown.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角按钮添加第一个倒计时'**
  String get addFirstCountdown;

  /// No description provided for @deleteCountdownConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除\"{title}\"吗？'**
  String deleteCountdownConfirm(String title);

  /// No description provided for @editCountdown.
  ///
  /// In zh, this message translates to:
  /// **'编辑倒计时'**
  String get editCountdown;

  /// No description provided for @addCountdown.
  ///
  /// In zh, this message translates to:
  /// **'添加倒计时'**
  String get addCountdown;

  /// No description provided for @title.
  ///
  /// In zh, this message translates to:
  /// **'标题'**
  String get title;

  /// No description provided for @enterTitle.
  ///
  /// In zh, this message translates to:
  /// **'请输入倒计时标题'**
  String get enterTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In zh, this message translates to:
  /// **'请输入标题'**
  String get pleaseEnterTitle;

  /// No description provided for @description.
  ///
  /// In zh, this message translates to:
  /// **'描述'**
  String get description;

  /// No description provided for @optionalDescription.
  ///
  /// In zh, this message translates to:
  /// **'（可选）请输入倒计时描述'**
  String get optionalDescription;

  /// No description provided for @targetDate.
  ///
  /// In zh, this message translates to:
  /// **'目标日期'**
  String get targetDate;

  /// No description provided for @category.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get category;

  /// No description provided for @noCategory.
  ///
  /// In zh, this message translates to:
  /// **'无分类'**
  String get noCategory;

  /// No description provided for @type.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get type;

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'时间小组件'**
  String get appName;

  /// No description provided for @developerInfo.
  ///
  /// In zh, this message translates to:
  /// **'开发者信息'**
  String get developerInfo;

  /// No description provided for @developer.
  ///
  /// In zh, this message translates to:
  /// **'开发者'**
  String get developer;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'联系邮箱'**
  String get email;

  /// No description provided for @githubProject.
  ///
  /// In zh, this message translates to:
  /// **'GitHub项目'**
  String get githubProject;

  /// No description provided for @copyright.
  ///
  /// In zh, this message translates to:
  /// **'© 2025 ziyi127. 保留所有权利。'**
  String get copyright;

  /// No description provided for @license.
  ///
  /// In zh, this message translates to:
  /// **'基于 Apache License 2.0 开源'**
  String get license;

  /// No description provided for @desktopWidgetConfigTitle.
  ///
  /// In zh, this message translates to:
  /// **'桌面小组件配置'**
  String get desktopWidgetConfigTitle;

  /// No description provided for @resetPositions.
  ///
  /// In zh, this message translates to:
  /// **'重置位置'**
  String get resetPositions;

  /// No description provided for @usageGuide.
  ///
  /// In zh, this message translates to:
  /// **'使用说明'**
  String get usageGuide;

  /// No description provided for @usageGuideContent.
  ///
  /// In zh, this message translates to:
  /// **'• 切换开关控制小组件的显示隐藏\n• 在桌面小组件界面点击\"编辑布局\"可拖拽调整位置\n• 点击\"重置位置\"恢复默认布局'**
  String get usageGuideContent;

  /// No description provided for @widgetManagement.
  ///
  /// In zh, this message translates to:
  /// **'小组件管理'**
  String get widgetManagement;

  /// No description provided for @positionInfo.
  ///
  /// In zh, this message translates to:
  /// **'位置: ({x}, {y}) • 尺寸: {width}×{height}'**
  String positionInfo(int x, int y, int width, int height);

  /// No description provided for @todayCourses.
  ///
  /// In zh, this message translates to:
  /// **'今日课程'**
  String get todayCourses;

  /// No description provided for @weekSchedule.
  ///
  /// In zh, this message translates to:
  /// **'本周课表'**
  String get weekSchedule;

  /// No description provided for @weekNumber.
  ///
  /// In zh, this message translates to:
  /// **'第 {week} 周'**
  String weekNumber(int week);

  /// No description provided for @dayView.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get dayView;

  /// No description provided for @weekView.
  ///
  /// In zh, this message translates to:
  /// **'周'**
  String get weekView;

  /// No description provided for @noCourseToday.
  ///
  /// In zh, this message translates to:
  /// **'今天没有课程'**
  String get noCourseToday;

  /// No description provided for @enjoyFreeTime.
  ///
  /// In zh, this message translates to:
  /// **'好好享受自由时光吧 ☕'**
  String get enjoyFreeTime;

  /// No description provided for @statusOngoing.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get statusOngoing;

  /// No description provided for @statusUpcoming.
  ///
  /// In zh, this message translates to:
  /// **'即将开始'**
  String get statusUpcoming;

  /// No description provided for @statusEnded.
  ///
  /// In zh, this message translates to:
  /// **'已结束'**
  String get statusEnded;

  /// No description provided for @loadingWeekSchedule.
  ///
  /// In zh, this message translates to:
  /// **'正在加载周课表...'**
  String get loadingWeekSchedule;

  /// No description provided for @copyToOtherTime.
  ///
  /// In zh, this message translates to:
  /// **'复制到其他时间'**
  String get copyToOtherTime;

  /// No description provided for @setReminder.
  ///
  /// In zh, this message translates to:
  /// **'设置提醒'**
  String get setReminder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
