import 'dart:convert';

class DailyLog {
  final String habitId;
  final DateTime date;
  final bool isCompleted;
  final int value;
  final String note;
  final String mood; // Great, Good, Okay, Bad, Terrible, None

  DailyLog({
    required this.habitId,
    required DateTime date,
    this.isCompleted = false,
    this.value = 0,
    this.note = '',
    this.mood = 'None',
  }) : date = DateTime(date.year, date.month, date.day);

  DailyLog copyWith({
    bool? isCompleted,
    int? value,
    String? note,
    String? mood,
  }) {
    return DailyLog(
      habitId: habitId,
      date: date,
      isCompleted: isCompleted ?? this.isCompleted,
      value: value ?? this.value,
      note: note ?? this.note,
      mood: mood ?? this.mood,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'date': date.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'value': value,
      'note': note,
      'mood': mood,
    };
  }

  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      habitId: map['habitId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      isCompleted: map['isCompleted'] ?? false,
      value: map['value'] ?? 0,
      note: map['note'] ?? '',
      mood: map['mood'] ?? 'None',
    );
  }

  String toJson() => json.encode(toMap());
  factory DailyLog.fromJson(String source) =>
      DailyLog.fromMap(json.decode(source));
}
