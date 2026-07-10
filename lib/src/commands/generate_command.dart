import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../logger.dart';
import '../utils.dart';
import '../generator.dart';
import '../templates/repo_template.dart';
import '../templates/controller_template.dart';
import '../templates/binding_template.dart';
import '../templates/page_template.dart';
import '../templates/model_template.dart';
import '../templates/component_template.dart';
import '../templates/module_service_template.dart';
import '../templates/extra_templates.dart';

class GenerateCommand extends Command<int> {
  @override
  final String name = 'generate';

  @override
  final String description = 'Generate a module, component, model, repo, service, controller, '
      'binding, page, enum, interface, guard, interceptor, mixin, or extension.';

  @override
  final List<String> aliases = ['g'];

  GenerateCommand() {
    argParser
      // ─── Module modes ──────────────────────────────────────────────────
      ..addFlag('full', abbr: 'f', negatable: false, help: 'Full: search + filters + history + smart refresh')
      ..addFlag('minimal', negatable: false, help: 'Minimal: no search, no filters')
      ..addFlag('search', negatable: false, help: 'Search + history, no filter chips')
      // ─── Angular-parity flags ─────────────────────────────────────────
      ..addFlag('dry-run', abbr: 'd', negatable: false, help: 'Preview without writing files')
      ..addFlag('force', negatable: false, help: 'Overwrite existing files')
      ..addFlag('flat', negatable: false, help: 'Place file at the module root instead of a sub-folder')
      ..addFlag('defaults', negatable: false, help: 'Skip interactive prompts and use default values')
      // ─── Project overrides ────────────────────────────────────────────
      ..addOption('package', abbr: 'p', help: 'Flutter package name (auto-detected from pubspec.yaml)')
      ..addOption('output', abbr: 'o', help: 'Output lib/ directory (auto-detected if omitted)');
  }

  @override
  String get invocation => 'ag generate <type> [<module>/]<name> [options]\n'
      '       ag g     <type> [<module>/]<name> [options]\n\n'
      '  Angular-style path — module prefix sets target folder and compound name:\n'
      '    ag g page   checkout           → CheckoutPage inside lib/modules/checkout/pages/\n'
      '    ag g page   orders/checkout    → OrdersCheckoutPage inside lib/modules/orders/pages/\n'
      '    ag g ctrl   orders/dashboard   → OrdersDashboardController inside lib/modules/orders/controllers/\n'
      '    ag g guard  auth               → AuthGuard inside lib/modules/auth/guards/\n\n'
      '  Types:\n'
      '    module(m)  component(c)   model(mo)    repo(r)    service(s/svc)\n'
      '    ctrl(co)   binding(b)     page(p/pg)   enum(e)    interface(i)\n'
      '    guard(gu)  interceptor(in) mixin(mx)   extension(ex)';

