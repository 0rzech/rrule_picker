// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

const defaultInterval = 1;

int parseInterval(
  final String? value, [
  final int defaultValue = defaultInterval,
]) {
  if (value == null) {
    return defaultValue;
  }

  return switch (int.tryParse(value)) {
    final value? when value > 0 => value,
    _ => defaultValue,
  };
}
