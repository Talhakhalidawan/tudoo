import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../providers/streak_provider.dart';
import '../providers/log_provider.dart';
import '../theme.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final streakData = ref.watch(streakProvider(widget.habit));
    final log = ref
        .watch(logProvider)
        .where(
          (l) =>
              l.habitId == widget.habit.id &&
              l.date.isAtSameMomentAs(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              ),
        )
        .firstOrNull;
    final isCompletedToday = log?.isCompleted ?? false;
    final themeColor = widget.habit.color;

    IconData hIcon = Icons.book;
    if (widget.habit.icon == 'workout') hIcon = Icons.directions_run_rounded;
    if (widget.habit.icon == 'water') hIcon = Icons.water_drop_rounded;
    if (widget.habit.icon == 'meditate') hIcon = Icons.spa_rounded;
    if (widget.habit.icon == 'study') hIcon = Icons.school_rounded;

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
                        widget.habit.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.list_rounded),
                    onPressed: () {},
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

              // Streak Text
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

              // Tabs using custom styling
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
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: themeColor,
                  unselectedLabelColor: AppTheme.textMuted,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Colors.transparent,
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
                    _buildCalendarTab(isCompletedToday, themeColor),
                    const Center(child: Text('Stats Placeholder')),
                    _buildNotesTab(themeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarTab(bool isCompletedToday, Color themeColor) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: AppTheme.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Sort',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
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
                  itemCount: 7 * 15,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final random = (index * 7) % 10;
                    Color boxColor = AppTheme.borderColor;
                    if (random > 8)
                      boxColor = themeColor;
                    else if (random > 5)
                      boxColor = themeColor.withOpacity(0.5);
                    else if (random > 3)
                      boxColor = themeColor.withOpacity(0.2);
                    return Container(
                      decoration: BoxDecoration(
                        color: boxColor,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
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
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: themeColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Edit Habit',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(Color themeColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal date picker snippet
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniDate('Mon', '13', false, themeColor),
              _buildMiniDate('Tue', '14', false, themeColor),
              _buildMiniDate('Wed', '15', true, themeColor),
              _buildMiniDate('Thu', '16', false, themeColor),
              _buildMiniDate('Fri', '17', false, themeColor),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'May 15, 2024',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Text(
                    'Studied DSA for 2 hours. Solved problems on arrays and learned something new about sliding window.',
                    style: TextStyle(color: AppTheme.textMuted, height: 1.6),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(Icons.edit, color: AppTheme.textMuted, size: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            'How was your day?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodEmoji('😄', 'Great', true, themeColor),
              _buildMoodEmoji('🙂', 'Good', false, themeColor),
              _buildMoodEmoji('😐', 'Okay', false, themeColor),
              _buildMoodEmoji('🙁', 'Bad', false, themeColor),
              _buildMoodEmoji('😩', 'Terrible', false, themeColor),
            ],
          ),

          const SizedBox(height: 32),
          const Text(
            'Photos / Attachments',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.textMuted.withOpacity(0.5),
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.textMuted,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: AppTheme.textMuted, size: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDate(
    String day,
    String date,
    bool isActive,
    Color themeColor,
  ) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            date,
            style: TextStyle(
              color: isActive ? Colors.black : AppTheme.borderColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodEmoji(
    String emoji,
    String text,
    bool isSelected,
    Color themeColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.2) : AppTheme.bgInput,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeColor : AppTheme.borderColor,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? themeColor : AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
