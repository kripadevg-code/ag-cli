// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path/path.dart' as p;
import '../logger.dart';
import '../utils.dart';
import '../templates/init_templates.dart';

/// Runs the `ag init` command — scaffolds project folder structure.
void runInitCommand({
  String? packageOverride,
  String? outputOverride,
  bool dryRun = false,
  bool force = false,
}) {
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

  if (dryRun) Log.info('🔍  Dry run — no files will be created\n');

  Log.header('🏗️  Initializing GetX project structure');
  Log.dim('   package : $packageName');
  Log.dim('   output  : ${p.relative(libDir)}/\n');

  var count = 0;

  // ─── Routes ─────────────────────────────────────────────────────────────
  count += _w(p.join(libDir, 'routes', 'app_routes.dart'), appRoutesStub(),
      dryRun: dryRun, force: force);
  count += _w(
      p.join(libDir, 'routes', 'app_pages.dart'), appPagesStub(packageName),
      dryRun: dryRun, force: force);
  count += _w(p.join(libDir, 'routes', 'route_management.dart'),
      routeManagementStub(packageName),
      dryRun: dryRun, force: force);

  // ─── Constants ──────────────────────────────────────────────────────────
  count += _w(p.join(libDir, 'constants', 'enums.dart'), enumsStub(),
      dryRun: dryRun, force: force);

  // ─── Utils ──────────────────────────────────────────────────────────────
  count += _w(p.join(libDir, 'utils', 'dimens.dart'), dimensStub(),
      dryRun: dryRun, force: force);
  count += _w(p.join(libDir, 'utils', 'utility.dart'), utilityStub(),
      dryRun: dryRun, force: force);

  // ─── APIs ───────────────────────────────────────────────────────────────
  count += _w(p.join(libDir, 'apis', 'providers', 'api_provider.dart'),
      apiProviderStub(),
      dryRun: dryRun, force: force);

  // ─── Core ───────────────────────────────────────────────────────────────
  count += _w(
      p.join(libDir, 'core', 'isolate_handler.dart'), isolateHandlerStub(),
      dryRun: dryRun, force: force);

  // ─── Empty directories ──────────────────────────────────────────────────
  final emptyDirs = [
    'modules',
    'model',
    'helpers',
    'resources',
    'services',
    'widgets',
    'extensions',
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
        '$count files + ${emptyDirs.length} directories would be created.');
  } else {
    Log.info(
        '✅  Project structure initialized! Run `ag g module <name>` to create your first module.\n');
  }
}

/// Shorthand write that returns 1 if written, 0 if skipped.
int _w(String path, String content,
    {required bool dryRun, required bool force}) {
  writeFile(path, content, dryRun: dryRun, force: force);
  return 1;
}

/// Prints init command usage.
void printInitUsage() {
  print('''
Usage: ag init [options]

Scaffolds the standard GetX project folder structure inside lib/:

  lib/
  ├── apis/providers/api_provider.dart
  ├── constants/enums.dart
  ├── core/isolate_handler.dart
  ├── helpers/
  ├── model/
  ├── modules/
  ├── resources/
  ├── routes/
  │   ├── app_routes.dart
  │   ├── app_pages.dart
  │   └── route_management.dart
  ├── services/
  ├── utils/
  │   ├── dimens.dart
  │   └── utility.dart
  ├── widgets/
  └── extensions/

Options:
  -p, --package <name>  Flutter package name (auto-detected from pubspec.yaml)
  -o, --output <path>   Output lib/ directory (auto-detected if omitted)
  -d, --dry-run         Preview without writing files
  --force               Overwrite existing files

Example:
  ag init
  ag init --dry-run
  ag init --package my_app --output apps/client/lib
''');
}
