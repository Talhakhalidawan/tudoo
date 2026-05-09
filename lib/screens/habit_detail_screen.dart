import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../models/daily_log.dart';
import '../providers/streak_provider.dart';
import '../providers/log_provider.dart';
import '../providers/habit_provider.dart';
import '../theme.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final currentHabit =
        habits.where((h) => h.id == widget.habit.id).firstOrNull ??
        widget.habit;
    final streakData = ref.watch(streakProvider(currentHabit));
    final logs = ref
        .watch(logProvider)
        .where((l) => l.habitId == currentHabit.id)
        .toList();
    final todayLog = logs
        .where(
          (l) => l.date.isAtSameMomentAs(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          ),
        )
        .firstOrNull;
    final isCompletedToday = todayLog?.isCompleted ?? false;
    final themeColor = currentHabit.color;

    IconData hIcon = Icons.book;
    if (currentHabit.icon == 'workout') hIcon = Icons.directions_run_rounded;
    if (currentHabit.icon == 'water') hIcon = Icons.water_drop_rounded;
    if (currentHabit.icon == 'meditate') hIcon = Icons.spa_rounded;
    if (currentHabit.icon == 'study') hIcon = Icons.school_rounded;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Icon(hIcon, color: themeColor),
                      const SizedBox(width: 8),
                      Text(
                        currentHabit.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddHabitScreen(habit: currentHabit),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Circular Progress
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: streakData.currentStreak > 0
                            ? (streakData.currentStreak / 30).clamp(0.0, 1.0)
                            : 0,
                        strokeWidth: 12,
                        backgroundColor: AppTheme.borderColor,
                        color: themeColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${streakData.currentStreak}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          'Days',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Current Streak 🔥',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Best Streak: ${streakData.bestStreak} days',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Tabs
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  labelColor: themeColor,
                  unselectedLabelColor: AppTheme.textMuted,
                  tabs: const [
                    Tab(text: 'Calendar'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Notes'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCalendarTab(logs, themeColor, isCompletedToday),
                    _buildStatsTab(logs, themeColor),
                    _buildNotesTab(logs, themeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarTab(
    List<DailyLog> logs,
    Color themeColor,
    bool isCompletedToday,
  ) {
    // Functional Heatmap for this habit
    final List<double> heatmap = [];
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 104));
    for (int i = 0; i < 105; i++) {
      final d = start.add(Duration(days: i));
      final normalized = DateTime(d.year, d.month, d.day);
      final log = logs
          .where((l) => l.date.isAtSameMomentAs(normalized))
          .firstOrNull;
      heatmap.add(log != null && log.isCompleted ? 1.0 : 0.0);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
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
                    final val = heatmap[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: val > 0 ? themeColor : AppTheme.borderColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppTheme.borderColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Icon(
                          isCompletedToday
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isCompletedToday
                              ? themeColor
                              : AppTheme.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCompletedToday ? 'Completed' : 'Not actioned',
                          style: TextStyle(
                            color: isCompletedToday
                                ? themeColor
                                : AppTheme.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(List<DailyLog> logs, Color themeColor) {
    final completions = logs.where((l) => l.isCompleted).length;
    final totalDays = logs.length;
    final rate = totalDays > 0 ? (completions / totalDays * 100).toInt() : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          _statRow('Total Completions', '$completions', themeColor),
          const SizedBox(height: 12),
          _statRow('Completion Rate', '$rate%', themeColor),
          const SizedBox(height: 12),
          _statRow('Total Logs', '$totalDays', AppTheme.textMuted),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(List<DailyLog> logs, Color themeColor) {
    final currentLog = logs
        .where((l) => l.date.isAtSameMomentAs(_selectedDate))
        .firstOrNull;
    final noteController = TextEditingController(text: currentLog?.note ?? '');

    return ListView(
      children: [
        // Simple horizontal week picker
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              final d = DateTime.now().subtract(Duration(days: 6 - index));
              final normalized = DateTime(d.year, d.month, d.day);
              final isSelected = normalized.isAtSameMomentAs(_selectedDate);
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = normalized),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? themeColor : AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(d),
                        style: TextStyle(
                          color: isSelected ? Colors.black : AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('d').format(d),
                        style: TextStyle(
                          color: isSelected ? Colors.black : AppTheme.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          DateFormat('MMMM d, yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: noteController,
          maxLines: 5,
          style: const TextStyle(color: AppTheme.textMain),
          decoration: InputDecoration(
            hintText: 'Add a note for this day...',
            fillColor: AppTheme.bgCard,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (val) {
            final newLog =
                (currentLog ??
                        DailyLog(
                          habitId: widget.habit.id,
                          date: _selectedDate,
                          isCompleted: false,
                        ))
                    .copyWith(note: val);
            ref.read(logProvider.notifier).saveLog(newLog);
          },
        ),
        const SizedBox(height: 24),
        const Text('Daily Mood', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['😄', '🙂', '😐', '🙁', '😩'].map((emoji) {
            final isSelected = currentLog?.mood == emoji;
            return GestureDetector(
              onTap: () {
                final newLog =
                    (currentLog ??
                            DailyLog(
                              habitId: widget.habit.id,
                              date: _selectedDate,
                              isCompleted: false,
                            ))
                        .copyWith(mood: emoji);
                ref.read(logProvider.notifier).saveLog(newLog);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? themeColor.withOpacity(0.2)
                      : AppTheme.bgCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? themeColor : AppTheme.borderColor,
                  ),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
