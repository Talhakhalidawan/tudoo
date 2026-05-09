import 'package:flutter/material.dart';
import '../theme.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  // Use state or riverpod to save theme globally later
  // We'll mimic the UI visual for now
  Color _selectedTheme = AppTheme.themeGreen;

  final List<Map<String, dynamic>> _themes = [
    {'color': const Color(0xFF34C759), 'name': 'Green', 'default': true},
    {'color': const Color(0xFFAF52DE), 'name': 'Purple', 'default': false},
    {'color': const Color(0xFF32ADE6), 'name': 'Blue', 'default': false},
    {'color': const Color(0xFFFF9500), 'name': 'Orange', 'default': false},
    {'color': const Color(0xFFFF2D55), 'name': 'Pink', 'default': false},
    {'color': const Color(0xFF30B0C7), 'name': 'Teal', 'default': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Select Theme',
              style: TextStyle(color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: _themes.length,
              itemBuilder: (context, index) {
                final t = _themes[index];
                final tColor = t['color'] as Color;
                final isSelected = _selectedTheme == tColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTheme = tColor),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tColor.withOpacity(0.1)
                          : AppTheme.bgCard,
                      border: Border.all(
                        color: isSelected ? tColor : AppTheme.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(tColor.withOpacity(0.2)),
                            const SizedBox(width: 2),
                            _buildDot(tColor.withOpacity(0.6)),
                            const SizedBox(width: 2),
                            _buildDot(tColor),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isSelected ? tColor : AppTheme.textMain,
                          ),
                        ),
                        if (t['default'] == true)
                          const Text(
                            '(Default)',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text('Preview', style: TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4 * 15,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 15,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  final random = (index * 7) % 10;
                  Color boxColor = AppTheme.borderColor;
                  if (random > 8)
                    boxColor = _selectedTheme;
                  else if (random > 5)
                    boxColor = _selectedTheme.withOpacity(0.6);
                  else if (random > 3)
                    boxColor = _selectedTheme.withOpacity(0.2);
                  return Container(
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color c) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
