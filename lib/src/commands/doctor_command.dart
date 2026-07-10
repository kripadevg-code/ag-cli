import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../logger.dart';
import '../utils.dart';

class DoctorCommand extends Command<int> {
  @override
  final String name = 'doctor';

  @override
  final String description = 'Diagnose your environment and project for ag_cli compatibility.';

  @override
  Future<int> run() async {
    Log.header('🩺  ag_cli doctor\n');

    var issues = 0;

    // ─── 1. Dart SDK ──────────────────────────────────────────────────────────
    Log.header('  Environment');
    issues += await _checkDart();
    issues += await _checkFlutter();
    Log.blank();

    // ─── 2. Project ───────────────────────────────────────────────────────────
    Log.header('  Project');
    final libDir = await _checkProject();
    Log.blank();

    // ─── 3. ag init structure ─────────────────────────────────────────────────
    Log.header('  ag_cli Structure');
    if (libDir != null) {
      issues += _checkStructure(libDir);
    } else {
      Log.warn('Skipping structure check — lib/ not found');
      issues++;
    }
    Log.blank();

    // ─── Summary ──────────────────────────────────────────────────────────────
    if (issues == 0) {
      Log.success('✅  No issues found! Your project is ready for ag_cli.');
      Log.blank();
      Log.dim('  Next steps:');
      Log.dim('    ag init          → scaffold the full GetX project structure');
      Log.dim('    ag g m home      → generate your first module');
    } else {
      Log.error('❌  $issues issue${issues == 1 ? '' : 's'} found. Fix them before generating modules.');
    }

    Log.blank();
    return issues == 0 ? 0 : 1;
  }

  // ─── Checks ─────────────────────────────────────────────────────────────────

  Future<int> _checkDart() async {
    try {
      final result = await Process.run('dart', ['--version'], runInShell: true);
      final output = (result.stdout as String).trim().isNotEmpty ? (result.stdout as String).trim() : (result.stderr as String).trim();

      // Extract version number
      final versionMatch = RegExp(r'(\d+\.\d+\.\d+)').firstMatch(output);
      if (versionMatch != null) {
        final parts = versionMatch.group(1)!.split('.').map(int.parse).toList();
        if (parts[0] >= 3) {
          Log.success('Dart SDK ${versionMatch.group(1)} (≥ 3.0.0 required)');
          return 0;
        } else {
          Log.error('Dart SDK ${versionMatch.group(1)} is too old. Requires ≥ 3.0.0');
          return 1;
        }
      }
      Log.warn('Dart SDK found but version could not be parsed');
      return 0;
    } catch (_) {
      Log.error('Dart SDK not found. Install from https://dart.dev/get-dart');
      return 1;
    }
  }

  Future<int> _checkFlutter() async {
    try {
      final result = await Process.run('flutter', ['--version'], runInShell: true);
      final output = (result.stdout as String).trim();
      final versionMatch = RegExp(r'Flutter (\d+\.\d+\.\d+)').firstMatch(output);
      if (versionMatch != null) {
        Log.success('Flutter ${versionMatch.group(1)} found');
      } else {
        Log.success('Flutter SDK found');
      }
      return 0;
    } catch (_) {
      Log.error('Flutter SDK not found. Install from https://flutter.dev/docs/get-started');
      return 1;
    }
  }

  Future<String?> _checkProject() async {
    final pubspecFile = File(p.join(Directory.current.path, 'pubspec.yaml'));

    if (!pubspecFile.existsSync()) {
      Log.error('pubspec.yaml not found. Run ag_cli from a Flutter project root.');
      return null;
    }
    Log.success('pubspec.yaml found');

    final content = pubspecFile.readAsStringSync();

    // Check package name
    final nameMatch = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
    if (nameMatch != null) {
      Log.success('Package name: ${nameMatch.group(1)!.trim()}');
    }

    // Check get package
    if (content.contains(RegExp(r'\n\s*get:\s*'))) {
      Log.success('get package found in dependencies');
    } else {
      Log.warn('get package not found in dependencies. Run: flutter pub add get');
    }

    // Check dio
    if (content.contains(RegExp(r'\n\s*dio:\s*'))) {
      Log.success('dio package found in dependencies');
    } else {
      Log.dim('  ○  dio not found (optional — needed for API layer)');
    }

    // Check flutter_screenutil
    if (content.contains(RegExp(r'\n\s*flutter_screenutil:\s*'))) {
      Log.success('flutter_screenutil found in dependencies');
    } else {
      Log.dim('  ○  flutter_screenutil not found (optional — needed for Dimens)');
    }

    final libDir = findLibDir();
    if (libDir == null) {
      Log.error('lib/ directory not found');
      return null;
    }
    Log.success('lib/ directory found at ${p.relative(libDir)}/');
    return libDir;
  }

  int _checkStructure(String libDir) {
    var issues = 0;

    final checks = <String, String>{
      p.join(libDir, 'routes', 'app_routes.dart'): 'routes/app_routes.dart',
      p.join(libDir, 'routes', 'app_pages.dart'): 'routes/app_pages.dart',
      p.join(libDir, 'routes', 'route_management.dart'): 'routes/route_management.dart',
      p.join(libDir, 'constants', 'enums.dart'): 'constants/enums.dart',
      p.join(libDir, 'apis', 'providers', 'api_provider.dart'): 'apis/providers/api_provider.dart',
      p.join(libDir, 'core', 'bindings', 'initial_binding.dart'): 'core/bindings/initial_binding.dart',
      p.join(libDir, 'core', 'isolate_handler.dart'): 'core/isolate_handler.dart',
    };

    var initialized = true;
    for (final entry in checks.entries) {
      if (File(entry.key).existsSync()) {
        Log.success(entry.value);
      } else {
        Log.warn('${entry.value} missing');
        initialized = false;
      }
    }

    if (!initialized) {
      Log.blank();
      Log.info('  Run `ag init` to scaffold the full GetX project structure.');
      issues++;
    }

    return issues;
  }
}
