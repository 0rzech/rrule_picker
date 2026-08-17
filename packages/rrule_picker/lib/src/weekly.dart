// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/shared/split_segmented_button.dart';

@internal
class WeeklyPicker extends StatefulWidget {
  final DayOfWeek firstDayOfWeek;
  final WeeklyPickerController controller;

  const WeeklyPicker({
    super.key,
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _WeeklyPickerState();
}

class _WeeklyPickerState extends State<WeeklyPicker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant WeeklyPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      widget.controller._updateState(firstDayOfWeek: widget.firstDayOfWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);
    final l = RRulePickerLocalizations.of(context);
    final controller = widget.controller;

    final interval = IntervalPicker(
      everyUnitText: l.rrulePickerEveryWeekly,
      intervalUnitText: l.rrulePickerWeeks,
      controller: controller,
    );

    final dayOfWeekSelector = SizedBox(
      width: .infinity,
      child: ValueListenableBuilder(
        valueListenable: controller.selectedDaysOfWeek,
        builder: (_, selectedDays, _) {
          return SplitSegmentedButton<DayOfWeek, (DayOfWeek, String)>(
            selected: selectedDays,
            onSelectionChanged: (days) =>
                controller.selectedDaysOfWeek.value = days,
            segmentInput: controller.daysOfWeek,
            segmentMapper: (day) =>
                SplitButtonSegment(value: day.$1, text: day.$2),
          );
        },
      ),
    );

    return Column(
      mainAxisSize: .min,
      spacing: theme.spacing.column,
      children: [interval, dayOfWeekSelector],
    );
  }
}

@internal
class WeeklyPickerController extends IntervalPickerController {
  final ValueNotifier<Set<DayOfWeek>> selectedDaysOfWeek;
  DateFormat dayOfWeekFormat;
  List<(DayOfWeek, String)> daysOfWeek;

  factory WeeklyPickerController({
    required VoidCallback listener,
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  }) {
    final (weeks, days) = parseRRule(initialRRule, firstDayOfWeek);
    final dayOfWeekFormat = DateFormat.E();

    return WeeklyPickerController._(
      listener: listener,
      initialInterval: weeks,
      selectedDaysOfWeek: ValueNotifier(days)..addListener(listener),
      dayOfWeekFormat: dayOfWeekFormat,
      daysOfWeek: DayOfWeek.buildWeek(firstDayOfWeek, dayOfWeekFormat),
    );
  }

  WeeklyPickerController._({
    required super.listener,
    required super.initialInterval,
    required this.selectedDaysOfWeek,
    required this.dayOfWeekFormat,
    required this.daysOfWeek,
  });

  @override
  void dispose() {
    selectedDaysOfWeek.dispose();
    super.dispose();
  }

  void _updateState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) {
    if (localizations != null) {
      dayOfWeekFormat = DateFormat.E(localizations.localeName);
    }

    if (firstDayOfWeek != null) {
      daysOfWeek = DayOfWeek.buildWeek(firstDayOfWeek, dayOfWeekFormat);
    }
  }

  @override
  void setRRule(String rrule, [DayOfWeek firstDayOfWeek = .monday]) {
    final (weeks, days) = parseRRule(rrule, firstDayOfWeek);
    setIntervalValue(weeks);
    selectedDaysOfWeek.value = days;
    if (daysOfWeek.first.$1 != firstDayOfWeek) {
      daysOfWeek = DayOfWeek.buildWeek(firstDayOfWeek, dayOfWeekFormat);
    }
  }

  @override
  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=WEEKLY;INTERVAL=');
    sb.write(getIntervalValue());
    sb.write(';BYDAY=');
    final sorted = selectedDaysOfWeek.value.toList(growable: false)
      ..sort(DayOfWeek.compare);
    sb.write(sorted.map((d) => d.rruleName).join(','));
  }
}

@visibleForTesting
@internal
(int, Set<DayOfWeek>) parseRRule(String rrule, DayOfWeek firstDayOfWeek) {
  if (rrule.isEmpty) {
    return (defaultInterval, {firstDayOfWeek});
  }

  const reInterval = r'INTERVAL=(\d+)(?:;|$)';
  const reByDay =
      r'BYDAY=((?:MO|TU|WE|TH|FR|SA|SU)'
      r'(?:,(?:MO|TU|WE|TH|FR|SA|SU))*)(?:;|$)';

  var match = RegExp(reInterval, caseSensitive: false).firstMatch(rrule);
  final interval = parseInterval(match?.group(1));

  final rest = rrule.substring(match?.end ?? 0);
  match = RegExp(reByDay, caseSensitive: false).firstMatch(rest);
  final byDayMulti = parseByDayMulti(match?.group(1), {firstDayOfWeek});

  return (interval, byDayMulti);
}
