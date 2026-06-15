#!/usr/bin/env dart
// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

Future<void> main() async {
  exitCode = await Process.start('flutter', [
    'analyze',
  ], mode: .inheritStdio).then((process) => process.exitCode);
}
