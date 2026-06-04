// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/widgets/shared/parsing.dart';

@internal
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
