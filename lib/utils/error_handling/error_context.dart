import 'dart:io';
import 'package:flutter/foundation.dart';

/// 错误上下文收集器
class ErrorContext {
  /// 收集系统信息
  static Map<String, dynamic> collectSystemInfo() {
    return {
      'platform': Platform.operatingSystem,
      'platformVersion': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'numberOfProcessors': Platform.numberOfProcessors,
      'isDebugMode': kDebugMode,
      'isProfileMode': kProfileMode,
      'isReleaseMode': kReleaseMode,
    };
  }

  /// 收集应用状态
  static Map<String, dynamic> collectAppState({
    String? currentScreen,
    String? lastAction,
    Map<String, dynamic>? additionalState,
  }) {
    return {
      if (currentScreen != null) 'currentScreen': currentScreen,
      if (lastAction != null) 'lastAction': lastAction,
      'timestamp': DateTime.now().toIso8601String(),
      ...?additionalState,
    };
  }

  /// 收集网络错误上下文
  static Map<String, dynamic> collectNetworkContext({
    required String url,
    required String method,
    Map<String, String>? headers,
    int? statusCode,
    String? responseBody,
  }) {
    return {
      'url': url,
      'method': method,
      if (headers != null) 'headers': headers,
      if (statusCode != null) 'statusCode': statusCode,
      if (responseBody != null) 'responseBody': responseBody,
    };
  }

  /// 收集存储错误上下文
  static Map<String, dynamic> collectStorageContext({
    required String path,
    required String operation,
    int? fileSize,
    bool? fileExists,
  }) {
    return {
      'path': path,
      'operation': operation,
      if (fileSize != null) 'fileSize': fileSize,
      if (fileExists != null) 'fileExists': fileExists,
      'availableSpace': _getAvailableSpace(),
    };
  }

  /// 收集验证错误上下文
  static Map<String, dynamic> collectValidationContext({
    required String fieldName,
    required dynamic value,
    required String rule,
  }) {
    return {
      'fieldName': fieldName,
      'value': value?.toString() ?? 'null',
      'rule': rule,
    };
  }

  /// 获取可用存储空间（简化版）
  static String _getAvailableSpace() {
    try {
      // 这里可以实现更复杂的存储空间检查
      return 'unknown';
    } catch (e) {
      return 'error';
    }
  }

  /// 合并多个上下文
  static Map<String, dynamic> merge(List<Map<String, dynamic>> contexts) {
    final merged = <String, dynamic>{};
    for (final context in contexts) {
      merged.addAll(context);
    }
    return merged;
  }
}
