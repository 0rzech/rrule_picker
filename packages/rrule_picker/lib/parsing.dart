// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:rrule_picker/localizations/extensions.dart';
import 'package:rrule_picker/widgets/monthly.dart';

const defaultInterval = 1;

int parseInterval(String? value, [int defaultValue = defaultInterval]) {
  if (value == null) {
    return defaultValue;
  }

  return switch (int.tryParse(value)) {
    final value? when value > 0 => value,
    _ => defaultValue,
  };
}

const byMonthDayMin = 1;
const byMonthDayMax = 32;
const defaultByMonthDay = byMonthDayMin;

int parseByMonthDay(String? value, [int defaultValue = defaultByMonthDay]) {
  if (value == null) {
    return defaultValue;
  }

  return switch (int.tryParse(value)) {
    -1 => byMonthDayMax,
    final value? when value >= byMonthDayMin && value < byMonthDayMax => value,
    _ => defaultValue,
  };
}

const defaultByDaySingle = DayOfWeek.monday;

DayOfWeek parseByDaySingle(
  String? value, [
  DayOfWeek defaultValue = defaultByDaySingle,
]) {
  if (value == null) {
    return defaultValue;
  }

  return DayOfWeek.tryParse(value) ?? defaultValue;
}

const defaultByDayMulti = {DayOfWeek.monday};

Set<DayOfWeek> parseByDayMulti(
  String? value, [
  Set<DayOfWeek> defaultValue = defaultByDayMulti,
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

const defaultBySetPosNthWeekDay = DayOfWeekOrdinal.first;

DayOfWeekOrdinal parseBySetPosNthWeekDay(
  String? value, [
  DayOfWeekOrdinal defaultValue = defaultBySetPosNthWeekDay,
]) {
  if (value == null) {
    return defaultValue;
  }

  return DayOfWeekOrdinal.tryParse(value) ?? defaultValue;
}
