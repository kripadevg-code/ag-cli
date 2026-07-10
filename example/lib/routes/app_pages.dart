// ignore_for_file: unused_import
import 'package:get/get.dart';
import 'package:example/routes/app_routes.dart';
import 'package:example/modules/orders/pages/orders_page.dart';
import 'package:example/modules/orders/bindings/orders_binding.dart';

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
    GetPage(name: AppRoutes.orders, page: OrdersPage.new, binding: OrdersBinding(), transition: defaultTransition),
  ];
}
