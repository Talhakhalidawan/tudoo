import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

final habitProvider = NotifierProvider<HabitNotifier, List<Habit>>(() {
  return HabitNotifier();
});

class HabitNotifier extends Notifier<List<Habit>> {
  @override
  List<Habit> build() {
    _loadHabits();
    return [];
  }

  static const _key = 'habits';

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      final List<dynamic> list = json.decode(data);
      state = list.map((e) => Habit.fromMap(e)).toList();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(state.map((e) => e.toMap()).toList());
    await prefs.setString(_key, data);
  }

  Future<void> addHabit(Habit habit) async {
    state = [...state, habit];
    await _saveHabits();
  }

  Future<void> deleteHabit(String id) async {
    state = state.where((h) => h.id != id).toList();
    await _saveHabits();
  }
}
