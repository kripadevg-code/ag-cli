import 'package:flutter/material.dart';
import 'package:example/utils/theme/app_colors.dart';

/// App-wide theme configuration.
abstract class AppTheme {
  static final light = ThemeData(primaryColor: AppColors.primary, scaffoldBackgroundColor: AppColors.background, useMaterial3: true);

  static final dark = ThemeData(primaryColor: AppColors.primary, scaffoldBackgroundColor: AppColors.black, useMaterial3: true);
}
