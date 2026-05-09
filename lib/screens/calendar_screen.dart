import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../providers/log_provider.dart';
import '../models/daily_log.dart';
import '../theme.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final allLogs = ref.watch(logProvider);
    final themeColor = Theme.of(context).primaryColor;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
      children: [
        const Center(
          child: Text(
            'Calendar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppTheme.textMuted),
              onPressed: () => setState(
                () => _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                ),
              ),
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onPressed: () => setState(
                () => _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map(
                (d) => Flexible(
                  child: Center(
                    child: Text(
                      d,
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
        const SizedBox(height: 12),

        _buildCalendarGrid(allLogs, themeColor),
        const SizedBox(height: 32),

        Text(
          DateFormat('MMMM d, yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: habits.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No habits recorded.',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    ),
                  ]
                : habits.map((habit) {
                    final log = allLogs
                        .where(
                          (l) =>
                              l.habitId == habit.id &&
                              l.date.isAtSameMomentAs(_selectedDate),
                        )
                        .firstOrNull;
                    final isDone = log?.isCompleted ?? false;

                    IconData hIcon = Icons.book;
                    if (habit.icon == 'workout')
                      hIcon = Icons.directions_run_rounded;
                    if (habit.icon == 'water') hIcon = Icons.water_drop_rounded;
                    if (habit.icon == 'meditate') hIcon = Icons.spa_rounded;
                    if (habit.icon == 'study') hIcon = Icons.school_rounded;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    hIcon,
                                    size: 20,
                                    color: isDone
                                        ? habit.color
                                        : AppTheme.textMuted,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    habit.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isDone
                                          ? AppTheme.textMain
                                          : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              if (isDone)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: habit.color,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (habit != habits.last)
                          const Divider(color: AppTheme.borderColor, height: 1),
                      ],
                    );
                  }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<DailyLog> allLogs, Color themeColor) {
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;
    final firstDayOffset =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final day = index - firstDayOffset + 1;
        final isOutOfRange = day <= 0 || day > daysInMonth;
        if (isOutOfRange) return const SizedBox.shrink();

        final d = DateTime(_selectedMonth.year, _selectedMonth.month, day);
        final isSelected = d.isAtSameMomentAs(_selectedDate);

        // Find if ANY habit was completed this day
        final dayLogs = allLogs
            .where((l) => l.date.isAtSameMomentAs(d) && l.isCompleted)
            .toList();
        final isDone = dayLogs.isNotEmpty;

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = d),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? themeColor
                  : (isDone ? themeColor.withOpacity(0.2) : AppTheme.bgInput),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : (isDone ? themeColor : Colors.white),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
