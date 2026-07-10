import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:ag_cli/src/route_injector.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('ag_cli_routes_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  // Helper: sets up a minimal routes directory
  String setupRoutes(String libDir) {
    final routesDir = Directory(p.join(libDir, 'routes'))..createSync(recursive: true);

    File(p.join(routesDir.path, 'app_routes.dart')).writeAsStringSync('''
abstract class AppRoutes {
  static const initial = _Routes.home;
}

abstract class _Routes {
  static const home = '/home';
}
''');

    File(p.join(routesDir.path, 'app_pages.dart')).writeAsStringSync('''
import 'package:get/get.dart';
import 'package:my_app/routes/app_routes.dart';

abstract class AppPages {
  static final defaultTransition = Transition.rightToLeftWithFade;
  static final pages = <GetPage>[
  ];
}
''');

    File(p.join(routesDir.path, 'route_management.dart')).writeAsStringSync('''
import 'package:get/get.dart';
import 'package:my_app/routes/app_routes.dart';

abstract class RouteManagement {
}
''');

    return libDir;
  }

  group('RouteInjector.injectRoutes', () {
    test('returns false when route files do not exist', () {
      final result = RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );
      expect(result, isFalse);
    });

    test('injects route into app_routes.dart', () {
      setupRoutes(tempDir.path);
      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );

      final content = File(
        p.join(tempDir.path, 'routes', 'app_routes.dart'),
      ).readAsStringSync();
      expect(content, contains('static const orders ='));
    });

    test('injects GetPage into app_pages.dart', () {
      setupRoutes(tempDir.path);
      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );

      final content = File(
        p.join(tempDir.path, 'routes', 'app_pages.dart'),
      ).readAsStringSync();
      expect(content, contains('OrdersPage'));
      expect(content, contains('OrdersBinding'));
    });

    test('injects navigation method into route_management.dart', () {
      setupRoutes(tempDir.path);
      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );

      final content = File(
        p.join(tempDir.path, 'routes', 'route_management.dart'),
      ).readAsStringSync();
      expect(content, contains('goToOrders()'));
    });

    test('does not inject duplicate routes on second call', () {
      setupRoutes(tempDir.path);

      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );

      // Second call — should be a no-op
      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: false,
      );

      final routesContent = File(
        p.join(tempDir.path, 'routes', 'app_routes.dart'),
      ).readAsStringSync();

      // Should appear exactly once per class (AppRoutes + _Routes = 2 total is correct)
      // The important thing is it does NOT appear more than twice
      final matches = 'static const orders ='.allMatches(routesContent).length;
      expect(matches, lessThanOrEqualTo(2));
      expect(matches, greaterThan(0));
    });

    test('dry-run does not write files', () {
      setupRoutes(tempDir.path);
      final originalContent = File(
        p.join(tempDir.path, 'routes', 'app_routes.dart'),
      ).readAsStringSync();

      RouteInjector.injectRoutes(
        libDir: tempDir.path,
        packageName: 'my_app',
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        dryRun: true,
      );

      final afterContent = File(
        p.join(tempDir.path, 'routes', 'app_routes.dart'),
      ).readAsStringSync();

      expect(afterContent, equals(originalContent));
    });
  });
}
