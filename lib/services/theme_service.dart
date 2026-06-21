import 'package:flutter/material.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  bool get isDarkMode => themeNotifier.value == ThemeMode.dark;

  void toggleTheme() {
    themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}
