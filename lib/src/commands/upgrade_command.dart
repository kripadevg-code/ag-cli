import 'dart:io';
import 'package:args/command_runner.dart';
import '../logger.dart';

class UpgradeCommand extends Command<int> {
  @override
  final String name = 'upgrade';

  @override
  final String description = 'Upgrade ag_cli to the latest version.';

  @override
  Future<int> run() async {
    Log.header('🚀 Upgrading ag_cli...');

    try {
      final result = await Process.run(
          'dart',
          [
            'pub',
            'global',
            'activate',
            'ag_cli',
          ],
          runInShell: true);

      if (result.exitCode == 0) {
        print(result.stdout);
        Log.success('Successfully upgraded ag_cli!');
        return 0;
      } else {
        Log.error('Failed to upgrade ag_cli.');
        print(result.stderr);
        return result.exitCode;
      }
    } catch (e) {
      Log.error('An error occurred while upgrading: $e');
      return 1;
    }
  }
}
