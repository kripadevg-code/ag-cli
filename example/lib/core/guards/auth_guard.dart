import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/core/services/storage_service.dart';
import 'package:example/routes/app_routes.dart';

/// Standard GetX authentication guard.
///
/// Registers automatically in AppPages for protected routes.
class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Inject the unified StorageService
    final storage = StorageService.find;

    // Check if the user has a valid session token
    final token = storage.getToken();

    // If not authenticated, redirect to the login page
    if (token == null || token.isEmpty) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // Allow navigation
    return null;
  }
}
