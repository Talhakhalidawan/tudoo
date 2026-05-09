import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../models/daily_log.dart';
import 'log_provider.dart';
import 'habit_provider.dart';

class StreakData {
  final int currentStreak;
  final int bestStreak;

  StreakData({required this.currentStreak, required this.bestStreak});
}

final streakProvider = Provider.family<StreakData, Habit>((ref, habit) {
  final logs = ref
      .watch(logProvider)
      .where((l) => l.habitId == habit.id && l.isCompleted)
      .toList();
  logs.sort((a, b) => b.date.compareTo(a.date)); // Newest first

  if (logs.isEmpty) {
    return StreakData(currentStreak: 0, bestStreak: 0);
  }

  int currentStreak = 0;
  int bestStreak = 0;
  int tempStreak = 0;
  DateTime? lastDate;

  // Let's sort oldest first for best streak logic
  final sortedLogs = List<DailyLog>.from(logs)
    ..sort((a, b) => a.date.compareTo(b.date));

  for (final log in sortedLogs) {
    if (lastDate == null) {
      tempStreak = 1;
    } else {
      final difference = log.date.difference(lastDate).inDays;
      if (difference == 1) {
        tempStreak++;
      } else if (difference > 1) {
        tempStreak = 1;
      }
    }
    if (tempStreak > bestStreak) {
      bestStreak = tempStreak;
    }
    lastDate = log.date;
  }

  // Calculate current streak backward from today or yesterday
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);
  final normalizedYesterday = normalizedToday.subtract(const Duration(days: 1));

  if (logs.isNotEmpty) {
    final mostRecentLogDate = logs.first.date;
    if (mostRecentLogDate.isAtSameMomentAs(normalizedToday) ||
        mostRecentLogDate.isAtSameMomentAs(normalizedYesterday)) {
      currentStreak = 1;
      var currentDateToCheck = mostRecentLogDate;

      for (int i = 1; i < logs.length; i++) {
        final previousDate = logs[i].date;
        if (currentDateToCheck.difference(previousDate).inDays == 1) {
          currentStreak++;
          currentDateToCheck = previousDate;
        } else {
          break;
        }
      }
    }
  }

  return StreakData(currentStreak: currentStreak, bestStreak: bestStreak);
});

final totalCurrentStreakProvider = Provider<int>((ref) {
  final habits = ref.watch(habitProvider);
  if (habits.isEmpty) return 0;

  // A simplistic summary: Max of all current streaks, or sum? The design shows a global "Day Streak".
  // Let's sum the current streaks, or it might be the length of days since the user started logging sequentially across ANY habit.
  // We'll just define it as the highest streak of any habit.
  int maxStreak = 0;
  for (var habit in habits) {
    final streak = ref.watch(streakProvider(habit)).currentStreak;
    if (streak > maxStreak) maxStreak = streak;
  }
  return maxStreak;
});
