import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/streak_provider.dart';
import '../providers/log_provider.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakProvider(habit));
    final logs = ref
        .watch(logProvider)
        .where((l) => l.habitId == habit.id)
        .toList();

    IconData hIcon = Icons.book;
    if (habit.icon == 'workout') hIcon = Icons.directions_run_rounded;
    if (habit.icon == 'water') hIcon = Icons.water_drop_rounded;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(hIcon, color: habit.color),
              const SizedBox(width: 8),
              Text(
                habit.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: true,
          actions: [IconButton(icon: const Icon(Icons.list), onPressed: () {})],
        ),
        body: Column(
          children: [
            const SizedBox(height: 32),
            // Circular Progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: streakData.currentStreak > 0
                        ? (streakData.currentStreak / 30).clamp(0.0, 1.0)
                        : 0,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    color: habit.color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${streakData.currentStreak}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const Text('Days', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Current Streak ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('🔥'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Best Streak: ${streakData.bestStreak} days',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 32),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: habit.color, width: 2),
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade500,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Calendar'),
                    Tab(text: 'Stats'),
                    Tab(text: 'Notes'),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildCalendarTab(),
                  const Center(child: Text('Stats Placeholder')),
                  _buildNotesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'May 2024',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  const Text(
                    '8nd',
                    style: TextStyle(color: Colors.grey),
                  ), // Mock
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.grey.shade500),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Simplified placeholder grid
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Heatmap Grid Here',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: habit.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.check_circle, color: habit.color),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Edit Habit', style: TextStyle(color: habit.color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'May 15, 2024',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                const Text(
                  'Studied DSA for 2 hours. Solved problems on arrays and learned something new about sliding window.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'How was your day?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodEmoji('😁', 'Great', true),
              _buildMoodEmoji('😊', 'Good', false),
              _buildMoodEmoji('😐', 'Okay', false),
              _buildMoodEmoji('😞', 'Bad', false),
              _buildMoodEmoji('😩', 'Terrible', false),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Photos / Attachments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                style: BorderStyle.none,
              ),
            ),
            child: Material(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: const Center(child: Icon(Icons.add, color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodEmoji(String emoji, String text, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? habit.color.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? habit.color : Colors.transparent,
            ),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: isSelected ? habit.color : Colors.grey.shade500,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
