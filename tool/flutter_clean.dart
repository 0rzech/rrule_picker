#!/usr/bin/env dart

// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

final sep = Platform.pathSeparator;
const dirNamesToDelete = ['localizations', 'failures'];

Future<void> main() async {
  var errorCode = 0;

  try {
    await Directory('packages')
        .list(followLinks: false)
        .where((entity) => entity is Directory)
        .asyncMap((entity) async {
          final result = await runCleanAndDelete(entity as Directory);
          if (result != 0) {
            errorCode = result;
          }
        })
        .toList();

    exitCode = errorCode;
  } catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  }
}

Future<int> runCleanAndDelete(Directory dir) async {
  var result = 0;

  try {
    result = await runClean(dir);
  } catch (e) {
    stderr.writeln(e.toString());
    result = 1;
  }

  if (result == 0) {
    try {
      result = await runDelete(dir);
    } catch (e) {
      stderr.writeln(e.toString());
      result = 1;
    }
  }

  return result;
}

Future<int> runClean(FileSystemEntity entity) => Process.start(
  'flutter',
  ['clean'],
  workingDirectory: entity.path,
  mode: .inheritStdio,
).then((process) => process.exitCode);

Future<int> runDelete(Directory dir) async {
  var result = 0;

  final futures = await dir
      .list(recursive: true, followLinks: false)
      .where((entity) {
        return dirNamesToDelete.any((dirName) {
          return entity.path.contains('$sep$dirName$sep') && entity is File;
        });
      })
      .map((file) async {
        try {
          stdout.writeln('Deleting ${file.path}');
          await file.delete();
        } catch (e) {
          stderr.writeln(e.toString());
          result = 1;
        }
      })
      .toList();

  await futures.wait;

  return result;
}
