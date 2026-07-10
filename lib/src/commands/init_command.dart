import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../logger.dart';
import '../utils.dart';
import '../templates/init_templates.dart';
import '../templates/common_widgets_templates.dart';

class InitCommand extends Command<int> {
  @override
  final String name = 'init';

  @override
  final String description = 'Scaffold the standard GetX project folder structure.';

  InitCommand() {
    argParser
      ..addFlag(
        'dry-run',
        abbr: 'd',
        negatable: false,
        help: 'Preview without writing files',
      )
      ..addFlag('force', negatable: false, help: 'Overwrite existing files')
      ..addOption(
        'package',
        abbr: 'p',
        help: 'Flutter package name (auto-detected from pubspec.yaml)',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output lib/ directory (auto-detected if omitted)',
      );
  }

  @override
  Future<int> run() async {
    final outputOverride = argResults?['output'] as String?;
    final packageOverride = argResults?['package'] as String?;
    final dryRun = argResults?['dry-run'] as bool? ?? false;
    final force = argResults?['force'] as bool? ?? false;

    // ─── Resolve lib dir ────────────────────────────────────────────────────
    final libDir = outputOverride != null ? p.join(Directory.current.path, outputOverride) : findLibDir();
    if (libDir == null) {
      Log.error(
        'Could not find lib/ directory. Run from project root or pass --output <path>.',
      );
      return 1;
    }

    // ─── Resolve package name ───────────────────────────────────────────────
    final packageName = packageOverride ?? detectPackageName();
    if (packageName == null) {
      Log.error('Could not detect package name. Pass --package <name>.');
      return 1;
    }

    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

    Log.header('🏗️  Initializing GetX project structure');
    Log.dim('   package : $packageName');
    Log.dim('   output  : ${p.relative(libDir)}/\n');

    var count = 0;

    // ─── Routes ─────────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'routes', 'app_routes.dart'),
      appRoutesStub(),
      dryRun: dryRun,
      force: force,
    );
    count += _w(
      p.join(libDir, 'routes', 'app_pages.dart'),
      appPagesStub(packageName),
      dryRun: dryRun,
      force: force,
    );
    count += _w(
      p.join(libDir, 'routes', 'route_management.dart'),
      routeManagementStub(packageName),
      dryRun: dryRun,
      force: force,
    );

