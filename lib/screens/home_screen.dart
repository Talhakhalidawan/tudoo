import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/habit_provider.dart';
import '../providers/log_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/habit_log_row.dart';
import '../widgets/log_input_sheet.dart';
import '../models/daily_log.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final totalStreak = ref.watch(totalCurrentStreakProvider);

    // Calculate week progress
    int totalWeekLogs = 0;
    int completedWeekLogs = 0;

    // Very simple past 7 days calculation across all habits
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good evening,',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Talha',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('👋', style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$totalStreak',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            Text(
                              'Day Streak',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Progress Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This Week Progress',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$progressPercent%',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedWeekLogs / $totalWeekLogs',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressVal,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Your Habits List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Habits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(color: Colors.greenAccent.shade400),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (habits.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Tap + to create a new habit.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                ...habits.map((habit) {
                  final streakData = ref.watch(streakProvider(habit));
                  final isCompletedToday =
                      ref
                          .read(logProvider.notifier)
                          .getLogForDate(habit.id, DateTime.now())
                          ?.isCompleted ??
                      false;

                  // Get correct icon if mapped
                  IconData hIcon = Icons.book;
                  if (habit.icon == 'workout')
                    hIcon = Icons.directions_run_rounded;
                  if (habit.icon == 'water') hIcon = Icons.water_drop_rounded;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: habit.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(hIcon, color: habit.color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${streakData.currentStreak} day streak',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Toggle completion
                            final log = ref
                                .read(logProvider.notifier)
                                .getLogForDate(habit.id, DateTime.now());
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
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompletedToday
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                              border: Border.all(
                                color: isCompletedToday
                                    ? Colors.greenAccent
                                    : Colors.grey.shade700,
                                width: 2,
                              ),
                            ),
                            child: isCompletedToday
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 80), // Fab space
            ],
          ),
        ),
      ),
    );
  }
}
