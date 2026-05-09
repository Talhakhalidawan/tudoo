import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../theme.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  int _selectedDate = 15;

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final themeColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
              const Text(
                'Calendar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: AppTheme.textMuted),
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textMuted),
            ],
          ),
          const SizedBox(height: 24),

          // Calendar Grid Header
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

          // Mock Grid exactly like design.html
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              int day = index - 1; // start off offset for 29, 30...
              bool isDimmed = day <= 0 || day > 31;
              int displayDay = day <= 0
                  ? 30 + day
                  : (day > 31 ? day - 31 : day);

              bool isStreak =
                  [13, 16, 17, 18, 19, 20, 21, 27, 28].contains(displayDay) &&
                  !isDimmed;
              bool isActive = displayDay == _selectedDate && !isDimmed;

              return GestureDetector(
                onTap: () {
                  if (!isDimmed) setState(() => _selectedDate = displayDay);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? themeColor
                        : (isStreak
                              ? themeColor.withOpacity(0.2)
                              : (isDimmed
                                    ? Colors.transparent
                                    : AppTheme.bgInput)),
                  ),
                  child: Text(
                    '$displayDay',
                    style: TextStyle(
                      color: isActive
                          ? Colors.black
                          : (isStreak
                                ? themeColor
                                : (isDimmed
                                      ? AppTheme.borderColor
                                      : Colors.white)),
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          Text(
            'May $_selectedDate, 2024',
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
                        child: Text(
                          'No habits recorded.',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    ]
                  : habits.map((habit) {
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
                                      Icons.book,
                                      size: 20,
                                    ), // Placeholder simple icon
                                    const SizedBox(width: 12),
                                    Text(
                                      habit.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeColor,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 14,
                                    weight: 900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (habit != habits.last)
                            const Divider(
                              color: AppTheme.borderColor,
                              height: 1,
                            ),
                        ],
                      );
                    }).toList(),
            ),
          ),
          const SizedBox(height: 100), // FAB padding
        ],
      ),
    );
  }
}
