// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/theme.dart';
import 'package:spot/spot.dart';

extension PumpWrapped on WidgetTester {
  Future<void> pumpWrapped(
    Widget widget, {
    Locale locale = const Locale('en'),
  }) async => await pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: RRulePickerLocalizations.supportedLocales,
      localizationsDelegates: RRulePickerLocalizations.localizationsDelegates,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

extension Localizations on WidgetTester {
  RRulePickerLocalizations localizations<T extends Widget>() {
    final widget = spot<T>().existsOnce().element;
    return RRulePickerLocalizations.of(widget);
  }
}

extension IgnoreErrors on void Function() {
  /// Catches and ignores [Error]s. Useful, for example, when calling
  /// `dispose()` on a `late` instance, that hasn't been initialized.
  void callIgnoringErrors() {
    try {
      call();
    } on Error {
      // noop
    }
  }
}

Arbitrary<int> interval() => integer(min: intervalMin);

Arbitrary<String> asciiString({int minLength = 1, int maxLength = 5}) => string(
  minLength: minLength,
  maxLength: maxLength,
  characterSet: .all(.ascii),
);

Arbitrary<String> utf8String({int minLength = 1, int maxLength = 5}) => string(
  minLength: minLength,
  maxLength: maxLength,
  characterSet: .all(.utf8),
);

Arbitrary<DateTime> date({DateTime? min, DateTime? max}) {
  final minimum = min ?? DateTime(0000, 01, 01);
  final maximum = max ?? DateTime(5000, 12, 31);

  return combine3(
    integer(min: minimum.year, max: maximum.year),
    integer(min: minimum.month, max: maximum.month),
    integer(min: minimum.day, max: maximum.day),
  ).map((t) {
    return DateTime(t.$1, t.$2, switch (t.$2) {
      4 || 6 || 9 || 11 => math.min(t.$3, 30),
      2 => math.min(t.$3, 28),
      _ => t.$3,
    });
  });
}

Arbitrary<({String string, Set<DateTime> dates})> stringDateSet({
  DateTime? min,
  DateTime? max,
  int minLength = 1,
  int maxLength = 5,
}) {
  return set(
    date(min: min, max: max),
    minLength: minLength,
    maxLength: maxLength,
  ).map((dates) {
    return (string: dates.map(exdateFormatter.format).join(','), dates: dates);
  });
}

Arbitrary<DayOfWeek> dayOfWeek() => constantFrom(DayOfWeek.values);

Arbitrary<Set<DayOfWeek>> dayOfWeekSet() =>
    set(dayOfWeek(), minLength: 1, maxLength: DayOfWeek.values.length);

Arbitrary<DayOfWeekOrdinal> dayOfWeekOrdinal() =>
    constantFrom(DayOfWeekOrdinal.values);

Arbitrary<int> byMonthDay() => integer(min: byMonthDayMin, max: byMonthDayMax);

Arbitrary<Month> month() => constantFrom(Month.values);

Arbitrary<Set<T>> standardSet<T>(
  Arbitrary<T> element, {
  int minLength = 1,
  int maxLength = 5,
}) => set(element, minLength: minLength, maxLength: maxLength);

final exdateFormatter = DateFormat('yyyyMMdd');

ResolvedThemeData testResolvedTheme({
  TextStyle? labelStyle,
  EdgeInsetsGeometry padding = .zero,
  RRulePickerHeaderThemeData headerTheme = const .new(),
  RRulePickerDropdownThemeData dropdownTheme = const .new(),
  RRulePickerDropdownThemeData topDropdownTheme = const .new(),
  RRulePickerTextFieldThemeData? textFieldTheme = const .new(),
  ButtonStyle? segmentedButtonStyle,
  ButtonStyle? splitSegmentedButtonStyle,
}) => ResolvedThemeData(
  labelStyle: labelStyle,
  padding: padding,
  headerTheme: headerTheme,
  dropdownTheme: dropdownTheme,
  topDropdownTheme: topDropdownTheme,
  textFieldTheme: textFieldTheme,
  segmentedButtonStyle: segmentedButtonStyle,
  splitSegmentedButtonStyle: splitSegmentedButtonStyle,
);
