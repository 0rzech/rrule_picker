#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;

Future<void> main() async {
  final errors = <String>[];

  try {
    final futures = await Directory('packages')
        .list(followLinks: false)
        .map((entity) => File('${entity.path}${sep}l10n${sep}missing.json'))
        .where((file) => file.existsSync())
        .map((file) {
          return file.readAsString().then((value) {
            if (value != '{}') {
              errors.add('${file.path}\n$value');
            }
          }, onError: (error) => errors.add(error.toString()));
        })
        .toList();

    await futures.wait;
  } catch (e) {
    errors.add(e.toString());
  }

  if (errors.isNotEmpty) {
    errors.forEach(stderr.writeln);
    exitCode = 1;
  }
}
