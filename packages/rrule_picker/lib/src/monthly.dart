// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class MonthlyPicker extends StatefulWidget {
  final DayOfWeek firstDayOfWeek;
  final MonthlyPickerController controller;

  const MonthlyPicker({
    super.key,
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _MonthlyPickerState();
}

class _MonthlyPickerState extends State<MonthlyPicker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant MonthlyPicker oldWidget) {
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
      everyUnitText: l.rrulePickerEveryMonthly,
      intervalUnitText: l.rrulePickerMonths,
      controller: controller,
    );

    return ValueListenableBuilder(
      valueListenable: controller.intervalSegmentType,
      builder: (context, segmentType, interval) {
        return Column(
          spacing: 8,
          children: [
            interval!,
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
              .precise => ValueListenableBuilder(
                valueListenable: controller.dayOfMonth,
                builder: (context, day, _) {
                  final dropdown = DropdownButton(
                    value: day,
                    isExpanded: true,
                    style: theme.dropdownTheme.style,
                    items: .generate(byMonthDayMax, (i) {
                      final day = i + 1;
                      final text = switch (day) {
                        byMonthDayMax => Text(
                          l.rrulePickerLastDay,
                          style: theme.dropdownTheme.menuItemStyle,
                        ),
                        _ => Text(
                          controller.dayOfMonthFormatter.format(day),
                          style: theme.dropdownTheme.menuItemStyle,
                        ),
                      };

                      return DropdownMenuItem(
                        value: day,
                        child: decorate.dropdownMenuItem(text),
                      );
                    }),
                    onChanged: (value) => controller.dayOfMonth.value = value!,
                  );

                  return decorate.dropdown(dropdown);
                },
              ),
              .relative => ListenableBuilder(
                listenable: .merge([
                  controller.daysOfWeek,
                  controller.dayOfWeekOrdinal,
                  controller.dayOfWeek,
                ]),
                builder: (context, _) {
                  final ordinal = controller.dayOfWeekOrdinal.value;
                  final day = controller.dayOfWeek.value;

                  final ordinalDropdown = DropdownButton(
                    isExpanded: true,
                    value: ordinal,
                    style: theme.dropdownTheme.style,
                    items: DayOfWeekOrdinal.values
                        .map((ordinal) {
                          final text = Text(
                            l.rrulePickerDayOfWeekOrdinal(ordinal, day),
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

                  final dayDropdown = DropdownButton(
                    isExpanded: true,
                    value: day,
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
                    onChanged: (value) => controller.dayOfWeek.value = value!,
                  );

                  return Row(
                    spacing: 8,
                    children: [
                      Flexible(child: decorate.dropdown(ordinalDropdown)),
                      Flexible(child: decorate.dropdown(dayDropdown)),
                    ],
                  );
                },
              ),
            },
          ],
        );
      },
      child: interval,
    );
  }
}

@internal
class MonthlyPickerController extends IntervalPickerSegmentController {
  factory MonthlyPickerController({
    required VoidCallback listener,
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  }) {
    final rrule = parseRRule(initialRRule, firstDayOfWeek);

    return MonthlyPickerController._(
      listener: listener,
      initialInterval: rrule.interval,
      initialSegmentType: rrule.dayOfMonth == null
          ? const {.relative}
          : const {.precise},
      initialDayOfMonth: rrule.dayOfMonth ?? defaultByMonthDay,
      initialDayOfWeekOrdinal: rrule.dayOfWeekOrdinal ?? .first,
      initialDayOfWeek: rrule.dayOfWeek ?? firstDayOfWeek,
    );
  }

  MonthlyPickerController._({
    required super.listener,
    required super.initialInterval,
    required super.initialSegmentType,
    required super.initialDayOfMonth,
    required super.initialDayOfWeekOrdinal,
    required super.initialDayOfWeek,
  });

  void _updateState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) => updateDayOfWeekState(
    localizations: localizations,
    firstDayOfWeek: firstDayOfWeek,
  );

  @override
  void setRRule(String rrule, [DayOfWeek firstDayOfWeek = .monday]) {
    final parsed = parseRRule(rrule, firstDayOfWeek);

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
  }

  @override
  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=MONTHLY;INTERVAL=');
    sb.write(getIntervalValue());

    switch (intervalSegmentType.value.first) {
      case .precise:
        sb.write(';BYMONTHDAY=');
        sb.write(dayOfMonth.value == byMonthDayMax ? -1 : dayOfMonth.value);
      case .relative:
        sb.write(';BYDAY=');
        sb.write(dayOfWeek.value.rruleName);
        sb.write(';BYSETPOS=');
        sb.write(dayOfWeekOrdinal.value.rruleValue);
    }
  }
}

@internal
ParsedRRule parseRRule(String rrule, DayOfWeek firstDayOfWeek) {
  if (rrule.isEmpty) {
    return const ParsedRRule(
      interval: defaultInterval,
      dayOfMonth: defaultByMonthDay,
    );
  }

  const reInterval = r'INTERVAL=(\d+)(?:;|$)';
  const reByMonthDay = r'BYMONTHDAY=(-?\d+)(?:;|$)';
  const reByDay =
      r'BYDAY=((?:MO|TU|WE|TH|FR|SA|SU)'
      r'(?:,(?:MO|TU|WE|TH|FR|SA|SU))*)(?:;|$)';
  const reBySetPos = r'BYSETPOS=(-?\d+)(?:;|$)';

  var match = RegExp(reInterval, caseSensitive: false).firstMatch(rrule);
  final interval = parseInterval(match?.group(1));

  final rest = rrule.substring(match?.end ?? 0);

  match = RegExp(reByMonthDay, caseSensitive: false).firstMatch(rest);
  final dayOfMonth = match?.group(1);

  match = RegExp(reByDay, caseSensitive: false).firstMatch(rest);
  final dayOfWeek = match?.group(1);

  match = RegExp(reBySetPos, caseSensitive: false).firstMatch(rest);
  final dayOfWeekOrdinal = match?.group(1);

  return dayOfWeek == null
      ? ParsedRRule(interval: interval, dayOfMonth: parseByMonthDay(dayOfMonth))
      : ParsedRRule(
          interval: interval,
          dayOfWeek: parseByDaySingle(dayOfWeek, firstDayOfWeek),
          dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
        );
}

@internal
class ParsedRRule {
  final int interval;
  final int? dayOfMonth;
  final DayOfWeek? dayOfWeek;
  final DayOfWeekOrdinal? dayOfWeekOrdinal;

  const ParsedRRule({
    required this.interval,
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
