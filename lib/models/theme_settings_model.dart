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

  /// 是否使用系统强调色(Android 12+)
  final bool useSystemColor;

  /// 字体大小缩放比例
  final double fontSizeScale;

  /// 圆角大小缩放比例
  final double borderRadiusScale;

  /// 组件透明度
  final double componentOpacity;

  /// 卡片阴影强度
  final double shadowStrength;

  /// 是否启用渐变效果
  final bool enableGradients;

  const ThemeSettings({
    required this.seedColor,
    required this.themeMode,
    required this.useDynamicColor,
    required this.useSystemColor,
    this.fontSizeScale = 1.0,
    this.borderRadiusScale = 1.0,
    this.componentOpacity = 1.0,
    this.shadowStrength = 1.0,
    this.enableGradients = true,
  });

  /// 默认主题设置
  /// 使用 Material 3 默认的紫色作为种子颜色
  factory ThemeSettings.defaultSettings() {
    return const ThemeSettings(
      seedColor: Color(0xFF6750A4), // Material 3 default purple
      themeMode: ThemeMode.system,
      useDynamicColor: true,
      useSystemColor: false,
      fontSizeScale: 1.0,
      borderRadiusScale: 1.0,
      componentOpacity: 1.0,
      shadowStrength: 1.0,
      enableGradients: true,
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
      fontSizeScale: (json['fontSizeScale'] as num? ?? 1.0).toDouble(),
      borderRadiusScale: (json['borderRadiusScale'] as num? ?? 1.0).toDouble(),
      componentOpacity: (json['componentOpacity'] as num? ?? 1.0).toDouble(),
      shadowStrength: (json['shadowStrength'] as num? ?? 1.0).toDouble(),
      enableGradients: json['enableGradients'] as bool? ?? true,
    );
  }

  /// 序列化为 JSON
  Map<String, dynamic> toJson() {
    return {
      'seedColor': seedColor.toARGB32(),
      'themeMode': themeMode.toString(),
      'useDynamicColor': useDynamicColor,
      'useSystemColor': useSystemColor,
      'fontSizeScale': fontSizeScale,
      'borderRadiusScale': borderRadiusScale,
      'componentOpacity': componentOpacity,
      'shadowStrength': shadowStrength,
      'enableGradients': enableGradients,
    };
  }

  /// 复制并修改部分字段
  ThemeSettings copyWith({
    Color? seedColor,
    ThemeMode? themeMode,
    bool? useDynamicColor,
    bool? useSystemColor,
    double? fontSizeScale,
    double? borderRadiusScale,
    double? componentOpacity,
    double? shadowStrength,
    bool? enableGradients,
  }) {
    return ThemeSettings(
      seedColor: seedColor ?? this.seedColor,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      useSystemColor: useSystemColor ?? this.useSystemColor,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      borderRadiusScale: borderRadiusScale ?? this.borderRadiusScale,
      componentOpacity: componentOpacity ?? this.componentOpacity,
      shadowStrength: shadowStrength ?? this.shadowStrength,
      enableGradients: enableGradients ?? this.enableGradients,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeSettings &&
        other.seedColor.toARGB32() == seedColor.toARGB32() &&
        other.themeMode == themeMode &&
        other.useDynamicColor == useDynamicColor &&
        other.useSystemColor == useSystemColor &&
        other.fontSizeScale == fontSizeScale &&
        other.borderRadiusScale == borderRadiusScale &&
        other.componentOpacity == componentOpacity &&
        other.shadowStrength == shadowStrength &&
        other.enableGradients == enableGradients;
  }

  @override
  int get hashCode {
    return Object.hash(
      seedColor.toARGB32(),
      themeMode,
      useDynamicColor,
      useSystemColor,
      fontSizeScale,
      borderRadiusScale,
      componentOpacity,
      shadowStrength,
      enableGradients,
    );
  }

  @override
  String toString() {
    return 'ThemeSettings(seedColor: ${seedColor.toARGB32().toRadixString(16)}, ' 
        'themeMode: $themeMode, useDynamicColor: $useDynamicColor, ' 
        'useSystemColor: $useSystemColor, fontSizeScale: $fontSizeScale, ' 
        'borderRadiusScale: $borderRadiusScale, componentOpacity: $componentOpacity, ' 
        'shadowStrength: $shadowStrength, enableGradients: $enableGradients)';
  }
}
