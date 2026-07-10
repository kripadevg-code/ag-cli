/// App-wide utility/logging helper.
abstract class AppUtility {
  static void log(String message, {String tag = 'log'}) {
    // ignore: avoid_print
    print('[$tag] $message');
  }
}
