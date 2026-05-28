// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:rrule_picker/widgets/weekly.dart';

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

const defaultByDayMulti = {DayOfWeek.monday};

Set<DayOfWeek> parseByDayMulti(
  final String? value, [
  final Set<DayOfWeek> defaultValue = defaultByDayMulti,
]) {
  if (value == null) {
    return defaultValue;
  }

  final byDay = value
      .split(',')
      .map(DayOfWeek.tryParse)
      .whereType<DayOfWeek>()
      .toSet();

  return byDay.isEmpty ? defaultValue : byDay;
}
