// ignore_for_file: avoid_print
import 'dart:io';
import 'package:args/args.dart';
import 'package:ag_cli/src/logger.dart';
import 'package:ag_cli/src/utils.dart';
import 'package:ag_cli/src/commands/generate_command.dart';
import 'package:ag_cli/src/commands/init_command.dart';
import 'package:ag_cli/src/commands/list_command.dart';

void main(List<String> args) {
  // ─── Top-level flags (--version, --help) ────────────────────────────────
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    _printUsage();
    exit(args.isEmpty ? 1 : 0);
  }

  if (args.contains('--version') || args.contains('-v')) {
    print('ag_cli v$cliVersion');
    exit(0);
  }

  // ─── Route to command ───────────────────────────────────────────────────
  final command = args.first;

  switch (command) {
    case 'generate' || 'g':
      _handleGenerate(args.sublist(1));
    case 'init':
      _handleInit(args.sublist(1));
    case 'list' || 'ls':
      runListCommand();
    default:
      Log.error('Unknown command: $command');
      Log.blank();
      _printUsage();
      exit(1);
  }
}

// ─── Generate ──────────────────────────────────────────────────────────────

void _handleGenerate(List<String> args) {
  if (args.isEmpty) {
    printGenerateUsage();
    exit(1);
  }

  final typeName = resolveGeneratorName(args.first);
  if (typeName == null) {
    Log.error('Unknown generator type: ${args.first}');
    Log.blank();
    printGenerateUsage();
    exit(1);
  }

  final parser = ArgParser()
    ..addFlag('full',
        abbr: 'f',
        negatable: false,
        help: 'Full: search + filters + history + smart refresh')
    ..addFlag('minimal',
        abbr: 'm', negatable: false, help: 'Minimal: no search, no filters')
    ..addFlag('search',
        abbr: 's', negatable: false, help: 'Search + history, no filter chips')
    ..addFlag('dry-run',
        abbr: 'd', negatable: false, help: 'Preview without writing files')
    ..addFlag('force', negatable: false, help: 'Overwrite existing files')
    ..addOption('module',
        help: 'Target module name (auto-detected from CWD if omitted)')
    ..addOption('package',
        abbr: 'p',
        help: 'Flutter package name (auto-detected from pubspec.yaml)')
    ..addOption('output',
        abbr: 'o', help: 'Output lib/ directory (auto-detected if omitted)');

  ArgResults result;
  try {
    result = parser.parse(args.sublist(1));
  } catch (e) {
    Log.error('$e');
    Log.blank();
    printGenerateUsage();
    exit(1);
  }

  if (result.rest.isEmpty) {
    Log.error('Name required.\n\nUsage: ag g $typeName <name> [options]');
    exit(1);
  }

  final rawName = result.rest.first.trim();

  runGenerateCommand(
    generatorName: typeName,
    rawName: rawName,
    moduleOverride: result['module'] as String?,
    packageOverride: result['package'] as String?,
    outputOverride: result['output'] as String?,
    isFull: result['full'] as bool,
    isMinimal: result['minimal'] as bool,
    isSearch: result['search'] as bool,
    dryRun: result['dry-run'] as bool,
    force: result['force'] as bool,
  );
}

// ─── Init ──────────────────────────────────────────────────────────────────

void _handleInit(List<String> args) {
  final parser = ArgParser()
    ..addFlag('dry-run',
        abbr: 'd', negatable: false, help: 'Preview without writing files')
    ..addFlag('force', negatable: false, help: 'Overwrite existing files')
    ..addOption('package',
        abbr: 'p',
        help: 'Flutter package name (auto-detected from pubspec.yaml)')
    ..addOption('output',
        abbr: 'o', help: 'Output lib/ directory (auto-detected if omitted)');

  ArgResults result;
  try {
    result = parser.parse(args);
  } catch (e) {
    Log.error('$e');
    Log.blank();
    printInitUsage();
    exit(1);
  }

  if (result.rest.isNotEmpty && result.rest.first == '--help') {
    printInitUsage();
    exit(0);
  }

  runInitCommand(
    packageOverride: result['package'] as String?,
    outputOverride: result['output'] as String?,
    dryRun: result['dry-run'] as bool,
    force: result['force'] as bool,
  );
}

// ─── Help ──────────────────────────────────────────────────────────────────

void _printUsage() {
  print('''

\x1B[1m\x1B[36m  ag\x1B[0m \x1B[90mv$cliVersion\x1B[0m
\x1B[90m  Flutter GetX code generator — install once, use anywhere.\x1B[0m

\x1B[1mUsage:\x1B[0m ag <command> [arguments]

\x1B[1mCommands:\x1B[0m
  \x1B[36mgenerate\x1B[0m (g)    Generate a module, component, model, repo, controller, binding, or page
  \x1B[36minit\x1B[0m             Scaffold the standard GetX project folder structure
  \x1B[36mlist\x1B[0m (ls)        Show all available generators

\x1B[1mGlobal flags:\x1B[0m
  -v, --version    Show CLI version
  -h, --help       Show this help message

\x1B[1mExamples:\x1B[0m
  ag g module problem --full       Generate a full GetX module
  ag g m profile --minimal         Generate a minimal module (shortcut)
  ag g model user --module problem Generate a model inside problem module
  ag g c filter_tag --module tickets Generate a component
  ag init                          Scaffold project structure
  ag list                          Show available generators
  ag g module test --dry-run       Preview without writing files
''');
}
