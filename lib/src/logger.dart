import 'package:mason_logger/mason_logger.dart';

/// Centralized logger instance using mason_logger for premium UI, spinners, and prompts.
class Log {
  Log._();

  static final Logger mason = Logger();

  // ─── ANSI codes (for custom formatting if needed) ───────────────────────
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _gray = '\x1B[90m';

  // ─── Public API ────────────────────────────────────────────────────────────

  static void success(String msg) => mason.success(msg);
  static void warn(String msg) => mason.warn(msg);
  static void error(String msg) => mason.err(msg);
  static void info(String msg) => mason.info(msg);
  static void dim(String msg) => print('$_gray$msg$_reset');
  static void header(String msg) => print('$_bold$msg$_reset');
  static void blank() => print('');

  /// Dry-run placeholder (○ instead of ✔).
  static void dryRun(String msg) => print('  $_gray○$_reset $msg');

  /// Start a progress spinner. Call `.complete([msg])` or `.fail([msg])` on it.
  static Progress progress(String msg) => mason.progress(msg);

  /// Prompt the user with an interactive list of options.
  static T chooseOne<T>({
    required String prompt,
    required List<T> choices,
    String Function(T)? display,
    T? defaultValue,
  }) {
    return mason.chooseOne<T>(
      prompt,
      choices: choices,
      display: display,
      defaultValue: defaultValue,
    );
  }

  /// Prompt the user for text input.
  static String prompt(String message, {String? defaultValue}) {
    return mason.prompt(message, defaultValue: defaultValue);
  }
}
