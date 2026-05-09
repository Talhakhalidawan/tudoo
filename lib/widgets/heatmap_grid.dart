import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/habit.dart';

class HeatmapGrid extends StatelessWidget {
  final Habit habit;
  final List<DailyLog> logs;

  const HeatmapGrid({super.key, required this.habit, required this.logs});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(
      const Duration(days: 90),
    ); // Show 90 days for compactness

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: 13, // ~13 weeks
        itemBuilder: (context, weekIndex) {
          return Column(
            children: List.generate(7, (dayIndex) {
              final date = now.subtract(
                Duration(days: (weekIndex * 7) + (6 - dayIndex)),
              );
              if (date.isAfter(now))
                return const SizedBox(width: 12, height: 12);

              final log = _getLogForDate(date);
              final color = _getCellColor(log);

              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
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
    if (log == null) return Colors.white.withOpacity(0.05);

    if (log.score > 0) {
      final intensity = log.score / 5.0;
      return habit.positiveColor.withOpacity(0.2 + (0.8 * intensity));
    } else {
      final intensity = log.score.abs() / 5.0;
      return habit.negativeColor.withOpacity(0.2 + (0.8 * intensity));
    }
  }
}
