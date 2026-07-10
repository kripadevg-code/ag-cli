// ignore_for_file: unused_import
import 'package:get/get.dart';
import 'package:example/routes/app_routes.dart';
import 'package:example/modules/auth/pages/auth_login_page.dart';
import 'package:example/modules/auth/bindings/auth_login_binding.dart';
import 'package:example/modules/profile/pages/profile_page.dart';
import 'package:example/modules/profile/bindings/profile_binding.dart';
import 'package:example/modules/settings/pages/settings_page.dart';
import 'package:example/modules/settings/bindings/settings_binding.dart';
import 'package:example/modules/products/pages/products_details_page.dart';
import 'package:example/modules/products/bindings/products_details_binding.dart';

/// Route → Page + Binding mapping.
abstract class AppPages {
  static final defaultTransition = Transition.rightToLeftWithFade;

  static final pages = <GetPage>[
    // TODO: add GetPage entries here
    // GetPage(
    //   name: AppRoutes.home,
    //   page: HomePage.new,
    //   binding: HomeBinding(),
    //   transition: defaultTransition,
    // ),
    GetPage(name: AppRoutes.authLogin, page: AuthLoginPage.new, binding: AuthLoginBinding(), transition: defaultTransition),
    GetPage(name: AppRoutes.profile, page: ProfilePage.new, binding: ProfileBinding(), transition: defaultTransition),
    GetPage(name: AppRoutes.settings, page: SettingsPage.new, binding: SettingsBinding(), transition: defaultTransition),
    GetPage(
      name: AppRoutes.productsDetails,
      page: ProductsDetailsPage.new,
      binding: ProductsDetailsBinding(),
      transition: defaultTransition,
    ),
  ];
}
