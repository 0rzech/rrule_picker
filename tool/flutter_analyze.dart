#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

Future<void> main(List<String> arguments) async {
  exitCode = await Process.start('flutter', [
    'analyze',
    ...arguments,
  ], mode: .inheritStdio).then((process) => process.exitCode);
}
