#!/usr/bin/env dart
// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main(List<String> arguments) async {
  final update = arguments.contains('--update');
  final packageDir = 'packages${sep}rrule_picker';

  try {
    exitCode = await Process.start('flutter', [
      'test',
      if (update) '--update-goldens',
      '$packageDir${sep}test${sep}screenshots_test.dart',
    ], mode: .inheritStdio).then((p) => p.exitCode);

    if (update) {
      final screenshots = await Directory('$packageDir${sep}screenshots')
          .list(recursive: true, followLinks: false)
          .where((entity) => entity.path.endsWith('.png') && entity is File)
          .map((file) => file.path)
          .toList();

      // ignore: avoid_print
      print('');

      exitCode = await Process.start('oxipng', [
        '--opt',
        'max',
        '--strip',
        'safe',
        ...screenshots,
      ], mode: .inheritStdio).then((p) => p.exitCode);
    }
  } catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  }
}
