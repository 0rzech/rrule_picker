// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/theme.dart';

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

@internal
extension ChildDecoration on Widget {
  DropdownDecorators dropdownDecorators(RRulePickerDropdownThemeData theme) {
    final DropdownDecorator underline = switch (theme.showUnderlineOrDefault) {
      true => (child) => child,
      false => (child) => DropdownButtonHideUnderline(child: child),
    };

    final DropdownDecorator dropdown = switch (theme.decoration) {
      null => (child) => underline(child),
      final decoration => (child) => DecoratedBox(
        decoration: decoration,
        child: underline(child),
      ),
    };

    final DropdownDecorator item = switch (theme.menuItemDecoration) {
      null => (child) => child,
      final decoration => (child) => DecoratedBox(
        decoration: decoration,
        child: child,
      ),
    };

    return (dropdown: dropdown, dropdownMenuItem: item);
  }
}

@internal
typedef DropdownDecorators = ({
  DropdownDecorator dropdown,
  DropdownDecorator dropdownMenuItem,
});

@internal
typedef DropdownDecorator = Widget Function(Widget child);

@internal
extension DropdownDefaults on RRulePickerDropdownThemeData {
  bool get showUnderlineOrDefault =>
      showUnderline ?? RRulePickerDropdownThemeData.defaultShowUnderline;
}

@internal
extension HeaderDefaults on RRulePickerHeaderThemeData {
  bool get showHeaderOrDefault =>
      showHeader ?? RRulePickerHeaderThemeData.defaultShowHeader;
}
