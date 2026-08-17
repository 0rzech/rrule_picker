#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main() async {
  try {
    final files = await Directory('packages')
        .list(recursive: true, followLinks: false)
        .where((entity) => entity is File)
        .where((entity) {
          final path = entity.path;
          return !(path.contains('${sep}localizations$sep') ||
                  path.contains('.dart_tool')) &&
              path.endsWith('.dart');
        })
        .map((entity) => entity.path)
        .toList();

    exitCode = await Process.start('dart', [
      'format',
      '--set-exit-if-changed',
      ...files,
    ], mode: .inheritStdio).then((process) => process.exitCode);
  } catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  }
}
