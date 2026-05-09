import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../theme.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? habit;
  const AddHabitScreen({super.key, this.habit});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  late TextEditingController _nameController;
  late String _selectedFrequency;
  late int _targetGoal;
  late String _selectedIcon;
  late Color _selectedColor;

  final List<Color> _palette = const [
    Color(0xFF34C759),
    Color(0xFF32ADE6),
    Color(0xFFAF52DE),
    Color(0xFFFF2D55),
    Color(0xFFFF9500),
    Color(0xFFA2845E),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _selectedFrequency = widget.habit?.frequency ?? 'Daily';
    _targetGoal = widget.habit?.targetValue ?? 1;
    _selectedIcon = widget.habit?.icon ?? 'book';
    _selectedColor = widget.habit?.color ?? _palette.first;
  }

  void _saveHabit() {
    if (_nameController.text.trim().isEmpty) return;

    if (widget.habit != null) {
      ref
          .read(habitProvider.notifier)
          .updateHabit(
            widget.habit!.copyWith(
              name: _nameController.text.trim(),
              icon: _selectedIcon,
              color: _selectedColor,
              frequency: _selectedFrequency,
              targetValue: _targetGoal,
            ),
          );
    } else {
      ref
          .read(habitProvider.notifier)
          .addHabit(
            name: _nameController.text.trim(),
            icon: _selectedIcon,
            color: _selectedColor,
            frequency: _selectedFrequency,
            targetValue: _targetGoal,
          );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textMain),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.habit != null ? 'Edit Habit' : 'Add New Habit',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.habit != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.danger,
                      ),
                      onPressed: () {
                        ref
                            .read(habitProvider.notifier)
                            .deleteHabit(widget.habit!.id);
                        Navigator.pop(context); // Close edit
                        Navigator.pop(context); // Close detail
                      },
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children:
                            [
                              'book',
                              'workout',
                              'water',
                              'meditate',
                              'study',
                            ].map((iconKey) {
                              final isSelected = _selectedIcon == iconKey;
                              IconData iconData;
                              switch (iconKey) {
                                case 'workout':
                                  iconData = Icons.directions_run;
                                  break;
                                case 'water':
                                  iconData = Icons.water_drop;
                                  break;
                                case 'meditate':
                                  iconData = Icons.spa;
                                  break;
                                case 'study':
                                  iconData = Icons.school;
                                  break;
                                default:
                                  iconData = Icons.book;
                              }
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedIcon = iconKey),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? _selectedColor.withOpacity(0.2)
                                        : AppTheme.bgCard,
                                    border: Border.all(
                                      color: isSelected
                                          ? _selectedColor
                                          : AppTheme.borderColor,
                                    ),
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: isSelected
                                        ? _selectedColor
                                        : AppTheme.textMuted,
                                    size: 28,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Choose Icon',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),

                      const SizedBox(height: 32),
                      _buildInputGroup(
                        'Habit Name',
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'e.g. Read Book',
                          ),
                        ),
                      ),

                      _buildInputGroup(
                        'Frequency',
                        Row(
                          children: ['Daily', 'Weekly', 'Custom'].map((freq) {
                            final isSelected = _selectedFrequency == freq;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedFrequency = freq),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? _selectedColor.withOpacity(0.2)
                                        : AppTheme.bgInput,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? _selectedColor
                                          : AppTheme.borderColor,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    freq,
                                    style: TextStyle(
                                      color: isSelected
                                          ? _selectedColor
                                          : AppTheme.textMain,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      _buildInputGroup(
                        'Goal',
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.bgInput,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_targetGoal}x per day',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  _buildCounterButton('-', () {
                                    if (_targetGoal > 1)
                                      setState(() => _targetGoal--);
                                  }),
                                  const SizedBox(width: 8),
                                  _buildCounterButton(
                                    '+',
                                    () => setState(() => _targetGoal++),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      _buildInputGroup(
                        'Choose Color',
                        Row(
                          children: _palette.map((color) {
                            final isSelected = _selectedColor == color;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _saveHabit,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.habit != null ? 'Save Changes' : 'Create Habit',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputGroup(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildCounterButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