  @override
  Future<int> run() async {
    final rest = argResults?.rest ?? [];
    final useDefaults = argResults?['defaults'] as bool? ?? false;

    String? typeName;
    String? rawName;

    if (rest.isEmpty) {
      typeName = Log.chooseOne(
        prompt: 'What do you want to generate?',
        choices: [
          'module',
          'component',
          'model',
          'repo',
          'service',
          'controller',
          'binding',
          'page',
          'enum',
          'interface',
          'guard',
          'interceptor',
          'mixin',
          'extension',
        ],
      );
      rawName = Log.prompt('Name (e.g. "checkout" or "orders/checkout"):').trim();
      if (rawName.isEmpty) {
        Log.error('Name cannot be empty.');
        return 1;
      }
    } else {
      typeName = resolveGeneratorName(rest.first);
      if (typeName == null) {
        Log.error('Unknown generator type: ${rest.first}');
        printUsage();
        return 1;
      }
      if (rest.length < 2) {
        rawName = Log.prompt('Name (e.g. "checkout" or "orders/checkout"):').trim();
        if (rawName.isEmpty) {
          Log.error('Name cannot be empty.');
          return 1;
        }
      } else {
        rawName = rest[1].trim();
      }
    }

    // ─── Angular-style path parsing ──────────────────────────────────────
    // "orders/dashboard" → module=orders, name=orders_dashboard, cls=OrdersDashboard
    //                      file: lib/modules/orders/controllers/orders_dashboard_controller.dart
    // "dashboard"        → module=dashboard, name=dashboard, cls=Dashboard
    //                      file: lib/modules/dashboard/controllers/dashboard_controller.dart
    //
    // The prefix becomes part of the compound name — same as Angular CLI where
    // `ng g c orders/order-item` gives OrderItemComponent inside the orders folder.
    final String? parsedModule;
    final String parsedName;
    String componentPath = '';

    if (rawName.contains('/')) {
      final parts = rawName.split('/');
      parsedModule = toSnake(parts.first);

      final suffixParts = parts.sublist(1).map(toSnake);
      final suffix = suffixParts.join('_');
      componentPath = suffixParts.join('/');

      // Compound name: orders + details_header = orders_details_header
      // But skip prefix if it's already embedded: orders/orders_detail → orders_detail
      parsedName = suffix.startsWith(parsedModule) ? suffix : '${parsedModule}_$suffix';
    } else {
      parsedModule = null;
      parsedName = toSnake(rawName);
    }

    final name = parsedName;
    final cls = toPascal(parsedName); // e.g. OrdersDashboard
    final moduleName = parsedModule ?? detectModuleFromCwd();
    final effectiveMod = moduleName ?? toSnake(cls);

    final outputOverride = argResults?['output'] as String?;
    final packageOverride = argResults?['package'] as String?;
    final flat = argResults?['flat'] as bool? ?? false;

    final componentSubDir = flat ? '' : (componentPath.isEmpty ? 'components' : 'components/$componentPath');

    bool isFull = argResults?['full'] as bool? ?? false;
    bool isMinimal = argResults?['minimal'] as bool? ?? false;
    bool isSearch = argResults?['search'] as bool? ?? false;

    // Ask mode interactively unless --defaults is set
    final needsModePrompt = (typeName == 'module' || typeName == 'page' || typeName == 'controller') && !isFull && !isMinimal && !isSearch;
    if (needsModePrompt && !useDefaults) {
      final modeChoice = Log.chooseOne(
        prompt: 'Which mode do you prefer?',
        choices: ['Full (Search + Filters)', 'Minimal (No Search)', 'Search Only'],
      );
      if (modeChoice.startsWith('Full')) isFull = true;
      if (modeChoice.startsWith('Minimal')) isMinimal = true;
      if (modeChoice.startsWith('Search Only')) isSearch = true;
    } else if (needsModePrompt && useDefaults) {
      isFull = true; // default mode
    }

    final dryRun = argResults?['dry-run'] as bool? ?? false;
    final force = argResults?['force'] as bool? ?? false;

    // ─── Resolve lib dir ─────────────────────────────────────────────────
    final libDir = outputOverride != null ? p.join(Directory.current.path, outputOverride) : findLibDir();
    if (libDir == null) {
      Log.error('Could not find lib/ directory. Run from project root or pass --output <path>.');
      return 1;
    }

    // ─── Resolve package name ─────────────────────────────────────────────
    final packageName = packageOverride ?? detectPackageName();
    if (packageName == null) {
      Log.error('Could not detect package name. Pass --package <name>.');
      return 1;
    }

    // ─── Route to correct generator ───────────────────────────────────────
    switch (typeName) {
      // ─── Module ───────────────────────────────────────────────────────
      case 'module':
        _generateModule(
          moduleDir: effectiveMod,
          fileNamePrefix: name,
          componentSubDir: componentSubDir,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          isFull: isFull,
          isMinimal: isMinimal,
          isSearch: isSearch,
          dryRun: dryRun,
          force: force,
        );

      // ─── Component ────────────────────────────────────────────────────
      case 'component':
        _generateSingleFile(
          type: 'component',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: componentSubDir,
          suffix: '',
          template: componentTemplate(name, cls, packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Model ────────────────────────────────────────────────────────
      case 'model':
        _generateModel(
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          dryRun: dryRun,
          force: force,
        );

      // ─── Repository ───────────────────────────────────────────────────
      case 'repo':
        _generateSingleFile(
          type: 'repo',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'repos',
          suffix: '_repo',
          template: repoTemplate(effectiveMod, name, cls, packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Service ──────────────────────────────────────────────────────
      case 'service':
        _generateSingleFile(
          type: 'service',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'services',
          suffix: '_service',
          template: moduleServiceTemplate(effectiveMod, name, cls, packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Controller ───────────────────────────────────────────────────
      case 'controller':
        final template = isMinimal
            ? controllerMinimalTemplate(effectiveMod, name, cls, packageName)
            : controllerSearchTemplate(effectiveMod, name, cls, packageName);
        _generateSingleFile(
          type: 'controller',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'controllers',
          suffix: '_controller',
          template: template,
          dryRun: dryRun,
          force: force,
        );

      // ─── Binding ──────────────────────────────────────────────────────
      case 'binding':
        _generateSingleFile(
          type: 'binding',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'bindings',
          suffix: '_binding',
          template: bindingTemplate(effectiveMod, name, cls, packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Page ─────────────────────────────────────────────────────────
      case 'page':
        final mode = isMinimal ? GeneratorMode.minimal : (isSearch ? GeneratorMode.search : GeneratorMode.full);
        _generateSingleFile(
          type: 'page',
          name: name,
          cls: cls,
          libDir: libDir,
          packageName: packageName,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'pages',
          suffix: '_page',
          template: pageTemplate(effectiveMod, name, componentPath, cls, packageName, mode),
          dryRun: dryRun,
          force: force,
        );

      // ─── Enum (ng g enum equivalent) ─────────────────────────────────
      case 'enum':
        _generateSimpleFile(
          type: 'enum',
          name: name,
          cls: '${cls}Enum',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'enums',
          suffix: '_enum',
          template: enumTemplate('${cls}Enum'),
          dryRun: dryRun,
          force: force,
        );

      // ─── Interface (ng g interface equivalent) ────────────────────────
      case 'interface':
        _generateSimpleFile(
          type: 'interface',
          name: name,
          cls: 'I$cls',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'interfaces',
          suffix: '.interface',
          template: interfaceTemplate('I$cls', packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Guard (ng g guard equivalent) ───────────────────────────────
      case 'guard':
        _generateSimpleFile(
          type: 'guard',
          name: name,
          cls: '${cls}Guard',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'guards',
          suffix: '_guard',
          template: guardTemplate('${cls}Guard', packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Interceptor (ng g interceptor equivalent) ────────────────────
      case 'interceptor':
        _generateSimpleFile(
          type: 'interceptor',
          name: name,
          cls: '${cls}Interceptor',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'interceptors',
          suffix: '_interceptor',
          template: interceptorTemplate('${cls}Interceptor', packageName),
          dryRun: dryRun,
          force: force,
        );

      // ─── Mixin ────────────────────────────────────────────────────────
      case 'mixin':
        _generateSimpleFile(
          type: 'mixin',
          name: name,
          cls: '${cls}Mixin',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'mixins',
          suffix: '_mixin',
          template: mixinTemplate('${cls}Mixin'),
          dryRun: dryRun,
          force: force,
        );

      // ─── Extension ────────────────────────────────────────────────────
      case 'extension':
        _generateSimpleFile(
          type: 'extension',
          name: name,
          cls: '${cls}Extension',
          libDir: libDir,
          moduleName: effectiveMod,
          subDir: flat ? '' : 'extensions',
          suffix: '_extension',
          template: extensionTemplate('${cls}Extension', 'dynamic'),
          dryRun: dryRun,
          force: force,
        );
    }
    return 0;
  }

  // ─── Generators ─────────────────────────────────────────────────────────

  void _generateModule({
    required String moduleDir,
    required String fileNamePrefix,
    required String componentSubDir,
    required String cls,
    required String libDir,
    required String packageName,
    required bool isFull,
    required bool isMinimal,
    required bool isSearch,
    required bool dryRun,
    required bool force,
  }) {
    final mode = isMinimal ? GeneratorMode.minimal : (isSearch ? GeneratorMode.search : GeneratorMode.full);
    ModuleGenerator(
      moduleDir: moduleDir,
      fileNamePrefix: fileNamePrefix,
      componentSubDir: componentSubDir,
      className: cls,
      libDir: libDir,
      packageName: packageName,
      mode: mode,
      dryRun: dryRun,
      force: force,
    ).generate();
  }

  void _generateModel({
    required String name,
    required String cls,
    required String libDir,
    required String packageName,
    required String moduleName,
    required bool dryRun,
    required bool force,
  }) {
    final base = p.join(libDir, 'modules', moduleName, 'models');
    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');
    final progress = Log.progress('Generating model [$cls]');
    var count = 0;

    writeFile(p.join(base, '${name}_model.dart'), modelTemplate(moduleName, name, cls, packageName), dryRun: dryRun, force: force);
    count++;

    writeFile(p.join(base, '${name}_response_model.dart'), responseModelTemplate(moduleName, name, cls, packageName),
        dryRun: dryRun, force: force);
    count++;

    if (dryRun) {
      progress.complete('$count files would be created.');
    } else {
      progress.complete('$count model files created.');
    }
  }

  /// For module-aware generators: places file inside `modules/mod/subDir/`
  void _generateSingleFile({
    required String type,
    required String name,
    required String cls,
    required String libDir,
    required String packageName,
    required String moduleName,
    required String subDir,
    required String suffix,
    required String template,
    required bool dryRun,
    required bool force,
  }) {
    final dir = subDir.isEmpty ? p.join(libDir, 'modules', moduleName) : p.join(libDir, 'modules', moduleName, subDir);
    final filePath = p.join(dir, '$name$suffix.dart');
    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');
    final progress = Log.progress('Generating $type [$cls]');
    writeFile(filePath, template, dryRun: dryRun, force: force);
    progress.complete(dryRun ? '1 file would be created.' : 'Done!');
  }

  /// For lib-level generators: places file inside `lib/subDir/`
  void _generateSimpleFile({
    required String type,
    required String name,
    required String cls,
    required String libDir,
    required String moduleName,
    required String subDir,
    required String suffix,
    required String template,
    required bool dryRun,
    required bool force,
  }) {
    final dir = subDir.isEmpty ? p.join(libDir, 'modules', moduleName) : p.join(libDir, 'modules', moduleName, subDir);
    final filePath = p.join(dir, '$name$suffix.dart');
    if (dryRun) Log.info('🔍  Dry run — no files will be created\n');
    final progress = Log.progress('Generating $type [$cls]');
    writeFile(filePath, template, dryRun: dryRun, force: force);
    progress.complete(dryRun ? '1 file would be created.' : 'Done!');
  }
}
