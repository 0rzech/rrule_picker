// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/rrule_picker_config.dart';
import 'package:rrule_picker/src/widgets/shared/day_of_month.dart';
import 'package:rrule_picker/src/widgets/shared/day_of_week.dart';
import 'package:rrule_picker/src/widgets/shared/extensions.dart';
import 'package:rrule_picker/src/widgets/shared/interval.dart';
import 'package:rrule_picker/src/widgets/shared/parsing.dart';

@internal
class RRulePickerYearly extends StatefulWidget {
  final RRulePickerConfig config;
  final DayOfWeek firstDayOfWeek;
  final RRulePickerYearlyController controller;

  const RRulePickerYearly({
    super.key,
    this.config = const .new(),
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
    final controller = widget.controller;

    final monthWidget = ValueListenableBuilder(
      valueListenable: controller._month,
      builder: (context, day, _) => Flexible(
        child: DropdownButton(
          value: day,
          isExpanded: true,
          items: Month.values
              .map((month) {
                final date = DateTime(2026, 01 + month.index, 01);
                return DropdownMenuItem(
                  value: month,
                  child: Text(controller._monthFormatter.format(date)),
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
        ),
      ),
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
                  Text(l.rrulePickerEveryMonth),
                  monthWidget!,
                  const Text('/'),
                  ValueListenableBuilder(
                    valueListenable: controller.dayOfMonth,
                    builder: (_, day, _) => Flexible(
                      child: DropdownButton(
                        value: day,
                        isExpanded: true,
                        items: .generate(controller._month.value.maxDay, (i) {
                          final day = i + 1;
                          final text = Text(
                            controller.dayOfMonthFormatter.format(day),
                          );
                          return DropdownMenuItem(value: day, child: text);
                        }, growable: false),
                        onChanged: (value) =>
                            controller.dayOfMonth.value = value!,
                      ),
                    ),
                  ),
                ],
              ),
              .relative => Row(
                spacing: 9,
                children: [
                  Text(l.rrulePickerEveryMonth),
                  monthWidget!,
                  const Text('/'),
                  ListenableBuilder(
                    listenable: .merge([
                      controller.daysOfWeek,
                      controller.dayOfWeekOrdinal,
                      controller.dayOfWeek,
                    ]),
                    builder: (_, _) => Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        value: controller.dayOfWeekOrdinal.value,
                        items: DayOfWeekOrdinal.values
                            .map((ordinal) {
                              return DropdownMenuItem(
                                value: ordinal,
                                child: Text(
                                  l.rrulePickerDayOfWeekOrdinal(
                                    ordinal,
                                    controller.dayOfWeek.value,
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) =>
                            controller.dayOfWeekOrdinal.value = value!,
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: .merge([
                      controller.daysOfWeek,
                      controller.dayOfWeek,
                    ]),
                    builder: (_, _) => Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        value: controller.dayOfWeek.value,
                        items: controller.daysOfWeek.value
                            .map((day) {
                              return DropdownMenuItem(
                                value: day.$1,
                                child: Text(day.$2),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) =>
                            controller.dayOfWeek.value = value!,
                      ),
                    ),
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
