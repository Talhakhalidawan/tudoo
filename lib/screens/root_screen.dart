import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_habit_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import '../theme.dart';
import 'dart:ui';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const Center(
      child: Text(
        'Coming Soon: Detailed Stats',
        style: TextStyle(color: AppTheme.textMuted),
      ),
    ),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBody: true, // Allows content to flow under the bottom nav
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(context, themeColor),
    );
  }

  Widget _buildBottomNav(BuildContext context, Color themeColor) {
    return Container(
      height: 90, // Slightly taller for safe area
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withOpacity(0.8),
        border: const Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20), // Simulated safe area
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navButton(0, Icons.home_filled),
                _navButton(1, Icons.bar_chart_rounded),

                // FAB
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddHabitScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 28),
                  ),
                ),

                _navButton(2, Icons.local_fire_department_rounded),
                _navButton(3, Icons.settings_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton(int index, IconData icon) {
    bool isActive = _currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Theme.of(context).primaryColor : AppTheme.textMuted,
      ),
      onPressed: () => setState(() => _currentIndex = index),
      iconSize: 26,
    );
  }
}
