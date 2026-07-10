import 'dart:io';
import 'package:path/path.dart' as p;
import 'logger.dart';
import 'utils.dart';

class RouteInjector {
  /// Attempts to automatically inject routing code for [moduleName] and [className].
  /// Returns `true` if all files were successfully updated.
  static bool injectRoutes({
    required String libDir,
    required String packageName,
    required String moduleDir,
    required String fileNamePrefix,
    required String className,
    required bool dryRun,
  }) {
    final routesFile = File(p.join(libDir, 'routes', 'app_routes.dart'));
    final pagesFile = File(p.join(libDir, 'routes', 'app_pages.dart'));
    final managementFile = File(
      p.join(libDir, 'routes', 'route_management.dart'),
    );

    if (!routesFile.existsSync() || !pagesFile.existsSync() || !managementFile.existsSync()) {
      return false; // Cannot auto-inject if files don't exist
    }

    try {
      bool success = true;
      success &= injectAppRoutes(routesFile, fileNamePrefix, dryRun);
      success &= injectAppPages(
        pagesFile,
        moduleDir,
        fileNamePrefix,
        className,
        packageName,
        dryRun,
      );
      success &= injectRouteManagement(
        managementFile,
        fileNamePrefix,
        className,
        dryRun,
      );

      if (success && !dryRun) {
        Log.success(
          'Auto-injected routes into app_routes, app_pages, and route_management',
        );
      }
      return success;
    } catch (e) {
      Log.warn('Failed to auto-inject routes: $e');
      return false;
    }
  }

  static bool injectAppRoutes(File file, String name, bool dryRun) {
    String content = file.readAsStringSync();
    final camelName = toCamel(name);
    if (content.contains('static const $camelName =')) {
      return true; // Already exists
    }

    // Inject into AppRoutes
    final appRoutesEnd = content.indexOf('}');
    if (appRoutesEnd == -1) return false;
    content = content.replaceRange(
      appRoutesEnd,
      appRoutesEnd,
      '  static const $camelName = _Routes.$camelName;\n',
    );

    // Inject into _Routes
    final routesEnd = content.lastIndexOf('}');
    if (routesEnd == -1) return false;
    content = content.replaceRange(
      routesEnd,
      routesEnd,
      "  static const $camelName = '/$name';\n",
    );

    if (!dryRun) file.writeAsStringSync(content);
    return true;
  }

  static bool injectAppPages(
    File file,
    String moduleDir,
    String fileNamePrefix,
    String cls,
    String pkg,
    bool dryRun,
  ) {
    String content = file.readAsStringSync();
    final camelName = toCamel(fileNamePrefix);
    if (content.contains('AppRoutes.$camelName')) return true; // Already exists

    // 1. Add Imports
    final importPage = "import 'package:$pkg/modules/$moduleDir/pages/${fileNamePrefix}_page.dart';";
    final importBinding = "import 'package:$pkg/modules/$moduleDir/bindings/${fileNamePrefix}_binding.dart';";

    // Find last import
    final lastImportIdx = content.lastIndexOf(
      RegExp(r'^import .*;\n', multiLine: true),
    );
    if (lastImportIdx != -1) {
      final endOfImport = content.indexOf('\n', lastImportIdx) + 1;
      content = content.replaceRange(
        endOfImport,
        endOfImport,
        '$importPage\n$importBinding\n',
      );
    } else {
      content = '$importPage\n$importBinding\n$content';
    }

    // 2. Add GetPage
    final getPageString = '''
    GetPage(
      name: AppRoutes.$camelName,
      page: ${cls}Page.new,
      binding: ${cls}Binding(),
      transition: defaultTransition,
    ),
''';

    // Find the pages array `];`
    final pagesEnd = content.lastIndexOf('];');
    if (pagesEnd != -1) {
      content = content.replaceRange(pagesEnd, pagesEnd, getPageString);
    } else {
      return false;
    }

    if (!dryRun) file.writeAsStringSync(content);
    return true;
  }

  static bool injectRouteManagement(
    File file,
    String name,
    String cls,
    bool dryRun,
  ) {
    String content = file.readAsStringSync();
    final camelName = toCamel(name);
    if (content.contains('AppRoutes.$camelName')) return true; // Already exists

    final methodString = '''
  static void goTo$cls() {
    Get.toNamed(AppRoutes.$camelName);
  }
''';

    final endIdx = content.lastIndexOf('}');
    if (endIdx != -1) {
      content = content.replaceRange(endIdx, endIdx, methodString);
    } else {
      return false;
    }

    if (!dryRun) file.writeAsStringSync(content);
    return true;
  }
}
