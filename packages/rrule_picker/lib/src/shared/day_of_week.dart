// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

@internal
mixin DayOfWeekState {
  late final ValueNotifier<DayOfWeekOrdinal> dayOfWeekOrdinal;
  late final ValueNotifier<DayOfWeek> dayOfWeek;
  late final ValueNotifier<List<(DayOfWeek, String)>> daysOfWeek;
  late DateFormat dayOfWeekFormatter;

  @protected
  @mustCallSuper
  void initDayOfWeekState([
    DayOfWeekOrdinal initialDayOfWeekOrdinal = .first,
    DayOfWeek initialDayOfWeek = .monday,
  ]) {
    dayOfWeekOrdinal = ValueNotifier(initialDayOfWeekOrdinal);
    dayOfWeek = ValueNotifier(initialDayOfWeek);
    // dummy values just to instantiate the notifier
    daysOfWeek = ValueNotifier([(.monday, '')]);
  }

  @protected
  @mustCallSuper
  void disposeDayOfWeekState() {
    daysOfWeek.dispose();
    dayOfWeek.dispose();
    dayOfWeekOrdinal.dispose();
  }

  @protected
  @mustCallSuper
  void updateDayOfWeekState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) {
    if (localizations != null) {
      dayOfWeekFormatter = DateFormat.EEEE(localizations.localeName);
    }

    if (firstDayOfWeek != null) {
      daysOfWeek.value = DayOfWeek.buildWeek(
        firstDayOfWeek,
        dayOfWeekFormatter,
      );
    }
  }

  @protected
  void setDayOfWeekValue(
    DayOfWeekOrdinal dayOfWeekOrdinal,
    DayOfWeek dayOfWeek,
  ) {
    this.dayOfWeekOrdinal.value = dayOfWeekOrdinal;
    this.dayOfWeek.value = dayOfWeek;
  }
}
