// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/widgets/monthly.dart';

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

  static DayOfWeek? tryParse(final String text) => switch (text.toUpperCase()) {
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
    final DayOfWeek firstDayOfWeek,
    final DateFormat formatter,
  ) => .generate(DayOfWeek.values.length, (index) {
    final offset = (index + firstDayOfWeek.index) % DayOfWeek.values.length;
    final day = DateTime(2026, 03, 30 + offset);
    return (DayOfWeek.values[offset], formatter.format(day));
  }, growable: false);

  static int compare(final DayOfWeek a, final DayOfWeek b) =>
      a.index.compareTo(b.index);
}

extension ByDayOfWeek on RRulePickerLocalizations {
  String rrulePickerDayOfWeekOrdinal(
    final DayOfWeekOrdinal ordinal,
    final DayOfWeek day,
  ) => switch (ordinal) {
    .first => rrulePickerFirstDayOfWeek(day.name),
    .second => rrulePickerSecondDayOfWeek(day.name),
    .third => rrulePickerThirdDayOfWeek(day.name),
    .fourth => rrulePickerFourthDayOfWeek(day.name),
    .last => rrulePickerLastDayOfWeek(day.name),
  };
}
