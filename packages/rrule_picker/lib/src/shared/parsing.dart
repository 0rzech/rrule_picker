// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@internal
const intervalMin = 1;
@internal
const defaultInterval = intervalMin;

@internal
int parseInterval(String? value, [int defaultValue = defaultInterval]) {
  if (value == null) {
    return defaultValue;
  }

  return switch (int.tryParse(value)) {
    final value? when value > 0 => value,
    _ => defaultValue,
  };
}

@internal
const defaultByMonth = Month.january;

@internal
Month parseByMonth(String? value, [Month defaultValue = defaultByMonth]) {
  if (value == null) {
    return defaultValue;
  }

  return Month.tryParse(value) ?? defaultValue;
}

@internal
const byMonthDayMin = 1;
@internal
const byMonthDayMax = 32;
@internal
const defaultByMonthDay = byMonthDayMin;

@internal
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

@internal
const defaultByDaySingle = DayOfWeek.monday;

@internal
DayOfWeek parseByDaySingle(
  String? value, [
  DayOfWeek defaultValue = defaultByDaySingle,
]) {
  if (value == null) {
    return defaultValue;
  }

  return DayOfWeek.tryParse(value) ?? defaultValue;
}

@internal
const defaultByDayMulti = {DayOfWeek.monday};

@internal
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

@internal
const defaultBySetPosNthWeekDay = DayOfWeekOrdinal.first;

@internal
DayOfWeekOrdinal parseBySetPosNthWeekDay(
  String? value, [
  DayOfWeekOrdinal defaultValue = defaultBySetPosNthWeekDay,
]) {
  if (value == null) {
    return defaultValue;
  }

  return DayOfWeekOrdinal.tryParse(value) ?? defaultValue;
}

@internal
enum DayOfWeek {
  monday('MO'),
  tuesday('TU'),
  wednesday('WE'),
  thursday('TH'),
  friday('FR'),
  saturday('SA'),
  sunday('SU');

  final String rruleName;

  const DayOfWeek(this.rruleName);

  static DayOfWeek? tryParse(String text) => switch (text.toUpperCase()) {
    'MO' => monday,
    'TU' => tuesday,
    'WE' => wednesday,
    'TH' => thursday,
    'FR' => friday,
    'SA' => saturday,
    'SU' => sunday,
    _ => null,
  };

  static List<(DayOfWeek, String)> buildWeek(
    DayOfWeek firstDayOfWeek,
    DateFormat formatter,
  ) => .generate(DayOfWeek.values.length, (index) {
    final offset = (index + firstDayOfWeek.index) % DayOfWeek.values.length;
    final day = DateTime(2026, 03, 30 + offset);
    return (DayOfWeek.values[offset], formatter.format(day));
  }, growable: false);

  static int compare(DayOfWeek a, DayOfWeek b) => a.index.compareTo(b.index);
}

@internal
enum DayOfWeekOrdinal {
  first(1),
  second(2),
  third(3),
  fourth(4),
  last(-1);

  final int rruleValue;

  const DayOfWeekOrdinal(this.rruleValue);

  static DayOfWeekOrdinal? tryParse(String text) {
    return switch (int.tryParse(text)) {
      1 => first,
      2 => second,
      3 => third,
      4 => fourth,
      -1 => last,
      _ => null,
    };
  }
}

@internal
enum Month {
  january('1', 31),
  february('2', 29),
  march('3', 31),
  april('4', 30),
  may('5', 31),
  june('6', 30),
  july('7', 31),
  august('8', 31),
  september('9', 30),
  october('10', 31),
  november('11', 30),
  december('12', 31);

  final String rruleValue;
  final int maxDay;

  const Month(this.rruleValue, this.maxDay);

  static Month? tryParse(String value) => switch (value) {
    '1' => january,
    '2' => february,
    '3' => march,
    '4' => april,
    '5' => may,
    '6' => june,
    '7' => july,
    '8' => august,
    '9' => september,
    '10' => october,
    '11' => november,
    '12' => december,
    _ => null,
  };
}
