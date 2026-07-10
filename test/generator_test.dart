import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:ag_cli/src/generator.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('ag_cli_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  // ─── ModuleGenerator — full mode ──────────────────────────────────────────
  group('ModuleGenerator.full', () {
    late String libDir;

    setUp(() {
      libDir = tempDir.path;
      ModuleGenerator(
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.full,
      ).generate();
    });

    test('generates repo', () {
      expect(
        File(p.join(libDir, 'modules', 'orders', 'repos', 'orders_repo.dart')).existsSync(),
        isTrue,
      );
    });

    test('generates service', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'services',
          'orders_service.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates controller', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'controllers',
          'orders_controller.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates binding', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'bindings',
          'orders_binding.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates page', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'pages',
          'orders_page.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates app bar component (full mode)', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'components',
          'orders_app_bar.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates filter component (full mode only)', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'components',
          'orders_appbar_filter.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates model', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'models',
          'orders_model.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('generates response model', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'orders',
          'models',
          'orders_response_model.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('controller uses correct class name', () {
      final content = File(p.join(
        libDir,
        'modules',
        'orders',
        'controllers',
        'orders_controller.dart',
      )).readAsStringSync();
      expect(content, contains('class OrdersController'));
    });

    test('controller does not use bare enum syntax', () {
      final content = File(p.join(
        libDir,
        'modules',
        'orders',
        'controllers',
        'orders_controller.dart',
      )).readAsStringSync();
      // Must NOT contain bare enum syntax like "= .done"
      expect(content, isNot(contains('= .done')));
      expect(content, isNot(contains('= .loading')));
      expect(content, isNot(contains('= .error')));
      // Must use qualified enum
      expect(content, contains('LoadingStatus.'));
    });

    test('binding uses correct class name', () {
      final content = File(p.join(
        libDir,
        'modules',
        'orders',
        'bindings',
        'orders_binding.dart',
      )).readAsStringSync();
      expect(content, contains('class OrdersBinding'));
    });

    test('binding uses fenix: true', () {
      final content = File(p.join(
        libDir,
        'modules',
        'orders',
        'bindings',
        'orders_binding.dart',
      )).readAsStringSync();
      expect(content, contains('fenix: true'));
    });
  });

  // ─── ModuleGenerator — minimal mode ───────────────────────────────────────
  group('ModuleGenerator.minimal', () {
    late String libDir;

    setUp(() {
      libDir = tempDir.path;
      ModuleGenerator(
        moduleDir: 'profile',
        fileNamePrefix: 'profile',
        className: 'Profile',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.minimal,
      ).generate();
    });

    test('generates controller', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'profile',
          'controllers',
          'profile_controller.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('does NOT generate filter component in minimal mode', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'profile',
          'components',
          'profile_appbar_filter.dart',
        )).existsSync(),
        isFalse,
      );
    });

    test('does NOT generate app bar in minimal mode', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'profile',
          'components',
          'profile_app_bar.dart',
        )).existsSync(),
        isFalse,
      );
    });

    test('minimal controller does not use bare enum syntax', () {
      final content = File(p.join(
        libDir,
        'modules',
        'profile',
        'controllers',
        'profile_controller.dart',
      )).readAsStringSync();
      expect(content, isNot(contains('= .done')));
      expect(content, isNot(contains('= .loading')));
      expect(content, contains('LoadingStatus.'));
    });
  });

  // ─── ModuleGenerator — search mode ────────────────────────────────────────
  group('ModuleGenerator.search', () {
    late String libDir;

    setUp(() {
      libDir = tempDir.path;
      ModuleGenerator(
        moduleDir: 'tickets',
        fileNamePrefix: 'tickets',
        className: 'Tickets',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.search,
      ).generate();
    });

    test('generates app bar (search mode)', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'tickets',
          'components',
          'tickets_app_bar.dart',
        )).existsSync(),
        isTrue,
      );
    });

    test('does NOT generate filter in search mode', () {
      expect(
        File(p.join(
          libDir,
          'modules',
          'tickets',
          'components',
          'tickets_appbar_filter.dart',
        )).existsSync(),
        isFalse,
      );
    });
  });

  // ─── dry-run mode ─────────────────────────────────────────────────────────
  group('ModuleGenerator.dryRun', () {
    test('writes no files in dry-run mode', () {
      final libDir = tempDir.path;
      ModuleGenerator(
        moduleDir: 'invoices',
        fileNamePrefix: 'invoices',
        className: 'Invoices',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.full,
        dryRun: true,
      ).generate();

      final moduleDir = Directory(p.join(libDir, 'modules', 'invoices'));
      expect(moduleDir.existsSync(), isFalse);
    });
  });

  // ─── force flag ───────────────────────────────────────────────────────────
  group('ModuleGenerator.force', () {
    test('overwrites existing file when force=true', () {
      final libDir = tempDir.path;
      final controllerPath = p.join(
        libDir,
        'modules',
        'orders',
        'controllers',
        'orders_controller.dart',
      );

      // Write a sentinel file
      File(controllerPath).createSync(recursive: true);
      File(controllerPath).writeAsStringSync('// sentinel');

      ModuleGenerator(
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.full,
        force: true,
      ).generate();

      expect(
        File(controllerPath).readAsStringSync(),
        isNot(contains('// sentinel')),
      );
    });

    test('skips existing file when force=false', () {
      final libDir = tempDir.path;
      final controllerPath = p.join(
        libDir,
        'modules',
        'orders',
        'controllers',
        'orders_controller.dart',
      );

      File(controllerPath).createSync(recursive: true);
      File(controllerPath).writeAsStringSync('// sentinel');

      ModuleGenerator(
        moduleDir: 'orders',
        fileNamePrefix: 'orders',
        className: 'Orders',
        libDir: libDir,
        packageName: 'my_app',
        mode: GeneratorMode.full,
        force: false,
      ).generate();

      expect(
        File(controllerPath).readAsStringSync(),
        contains('// sentinel'),
      );
    });
  });
}
