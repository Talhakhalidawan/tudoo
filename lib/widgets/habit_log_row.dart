import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/habit.dart';

class HabitLogRow extends StatelessWidget {
  final Habit habit;
  final List<DailyLog> logs;

  const HabitLogRow({super.key, required this.habit, required this.logs});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, // Showing past 30 days
        itemBuilder: (context, index) {
          // Index 0 represents today, appearing on the left side
          final date = now.subtract(Duration(days: index));
          final log = _getLogForDate(date);
          final color = _getCellColor(log);

          return Container(
            width: 32,
            height: 48,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: index == 0
                    ? Colors.white30
                    : Colors.transparent, // Highlight today
                width: 1.5,
              ),
            ),
            child: _buildScoreText(log),
          );
        },
      ),
    );
  }

  DailyLog? _getLogForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    try {
      return logs.firstWhere((l) => l.date.isAtSameMomentAs(normalized));
    } catch (_) {
      return null;
    }
  }

  Color _getCellColor(DailyLog? log) {
    if (log == null || !log.isCompleted) return Colors.white.withOpacity(0.05);
    return habit.color;
  }

  Widget? _buildScoreText(DailyLog? log) {
    return null;
  }
}
