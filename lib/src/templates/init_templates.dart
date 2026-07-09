/// Templates for `ag init` — project structure scaffolding.
library;

String appRoutesStub() => '''
/// All route path constants live here.
abstract class AppRoutes {
  static const home = _Routes.home;

  // TODO: add routes here (ag module generates stubs in ROUTE_TODO.md)
}

abstract class _Routes {
  static const home = '/home';
}
''';

String appPagesStub(String pkg) => '''
import 'package:get/get.dart';
import 'package:$pkg/routes/app_routes.dart';

/// Route → Page + Binding mapping.
abstract class AppPages {
  static const initial = AppRoutes.home;

  static final defaultTransition = Transition.rightToLeftWithFade;

  static final pages = <GetPage>[
    // TODO: add GetPage entries here
    // GetPage(
    //   name: AppRoutes.home,
    //   page: HomePage.new,
    //   binding: HomeBinding(),
    //   transition: defaultTransition,
    // ),
  ];
}
''';

String routeManagementStub(String pkg) => '''
import 'package:get/get.dart';
import 'package:$pkg/routes/app_routes.dart';

/// Central navigation helper — every navigation action goes through here.
abstract class RouteManagement {
  // TODO: add navigation methods here
  // static void goToHomePage() {
  //   Get.toNamed(AppRoutes.home);
  // }
}
''';

String enumsStub() => '''
/// App-wide loading status enum.
enum LoadingStatus { loading, done, error, empty }
''';

String dimensStub() => '''
import 'package:flutter/material.dart';

/// Centralized dimension constants for consistent spacing.
abstract class Dimens {
  static const double two = 2;
  static const double four = 4;
  static const double six = 6;
  static const double eight = 8;
  static const double ten = 10;
  static const double twelve = 12;
  static const double fourteen = 14;
  static const double sixTeen = 16;
  static const double eighteen = 18;
  static const double twenty = 20;
  static const double twentyFour = 24;
  static const double twentyEight = 28;
  static const double thirtyTwo = 32;
  static const double fourty = 40;

  static const defaultPadding = EdgeInsets.symmetric(horizontal: sixTeen);
  static const onlyTop12 = EdgeInsets.only(top: twelve);
  static const onlyTop16 = EdgeInsets.only(top: sixTeen);
}
''';

String utilityStub() => '''
/// App-wide utility/logging helper.
abstract class AppUtility {
  static void log(String message, {String tag = 'log'}) {
    // ignore: avoid_print
    print('[\$tag] \$message');
  }
}
''';

String apiProviderStub() => '''
/// Central API provider — all HTTP calls go through here.
///
/// TODO: Configure your HTTP client (dio, http, etc.)
class ApiProvider {
  ApiProvider._();
  static final instance = ApiProvider._();

  // TODO: add API methods
  // Future<Response> getIncidents({...}) async { ... }
}
''';

String isolateHandlerStub() => '''
import 'dart:isolate';

/// Runs heavy JSON parsing on a background isolate to keep UI smooth.
class IsolateHandler<I, O> {
  Future<O> run(I input, O Function(I) parser) async =>
      await Isolate.run(() => parser(input));
}
''';
