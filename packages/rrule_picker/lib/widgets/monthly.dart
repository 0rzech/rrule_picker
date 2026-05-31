// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
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
  late final ValueNotifier<Set<_SegmentType>> segmentType;

  late final ValueNotifier<int> interval;
  late final TextEditingController intervalController;

  late final ValueNotifier<int> dayOfMonth;
  late final NumberFormat dayOfMonthFormatter;

  late final DateFormat dayOfWeekFormatter;
  late final ValueNotifier<List<(DayOfWeek, String)>> daysOfWeek;
  late final ValueNotifier<DayOfWeekOrdinal> dayOfWeekOrdinal;
  late final ValueNotifier<DayOfWeek> dayOfWeek;

  @override
  void initState() {
    super.initState();
    final rrule = parseRRule(widget.controller.initialRRule);

    segmentType = ValueNotifier({
      rrule.dayOfMonth == null ? .relative : .precise,
    });

    interval = ValueNotifier(rrule.interval);
    intervalController = .new(text: interval.value.toString());

    dayOfMonth = ValueNotifier(rrule.dayOfMonth ?? defaultByMonthDay);
    dayOfMonthFormatter = NumberFormat('00');

    dayOfWeekOrdinal = ValueNotifier(rrule.dayOfWeekOrdinal ?? .first);
    dayOfWeek = ValueNotifier(rrule.dayOfWeek ?? widget.firstDayOfWeek);

    widget.controller.rrulePartBuilder = buildRRulePart;
  }

  @override
  void dispose() {
    widget.controller.rrulePartBuilder = null;

    dayOfWeek.dispose();
    dayOfWeekOrdinal.dispose();
    daysOfWeek.dispose();

    dayOfMonth.dispose();

    intervalController.dispose();
    interval.dispose();

    segmentType.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = RRulePickerLocalizations.of(context).localeName;
    dayOfWeekFormatter = DateFormat.EEEE(locale);
    daysOfWeek = ValueNotifier(
      DayOfWeek.buildWeek(widget.firstDayOfWeek, dayOfWeekFormatter),
    );
  }

  @override
  void didUpdateWidget(covariant RRulePickerMonthly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDayOfWeek != widget.firstDayOfWeek) {
      daysOfWeek.value = DayOfWeek.buildWeek(
        widget.firstDayOfWeek,
        dayOfWeekFormatter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);

    final interval = RRulePickerInterval(
      everyUnitText: l.rrulePickerEveryMonthly,
      intervalUnitText: l.rrulePickerMonths,
      intervalController: intervalController,
      intervalNotifier: this.interval,
      config: widget.config,
    );

    return ValueListenableBuilder(
      valueListenable: segmentType,
      builder: (context, segment, interval) {
        return Column(
          spacing: 8,
          children: [
            interval!,
            SegmentedButton<_SegmentType>(
              onSelectionChanged: (value) => segmentType.value = value,
              selected: segment,
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
            switch (segment.first) {
              .precise => ValueListenableBuilder(
                valueListenable: dayOfMonth,
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
                          child: Text(dayOfMonthFormatter.format(day)),
                        ),
                      };
                    }),
                    onChanged: (value) => dayOfMonth.value = value!,
                  );
                },
              ),
              .relative => ListenableBuilder(
                listenable: .merge([daysOfWeek, dayOfWeekOrdinal, dayOfWeek]),
                builder: (context, _) {
                  final ordinal = dayOfWeekOrdinal.value;
                  final day = dayOfWeek.value;

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
                          onChanged: (value) => dayOfWeekOrdinal.value = value!,
                        ),
                      ),
                      Flexible(
                        child: DropdownButton(
                          isExpanded: true,
                          value: day,
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

  _ParsedRRule parseRRule(String rule) {
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
        dayOfWeek: parseByDaySingle(dayOfWeek, widget.firstDayOfWeek),
        dayOfWeekOrdinal: parseBySetPosNthWeekDay(dayOfWeekOrdinal),
      );
    }
  }

  void buildRRulePart(StringBuffer sb) {
    if (mounted) {
      sb.write('FREQ=MONTHLY;INTERVAL=');
      sb.write(interval.value > 0 ? interval.value : defaultInterval);

      switch (segmentType.value.first) {
        case .precise:
          sb.write(';BYMONTHDAY=');
          sb.write(dayOfMonth.value == byMonthDayMax ? -1 : dayOfMonth.value);
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

enum DayOfWeekOrdinal {
  first(1),
  second(2),
  third(3),
  fourth(4),
  last(-1);

  final int rruleValue;

  const DayOfWeekOrdinal(this.rruleValue);

  static DayOfWeekOrdinal? tryParse(String text) {
    return switch (int.tryParse(text)) {
      0 => first,
      1 => second,
      2 => third,
      3 => fourth,
      -1 => last,
      _ => null,
    };
  }
}

class RRulePickerMonthlyController
    extends RRuleWidgetController<RRulePickerMonthly> {
  RRulePickerMonthlyController([super.initialRRule = '']);

  @override
  set rrulePartBuilder(RRulePartBuilder? value) =>
      super.rrulePartBuilder = value;
}

enum _SegmentType { precise, relative }

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
