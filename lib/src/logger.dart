// ignore_for_file: avoid_print

/// ANSI color codes for styled terminal output.
class Log {
  Log._();

  // ─── ANSI codes ────────────────────────────────────────────────────────────
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _cyan = '\x1B[36m';
  static const _gray = '\x1B[90m';

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Green ✔ success line.
  static void success(String msg) => print('  $_green✔$_reset $msg');

  /// Yellow ⚠ warning line.
  static void warn(String msg) => print('  $_yellow⚠$_reset $msg');

  /// Red ❌ error line.
  static void error(String msg) => print('$_red❌  $msg$_reset');

  /// Cyan ℹ info line.
  static void info(String msg) => print('$_cyan$msg$_reset');

  /// Gray dim text.
  static void dim(String msg) => print('$_gray$msg$_reset');

  /// Bold header text.
  static void header(String msg) => print('$_bold$msg$_reset');

  /// Dry-run placeholder (○ instead of ✔).
  static void dryRun(String msg) => print('  $_gray○$_reset $msg');

  /// Print a blank line.
  static void blank() => print('');

  /// Print the CLI banner.
  static void banner(String version) {
    print('');
    print('$_cyan$_bold  ag$_reset $_gray v$version$_reset');
    print('$_gray  Flutter GetX code generator$_reset');
    print('');
  }
}
