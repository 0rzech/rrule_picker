#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--dummy')) {
    return;
  }

  final workDir = Directory('tool');

  try {
    for (final tool in const ['flutter_clean.dart', 'flutter_gen_l10n.dart']) {
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
