// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/day_of_month.dart';
import 'package:rrule_picker/widgets/day_of_week.dart';
import 'package:rrule_picker/widgets/interval.dart';

class RRulePickerMonthly extends StatefulWidget {
  final RRulePickerConfig config;
  final DayOfWeek firstDayOfWeek;
  final RRulePickerMonthlyController controller;

  const RRulePickerMonthly({
    super.key,
    this.config = const .new(),
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
    final controller = widget.controller;

    final interval = RRulePickerInterval(
      everyUnitText: l.rrulePickerEveryMonthly,
      intervalUnitText: l.rrulePickerMonths,
      intervalController: controller.intervalController,
      intervalNotifier: controller.intervalNotifier,
      config: widget.config,
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
                  return DropdownButton(
                    value: day,
                    isExpanded: true,
                    items: .generate(byMonthDayMax, (i) {
                      final day = i + 1;
                      return switch (day) {
                        byMonthDayMax => DropdownMenuItem(
                          value: day,
                          child: Text(l.rrulePickerLastDay),
                        ),
                        _ => DropdownMenuItem(
                          value: day,
                          child: Text(
                            controller.dayOfMonthFormatter.format(day),
                          ),
                        ),
                      };
                    }),
                    onChanged: (value) => controller.dayOfMonth.value = value!,
                  );
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

                  return Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        child: DropdownButton(
                          isExpanded: true,
                          value: ordinal,
                          items: DayOfWeekOrdinal.values
                              .map((ordinal) {
                                return DropdownMenuItem(
                                  value: ordinal,
                                  child: Text(
                                    l.rrulePickerDayOfWeekOrdinal(ordinal, day),
                                  ),
                                );
                              })
                              .toList(growable: false),
                          onChanged: (value) =>
                              controller.dayOfWeekOrdinal.value = value!,
                        ),
                      ),
                      Flexible(
                        child: DropdownButton(
                          isExpanded: true,
                          value: day,
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
