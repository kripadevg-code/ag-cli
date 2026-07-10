import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ag_cli/src/logger.dart';
import 'package:ag_cli/src/utils.dart';
import 'package:ag_cli/src/commands/generate_command.dart';
import 'package:ag_cli/src/commands/init_command.dart';
import 'package:ag_cli/src/commands/list_command.dart';
import 'package:ag_cli/src/commands/upgrade_command.dart';
import 'package:ag_cli/src/commands/doctor_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner<int>(
    'ag',
    'Flutter GetX code generator — install once, use anywhere.',
  )
    ..addCommand(GenerateCommand())
    ..addCommand(InitCommand())
    ..addCommand(ListCommand())
    ..addCommand(UpgradeCommand())
    ..addCommand(DoctorCommand())
    ..argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current version.',
    );

  try {
    final parsedArgs = runner.argParser.parse(args);

    if (parsedArgs['version'] as bool) {
      print('ag_cli v$cliVersion');
      exit(0);
    }

    final exitCode = await runner.run(args) ?? 0;
    exit(exitCode);
  } on UsageException catch (e) {
    Log.error(e.message);
    Log.blank();
    print(e.usage);
    exit(1);
  } catch (e) {
    Log.error(e.toString());
    exit(1);
  }
}
