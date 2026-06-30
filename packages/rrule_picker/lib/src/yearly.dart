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
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class YearlyPicker extends StatefulWidget {
  final DayOfWeek firstDayOfWeek;
  final YearlyPickerController controller;

  const YearlyPicker({
    super.key,
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _YearlyPickerState();
}

class _YearlyPickerState extends State<YearlyPicker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant YearlyPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      widget.controller._updateState(firstDayOfWeek: widget.firstDayOfWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = ResolvedTheme.of(context);
    final decorate = widget.dropdownDecorators(theme.dropdownTheme);
    final controller = widget.controller;

    final interval = IntervalPicker(
      everyUnitText: l.rrulePickerEveryYearly,
      intervalUnitText: l.rrulePickerYears,
      intervalController: controller.intervalController,
      intervalNotifier: controller.intervalNotifier,
    );

    final monthWidget = ValueListenableBuilder(
      valueListenable: controller.month,
      builder: (context, day, _) {
        final dropdown = DropdownButton(
          value: day,
          isExpanded: true,
          style: theme.dropdownTheme.style,
          items: Month.values
              .map((month) {
                final date = DateTime(2026, 01 + month.index, 01);
                final text = Text(
                  controller.monthFormatter.format(date),
                  style: theme.dropdownTheme.menuItemStyle,
                );

                return DropdownMenuItem(
                  value: month,
                  child: decorate.dropdownMenuItem(text),
                );
              })
              .toList(growable: false),
          onChanged: (value) {
            controller.month.value = value!;
            controller.dayOfMonth.value = min(
              controller.dayOfMonth.value,
              controller.month.value.maxDay,
            );
          },
        );

        return Flexible(child: decorate.dropdown(dropdown));
      },
    );

    return ValueListenableBuilder(
      valueListenable: controller.intervalSegmentType,
      builder: (context, segmentType, _) {
        return Column(
          spacing: 8,
          children: [
            interval,
            SegmentedButton<IntervalPickerSegmentType>(
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
                  monthWidget,
                  Text('/', style: theme.labelStyle),
                  ListenableBuilder(
                    listenable: .merge([
                      controller.month,
                      controller.dayOfMonth,
                    ]),
                    builder: (_, _) {
                      final dropdown = DropdownButton(
                        value: controller.dayOfMonth.value,
                        isExpanded: true,
                        style: theme.dropdownTheme.style,
                        items: .generate(controller.month.value.maxDay, (i) {
                          final day = i + 1;
                          final text = Text(
                            controller.dayOfMonthFormatter.format(day),
                            style: theme.dropdownTheme.menuItemStyle,
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
                  monthWidget,
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
                        style: theme.dropdownTheme.style,
                        items: DayOfWeekOrdinal.values
                            .map((ordinal) {
                              final text = Text(
                                l.rrulePickerDayOfWeekOrdinal(
                                  ordinal,
                                  controller.dayOfWeek.value,
                                ),
                                style: theme.dropdownTheme.menuItemStyle,
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
                        style: theme.dropdownTheme.style,
                        items: controller.daysOfWeek.value
                            .map((day) {
                              final text = Text(
                                day.$2,
                                style: theme.dropdownTheme.menuItemStyle,
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
    );
  }
}

@internal
class YearlyPickerController
    with
        IntervalPickerSegmentTypeState,
        IntervalPickerState,
        DayOfMonthState,
        DayOfWeekState {
  late final ValueNotifier<Month> month;
  late DateFormat monthFormatter;

  YearlyPickerController({
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
    required VoidCallback listener,
  }) {
    final rrule = _parseRRule(initialRRule, firstDayOfWeek);

    initIntervalSegmentTypeState(
      initialSegmentType: rrule.dayOfMonth == null
          ? const {.relative}
          : const {.precise},
      listener: listener,
    );
    initIntervalState(initialValue: rrule.interval, listener: listener);
    initDayOfMonthState(
      initialDayOfMonth: rrule.dayOfMonth ?? defaultByMonthDay,
      listener: listener,
    );
    initDayOfWeekState(
      initialDayOfWeekOrdinal: rrule.dayOfWeekOrdinal ?? .first,
      initialDayOfWeek: rrule.dayOfWeek ?? firstDayOfWeek,
      listener: listener,
    );
    month = ValueNotifier(rrule.month)..addListener(listener);
  }

  @mustCallSuper
  void dispose() {
    month.dispose();
    disposeDayOfWeekState();
    disposeDayOfMonthState();
    disposeIntervalState();
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
      monthFormatter = DateFormat.MMMM(localizations.localeName);
    }
  }

  _ParsedRRule _parseRRule(String rrule, DayOfWeek firstDayOfWeek) {
    if (rrule.isEmpty) {
      return const _ParsedRRule(
        interval: defaultInterval,
        month: .january,
        dayOfMonth: defaultByMonthDay,
      );
    }

    const reInterval = r'INTERVAL=(\d+)(?:;|$)';
    const reMonth = r'BYMONTH=(\d+)(?:;|$)';
    const reDayOfMonth = r'BYMONTHDAY=(\d+)(?:;|$)';
    const reDayOfWeek =
        r'BYDAY=((?:MO|TU|WE|TH|FR|SA|SU)'
        r'(?:,(?:MO|TU|WE|TH|FR|SA|SU))*)(?:;|$)';
    const reBySetPos = r'BYSETPOS=(-?\d+)(?:;|$)';

    var match = RegExp(reInterval, caseSensitive: false).firstMatch(rrule);
    final interval = parseInterval(match?.group(1));

    final rest = rrule.substring(match?.end ?? 0);

    match = RegExp(reMonth, caseSensitive: false).firstMatch(rrule);
    final month = parseByMonth(match?.group(1));

    match = RegExp(reDayOfMonth, caseSensitive: false).firstMatch(rest);
    final dayOfMonth = match?.group(1);

    match = RegExp(reDayOfWeek, caseSensitive: false).firstMatch(rest);
    final dayOfWeek = match?.group(1);

    match = RegExp(reBySetPos, caseSensitive: false).firstMatch(rest);
    final dayOfWeekOrdinal = match?.group(1);

    if (dayOfWeek == null) {
      return _ParsedRRule(
        interval: interval,
        month: month,
        dayOfMonth: parseByMonthDay(dayOfMonth, maxValue: month.maxDay),
      );
    } else {
      return _ParsedRRule(
        interval: interval,
        month: month,
        dayOfWeek: parseByDaySingle(dayOfWeek, firstDayOfWeek),
        dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
      );
    }
  }

  void setRRule(String rrule, [DayOfWeek firstDayOfWeek = .monday]) {
    final parsed = _parseRRule(rrule, firstDayOfWeek);

    setIntervalSegmentTypeValue(
      parsed.dayOfMonth == null ? const {.relative} : const {.precise},
    );
    setIntervalValue(parsed.interval);
    setDayOfMonthValue(parsed.dayOfMonth ?? defaultByMonthDay);
    setDayOfWeekValue(
      parsed.dayOfWeekOrdinal ?? .first,
      parsed.dayOfWeek ?? firstDayOfWeek,
      firstDayOfWeek,
    );
    month.value = parsed.month;
  }

  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=YEARLY;INTERVAL=');
    sb.write(intervalNotifier.value);
    sb.write(';BYMONTH=');
    sb.write(month.value.rruleValue);

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
  final int interval;
  final Month month;
  final int? dayOfMonth;
  final DayOfWeek? dayOfWeek;
  final DayOfWeekOrdinal? dayOfWeekOrdinal;

  const _ParsedRRule({
    required this.interval,
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
