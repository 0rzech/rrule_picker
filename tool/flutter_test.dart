#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main(List<String> arguments) async {
  var errorCode = 0;

  try {
    await Directory('packages')
        .list(followLinks: false)
        .map((dir) => dir.path)
        .where((path) => Directory('$path${sep}test').existsSync())
        .asyncMap((path) async {
          return await Process.start(
            'flutter',
            [
              'test',
              '--test-randomize-ordering-seed',
              'random',
              ...arguments,
              'test',
            ],
            mode: .inheritStdio,
            workingDirectory: path,
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
