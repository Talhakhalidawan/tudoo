import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../providers/log_provider.dart';
import '../widgets/heatmap_grid.dart';
import '../widgets/log_input_sheet.dart';
import 'add_habit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final logs = ref.watch(logProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TUDOO',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900),
        ),
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No habits yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _navigateToAddHabit(context),
                    child: const Text('Create your first habit'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final habitLogs = ref
                    .read(logProvider.notifier)
                    .getLogsForHabit(habit.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: InkWell(
                    onLongPress: () => _confirmDelete(context, ref, habit),
                    onTap: () => _showLogSheet(context, habit),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              habit.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        HeatmapGrid(habit: habit, logs: habitLogs),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHabit(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
  }

  void _showLogSheet(BuildContext context, dynamic habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          LogInputSheet(habitId: habit.id, habitName: habit.name),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, dynamic habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitProvider.notifier).deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
