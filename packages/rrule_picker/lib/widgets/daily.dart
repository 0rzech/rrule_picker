// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/interval.dart';

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

    return RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryDaily,
      intervalUnitText: localizations.rrulePickerDays,
      intervalNotifier: interval,
      intervalController: intervalController,
      config: widget.config,
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
