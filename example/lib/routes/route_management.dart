// ignore_for_file: unused_import
import 'package:get/get.dart';
import 'package:example/routes/app_routes.dart';

/// Central navigation helper — every navigation action goes through here.
abstract class RouteManagement {
  // TODO: add navigation methods here
  // static void goToHomePage() {
  //   Get.toNamed(AppRoutes.home);
  // }
  static void goToAuthLogin() {
    Get.toNamed(AppRoutes.authLogin);
  }

  static void goToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  static void goToSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  static void goToProductsDetails() {
    Get.toNamed(AppRoutes.productsDetails);
  }
}
