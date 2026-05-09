import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_log.dart';

final logProvider = NotifierProvider<LogNotifier, List<DailyLog>>(() {
  return LogNotifier();
});

class LogNotifier extends Notifier<List<DailyLog>> {
  @override
  List<DailyLog> build() {
    _loadLogs();
    return [];
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

  Future<void> saveLog(DailyLog log) async {
    final normalizedDate = DateTime(
      log.date.year,
      log.date.month,
      log.date.day,
    );

    final newState = state
        .where(
          (l) =>
              !(l.habitId == log.habitId &&
                  l.date.isAtSameMomentAs(normalizedDate)),
        )
        .toList();

    newState.add(log);
    state = newState;
    await _saveLogs();
  }

  DailyLog? getLogForDate(String habitId, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      return state.firstWhere(
        (l) => l.habitId == habitId && l.date.isAtSameMomentAs(normalizedDate),
      );
    } catch (_) {
      return null;
    }
  }

  List<DailyLog> getLogsForHabit(String habitId) {
    return state.where((l) => l.habitId == habitId).toList();
  }
}
