// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/parsing.dart';

mixin RRulePickerDayOfMonthState<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<int> dayOfMonth;
  late final NumberFormat dayOfMonthFormatter;
  bool _isDayOfMonthStateInitialized = false;

  void initDayOfMonthState([
    int initialDayOfMonth = defaultByMonthDay,
    String numberFormat = '00',
  ]) {
    dayOfMonth = ValueNotifier(initialDayOfMonth);
    dayOfMonthFormatter = NumberFormat(numberFormat);
    _isDayOfMonthStateInitialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(
      _isDayOfMonthStateInitialized,
      'RRulePickerDayOfMonthState error: You must call initDayOfMonthState() '
      "inside your widget's initState() method.",
    );
  }

  @override
  void dispose() {
    dayOfMonth.dispose();
    super.dispose();
  }
}
