// ignore_for_file: avoid_print
import 'dart:io';
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

/// Resolves the sub-generator name from input + alias.
///
/// Supports: module/m, component/c, model, repo/r,
///           controller/ctrl, binding/b, page/p
String? resolveGeneratorName(String input) {
  const aliases = <String, String>{
    'module': 'module',
    'm': 'module',
    'component': 'component',
    'c': 'component',
    'model': 'model',
    'repo': 'repo',
    'r': 'repo',
    'repository': 'repo',
    'controller': 'controller',
    'ctrl': 'controller',
    'binding': 'binding',
    'b': 'binding',
    'page': 'page',
    'p': 'page',
  };
  return aliases[input.toLowerCase()];
}

/// Runs the `generate` command.
void runGenerateCommand({
  required String generatorName,
  required String rawName,
  String? moduleOverride,
  String? packageOverride,
  String? outputOverride,
  bool isFull = false,
  bool isMinimal = false,
  bool isSearch = false,
  bool dryRun = false,
  bool force = false,
}) {
  final name = toSnake(rawName);
  final cls = toPascal(rawName);

  // ─── Resolve lib dir ────────────────────────────────────────────────────
  final libDir = outputOverride != null
      ? p.join(Directory.current.path, outputOverride)
      : findLibDir();
  if (libDir == null) {
    Log.error(
        'Could not find lib/ directory. Run from project root or pass --output <path>.');
    exit(1);
  }

  // ─── Resolve package name ───────────────────────────────────────────────
  final packageName = packageOverride ?? detectPackageName();
  if (packageName == null) {
    Log.error('Could not detect package name. Pass --package <name>.');
    exit(1);
  }

  // ─── Resolve module name (for individual generators) ────────────────────
  final moduleName = moduleOverride != null ? toSnake(moduleOverride) : null;

  // ─── Route to correct generator ─────────────────────────────────────────
  switch (generatorName) {
    case 'module':
      _generateModule(
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        isFull: isFull,
        isMinimal: isMinimal,
        isSearch: isSearch,
        dryRun: dryRun,
        force: force,
      );
    case 'component':
      _generateSingleFile(
        type: 'component',
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        subDir: 'components',
        suffix: '',
        template: componentTemplate(name, cls, packageName),
        dryRun: dryRun,
        force: force,
      );
    case 'model':
      _generateModel(
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        dryRun: dryRun,
        force: force,
      );
    case 'repo':
      _generateSingleFile(
        type: 'repo',
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        subDir: 'repos',
        suffix: '_repo',
        template: repoTemplate(name, cls, packageName),
        dryRun: dryRun,
        force: force,
      );
    case 'controller':
      final template = isMinimal
          ? controllerMinimalTemplate(name, cls, packageName)
          : controllerSearchTemplate(name, cls, packageName);
      _generateSingleFile(
        type: 'controller',
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        subDir: 'controllers',
        suffix: '_controller',
        template: template,
        dryRun: dryRun,
        force: force,
      );
    case 'binding':
      _generateSingleFile(
        type: 'binding',
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        subDir: 'bindings',
        suffix: '_binding',
        template: bindingTemplate(name, cls, packageName),
        dryRun: dryRun,
        force: force,
      );
    case 'page':
      final mode = isMinimal
          ? GeneratorMode.minimal
          : (isSearch ? GeneratorMode.search : GeneratorMode.full);
      _generateSingleFile(
        type: 'page',
        name: name,
        cls: cls,
        libDir: libDir,
        packageName: packageName,
        moduleName: moduleName,
        subDir: 'pages',
        suffix: '_page',
        template: pageTemplate(name, cls, packageName, mode),
        dryRun: dryRun,
        force: force,
      );
    default:
      Log.error('Unknown generator: $generatorName');
      exit(1);
  }
}

// ─── Module generator (delegates to ModuleGenerator) ──────────────────────

void _generateModule({
  required String name,
  required String cls,
  required String libDir,
  required String packageName,
  required bool isFull,
  required bool isMinimal,
  required bool isSearch,
  required bool dryRun,
  required bool force,
}) {
  final mode = isMinimal
      ? GeneratorMode.minimal
      : (isSearch ? GeneratorMode.search : GeneratorMode.full);

  ModuleGenerator(
    moduleName: name,
    className: cls,
    libDir: libDir,
    packageName: packageName,
    mode: mode,
    dryRun: dryRun,
    force: force,
  ).generate();
}

// ─── Model generator (creates model + response model) ──────────────────────

void _generateModel({
  required String name,
  required String cls,
  required String libDir,
  required String packageName,
  required String? moduleName,
  required bool dryRun,
  required bool force,
}) {
  final mod = moduleName ?? name;
  final base = p.join(libDir, 'modules', mod, 'models');

  if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

  Log.header('📦  Generating model [$cls]');
  Log.dim('   package : $packageName');
  Log.dim('   output  : ${p.relative(base)}/\n');

  var count = 0;
  writeFile(
      p.join(base, '${name}_model.dart'), modelTemplate(mod, cls, packageName),
      dryRun: dryRun, force: force);
  count++;

  writeFile(p.join(base, '${name}_response_model.dart'),
      responseModelTemplate(mod, cls, packageName),
      dryRun: dryRun, force: force);
  count++;

  Log.blank();
  if (dryRun) {
    Log.info('$count files would be created.');
  } else {
    Log.info('✅  $count model files created.\n');
  }
}

// ─── Single-file generator ─────────────────────────────────────────────────

void _generateSingleFile({
  required String type,
  required String name,
  required String cls,
  required String libDir,
  required String packageName,
  required String? moduleName,
  required String subDir,
  required String suffix,
  required String template,
  required bool dryRun,
  required bool force,
}) {
  // If --module not given, try auto-detect from CWD, else use the name itself
  final mod = moduleName ?? detectModuleFromCwd() ?? name;

  final filePath = p.join(libDir, 'modules', mod, subDir, '$name$suffix.dart');

  if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

  Log.header('📦  Generating $type [$cls]');
  Log.dim('   module  : $mod');
  Log.dim('   package : $packageName\n');

  writeFile(filePath, template, dryRun: dryRun, force: force);

  Log.blank();
  if (dryRun) {
    Log.info('1 file would be created.');
  } else {
    Log.info('✅  Done!\n');
  }
}

/// Prints generate sub-command usage.
void printGenerateUsage() {
  print('''
Usage: ag generate <type> <name> [options]
       ag g <type> <name> [options]

Types:
  module      (m)       Full GetX module (repo + controller + binding + page + components)
  component   (c)       Single StatelessWidget
  model                 Data model class with fromJson / toJson
  repo        (r)       Repository (abstract interface + implementation)
  controller  (ctrl)    GetxController with ScrollMixin
  binding     (b)       GetX Binding class
  page        (p)       StatelessWidget page with GetBuilder

Module flags (for module/controller/page):
  -f, --full            Full with search + filters + history + smart refresh (default)
  -m, --minimal         Minimal — no search, no filters
  -s, --search          Search + history, no filter chips

Options:
  --module <name>       Target module name (auto-detected from CWD if omitted)
  -p, --package <name>  Flutter package name (auto-detected from pubspec.yaml)
  -o, --output <path>   Output lib/ directory (auto-detected if omitted)
  -d, --dry-run         Preview what would be generated without writing files
  --force               Overwrite existing files

Examples:
  ag g module problem --full
  ag g m profile --minimal
  ag g model user --module problem
  ag g c filter_tag --module tickets
  ag g r approval
  ag g ctrl dashboard --search
  ag g module incidents --dry-run
''');
}
