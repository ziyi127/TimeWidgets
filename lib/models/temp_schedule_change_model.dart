/// 临时调课类型
enum TempChangeType {
  day,    // 按天调课
  period, // 按节调课
}

/// 临时调课记录
class TempScheduleChange {  // 备注

  const TempScheduleChange({
    required this.id,
    required this.type,
    required this.date,
    this.timeSlotId,
    this.originalCourseId,
    this.newCourseId,
    this.originalScheduleId,
    this.newScheduleId,
    required this.createdAt,
    this.note,
  });

  factory TempScheduleChange.fromJson(Map<String, dynamic> json) {
    return TempScheduleChange(
      id: json['id'] as String,
      type: TempChangeType.values[json['type'] as int],
      date: DateTime.parse(json['date'] as String),
      timeSlotId: json['timeSlotId'] as String?,
      originalCourseId: json['originalCourseId'] as String?,
      newCourseId: json['newCourseId'] as String?,
      originalScheduleId: json['originalScheduleId'] as String?,
      newScheduleId: json['newScheduleId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );
  }
  final String id;
  final TempChangeType type;
  final DateTime date;  // 生效日期
  final String? timeSlotId;  // 节次ID (按节调课时使用)
  final String? originalCourseId;  // 原课程ID (按节调课时使用)
  final String? newCourseId;  // 新课程ID (按节调课时使用)
  final String? originalScheduleId;  // 原课表ID (按天调课时使用)
  final String? newScheduleId;  // 新课表ID (按天调课时使用)
  final DateTime createdAt;  // 创建时间
  final String? note;

  TempScheduleChange copyWith({
    String? id,
    TempChangeType? type,
    DateTime? date,
    String? timeSlotId,
    String? originalCourseId,
    String? newCourseId,
    String? originalScheduleId,
    String? newScheduleId,
    DateTime? createdAt,
    String? note,
  }) {
    return TempScheduleChange(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      originalCourseId: originalCourseId ?? this.originalCourseId,
      newCourseId: newCourseId ?? this.newCourseId,
      originalScheduleId: originalScheduleId ?? this.originalScheduleId,
      newScheduleId: newScheduleId ?? this.newScheduleId,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'date': date.toIso8601String(),
      'timeSlotId': timeSlotId,
      'originalCourseId': originalCourseId,
      'newCourseId': newCourseId,
      'originalScheduleId': originalScheduleId,
      'newScheduleId': newScheduleId,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }
}
