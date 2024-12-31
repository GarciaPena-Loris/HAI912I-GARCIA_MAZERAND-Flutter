// lib/ThemeSwitcher.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/ThemeProvider.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Row(
      children: [
        if (!isDarkMode) const Icon(Icons.wb_sunny, color: Colors.yellow),
        Switch(
          value: isDarkMode,
          onChanged: themeProvider.toggleTheme,
          activeColor: Colors.black,
        ),
        if (isDarkMode) const Icon(Icons.nightlight_round, color: Colors.yellow),
      ],
    );
  }
}