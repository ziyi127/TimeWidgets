import 'package:flutter/material.dart';

class CountdownData {
  CountdownData({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.type,
    required this.progress,
    this.category,
    this.color,
  });

  // 从JSON解析
  factory CountdownData.fromJson(Map<String, dynamic> json) {
    return CountdownData(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetDate: DateTime.parse(
        json['targetDate'] as String? ?? DateTime.now().toIso8601String(),
      ),
      type: json['type'] as String? ?? 'event',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String?,
      color: json['color'] != null ? Color(json['color'] as int) : null,
    );
  }
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final String type;
  final double progress;
  final String? category;
  final Color? color;

  // 计算剩余天数
  int get remainingDays {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    return difference.inDays;
  }

  // 计算剩余小时数（不包括天数）
  int get remainingHours {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    return difference.inHours % 24;
  }

  // 计算剩余分钟数（不包括小时）
  int get remainingMinutes {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    return difference.inMinutes % 60;
  }

  // 是否即将到期（7天内）
  bool get isApproaching {
    return remainingDays <= 7 && remainingDays >= 0;
  }

  // 是否已经过期
  bool get isExpired {
    return remainingDays < 0;
  }

  // 获取类型标签
  String get typeLabel {
    switch (type.toLowerCase()) {
      case 'exam':
        return '考试';
      case 'deadline':
        return '截止';
      case 'event':
        return '事件';
      case 'task':
        return '任务';
      default:
        return type;
    }
  }

  // 获取类型颜色
  Color get typeColor {
    if (color != null) return color!;

    switch (type.toLowerCase()) {
      case 'exam':
        return const Color(0xFFF44336); // 红色
      case 'deadline':
        return const Color(0xFFFF9800); // 橙色
      case 'event':
        return const Color(0xFF4CAF50); // 绿色
      case 'task':
        return const Color(0xFF2196F3); // 蓝色
      default:
        return const Color(0xFF9E9E9E); // 灰色
    }
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.toIso8601String(),
      'type': type,
      'progress': progress,
      'category': category,
      'color': color?.toARGB32,
    };
  }

  // 复制方法
  CountdownData copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
    String? type,
    double? progress,
    String? category,
    Color? color,
  }) {
    return CountdownData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      type: type ?? this.type,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'CountdownData(id: $id, title: $title, targetDate: $targetDate, type: $type, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountdownData &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.targetDate == targetDate &&
        other.type == type &&
        other.progress == progress &&
        other.category == category &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        targetDate.hashCode ^
        type.hashCode ^
        progress.hashCode ^
        category.hashCode ^
        color.hashCode;
  }
}
