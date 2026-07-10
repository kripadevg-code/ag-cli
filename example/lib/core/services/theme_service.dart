import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage_service.dart';

/// Service to handle app theme mode
class ThemeService extends GetxService {
  static ThemeService get find => Get.find();

  final StorageService _storage = StorageService.find;

  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _storage.getBool(_themeKey);

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggles the current theme and persists it to StorageService
  void toggleTheme() {
    final isDark = isDarkMode;
    _storage.setBool(_themeKey, !isDark);
    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
