import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/log_provider.dart';

class LogInputSheet extends ConsumerWidget {
  final String habitId;
  final String habitName;

  const LogInputSheet({
    super.key,
    required this.habitId,
    required this.habitName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Log $habitName',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'How was today?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: scores.map((score) {
              final isPositive = score > 0;
              return InkWell(
                onTap: () {
                  ref
                      .read(logProvider.notifier)
                      .logScore(habitId, DateTime.now(), score);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isPositive
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    score > 0 ? '+$score' : '$score',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
