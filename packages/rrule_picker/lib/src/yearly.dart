// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/global_state.dart' as global;
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

part 'yearly/day_of_month.dart';
part 'yearly/day_of_week.dart';
part 'yearly/day_of_week_ordinal.dart';
part 'yearly/month.dart';
part 'yearly/precise_segment.dart';
part 'yearly/relative_segment.dart';

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
    final controller = widget.controller;

    final interval = IntervalPicker(
      everyUnitText: l.rrulePickerEveryYearly,
      intervalUnitText: l.rrulePickerYears,
      controller: controller,
    );

    final month = _MonthDropdown(
      month: controller.month,
      monthFormatter: controller.monthFormatter,
      onChanged: (value) {
        controller.month.value = value!;
        controller.dayOfMonth.value = min(
          controller.dayOfMonth.value,
          controller.month.value.maxDay,
        );
      },
    );

    final slash = Text('/', style: theme.labelStyle);

    return ValueListenableBuilder(
      valueListenable: controller.intervalSegmentType,
      builder: (_, segmentType, _) {
        final segmentTypeButton = IntervalSegmentTypeButton(
          segmentType: segmentType,
          preciseText: l.rrulePickerDayOfMonth,
          relativeText: l.rrulePickerDayOfWeek,
          onSelectionChanged: (value) =>
              controller.intervalSegmentType.value = value,
        );

        return switch (segmentType.first) {
          .precise => _PreciseIntervalSegment(
            intervalPicker: interval,
            segmentTypeButton: segmentTypeButton,
            monthDropdown: month,
            slash: slash,
            dayOfMonthDropdown: _DayOfMonthDropdown(
              month: controller.month,
              dayOfMonth: controller.dayOfMonth,
              dayOfMonthFormatter: controller.dayOfMonthFormatter,
              onChanged: (value) => controller.dayOfMonth.value = value!,
            ),
          ),
          .relative => _RelativeIntervalSegment(
            intervalPicker: interval,
            segmentTypeButton: segmentTypeButton,
            monthDropdown: month,
            slash: slash,
            dayOfWeekOrdinalDropdown: _DayOfWeekOrdinalDropdown(
              daysOfWeek: controller.daysOfWeek,
              dayOfWeekOrdinal: controller.dayOfWeekOrdinal,
              dayOfWeek: controller.dayOfWeek,
              onChanged: (value) => controller.dayOfWeekOrdinal.value = value!,
            ),
            dayOfWeekDropdown: _DayOfWeekDropdown(
              daysOfWeek: controller.daysOfWeek,
              dayOfWeek: controller.dayOfWeek,
              onChanged: (value) => controller.dayOfWeek.value = value!,
            ),
          ),
        };
      },
    );
  }
}

@internal
class YearlyPickerController extends IntervalPickerSegmentController {
  final ValueNotifier<Month> month;
  late DateFormat monthFormatter;

  factory YearlyPickerController({
    required VoidCallback listener,
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  }) {
    final rrule = parseRRule(initialRRule, firstDayOfWeek);

    return YearlyPickerController._(
      listener: listener,
      initialInterval: rrule.interval,
      initialSegmentType: rrule.dayOfMonth == null
          ? const {.relative}
          : const {.precise},
      initialDayOfMonth: rrule.dayOfMonth ?? defaultByMonthDay,
      initialDayOfWeekOrdinal: rrule.dayOfWeekOrdinal ?? .first,
      initialDayOfWeek: rrule.dayOfWeek ?? firstDayOfWeek,
      month: ValueNotifier(rrule.month)..addListener(listener),
    );
  }

  YearlyPickerController._({
    required super.listener,
    required super.initialInterval,
    required super.initialSegmentType,
    required super.initialDayOfMonth,
    required super.initialDayOfWeekOrdinal,
    required super.initialDayOfWeek,
    required this.month,
  });

  @override
  void dispose() {
    month.dispose();
    super.dispose();
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
    month.value = parsed.month;
  }

  @override
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

@visibleForTesting
@internal
ParsedRRule parseRRule(String rrule, DayOfWeek firstDayOfWeek) {
  if (rrule.isEmpty) {
    return const ParsedRRule(
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

  return dayOfWeek == null
      ? ParsedRRule(
          interval: interval,
          month: month,
          dayOfMonth: parseByMonthDay(dayOfMonth, maxValue: month.maxDay),
        )
      : ParsedRRule(
          interval: interval,
          month: month,
          dayOfWeek: parseByDaySingle(dayOfWeek, firstDayOfWeek),
          dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
        );
}

@visibleForTesting
@internal
class ParsedRRule {
  final int interval;
  final Month month;
  final int? dayOfMonth;
  final DayOfWeek? dayOfWeek;
  final DayOfWeekOrdinal? dayOfWeekOrdinal;

  const ParsedRRule({
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
