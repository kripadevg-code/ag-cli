// ignore_for_file: avoid_print
import 'package:path/path.dart' as p;
import 'logger.dart';
import 'utils.dart';
import 'templates/repo_template.dart';
import 'templates/controller_template.dart';
import 'templates/binding_template.dart';
import 'templates/page_template.dart';
import 'templates/app_bar_template.dart';
import 'templates/card_template.dart';
import 'templates/module_service_template.dart';
import 'templates/model_template.dart';
import 'templates/route_stub_template.dart';
import 'route_injector.dart';

/// The mode in which the generator runs.
enum GeneratorMode {
  /// Full module with search, filters, history, and smart refresh.
  full,

  /// Minimal module with just repo, controller, binding, and page.
  minimal,

  /// Search module with history but no filter chips.
  search,
}

/// Core generator class that scaffolds a GetX module.
class ModuleGenerator {
  /// Creates a new [ModuleGenerator].
  ModuleGenerator({
    required this.moduleDir,
    required this.fileNamePrefix,
    required this.className,
    required this.libDir,
    required this.packageName,
    required this.mode,
    this.componentSubDir = 'components',
    this.dryRun = false,
    this.force = false,
  });

  /// The root directory for the module (e.g., 'orders').
  final String moduleDir;

  /// The prefix for generated files (e.g., 'orders_details').
  final String fileNamePrefix;

  /// The PascalCase name of the module class (e.g., 'OrdersDetails').
  final String className;

  /// The absolute path to the `lib/` directory.
  final String libDir;

  /// The Flutter package name.
  final String packageName;

  /// The [GeneratorMode] defining what components to generate.
  final GeneratorMode mode;

  /// The sub-directory inside components/ where widgets should be placed.
  final String componentSubDir;

  /// Whether to simulate generation without writing files.
  final bool dryRun;

  /// Whether to overwrite existing files.
  final bool force;

  String get _base => p.join(libDir, 'modules', moduleDir);

  void generate() {
    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

    final progress = Log.progress(
      'Generating [$className] module (${mode.name})',
    );

    var count = 0;

    // Always generated
    _write(
      'repos',
      '${fileNamePrefix}_repo.dart',
      repoTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    _write(
      'bindings',
      '${fileNamePrefix}_binding.dart',
      bindingTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    _write(
      'services',
      '${fileNamePrefix}_service.dart',
      moduleServiceTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    _write(
      componentSubDir,
      '${fileNamePrefix}_card.dart',
      cardTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    // Models
    _write(
      'models',
      '${fileNamePrefix}_model.dart',
      modelTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    _write(
      'models',
      '${fileNamePrefix}_response_model.dart',
      responseModelTemplate(moduleDir, fileNamePrefix, className, packageName),
    );
    count++;

    // Attempt auto-routing
    final injected = RouteInjector.injectRoutes(
      libDir: libDir,
      packageName: packageName,
      moduleDir: moduleDir,
      fileNamePrefix: fileNamePrefix,
      className: className,
      dryRun: dryRun,
    );

    if (!injected) {
      _write('', 'ROUTE_TODO.md', routeStubTemplate(moduleDir, fileNamePrefix, className));
      count++;
    }

    // Controller — minimal vs full/search
    if (mode == GeneratorMode.minimal) {
      _write(
        'controllers',
        '${fileNamePrefix}_controller.dart',
        controllerMinimalTemplate(moduleDir, fileNamePrefix, className, packageName),
      );
    } else {
      _write(
        'controllers',
        '${fileNamePrefix}_controller.dart',
        controllerSearchTemplate(moduleDir, fileNamePrefix, className, packageName),
      );
    }
    count++;

    // Page
    _write(
      'pages',
      '${fileNamePrefix}_page.dart',
      pageTemplate(moduleDir, fileNamePrefix, componentSubDir == 'components' ? '' : componentSubDir.replaceAll('components/', ''),
          className, packageName, mode),
    );
    count++;

    // AppBar (full + search only)
    if (mode != GeneratorMode.minimal) {
      _write(
        componentSubDir,
        '${fileNamePrefix}_app_bar.dart',
        appBarTemplate(moduleDir, fileNamePrefix, className, packageName),
      );
      count++;
    }

    // Filter chips (full only)
    if (mode == GeneratorMode.full) {
      _write(
        componentSubDir,
        '${fileNamePrefix}_appbar_filter.dart',
        appBarFilterTemplate(moduleDir, fileNamePrefix, className, packageName),
      );
      count++;
    }

    if (dryRun) {
      progress.complete('$count files would be created.');
    } else {
      if (injected) {
        progress.complete('Done! Module and routes successfully generated.');
      } else {
        progress.complete(
          'Done! Fill TODOs then register the route (see ROUTE_TODO.md).',
        );
      }
    }
  }

  void _write(String subDir, String fileName, String content) {
    final path = subDir.isEmpty ? p.join(_base, fileName) : p.join(_base, subDir, fileName);
    writeFile(path, content, dryRun: dryRun, force: force);
  }
}
