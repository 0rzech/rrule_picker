// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

@internal
mixin DayOfMonthState {
  late final ValueNotifier<int> dayOfMonth;
  late final NumberFormat dayOfMonthFormatter;

  @protected
  @mustCallSuper
  void initDayOfMonthState({
    int initialDayOfMonth = defaultByMonthDay,
    String numberFormat = '00',
    required VoidCallback listener,
  }) {
    dayOfMonth = ValueNotifier(initialDayOfMonth)..addListener(listener);
    dayOfMonthFormatter = NumberFormat(numberFormat);
  }

  @protected
  @mustCallSuper
  void disposeDayOfMonthState() => dayOfMonth.dispose();

  @protected
  void setDayOfMonthValue(int value) => dayOfMonth.value = value;
}
