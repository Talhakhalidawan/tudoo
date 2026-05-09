import 'dart:convert';

class DailyLog {
  final String habitId;
  final DateTime date;
  final int score;

  DailyLog({
    required this.habitId,
    required DateTime date,
    required this.score,
  }) : date = DateTime(date.year, date.month, date.day);

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'date': date.millisecondsSinceEpoch,
      'score': score,
    };
  }

  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      habitId: map['habitId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      score: map['score'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyLog.fromJson(String source) => DailyLog.fromMap(json.decode(source));
}
