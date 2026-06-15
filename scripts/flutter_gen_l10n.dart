#!/usr/bin/env dart
// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

void main() async {
  var errorCode = 0;

  try {
    await Directory('packages')
        .list(followLinks: false)
        .map((entity) => File('${entity.path}${sep}l10n.yaml'))
        .where((entity) => entity.existsSync())
        .asyncMap((entity) async {
          final workDir = entity.parent.path;
          return await Process.start(
            'flutter',
            ['gen-l10n', '--project-dir', workDir],
            workingDirectory: workDir,
            mode: .inheritStdio,
          ).then((process) async {
            final result = await process.exitCode;
            if (result != 0) {
              errorCode = result;
            }
          });
        })
        .toList();

    exitCode = errorCode;
  } catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  }
}
