#!/usr/bin/env dart
// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--dummy')) {
    return;
  }

  if ((Platform.environment['NO_VERIFY'] ?? 'false') != 'false') {
    stdout.writeln(
      'NO_VERIFY environment variable set; skipping pre-commit hooks',
    );
    return;
  }

  final workDir = Directory('tool');

  try {
    for (final tool in const [
      'flutter_test.dart',
      'check_missing_localizations.dart',
      'flutter_analyze.dart',
      'dart_format.dart',
    ]) {
      final result = await Process.start('dart', [
        'run',
        '${workDir.path}$sep$tool',
      ], mode: .inheritStdio).then((process) => process.exitCode);

      if (result != 0) {
        exitCode = result;
        return;
      }
    }
  } catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  }
}
