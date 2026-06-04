// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/parsing.dart';

mixin RRulePickerDayOfMonthState {
  late final ValueNotifier<int> dayOfMonth;
  late final NumberFormat dayOfMonthFormatter;

  @protected
  @mustCallSuper
  void initDayOfMonthState([
    int initialDayOfMonth = defaultByMonthDay,
    String numberFormat = '00',
  ]) {
    dayOfMonth = ValueNotifier(initialDayOfMonth);
    dayOfMonthFormatter = NumberFormat(numberFormat);
  }

  @protected
  @mustCallSuper
  void disposeDayOfMonthState() => dayOfMonth.dispose();
}