    // ─── Constants ──────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'constants', 'enums.dart'),
      enumsStub(),
      dryRun: dryRun,
      force: force,
    );

    // ─── Utils ──────────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'utils', 'dimens.dart'),
      dimensStub(),
      dryRun: dryRun,
      force: force,
    );
    count += _w(
      p.join(libDir, 'utils', 'utility.dart'),
      utilityStub(),
      dryRun: dryRun,
      force: force,
    );

    // ─── APIs ───────────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'apis', 'providers', 'api_provider.dart'),
      apiProviderStub(),
      dryRun: dryRun,
      force: force,
    );

    // ─── Core ───────────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'core', 'isolate_handler.dart'),
      isolateHandlerStub(),
      dryRun: dryRun,
      force: force,
    );

    count += _w(
      p.join(libDir, 'core', 'guards', 'auth_guard.dart'),
      authGuardStub(packageName),
      dryRun: dryRun,
      force: force,
    );

    // ─── Theme ──────────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'utils', 'theme', 'app_colors.dart'),
      appColorsStub(),
      dryRun: dryRun,
      force: force,
    );
    count += _w(
      p.join(libDir, 'utils', 'theme', 'app_theme.dart'),
      appThemeStub(packageName),
      dryRun: dryRun,
      force: force,
    );

    // ─── Bindings ───────────────────────────────────────────────────────────
    count += _w(
      p.join(libDir, 'core', 'bindings', 'initial_binding.dart'),
      initialBindingStub(packageName),
      dryRun: dryRun,
      force: force,
    );

    // ─── Common Widgets & Helpers ───────────────────────────────────────────
    count += _w(p.join(libDir, 'core', 'services', 'theme_service.dart'), themeServiceStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'helpers', 'query_helper.dart'), queryHelperStub(), dryRun: dryRun, force: force);
    count +=
        _w(p.join(libDir, 'core', 'services', 'search_history_service.dart'), searchHistoryServiceStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'resources', 'app_string.dart'), appStringStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'common', 'app_error_widget.dart'), appErrorWidgetStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'common', 'empty_state_page_new.dart'), emptyStatePageStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'custom', 'custom_refresh_indicator.dart'), customRefreshIndicatorStub(),
        dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'custom', 'custom_scrollview_with_sliverappbar.dart'), customScrollViewStub(),
        dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'common', 'search_history_panel.dart'), searchHistoryPanelStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'extensions', 'response_extension.dart'), responseExtensionStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'model', 'common', 'state_model.dart'), stateModelStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'common', 'list_shimmer.dart'), listShimmerStub(), dryRun: dryRun, force: force);
    count += _w(p.join(libDir, 'widgets', 'common', 'item_card.dart'), incidentCardStub(), dryRun: dryRun, force: force);

    // ─── Empty directories ──────────────────────────────────────────────────
    final emptyDirs = [
      'modules',
      'model',
      'helpers',
      'resources',
      'widgets',
      'extensions',
      p.join('core', 'bindings'),
      p.join('utils', 'theme'),
    ];
    for (final dir in emptyDirs) {
      final dirPath = p.join(libDir, dir);
      if (dryRun) {
        Log.dryRun('${p.relative(dirPath)}/');
      } else if (!Directory(dirPath).existsSync()) {
        Directory(dirPath).createSync(recursive: true);
        Log.success('${p.relative(dirPath)}/');
      } else {
        Log.warn('${p.relative(dirPath)}/ already exists (skipped)');
      }
    }

    Log.blank();
    if (dryRun) {
      Log.info(
        '$count files + ${emptyDirs.length} directories would be created.',
      );
    } else {
      if (!Platform.environment.containsKey('AG_TEST')) {
        final installProgress = Log.progress(
          'Installing standard packages (get, dio, logger, shared_preferences)...',
        );
        try {
          final res = await Process.run(
              'flutter',
              [
                'pub',
                'add',
                'get',
                'dio',
                'logger',
                'shared_preferences',
                'flutter_screenutil',
              ],
              runInShell: true);
          if (res.exitCode == 0) {
            installProgress.complete('Standard packages installed!');
          } else {
            installProgress.fail(
              'Failed to install packages. Run flutter pub add manually.',
            );
          }
        } catch (e) {
          installProgress.fail('Failed to install packages: $e');
        }
      }

      final mainFile = File(p.join(libDir, 'main.dart'));
      if (mainFile.existsSync()) {
        String mainContent = mainFile.readAsStringSync();
        if (mainContent.contains('MaterialApp(') && !mainContent.contains('GetMaterialApp(')) {
          mainContent = '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';
import 'utils/theme/app_theme.dart';
import 'core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put(ThemeService(prefs));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter App',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeService.find.themeMode,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.initial,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
''';
          mainFile.writeAsStringSync(mainContent);
          Log.success(
            'Rewrote lib/main.dart with ScreenUtilInit and GetMaterialApp',
          );
        }
      }

      final rootDir = p.dirname(libDir);
      final testFile = File(p.join(rootDir, 'test', 'widget_test.dart'));
      if (testFile.existsSync()) {
        String testContent = testFile.readAsStringSync();
        if (testContent.contains('MyApp')) {
          testContent = testContent.replaceAll('MyApp', 'MainApp');
          testFile.writeAsStringSync(testContent);
          Log.success('Rewrote test/widget_test.dart to use MainApp');
        }
      }

      final analysisFile = File(p.join(rootDir, 'analysis_options.yaml'));
      if (analysisFile.existsSync()) {
        String analysisContent = analysisFile.readAsStringSync();
        if (!analysisContent.contains('page_width:')) {
          if (!analysisContent.contains('formatter:')) {
            analysisContent += '\nformatter:\n  page_width: 140\n';
          } else {
            analysisContent = analysisContent.replaceFirst('formatter:', 'formatter:\n  page_width: 140');
          }
          analysisFile.writeAsStringSync(analysisContent);
          Log.success('Updated analysis_options.yaml with formatter page_width: 140');
        }
      } else {
        analysisFile.writeAsStringSync('''include: package:flutter_lints/flutter.yaml

formatter:
  page_width: 140
''');
        Log.success('Created analysis_options.yaml with formatter page_width: 140');
      }

      Log.info(
        '✅  Project structure initialized! Run `ag g module <name>` to create your first module.\n',
      );
    }

    return 0;
  }

  /// Shorthand write that returns 1 if written, 0 if skipped.
  int _w(
    String path,
    String content, {
    required bool dryRun,
    required bool force,
  }) {
    final written = writeFile(path, content, dryRun: dryRun, force: force);
    return (dryRun || written) ? 1 : 0;
  }
}
