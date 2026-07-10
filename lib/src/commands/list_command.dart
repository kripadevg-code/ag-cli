import 'package:args/command_runner.dart';
import '../logger.dart';

class ListCommand extends Command<int> {
  @override
  final String name = 'list';

  @override
  final String description = 'Show all available generators.';

  @override
  final List<String> aliases = ['ls'];

  @override
  Future<int> run() async {
    Log.blank();
    Log.header('Available generators (ag g <type> [<module>/]<name>):');
    Log.blank();

    const generators = <List<String>>[
      // Flutter/GetX generators
      ['module', 'm', 'Full GetX module (repo + service + ctrl + binding + page + components)'],
      ['component', 'c', 'Single StatelessWidget component'],
      ['model', 'mo', 'Data model + response model with fromJson/toJson'],
      ['repo', 'r', 'Repository (abstract interface + IsolateHandler implementation)'],
      ['service', 's', 'Dio service with CRUD endpoints'],
      ['controller', 'ctrl', 'GetxController with ScrollMixin, search, pagination'],
      ['binding', 'b', 'GetX Bindings class with lazyPut + fenix: true'],
      ['page', 'p', 'StatelessWidget page with GetBuilder + error/loading/empty states'],
      // Angular-inspired schematics
      ['enum', 'e', 'Dart enum class'],
      ['interface', 'i', 'Abstract interface class (prefixed with I)'],
      ['guard', 'gu', 'GetX route middleware / navigation guard'],
      ['interceptor', 'in', 'Dio HTTP interceptor'],
      ['mixin', 'mx', 'Dart mixin'],
      ['extension', 'ex', 'Dart extension methods'],
    ];

    for (final g in generators) {
      final nameStr = g[0].padRight(14);
      final alias = g[1].isNotEmpty ? '(${g[1]})'.padRight(8) : ''.padRight(8);
      final desc = g[2];
      print('  \x1B[36m$nameStr\x1B[0m \x1B[90m$alias\x1B[0m $desc');
    }

    Log.blank();
    Log.dim('  Modes (for module, page, controller):');
    Log.dim('    --full       Search + filter chips + history + smart refresh (default)');
    Log.dim('    --minimal    Clean controller, no search, no filters');
    Log.dim('    --search     Search + history, no filter chips');
    Log.blank();
    Log.dim('  Flags:');
    Log.dim('    --dry-run    Preview files without writing (-d)');
    Log.dim('    --force      Overwrite existing files');
    Log.dim('    --flat       Place file at module root, skip sub-folder');
    Log.dim('    --defaults   Skip interactive prompts, use defaults');
    Log.blank();
    Log.header('Angular-style path syntax:');
    Log.blank();
    Log.dim('  ag g <type> <name>             →  lib/modules/<name>/<subdir>/');
    Log.dim('  ag g <type> <module>/<name>    →  lib/modules/<module>/<subdir>/');
    Log.blank();
    Log.dim('  Examples:');
    Log.dim('    ag g m    orders --full            full orders module');
    Log.dim('    ag g p    orders/checkout          CheckoutPage inside orders/');
    Log.dim('    ag g ctrl orders/dashboard         DashboardController inside orders/');
    Log.dim('    ag g b    orders/settings          SettingsBinding inside orders/');
    Log.dim('    ag g r    orders/payments          PaymentsRepo inside orders/');
    Log.dim('    ag g s    orders/analytics         AnalyticsService inside orders/');
    Log.dim('    ag g mo   orders/invoice           InvoiceModel inside orders/models/');
    Log.dim('    ag g e    LoadingStatus            LoadingStatusEnum');
    Log.dim('    ag g gu   auth                     AuthGuard route middleware');
    Log.dim('    ag g in   auth/token               TokenInterceptor inside auth/');
    Log.dim('    ag g i    payment                  IPayment abstract interface');
    Log.blank();

    return 0;
  }
}
