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

class _RRulePickerWeeklyState extends State<RRulePickerWeekly>
    with RRulePickerIntervalState {
  late final ValueNotifier<Set<DayOfWeek>> selectedDaysOfWeek;
  late DateFormat dayOfWeekFormat;
  late List<(DayOfWeek, String)> daysOfWeek;

  @override
  void initState() {
    super.initState();
    final (weeks, days) = parseRRule(widget.controller.initialRRule);
    initIntervalState(weeks);
    widget.controller.rrulePartBuilder = buildRRulePart;
    selectedDaysOfWeek = ValueNotifier(days);
  }

  @override
  void dispose() {
    selectedDaysOfWeek.dispose();
    widget.controller.rrulePartBuilder = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = RRulePickerLocalizations.of(context).localeName;
    dayOfWeekFormat = DateFormat.E(locale);
    daysOfWeek = DayOfWeek.buildWeek(widget.firstDayOfWeek, dayOfWeekFormat);
  }

  @override
  void didUpdateWidget(covariant RRulePickerWeekly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      daysOfWeek = DayOfWeek.buildWeek(widget.firstDayOfWeek, dayOfWeekFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final localizations = RRulePickerLocalizations.of(context);

    final interval = RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryWeekly,
      intervalController: intervalController,
      intervalUnitText: localizations.rrulePickerWeeks,
      intervalNotifier: intervalNotifier,
      config: config,
    );

    final dayOfWeekSelector = SizedBox(
      width: .infinity,
      child: ValueListenableBuilder(
        valueListenable: selectedDaysOfWeek,
        builder: (context, selected, _) => SegmentedButton(
          style: config.dayOfWeekStyle.buttonStyle,
          multiSelectionEnabled: true,
          showSelectedIcon: false,
          segments: daysOfWeek
              .map((day) {
                return ButtonSegment(
                  value: day.$1,
                  label: FittedBox(child: Text(day.$2)),
                );
              })
              .toList(growable: false),
          selected: selected,
          onSelectionChanged: (value) => selectedDaysOfWeek.value = value,
        ),
      ),
    );

    return Column(spacing: 8, children: [interval, dayOfWeekSelector]);
  }

  (int, Set<DayOfWeek>) parseRRule(String rule) {
    if (rule.isEmpty) {
      return (defaultInterval, {widget.firstDayOfWeek});
    }

    const re = r'INTERVAL=(\d+);BYDAY=([AEFHMORSTUW,]+)';
    final match = RegExp(re).firstMatch(rule);

    return (
      parseInterval(match?.group(1)),
      parseByDayMulti(match?.group(2), {widget.firstDayOfWeek}),
    );
  }

  void buildRRulePart(StringBuffer sb) {
    if (mounted) {
      sb.write('FREQ=WEEKLY;INTERVAL=');
      sb.write(getIntervalValue());
      sb.write(';BYDAY=');
      final sorted = selectedDaysOfWeek.value.toList(growable: false)
        ..sort(DayOfWeek.compare);
      sb.write(sorted.map((d) => d.rruleName).join(','));
    } else {
      sb.write(widget.controller.initialRRule);
    }
  }
}

class RRulePickerWeeklyController
    extends RRuleWidgetController<RRulePickerWeekly> {
  RRulePickerWeeklyController([super.initialRRule = '']);

  @override
  set rrulePartBuilder(RRulePartBuilder? value) =>
      super.rrulePartBuilder = value;
}
