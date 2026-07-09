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
import 'templates/route_stub_template.dart';

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
    required this.moduleName,
    required this.className,
    required this.libDir,
    required this.packageName,
    required this.mode,
    this.dryRun = false,
    this.force = false,
  });

  /// The snake_case name of the module.
  final String moduleName;

  /// The PascalCase name of the module class.
  final String className;

  /// The absolute path to the `lib/` directory.
  final String libDir;

  /// The Flutter package name.
  final String packageName;

  /// The [GeneratorMode] defining what components to generate.
  final GeneratorMode mode;

  /// Whether to simulate generation without writing files.
  final bool dryRun;

  /// Whether to overwrite existing files.
  final bool force;

  String get _base => p.join(libDir, 'modules', moduleName);

  void generate() {
    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

    Log.header('🚀  Generating [$className] module (${mode.name})');
    Log.dim('   package : $packageName');
    Log.dim('   output  : ${p.relative(_base)}/\n');

    var count = 0;

    // Always generated
    _write('repos', '${moduleName}_repo.dart',
        repoTemplate(moduleName, className, packageName));
    count++;

    _write('bindings', '${moduleName}_binding.dart',
        bindingTemplate(moduleName, className, packageName));
    count++;

    _write('components', '${moduleName}_card.dart',
        cardTemplate(moduleName, className, packageName));
    count++;

    _write('', 'ROUTE_TODO.md', routeStubTemplate(moduleName, className));
    count++;

    // Controller — minimal vs full/search
    if (mode == GeneratorMode.minimal) {
      _write('controllers', '${moduleName}_controller.dart',
          controllerMinimalTemplate(moduleName, className, packageName));
    } else {
      _write('controllers', '${moduleName}_controller.dart',
          controllerSearchTemplate(moduleName, className, packageName));
    }
    count++;

    // Page
    _write('pages', '${moduleName}_page.dart',
        pageTemplate(moduleName, className, packageName, mode));
    count++;

    // AppBar (full + search only)
    if (mode != GeneratorMode.minimal) {
      _write('components', '${moduleName}_app_bar.dart',
          appBarTemplate(moduleName, className, packageName));
      count++;
    }

    // Filter chips (full only)
    if (mode == GeneratorMode.full) {
      _write('components', '${moduleName}_appbar_filter.dart',
          appBarFilterTemplate(moduleName, className, packageName));
      count++;
    }

    Log.blank();
    if (dryRun) {
      Log.info('$count files would be created.');
    } else {
      Log.info(
          '✅  Done! Fill TODOs then register the route (see ROUTE_TODO.md).\n');
    }
  }

  void _write(String subDir, String fileName, String content) {
    final path = subDir.isEmpty
        ? p.join(_base, fileName)
        : p.join(_base, subDir, fileName);
    writeFile(path, content, dryRun: dryRun, force: force);
  }
}
