// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/interval.dart';

class RRulePickerWeekly extends StatefulWidget {
  final RRulePickerConfig config;
  final DayOfWeek firstDayOfWeek;
  final RRulePickerWeeklyController controller;

  const RRulePickerWeekly({
    super.key,
    this.config = const .new(),
    this.firstDayOfWeek = .monday,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerWeeklyState();
}

class _RRulePickerWeeklyState extends State<RRulePickerWeekly> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._updateState(
      localizations: RRulePickerLocalizations.of(context),
      firstDayOfWeek: widget.firstDayOfWeek,
    );
  }

  @override
  void didUpdateWidget(covariant RRulePickerWeekly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      widget.controller._updateState(firstDayOfWeek: widget.firstDayOfWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final localizations = RRulePickerLocalizations.of(context);

    final interval = RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryWeekly,
      intervalController: widget.controller.intervalController,
      intervalUnitText: localizations.rrulePickerWeeks,
      intervalNotifier: widget.controller.intervalNotifier,
      config: config,
    );

    final dayOfWeekSelector = SizedBox(
      width: .infinity,
      child: ValueListenableBuilder(
        valueListenable: widget.controller.selectedDaysOfWeek,
        builder: (context, selected, _) => SegmentedButton(
          style: config.dayOfWeekStyle.buttonStyle,
          multiSelectionEnabled: true,
          showSelectedIcon: false,
          segments: widget.controller.daysOfWeek
              .map((day) {
                return ButtonSegment(
                  value: day.$1,
                  label: FittedBox(child: Text(day.$2)),
                );
              })
              .toList(growable: false),
          selected: selected,
          onSelectionChanged: (value) =>
              widget.controller.selectedDaysOfWeek.value = value,
        ),
      ),
    );

    return Column(spacing: 8, children: [interval, dayOfWeekSelector]);
  }
}

class RRulePickerWeeklyController with RRulePickerIntervalState {
  late final ValueNotifier<Set<DayOfWeek>> selectedDaysOfWeek;
  late DateFormat dayOfWeekFormat;
  late List<(DayOfWeek, String)> daysOfWeek;

  RRulePickerWeeklyController([
    String initialRRule = '',
    DayOfWeek firstDayOfWeek = .monday,
  ]) {
    final (weeks, days) = _parseRRule(initialRRule, firstDayOfWeek);
    initIntervalState(weeks);
    selectedDaysOfWeek = ValueNotifier(days);
  }

  @mustCallSuper
  void dispose() {
    selectedDaysOfWeek.dispose();
    disposeIntervalState();
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

  (int, Set<DayOfWeek>) _parseRRule(String rule, DayOfWeek firstDayOfWeek) {
    if (rule.isEmpty) {
      return (defaultInterval, {firstDayOfWeek});
    }

    const re = r'INTERVAL=(\d+);BYDAY=([AEFHMORSTUW,]+)';
    final match = RegExp(re).firstMatch(rule);

    return (
      parseInterval(match?.group(1)),
      parseByDayMulti(match?.group(2), {firstDayOfWeek}),
    );
  }

  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=WEEKLY;INTERVAL=');
    sb.write(getIntervalValue());
    sb.write(';BYDAY=');
    final sorted = selectedDaysOfWeek.value.toList(growable: false)
      ..sort(DayOfWeek.compare);
    sb.write(sorted.map((d) => d.rruleName).join(','));
  }
}
