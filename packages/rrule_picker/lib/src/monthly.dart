// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/day_of_month.dart';
import 'package:rrule_picker/src/shared/day_of_week.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class RRulePickerMonthly extends StatefulWidget {
  final DayOfWeek firstDayOfWeek;
  final RRulePickerMonthlyController controller;

  const RRulePickerMonthly({
    super.key,
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerMonthlyState();
}

class _RRulePickerMonthlyState extends State<RRulePickerMonthly> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant RRulePickerMonthly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      widget.controller._updateState(firstDayOfWeek: widget.firstDayOfWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = RRulePickerTheme.of(context);
    final decorate = widget.dropdownDecorators(theme.dropdownTheme);
    final controller = widget.controller;

    final interval = RRulePickerInterval(
      everyUnitText: l.rrulePickerEveryMonthly,
      intervalUnitText: l.rrulePickerMonths,
      intervalController: controller.intervalController,
      intervalNotifier: controller.intervalNotifier,
    );

    return ValueListenableBuilder(
      valueListenable: controller.intervalSegmentType,
      builder: (context, segmentType, interval) {
        return Column(
          spacing: 8,
          children: [
            interval!,
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
class RRulePickerMonthlyController
    with
        RRulePickerIntervalSegmentTypeState,
        RRulePickerIntervalState,
        RRulePickerDayOfMonthState,
        RRulePickerDayOfWeekState {
  RRulePickerMonthlyController([
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  ]) {
    final rrule = _parseRRule(initialRRule, firstDayOfWeek);

    initIntervalSegmentTypeState(
      rrule.dayOfMonth == null ? const {.relative} : const {.precise},
    );
    initIntervalState(rrule.interval);
    initDayOfMonthState(rrule.dayOfMonth ?? defaultByMonthDay);
    initDayOfWeekState(
      rrule.dayOfWeekOrdinal ?? .first,
      rrule.dayOfWeek ?? firstDayOfWeek,
    );
  }

  @mustCallSuper
  void dispose() {
    disposeDayOfWeekState();
    disposeDayOfMonthState();
    disposeIntervalState();
    disposeIntervalSegmentTypeState();
  }

  void _updateState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) => updateDayOfWeekState(
    localizations: localizations,
    firstDayOfWeek: firstDayOfWeek,
  );

  _ParsedRRule _parseRRule(String rule, DayOfWeek firstDayOfWeek) {
    if (rule.isEmpty) {
      return const _ParsedRRule(
        interval: defaultInterval,
        dayOfMonth: defaultByMonthDay,
      );
    }

    const reInterval = r'INTERVAL=(\d+)';
    const reDayOfMonth = r'BYMONTHDAY=(\d+)';
    const reDayOfWeek = r'BYDAY=([AEFHMORSTUW,]+);BYSETPOS=(-?\d+)';

    var match = RegExp(reInterval).firstMatch(rule);
    final interval = parseInterval(match?.group(1));

    final rest = rule.substring(match?.end ?? 0);

    match = RegExp(reDayOfMonth).firstMatch(rest);
    final dayOfMonth = match?.group(1);

    match = RegExp(reDayOfWeek).firstMatch(rest);
    final dayOfWeek = match?.group(1);
    final dayOfWeekOrdinal = match?.group(2);

    if (dayOfWeek == null) {
      return _ParsedRRule(
        interval: interval,
        dayOfMonth: parseByMonthDay(dayOfMonth),
      );
    } else {
      return _ParsedRRule(
        interval: interval,
        dayOfWeek: parseByDaySingle(dayOfWeek, firstDayOfWeek),
        dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
      );
    }
  }

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

class _ParsedRRule {
  final int interval;
  final int? dayOfMonth;
  final DayOfWeek? dayOfWeek;
  final DayOfWeekOrdinal? dayOfWeekOrdinal;

  const _ParsedRRule({
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
