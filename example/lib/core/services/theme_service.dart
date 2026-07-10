import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage and persist the app theme across sessions.
class ThemeService extends GetxService {
  static ThemeService get find => Get.find();

  final SharedPreferences _prefs;
  ThemeService(this._prefs);

  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggles the current theme and persists it to SharedPreferences
  void toggleTheme() {
    final isDark = isDarkMode;
    _prefs.setBool(_themeKey, !isDark);
    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
