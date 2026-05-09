import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_habit_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import '../theme.dart';

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
    const SizedBox.shrink(), // Center placeholder for FAB
    const Center(
      child: Text('Streaks Placeholder', style: TextStyle(color: Colors.grey)),
    ),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the active color from the theme
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Content
          Positioned.fill(child: _screens[_currentIndex]),

          // Custom Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: const EdgeInsets.only(
                bottom: 15,
              ), // Safe area padding simulation
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withOpacity(0.95),
                border: const Border(
                  top: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(0, Icons.home_rounded),
                  _buildNavItem(1, Icons.bar_chart_rounded),

                  // Center FAB
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddHabitScreen(),
                        ),
                      );
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -10),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.bgMain, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  _buildNavItem(2, Icons.local_fire_department_rounded),
                  _buildNavItem(3, Icons.settings_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = _currentIndex == index;
    final themeColor = Theme.of(context).primaryColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 24,
          color: isActive ? themeColor : AppTheme.textMuted,
        ),
      ),
    );
  }
}
