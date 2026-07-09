// ignore_for_file: avoid_print
import '../logger.dart';

/// Runs the `ag list` command — shows all available generators.
void runListCommand() {
  Log.blank();
  Log.header('Available generators:');
  Log.blank();

  const generators = <List<String>>[
    [
      'module',
      'm',
      'Full GetX module (repo + controller + binding + page + components)'
    ],
    ['component', 'c', 'Single StatelessWidget'],
    ['model', '', 'Data model class with fromJson / toJson + response model'],
    ['repo', 'r', 'Repository (abstract interface + implementation)'],
    ['controller', 'ctrl', 'GetxController with ScrollMixin'],
    ['binding', 'b', 'GetX Binding class'],
    ['page', 'p', 'StatelessWidget page with GetBuilder'],
  ];

  for (final g in generators) {
    final name = g[0].padRight(14);
    final alias = g[1].isNotEmpty ? '(${g[1]})'.padRight(8) : ''.padRight(8);
    final desc = g[2];
    print('  \x1B[36m$name\x1B[0m $alias $desc');
  }

  Log.blank();
  Log.dim('  Usage: ag generate <type> <name> [options]');
  Log.dim('         ag g <shortcut> <name> [options]');
  Log.blank();
  Log.dim('  Example: ag g m problem --full');
  Log.dim('           ag g model user --module problem');
  Log.blank();
}
