import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';

// houses the dark and light mode
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // rebuilds the screen whenever theme provide notifies listeners
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Settings',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const CustomText(
                text: 'Dark Mode',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              subtitle: CustomText(
                text: themeProvider.isDark ? 'Enabled' : 'Disabled',
                fontSize: 12,
              ),
              value: themeProvider.isDark,
              onChanged: (value) {
                // Enhancement 3: calling setDarkMode here notifies listeners,
                // which rebuilds MaterialApp in main.dart with the new
                // theme/darkTheme/themeMode combination.
                context.read<ThemeProvider>().setDarkMode(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}