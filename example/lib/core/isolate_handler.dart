import 'dart:isolate';
import 'package:logger/logger.dart';

/// Advanced Isolate Handler for heavy background parsing.
class IsolateHandler {
  static final _logger = Logger();

  /// Runs a computationally heavy [parser] function on a background thread.
  static Future<O?> run<I, O>(I input, O Function(I) parser) async {
    try {
      return await Isolate.run(() => parser(input));
    } catch (e, stackTrace) {
      _logger.e('Isolate Error: $e', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
