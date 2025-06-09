import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;

  AppLogger() : _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Display only time and time since start
    ),
  );

  /// Logs a debug message. Use for detailed information useful for debugging.
  /// An optional [time] parameter can be provided to specify the log time.
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.d(message, error: error, stackTrace: stackTrace, time: time);
  }

  /// Logs an informational message. Use for general application flow.
  /// An optional [time] parameter can be provided to specify the log time.
  void info(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.i(message, error: error, stackTrace: stackTrace, time: time);
  }

  /// Logs a warning message. Indicates potential issues but not critical errors.
  /// An optional [time] parameter can be provided to specify the log time.
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.w(message, error: error, stackTrace: stackTrace, time: time);
  }

  /// Logs an error message. Indicates a significant problem that prevents normal operation.
  /// An optional [time] parameter can be provided to specify the log time.
  void error(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.e(message, error: error, stackTrace: stackTrace, time: time);
  }

  /// Logs a fatal message. Indicates a severe error that causes the application to terminate or become unusable.
  /// An optional [time] parameter can be provided to specify the log time.
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.f(message, error: error, stackTrace: stackTrace, time: time);
  }

  /// Logs a verbose message. Use for very detailed logs, often for tracing execution flow.
  /// An optional [time] parameter can be provided to specify the log time.
  void trace(dynamic message, [dynamic error, StackTrace? stackTrace, DateTime? time]) {
    _logger.t(message, error: error, stackTrace: stackTrace, time: time);
  }
}