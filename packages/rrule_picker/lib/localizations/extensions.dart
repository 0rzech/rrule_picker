// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';

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
      0 => first,
      1 => second,
      2 => third,
      3 => fourth,
      -1 => last,
      _ => null,
    };
  }
}

extension ByDayOfWeek on RRulePickerLocalizations {
  String rrulePickerDayOfWeekOrdinal(DayOfWeekOrdinal ordinal, DayOfWeek day) =>
      switch (ordinal) {
        .first => rrulePickerFirstDayOfWeek(day.name),
        .second => rrulePickerSecondDayOfWeek(day.name),
        .third => rrulePickerThirdDayOfWeek(day.name),
        .fourth => rrulePickerFourthDayOfWeek(day.name),
        .last => rrulePickerLastDayOfWeek(day.name),
      };
}
