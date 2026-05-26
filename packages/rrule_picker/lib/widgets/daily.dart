// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';

class RRulePickerDaily extends StatefulWidget {
  final RRulePickerConfig config;
  final RRulePickerDailyController controller;

  const RRulePickerDaily({
    super.key,
    this.config = const .new(),
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerDailyState();
}

class _RRulePickerDailyState extends State<RRulePickerDaily> {
  late final ValueNotifier<int> interval;
  late final TextEditingController intervalController;

  @override
  void initState() {
    super.initState();
    interval = ValueNotifier(parseRRule(widget.controller.initialRRule));
    intervalController = .new(text: interval.value.toString());
    widget.controller.rruleBuilder = buildRRule;
  }

  @override
  void dispose() {
    widget.controller.rruleBuilder = null;
    intervalController.dispose();
    interval.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final config = widget.config;

    final everyLabel = ValueListenableBuilder(
      valueListenable: interval,
      builder: (context, count, _) => Text(
        localizations.rrulePickerEveryDaily(count),
        style: config.labelStyle,
      ),
    );

    final dayCountField = Expanded(
      child: TextField(
        controller: intervalController,
        keyboardType: .number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: config.textFieldStyle.textStyle,
        decoration: config.textFieldStyle.decoration,
        onChanged: (value) {
          if (int.tryParse(value) case final int count) {
            interval.value = count;
          }
        },
      ),
    );

    final daysLabel = ValueListenableBuilder(
      valueListenable: interval,
      builder: (context, count, _) =>
          Text(localizations.rrulePickerDays(count), style: config.labelStyle),
    );

    return Row(
      children: [
        everyLabel,
        const SizedBox(width: 8),
        dayCountField,
        const SizedBox(width: 8),
        daysLabel,
      ],
    );
  }

  int parseRRule(final String rule) {
    if (rule.isEmpty) {
      return defaultInterval;
    }

    return parseInterval(RegExp(r'INTERVAL=(\d+)').firstMatch(rule)?.group(1));
  }

  void buildRRule(final StringBuffer sb) {
    if (mounted) {
      sb.write('FREQ=DAILY;INTERVAL=');
      sb.write(interval.value > 0 ? interval.value : defaultInterval);
    } else {
      sb.write(widget.controller.initialRRule);
    }
  }
}

class RRulePickerDailyController
    extends RRuleWidgetController<RRulePickerDaily> {
  RRulePickerDailyController([super.initialRRule = '']);

  @override
  set rruleBuilder(RRuleBuilder? value) => super.rruleBuilder = value;
}
