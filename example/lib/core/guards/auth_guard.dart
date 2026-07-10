import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/routes/app_routes.dart';

/// Standard GetX authentication guard.
///
/// Registers automatically in AppPages for protected routes.
class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Inject the global SharedPreferences instance
    final prefs = Get.find<SharedPreferences>();

    // Check if the user has a valid session token
    final token = prefs.getString('token');

    // If not authenticated, redirect to the login page
    if (token == null || token.isEmpty) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // Allow navigation
    return null;
  }
}
