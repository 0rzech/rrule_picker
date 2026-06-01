// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/rrule_picker.dart';

mixin RRulePickerDayOfWeekState<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<DayOfWeekOrdinal> dayOfWeekOrdinal;
  late final ValueNotifier<DayOfWeek> dayOfWeek;
  late final ValueNotifier<List<(DayOfWeek, String)>> daysOfWeek;
  late DateFormat dayOfWeekFormatter;
  bool _isDayOfWeekStateInitialized = false;

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
    _isDayOfWeekStateInitialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(
      _isDayOfWeekStateInitialized,
      'RRulePickerDayOfWeekState error: You must call initDayOfWeekState() '
      "inside your widget's initState() method.",
    );

    final locale = RRulePickerLocalizations.of(context).localeName;
    dayOfWeekFormatter = DateFormat.EEEE(locale);
  }

  @override
  void dispose() {
    daysOfWeek.dispose();
    dayOfWeek.dispose();
    dayOfWeekOrdinal.dispose();
    super.dispose();
  }

  @protected
  void rebuildDaysOfWeek(DayOfWeek firstDayOfWeek) {
    daysOfWeek.value = DayOfWeek.buildWeek(firstDayOfWeek, dayOfWeekFormatter);
  }
}
