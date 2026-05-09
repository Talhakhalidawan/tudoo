import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';

final logProvider = StateNotifierProvider<LogNotifier, List<DailyLog>>((ref) {
  return LogNotifier();
});

class LogNotifier extends StateNotifier<List<DailyLog>> {
  LogNotifier() : super([]) {
    _loadLogs();
  }

  static const _key = 'daily_logs';

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      final List<dynamic> list = json.decode(data);
      state = list.map((e) => DailyLog.fromMap(e)).toList();
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(state.map((e) => e.toMap()).toList());
    await prefs.setString(_key, data);
  }

  Future<void> logScore(String habitId, DateTime date, int score) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Remove existing log for same habit and date
    final newState = state
        .where(
          (l) =>
              !(l.habitId == habitId &&
                  l.date.isAtSameMomentAs(normalizedDate)),
        )
        .toList();

    newState.add(
      DailyLog(habitId: habitId, date: normalizedDate, score: score),
    );
    state = newState;
    await _saveLogs();
  }

  List<DailyLog> getLogsForHabit(String habitId) {
    return state.where((l) => l.habitId == habitId).toList();
  }
}
