import 'package:flutter/material.dart';
import 'package:glados/glados.dart';
import 'package:time_widgets/services/localization_service.dart';

void main() {
  group('Localization Property Tests', () {
    // **Feature: project-enhancement, Property 17: Chinese UI Text Display**
    // **Validates: Requirements 11.1**
    test('all UI text keys return Chinese strings', () {
      final allKeys = LocalizationService.getAllKeys();
      
      for (final key in allKeys) {
        final text = LocalizationService.getString(key);
        
        // 验证返回的文本不为空
        expect(text.isNotEmpty, isTrue, reason: 'Key "$key" returned empty text');
        
        // 验证返回的文本包含中文字符或是合理的英文（如单位、格式等）
        final isChineseOrValid = LocalizationService.isChineseText(text) || 
                                _isValidNonChineseText(text);
        expect(isChineseOrValid, isTrue, 
               reason: 'Key "$key" returned text "$text" that is not Chinese or valid non-Chinese');
      }
    });

    Glados<String>(any.choose(LocalizationService.getAllKeys())).test(
      'getString with valid keys always returns non-empty strings',
      (key) {
        final result = LocalizationService.getString(key);
        expect(result.isNotEmpty, isTrue);
        expect(result, isNot(equals(key))); // 应该返回实际的文本，而不是键本身
      },
    );

    test('getString with invalid key returns the key itself', () {
      const invalidKey = 'non_existent_key_12345';
      final result = LocalizationService.getString(invalidKey);
      expect(result, equals(invalidKey));
    });

    test('getString with parameters replaces placeholders correctly', () {
      // 测试周次格式化
      final weekText = LocalizationService.getString('week_format', params: {'week': 5});
      expect(weekText, equals('第5周'));
      
      // 测试倒计时格式化
      final daysText = LocalizationService.getString('days_remaining', params: {'days': 10});
      expect(daysText, equals('剩余10天'));
      
      final hoursText = LocalizationService.getString('hours_remaining', params: {'hours': 3});
      expect(hoursText, equals('剩余3小时'));
    });

    Glados2<String, int>(
      any.choose(['week_format', 'days_remaining', 'hours_remaining', 'minutes_remaining']),
      any.intInRange(1, 100)
    ).test(
      'parameter replacement works for any valid number',
      (key, number) {
        final paramKey = key == 'week_format' ? 'week' : 
                        key == 'days_remaining' ? 'days' :
                        key == 'hours_remaining' ? 'hours' : 'minutes';
        
        final result = LocalizationService.getString(key, params: {paramKey: number});
        
        // 验证结果包含数字
        expect(result.contains(number.toString()), isTrue);
        // 验证结果不包含占位符
        expect(result.contains('{$paramKey}'), isFalse);
      },
    );

    // **Feature: project-enhancement, Property 18: Chinese Error Messages**
    // **Validates: Requirements 11.2**
    test('all error messages are in Chinese', () {
      final errorKeys = LocalizationService.getAllKeys()
          .where((key) => key.contains('error') || key.contains('warning'))
          .toList();
      
      for (final key in errorKeys) {
        final errorMessage = LocalizationService.getString(key);
        
        // 验证错误消息不为空
        expect(errorMessage.isNotEmpty, isTrue);
        
        // 验证错误消息是中文
        expect(LocalizationService.isChineseText(errorMessage), isTrue,
               reason: 'Error message for key "$key" is not in Chinese: "$errorMessage"');
      }
    });

    test('getErrorMessage formats error with context correctly', () {
      const errorCode = 'network_error';
      const context = '连接超时';
      
      final message = LocalizationService.getErrorMessage(errorCode, context: context);
      
      expect(message.contains('网络连接失败'), isTrue);
      expect(message.contains(context), isTrue);
    });

    // **Feature: project-enhancement, Property 19: Chinese Date Time Formatting**
    // **Validates: Requirements 11.3**
    test('date formatting follows Chinese conventions', () {
      final testDate = DateTime(2024, 3, 15, 14, 30);
      
      // 测试长日期格式
      final longDate = LocalizationService.formatDate(testDate, format: 'long');
      expect(longDate, equals('2024年3月15日'));
      
      // 测试短日期格式
      final shortDate = LocalizationService.formatDate(testDate, format: 'short');
      expect(shortDate, equals('03-15'));
      
      // 测试日期时间格式
      final datetime = LocalizationService.formatDate(testDate, format: 'datetime');
      expect(datetime, equals('2024年3月15日 14:30'));
    });

    Glados<int>(any.intInRange(2020, 2030)).test(
      'date formatting works for any valid year',
      (year) {
        final testDate = DateTime(year, 6, 15);
        final formatted = LocalizationService.formatDate(testDate, format: 'long');
        
        // 验证包含年份
        expect(formatted.contains('${year}年'), isTrue);
        // 验证包含月份
        expect(formatted.contains('6月'), isTrue);
        // 验证包含日期
        expect(formatted.contains('15日'), isTrue);
      },
    );

    test('time formatting follows Chinese conventions', () {
      final testTime = DateTime(2024, 3, 15, 14, 30);
      
      // 测试24小时制
      final time24 = LocalizationService.formatTime(testTime, use24Hour: true);
      expect(time24, equals('14:30'));
      
      // 测试12小时制
      final time12 = LocalizationService.formatTime(testTime, use24Hour: false);
      expect(time12.contains('14:30') || time12.contains('2:30'), isTrue);
    });

    test('Chinese weekday formatting is correct', () {
      // 测试一周的每一天
      final monday = DateTime(2024, 3, 11); // 2024年3月11日是星期一
      
      for (int i = 0; i < 7; i++) {
        final date = monday.add(Duration(days: i));
        final weekday = LocalizationService.getChineseWeekday(date);
        
        expect(weekday.startsWith('星期'), isTrue);
        expect(weekday.length, equals(3)); // "星期X" 应该是3个字符
      }
    });

    test('week formatting is correct', () {
      for (int week = 1; week <= 20; week++) {
        final formatted = LocalizationService.formatWeek(week);
        expect(formatted, equals('第${week}周'));
      }
    });

    // **Feature: project-enhancement, Property 20: Chinese Dialog Content**
    // **Validates: Requirements 11.5**
    test('all dialog-related strings are in Chinese', () {
      final dialogKeys = LocalizationService.getAllKeys()
          .where((key) => key.startsWith('dialog_'))
          .toList();
      
      for (final key in dialogKeys) {
        final dialogText = LocalizationService.getString(key);
        
        // 验证对话框文本不为空
        expect(dialogText.isNotEmpty, isTrue);
        
        // 验证对话框文本是中文
        expect(LocalizationService.isChineseText(dialogText), isTrue,
               reason: 'Dialog text for key "$key" is not in Chinese: "$dialogText"');
      }
    });

    test('countdown formatting works correctly', () {
      final now = DateTime(2024, 3, 15, 12, 0);
      
      // 测试天数倒计时
      final futureDate1 = now.add(const Duration(days: 5));
      final countdown1 = LocalizationService.formatCountdown(futureDate1, currentDate: now);
      expect(countdown1, equals('剩余5天'));
      
      // 测试小时倒计时
      final futureDate2 = now.add(const Duration(hours: 3));
      final countdown2 = LocalizationService.formatCountdown(futureDate2, currentDate: now);
      expect(countdown2, equals('剩余3小时'));
      
      // 测试分钟倒计时
      final futureDate3 = now.add(const Duration(minutes: 30));
      final countdown3 = LocalizationService.formatCountdown(futureDate3, currentDate: now);
      expect(countdown3, equals('剩余30分钟'));
      
      // 测试过期事件
      final pastDate = now.subtract(const Duration(days: 1));
      final countdownPast = LocalizationService.formatCountdown(pastDate, currentDate: now);
      expect(countdownPast, equals('事件已过期'));
    });

    test('Chinese text detection works correctly', () {
      // 测试中文文本
      expect(LocalizationService.isChineseText('你好世界'), isTrue);
      expect(LocalizationService.isChineseText('Hello 世界'), isTrue);
      expect(LocalizationService.isChineseText('设置'), isTrue);
      
      // 测试非中文文本
      expect(LocalizationService.isChineseText('Hello World'), isFalse);
      expect(LocalizationService.isChineseText('123456'), isFalse);
      expect(LocalizationService.isChineseText('°C'), isFalse);
    });

    test('key existence check works correctly', () {
      // 测试存在的键
      expect(LocalizationService.hasKey('app_title'), isTrue);
      expect(LocalizationService.hasKey('settings'), isTrue);
      
      // 测试不存在的键
      expect(LocalizationService.hasKey('non_existent_key'), isFalse);
      expect(LocalizationService.hasKey(''), isFalse);
    });
  });
}

/// 检查是否为有效的非中文文本（如单位、格式字符串等）
bool _isValidNonChineseText(String text) {
  // 允许的非中文文本模式
  final validPatterns = [
    RegExp(r'^[°%CF]+$'), // 单位符号如 °C, °F, %
    RegExp(r'^[A-Za-z]{1,5}$'), // 短英文缩写如 API, URL
    RegExp(r'^[HMSahm:]+$'), // 时间格式如 HH:mm, ah:mm
    RegExp(r'^[yMdEH:年月日周星期\s-]+$'), // 日期格式
    RegExp(r'^\{[a-zA-Z_]+\}$'), // 占位符如 {week}
    RegExp(r'^[0-9\s]+$'), // 纯数字
    RegExp(r'^[km/h]+$'), // 速度单位如 km/h
  ];
  
  return validPatterns.any((pattern) => pattern.hasMatch(text));
}