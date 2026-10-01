import 'package:flutter/material.dart';

//stores the application's theme and notifies every screen whenever the theme changes.
class ThemeModel extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// Switches between light and dark mode.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}