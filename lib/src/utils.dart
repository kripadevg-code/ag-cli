// ignore_for_file: avoid_print
import 'dart:io';
import 'package:path/path.dart' as p;
import 'logger.dart';

/// CLI version — single source of truth.
const String cliVersion = '2.1.0';

/// Converts any string to snake_case.
String toSnake(String input) => input
    .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}')
    .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
    .replaceAll(RegExp(r'_+'), '_')
    .replaceAll(RegExp(r'^_|_$'), '');

/// Converts any string to PascalCase.
String toPascal(String input) =>
    input.split(RegExp(r'[_\s\-]+')).where((s) => s.isNotEmpty).map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase()).join();

/// Converts any string to camelCase.
String toCamel(String input) {
  final pascal = toPascal(input);
  if (pascal.isEmpty) return pascal;
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String? resolveGeneratorName(String input) {
  const aliases = <String, String>{
    // ─── Module ───────────────────────────────────────────────────────────
    'module': 'module',
    'm': 'module',
    // ─── Component ────────────────────────────────────────────────────────
    'component': 'component',
    'c': 'component',
    // ─── Model ────────────────────────────────────────────────────────────
    'model': 'model',
    'mo': 'model',
    // ─── Repository ───────────────────────────────────────────────────────
    'repo': 'repo',
    'r': 'repo',
    'repository': 'repo',
    // ─── Service ──────────────────────────────────────────────────────────
    'service': 'service',
    'svc': 'service',
    's': 'service',
    // ─── Controller ───────────────────────────────────────────────────────
    'controller': 'controller',
    'ctrl': 'controller',
    'co': 'controller',
    // ─── Binding ──────────────────────────────────────────────────────────
    'binding': 'binding',
    'b': 'binding',
    // ─── Page ─────────────────────────────────────────────────────────────
    'page': 'page',
    'p': 'page',
    'pg': 'page',
    // ─── Enum (Flutter equivalent of ng g enum) ───────────────────────────
    'enum': 'enum',
    'e': 'enum',
    // ─── Interface / Abstract class ───────────────────────────────────────
    'interface': 'interface',
    'i': 'interface',
    // ─── Guard (route guard) ──────────────────────────────────────────────
    'guard': 'guard',
    'gu': 'guard',
    // ─── Middleware / Interceptor ─────────────────────────────────────────
    'interceptor': 'interceptor',
    'in': 'interceptor',
    // ─── Mixin ────────────────────────────────────────────────────────────
    'mixin': 'mixin',
    'mx': 'mixin',
    // ─── Extension ────────────────────────────────────────────────────────
    'extension': 'extension',
    'ex': 'extension',
  };
  return aliases[input.toLowerCase()];
}

/// Creates a file at [filePath] with [content], creating parent dirs as needed.
///
/// Returns `true` if file was written, `false` if skipped.
/// When [dryRun] is true, only logs what would happen.
/// When [force] is false and file exists, skips it.
bool writeFile(
  String filePath,
  String content, {
  bool dryRun = false,
  bool force = false,
}) {
  final rel = p.relative(filePath);
  final file = File(filePath);

  if (dryRun) {
    Log.dryRun(rel);
    return false;
  }

  if (file.existsSync() && !force) {
    Log.warn('$rel already exists (skipped, use --force to overwrite)');
    return false;
  }

  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
  Log.success(rel);
  return true;
}

/// Auto-detects the Flutter package name by reading pubspec.yaml from
/// [startDir] upward (max 6 levels). Returns null if not found.
String? detectPackageName([Directory? startDir]) {
  var dir = startDir ?? Directory.current;
  for (var i = 0; i < 6; i++) {
    final pubspec = File(p.join(dir.path, 'pubspec.yaml'));
    if (pubspec.existsSync()) {
      final lines = pubspec.readAsLinesSync();
      for (final line in lines) {
        if (line.trimLeft().startsWith('name:')) {
          final name = line.split(':').last.trim();
          if (name.isNotEmpty) return name;
        }
      }
    }
    dir = dir.parent;
  }
  return null;
}

/// Finds the Flutter lib directory. Searches for:
///   [root]/lib/   (single-app project)
///   [root]/apps/client/lib/   (monorepo)
/// Returns null if not found.
String? findLibDir([Directory? startDir]) {
  var dir = startDir ?? Directory.current;
  for (var i = 0; i < 6; i++) {
    // Monorepo pattern
    final monoLib = Directory(p.join(dir.path, 'apps', 'client', 'lib'));
    if (monoLib.existsSync()) return monoLib.path;

    // Standard single-app project
    final singleLib = Directory(p.join(dir.path, 'lib'));
    if (singleLib.existsSync() && File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return singleLib.path;
    }
    dir = dir.parent;
  }
  return null;
}

/// Tries to detect which module the user is currently inside of
/// by looking at the CWD path for a `/modules/<name>/` segment.
/// Returns the module name or null.
String? detectModuleFromCwd([Directory? startDir]) {
  final dir = startDir ?? Directory.current;
  final parts = p.split(dir.path);
  for (var i = 0; i < parts.length - 1; i++) {
    if (parts[i] == 'modules') return parts[i + 1];
  }
  return null;
}
