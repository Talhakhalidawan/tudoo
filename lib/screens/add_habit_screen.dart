import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _nameController = TextEditingController();
  Color _positiveColor = Colors.greenAccent;
  Color _negativeColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g. Namaz',
              ),
              style: const TextStyle(fontSize: 24),
              autofocus: true,
            ),
            const SizedBox(height: 40),
            _buildColorSection(
              'Positive Color',
              'Used for good days',
              _positiveColor,
              (color) => setState(() => _positiveColor = color),
            ),
            const SizedBox(height: 32),
            _buildColorSection(
              'Negative Color',
              'Used for bad days',
              _negativeColor,
              (color) => setState(() => _negativeColor = color),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'CREATE HABIT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(
    String title,
    String subtitle,
    Color color,
    ValueChanged<Color> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickColor(color, onSelected),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Center(
              child: Text(
                'Tap to change',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pickColor(Color initialColor, ValueChanged<Color> onSelected) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: onSelected,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) return;

    final habit = Habit(
      name: _nameController.text.trim(),
      positiveColor: _positiveColor,
      negativeColor: _negativeColor,
    );

    ref.read(habitProvider.notifier).addHabit(habit);
    Navigator.pop(context);
  }
}
