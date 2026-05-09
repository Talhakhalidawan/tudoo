import 'package:flutter/material.dart';
import '../theme.dart';
import 'theme_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
      children: [
        const Center(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 32),

        const Text(
          'Preferences',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              _buildListItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              _buildDivider(),
              _buildListItem(
                icon: Icons.notifications_none,
                title: 'Notifications',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                ),
              ),
              _buildDivider(),
              _buildListItem(
                icon: Icons.sync,
                title: 'First Day of Week',
                trailing: Row(
                  children: const [
                    Text('Monday', style: TextStyle(color: AppTheme.textMuted)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: AppTheme.textMuted),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        const Text(
          'App',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThemeScreen()),
                ),
                child: _buildListItem(
                  icon: Icons.palette_outlined,
                  title: 'Theme Color',
                  trailing: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              _buildDivider(),
              _buildListItem(
                icon: Icons.cloud_upload_outlined,
                title: 'Backup & Sync',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                ),
              ),
              _buildDivider(),
              _buildListItem(
                icon: Icons.info_outline,
                title: 'About Habit Tracker',
                trailing: Row(
                  children: const [
                    Text('v1.0.1', style: TextStyle(color: AppTheme.textMuted)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: AppTheme.textMuted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.textMain),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      const Divider(color: AppTheme.borderColor, height: 1);
}
