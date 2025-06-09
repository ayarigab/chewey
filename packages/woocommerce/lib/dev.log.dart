// Copyright (c) 2022 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'package:logger/logger.dart';

/// # Description
///
/// Creates a Developer log class to use in application debugging
abstract class Dev {
  /// Flag for debug mode level logs
  static bool _isDebugMode = true;

  /// Getter for Debug mode
  bool get isDebugMode => _isDebugMode;

  /// Setter for Debug mode
  set changeDebugMode(bool value) => _isDebugMode = value;

  /// Flag for result printing
  static bool _shouldPrintResult = true;

  /// Getter for Debug mode
  bool get shouldPrintResult => _shouldPrintResult;

  /// Setter for Debug mode
  set changePrintResultMode(bool value) => _shouldPrintResult = value;

  static final log = Logger(
    filter: DevelopmentFilter(),
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 0,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 100,
        // width of the output
        colors: false,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: false, // Should each log print contain a timestamp
      ),
    ),
    // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  static void info(dynamic message) {
    if (_isDebugMode) {
      log.i(message);
    }
  }

  static void debug(dynamic message) {
    if (_isDebugMode) {
      log.d(message);
    }
  }

  static void debugFunction({
    required String functionName,
    required String className,
    required bool start,
    required String fileName,
    String customMessage = '',
  }) {
    if (_isDebugMode) {
      final StringBuffer buffer = StringBuffer();

      if (customMessage.isNotEmpty) {
        buffer.write('[ $customMessage ] ');
      } else {
        buffer.write(start ? 'Running ==> ' : 'End ==> ');
      }

      buffer.writeAll([functionName, className, fileName], ' ==> ');

      log.d(buffer);

      // log.d(
      //     '${customMessage.isNotEmpty ? customMessage : start ? 'Running' : 'End'} ==> $fileName ==> $functionName');
    }
  }

  static void warn(dynamic message) {
    log.w(message);
  }

  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    log.e(message, error, stackTrace);
  }

  static void printResult(dynamic result) {
    if (_shouldPrintResult) {
      log.i(result);
    }
  }
}
