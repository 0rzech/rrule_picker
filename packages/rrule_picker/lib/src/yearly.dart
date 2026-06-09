// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/day_of_month.dart';
import 'package:rrule_picker/src/shared/day_of_week.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/theme.dart';

@internal
class RRulePickerYearly extends StatefulWidget {
  final DayOfWeek firstDayOfWeek;
  final RRulePickerYearlyController controller;

  const RRulePickerYearly({
    super.key,
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerYearlyState();
}

class _RRulePickerYearlyState extends State<RRulePickerYearly> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant RRulePickerYearly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      widget.controller._updateState(firstDayOfWeek: widget.firstDayOfWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = RRulePickerTheme.of(context);
    final decorate = widget.dropdownDecorators(theme);
    final controller = widget.controller;

    final monthWidget = ValueListenableBuilder(
      valueListenable: controller._month,
      builder: (context, day, _) {
        final dropdown = DropdownButton(
          value: day,
          isExpanded: true,
          style: theme.dropdownStyle,
          items: Month.values
              .map((month) {
                final date = DateTime(2026, 01 + month.index, 01);
                final text = Text(
                  controller._monthFormatter.format(date),
                  style: theme.dropdownMenuItemStyle,
                );

                return DropdownMenuItem(
                  value: month,
                  child: decorate.dropdownMenuItem(text),
                );
              })
              .toList(growable: false),
          onChanged: (value) {
            controller._month.value = value!;
            controller.dayOfMonth.value = min(
              controller.dayOfMonth.value,
              controller._month.value.maxDay,
            );
          },
        );

        return Flexible(child: decorate.dropdown(dropdown));
      },
    );

    return ValueListenableBuilder(
      valueListenable: controller.intervalSegmentType,
      builder: (context, segmentType, monthWidget) {
        return Column(
          spacing: 8,
          children: [
            SegmentedButton<RRulePickerIntervalSegmentType>(
              onSelectionChanged: (value) =>
                  controller.intervalSegmentType.value = value,
              selected: segmentType,
              showSelectedIcon: false,
              style: theme.segmentedButtonStyle,
              segments: [
                ButtonSegment(
                  value: .precise,
                  label: Text(l.rrulePickerDayOfMonth),
                ),
                ButtonSegment(
                  value: .relative,
                  label: Text(l.rrulePickerDayOfWeek),
                ),
              ],
            ),
            switch (segmentType.first) {
              .precise => Row(
                spacing: 8,
                children: [
                  Text(l.rrulePickerEveryMonth, style: theme.labelStyle),
                  monthWidget!,
                  Text('/', style: theme.labelStyle),
                  ValueListenableBuilder(
                    valueListenable: controller.dayOfMonth,
                    builder: (_, day, _) {
                      final dropdown = DropdownButton(
                        value: day,
                        isExpanded: true,
                        style: theme.dropdownStyle,
                        items: .generate(controller._month.value.maxDay, (i) {
                          final day = i + 1;
                          final text = Text(
                            controller.dayOfMonthFormatter.format(day),
                            style: theme.dropdownMenuItemStyle,
                          );

                          return DropdownMenuItem(
                            value: day,
                            child: decorate.dropdownMenuItem(text),
                          );
                        }, growable: false),
                        onChanged: (value) =>
                            controller.dayOfMonth.value = value!,
                      );

                      return Flexible(child: decorate.dropdown(dropdown));
                    },
                  ),
                ],
              ),
              .relative => Row(
                spacing: 9,
                children: [
                  Text(l.rrulePickerEveryMonth, style: theme.labelStyle),
                  monthWidget!,
                  Text('/', style: theme.labelStyle),
                  ListenableBuilder(
                    listenable: .merge([
                      controller.daysOfWeek,
                      controller.dayOfWeekOrdinal,
                      controller.dayOfWeek,
                    ]),
                    builder: (_, _) {
                      final dropdown = DropdownButton(
                        isExpanded: true,
                        value: controller.dayOfWeekOrdinal.value,
                        style: theme.dropdownStyle,
                        items: DayOfWeekOrdinal.values
                            .map((ordinal) {
                              final text = Text(
                                l.rrulePickerDayOfWeekOrdinal(
                                  ordinal,
                                  controller.dayOfWeek.value,
                                ),
                                style: theme.dropdownMenuItemStyle,
                              );

                              return DropdownMenuItem(
                                value: ordinal,
                                child: decorate.dropdownMenuItem(text),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) =>
                            controller.dayOfWeekOrdinal.value = value!,
                      );

                      return Flexible(child: decorate.dropdown(dropdown));
                    },
                  ),
                  ListenableBuilder(
                    listenable: .merge([
                      controller.daysOfWeek,
                      controller.dayOfWeek,
                    ]),
                    builder: (_, _) {
                      final dropdown = DropdownButton(
                        value: controller.dayOfWeek.value,
                        isExpanded: true,
                        style: theme.dropdownStyle,
                        items: controller.daysOfWeek.value
                            .map((day) {
                              final text = Text(
                                day.$2,
                                style: theme.dropdownMenuItemStyle,
                              );

                              return DropdownMenuItem(
                                value: day.$1,
                                child: decorate.dropdownMenuItem(text),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) =>
                            controller.dayOfWeek.value = value!,
                      );

                      return Flexible(child: decorate.dropdown(dropdown));
                    },
                  ),
                ],
              ),
            },
          ],
        );
      },
      child: monthWidget,
    );
  }
}

@internal
class RRulePickerYearlyController
    with
        RRulePickerIntervalSegmentTypeState,
        RRulePickerDayOfMonthState,
        RRulePickerDayOfWeekState {
  late final ValueNotifier<Month> _month;
  late DateFormat _monthFormatter;

  RRulePickerYearlyController([
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  ]) {
    final rrule = _parseRRule(initialRRule, firstDayOfWeek);

    initIntervalSegmentTypeState(
      rrule.dayOfMonth == null ? const {.relative} : const {.precise},
    );
    initDayOfMonthState(rrule.dayOfMonth ?? defaultByMonthDay);
    initDayOfWeekState(
      rrule.dayOfWeekOrdinal ?? .first,
      rrule.dayOfWeek ?? firstDayOfWeek,
    );
    _month = ValueNotifier(rrule.month);
  }

  @mustCallSuper
  void dispose() {
    _month.dispose();
    disposeDayOfWeekState();
    disposeDayOfMonthState();
    disposeIntervalSegmentTypeState();
  }

  void _updateState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) {
    updateDayOfWeekState(
      localizations: localizations,
      firstDayOfWeek: firstDayOfWeek,
    );

    if (localizations != null) {
      _monthFormatter = DateFormat.MMMM(localizations.localeName);
    }
  }

  _ParsedRRule _parseRRule(String rule, DayOfWeek firstDayOfWeek) {
    if (rule.isEmpty) {
      return const _ParsedRRule(month: .january, dayOfMonth: defaultByMonthDay);
    }

    const reMonth = r'BYMONTH=(\d+)';
    const reDayOfMonth = r'BYMONTHDAY=(\d+)';
    const reDayOfWeek = r'BYDAY=([AEFHMORSTUW,]+);BYSETPOS=(-?\d+)';

    var match = RegExp(reMonth).firstMatch(rule);
    final month = parseByMonth(match?.group(1));

    final rest = rule.substring(match?.end ?? 0);

    match = RegExp(reDayOfMonth).firstMatch(rest);
    final dayOfMonth = match?.group(1);

    match = RegExp(reDayOfWeek).firstMatch(rest);
    final dayOfWeek = match?.group(1);
    final dayOfWeekOrdinal = match?.group(2);

    if (dayOfWeek == null) {
      return _ParsedRRule(
        month: month,
        dayOfMonth: parseByMonthDay(dayOfMonth),
      );
    } else {
      return _ParsedRRule(
        month: month,
        dayOfWeek: parseByDaySingle(dayOfWeek, firstDayOfWeek),
        dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
      );
    }
  }

  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=YEARLY;BYMONTH=');
    sb.write(_month.value.rruleValue);

    switch (intervalSegmentType.value.first) {
      case .precise:
        sb.write(';BYMONTHDAY=');
        sb.write(dayOfMonth.value);
      case .relative:
        sb.write(';BYDAY=');
        sb.write(dayOfWeek.value.rruleName);
        sb.write(';BYSETPOS=');
        sb.write(dayOfWeekOrdinal.value.rruleValue);
    }
  }
}

class _ParsedRRule {
  final Month month;
  final int? dayOfMonth;
  final DayOfWeek? dayOfWeek;
  final DayOfWeekOrdinal? dayOfWeekOrdinal;

  const _ParsedRRule({
    required this.month,
    this.dayOfMonth,
    this.dayOfWeek,
    this.dayOfWeekOrdinal,
  }) : assert(
         (dayOfMonth != null &&
                 dayOfWeek == null &&
                 dayOfWeekOrdinal == null) ||
             (dayOfMonth == null &&
                 dayOfWeek != null &&
                 dayOfWeekOrdinal != null),
         "You must provide either 'dayOfMonth' "
         "or both 'dayOfWeek' and 'dayOfWeekOrdinal'",
       );
}
