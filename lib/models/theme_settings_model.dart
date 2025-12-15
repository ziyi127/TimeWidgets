import 'package:flutter/material.dart';

/// 主题设置模型
/// 用于存储和管理应用的主题配置，包括种子颜色、主题模式等
class ThemeSettings {
  /// 种子颜色 - 用于生成 Material You 动态配色方案
  final Color seedColor;

  /// 主题模式 - light, dark, system
  final ThemeMode themeMode;

  /// 是否启用动态颜色
  final bool useDynamicColor;

  /// 是否使用系统强调色 (Android 12+)
  final bool useSystemColor;

  const ThemeSettings({
    required this.seedColor,
    required this.themeMode,
    required this.useDynamicColor,
    required this.useSystemColor,
  });

  /// 默认主题设置
  /// 使用 Material 3 默认的紫色作为种子颜色
  factory ThemeSettings.defaultSettings() {
    return const ThemeSettings(
      seedColor: Color(0xFF6750A4), // Material 3 default purple
      themeMode: ThemeMode.system,
      useDynamicColor: true,
      useSystemColor: false,
    );
  }

  /// 从 JSON 反序列化
  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      seedColor: Color(json['seedColor'] as int),
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.toString() == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      useDynamicColor: json['useDynamicColor'] as bool? ?? true,
      useSystemColor: json['useSystemColor'] as bool? ?? false,
    );
  }

  /// 序列化为 JSON
  Map<String, dynamic> toJson() {
    return {
      'seedColor': seedColor.toARGB32(),
      'themeMode': themeMode.toString(),
      'useDynamicColor': useDynamicColor,
      'useSystemColor': useSystemColor,
    };
  }

  /// 复制并修改部分字段
  ThemeSettings copyWith({
    Color? seedColor,
    ThemeMode? themeMode,
    bool? useDynamicColor,
    bool? useSystemColor,
  }) {
    return ThemeSettings(
      seedColor: seedColor ?? this.seedColor,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      useSystemColor: useSystemColor ?? this.useSystemColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeSettings &&
        other.seedColor.toARGB32() == seedColor.toARGB32() &&
        other.themeMode == themeMode &&
        other.useDynamicColor == useDynamicColor &&
        other.useSystemColor == useSystemColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      seedColor.toARGB32(),
      themeMode,
      useDynamicColor,
      useSystemColor,
    );
  }

  @override
  String toString() {
    return 'ThemeSettings(seedColor: ${seedColor.toARGB32().toRadixString(16)}, '
        'themeMode: $themeMode, useDynamicColor: $useDynamicColor, '
        'useSystemColor: $useSystemColor)';
  }
}
