// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/day_of_month.dart';
import 'package:rrule_picker/widgets/day_of_week.dart';
import 'package:rrule_picker/widgets/interval.dart';

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

class _RRulePickerYearlyState extends State<RRulePickerYearly>
    with
        RRulePickerIntervalSegmentTypeState,
        RRulePickerDayOfMonthState,
        RRulePickerDayOfWeekState {
  late final ValueNotifier<Month> month;
  late DateFormat monthFormatter;

  @override
  void initState() {
    super.initState();
    final rrule = parseRRule(widget.controller.initialRRule);

    initIntervalSegmentTypeState(
      rrule.dayOfMonth == null ? const {.relative} : const {.precise},
    );
    initDayOfMonthState(rrule.dayOfMonth ?? defaultByMonthDay);
    initDayOfWeekState(
      rrule.dayOfWeekOrdinal ?? .first,
      rrule.dayOfWeek ?? widget.firstDayOfWeek,
    );
    month = ValueNotifier(rrule.month);
    widget.controller.rrulePartBuilder = buildRRulePart;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rebuildDaysOfWeek(.monday);
    final locale = RRulePickerLocalizations.of(context).localeName;
    monthFormatter = DateFormat.MMMM(locale);
  }

  @override
  void didUpdateWidget(covariant RRulePickerYearly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      rebuildDaysOfWeek(.monday);
    }
  }

  @override
  void dispose() {
    widget.controller.rrulePartBuilder = null;
    month.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);

    final monthWidget = ValueListenableBuilder(
      valueListenable: month,
      builder: (context, day, _) => Flexible(
        child: DropdownButton(
          value: day,
          isExpanded: true,
          items: Month.values
              .map((month) {
                final date = DateTime(2026, 01 + month.index, 01);
                return DropdownMenuItem(
                  value: month,
                  child: Text(monthFormatter.format(date)),
                );
              })
              .toList(growable: false),
          onChanged: (value) {
            month.value = value!;
            dayOfMonth.value = min(dayOfMonth.value, month.value.maxDay);
          },
        ),
      ),
    );

    return ValueListenableBuilder(
      valueListenable: intervalSegmentType,
      builder: (context, segmentType, monthWidget) {
        return Column(
          spacing: 8,
          children: [
            SegmentedButton<RRulePickerIntervalSegmentType>(
              onSelectionChanged: (value) => intervalSegmentType.value = value,
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
                    valueListenable: dayOfMonth,
                    builder: (_, day, _) => Flexible(
                      child: DropdownButton(
                        value: day,
                        isExpanded: true,
                        items: .generate(month.value.maxDay, (i) {
                          final day = i + 1;
                          final text = Text(dayOfMonthFormatter.format(day));
                          return DropdownMenuItem(value: day, child: text);
                        }, growable: false),
                        onChanged: (value) => dayOfMonth.value = value!,
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
                      daysOfWeek,
                      dayOfWeekOrdinal,
                      dayOfWeek,
                    ]),
                    builder: (_, _) => Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        value: dayOfWeekOrdinal.value,
                        items: DayOfWeekOrdinal.values
                            .map((ordinal) {
                              return DropdownMenuItem(
                                value: ordinal,
                                child: Text(
                                  l.rrulePickerDayOfWeekOrdinal(
                                    ordinal,
                                    dayOfWeek.value,
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) => dayOfWeekOrdinal.value = value!,
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: .merge([daysOfWeek, dayOfWeek]),
                    builder: (_, _) => Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        value: dayOfWeek.value,
                        items: daysOfWeek.value
                            .map((day) {
                              return DropdownMenuItem(
                                value: day.$1,
                                child: Text(day.$2),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (value) => dayOfWeek.value = value!,
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

  _ParsedRRule parseRRule(String rule) {
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
        dayOfWeek: parseByDaySingle(dayOfWeek, widget.firstDayOfWeek),
        dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
      );
    }
  }

  void buildRRulePart(StringBuffer sb) {
    if (mounted) {
      sb.write('FREQ=YEARLY;BYMONTH=');
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
    } else {
      sb.write(widget.controller.initialRRule);
    }
  }
}

class RRulePickerYearlyController
    extends RRuleWidgetController<RRulePickerYearly> {
  RRulePickerYearlyController([super.initialRRule = '']);

  @override
  set rrulePartBuilder(RRulePartBuilder? value) =>
      super.rrulePartBuilder = value;
}

enum Month {
  january('1', 31),
  february('2', 29),
  march('3', 31),
  april('4', 30),
  may('5', 31),
  june('6', 30),
  july('7', 31),
  august('8', 31),
  september('9', 30),
  october('10', 31),
  november('11', 30),
  december('12', 31);

  final String rruleValue;
  final int maxDay;

  const Month(this.rruleValue, this.maxDay);

  static Month? tryParse(String value) => switch (value) {
    '1' => january,
    '2' => february,
    '3' => march,
    '4' => april,
    '5' => may,
    '6' => june,
    '7' => july,
    '8' => august,
    '9' => september,
    '10' => october,
    '11' => november,
    '12' => december,
    _ => null,
  };
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
