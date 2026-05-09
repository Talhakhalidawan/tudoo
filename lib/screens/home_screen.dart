import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../providers/log_provider.dart';
import '../providers/streak_provider.dart';
import '../models/daily_log.dart';
import 'habit_detail_screen.dart';
import '../theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final totalStreak = ref.watch(totalCurrentStreakProvider);
    final themeColor = Theme.of(context).primaryColor;

    // Calculate week progress
    int totalWeekLogs = 0;
    int completedWeekLogs = 0;
    final now = DateTime.now();

    for (var habit in habits) {
      final logs = ref.read(logProvider.notifier).getLogsForHabit(habit.id);
      for (int i = 0; i < 7; i++) {
        totalWeekLogs++;
        final d = now.subtract(Duration(days: i));
        final normalized = DateTime(d.year, d.month, d.day);
        final log = logs
            .where((l) => l.date.isAtSameMomentAs(normalized))
            .firstOrNull;
        if (log != null && log.isCompleted) completedWeekLogs++;
      }
    }

    final progressVal = totalWeekLogs > 0
        ? (completedWeekLogs / totalWeekLogs)
        : 0.0;
    final progressPercent = (progressVal * 100).toInt();

    // Heatmap Logic: Last 105 days
    final List<double> heatmapData = [];
    final startDay = now.subtract(const Duration(days: 104));
    for (int i = 0; i < 105; i++) {
      final d = startDay.add(Duration(days: i));
      final normalized = DateTime(d.year, d.month, d.day);

      int totalForDay = habits.length;
      int completedForDay = 0;

      for (var habit in habits) {
        final logs = ref.read(logProvider.notifier).getLogsForHabit(habit.id);
        final log = logs
            .where((l) => l.date.isAtSameMomentAs(normalized))
            .firstOrNull;
        if (log != null && log.isCompleted) completedForDay++;
      }

      heatmapData.add(totalForDay > 0 ? completedForDay / totalForDay : 0.0);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        60,
        20,
        120,
      ), // Top padding for status bar, bottom for nav
      children: [
        // Header Top
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good evening,',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Abdullah',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('👋', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('🔥 ', style: TextStyle(fontSize: 16)),
                  Text(
                    '$totalStreak ',
                    style: const TextStyle(
                      color: Color(0xFFFF9500),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Day Streak',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // This Week Progress Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'This Week Progress',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Completed ',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$completedWeekLogs / $totalWeekLogs',
                        style: const TextStyle(
                          color: AppTheme.textMain,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressVal,
                  minHeight: 8,
                  backgroundColor: AppTheme.borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Heatmap Component
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(now),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Sort',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map(
                (day) => Flexible(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 105,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 15,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final completion = heatmapData[index];
            Color boxColor = AppTheme.borderColor;
            if (completion > 0.8) {
              boxColor = themeColor;
            } else if (completion > 0.4) {
              boxColor = themeColor.withOpacity(0.6);
            } else if (completion > 0.1) {
              boxColor = themeColor.withOpacity(0.2);
            }

            return Container(
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        // Your Habits section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: themeColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (habits.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Tap + to create a new habit.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
          )
        else
          ...habits.map((habit) {
            final streakData = ref.watch(streakProvider(habit));
            final log = ref
                .read(logProvider.notifier)
                .getLogForDate(habit.id, DateTime.now());
            final isCompletedToday = log?.isCompleted ?? false;

            IconData hIcon = Icons.book;
            if (habit.icon == 'workout') hIcon = Icons.directions_run_rounded;
            if (habit.icon == 'water') hIcon = Icons.water_drop_rounded;
            if (habit.icon == 'meditate') hIcon = Icons.spa_rounded;
            if (habit.icon == 'study') hIcon = Icons.school_rounded;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitDetailScreen(habit: habit),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.bgInput,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(hIcon, color: habit.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${streakData.currentStreak} day streak',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (log != null) {
                          ref
                              .read(logProvider.notifier)
                              .saveLog(
                                log.copyWith(isCompleted: !log.isCompleted),
                              );
                        } else {
                          ref
                              .read(logProvider.notifier)
                              .saveLog(
                                DailyLog(
                                  habitId: habit.id,
                                  date: DateTime.now(),
                                  isCompleted: true,
                                ),
                              );
                        }
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompletedToday
                              ? themeColor
                              : Colors.transparent,
                          border: Border.all(
                            color: isCompletedToday
                                ? themeColor
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                        ),
                        child: isCompletedToday
                            ? const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 14,
                                weight: 900,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
