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

class _RRulePickerDailyState extends State<RRulePickerDaily>
    with RRulePickerIntervalState {
  @override
  void initState() {
    super.initState();
    initIntervalState(parseRRule(widget.controller.initialRRule));
    widget.controller.rrulePartBuilder = buildRRulePart;
  }

  @override
  void dispose() {
    widget.controller.rrulePartBuilder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);

    return RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryDaily,
      intervalUnitText: localizations.rrulePickerDays,
      intervalNotifier: intervalNotifier,
      intervalController: intervalController,
      config: widget.config,
    );
  }

  int parseRRule(String rule) {
    if (rule.isEmpty) {
      return defaultInterval;
    }

    return parseInterval(RegExp(r'INTERVAL=(\d+)').firstMatch(rule)?.group(1));
  }

  void buildRRulePart(StringBuffer sb) {
    if (mounted) {
      sb.write('FREQ=DAILY;INTERVAL=');
      sb.write(getIntervalValue());
    } else {
      sb.write(widget.controller.initialRRule);
    }
  }
}

class RRulePickerDailyController
    extends RRuleWidgetController<RRulePickerDaily> {
  RRulePickerDailyController([super.initialRRule = '']);

  @override
  set rrulePartBuilder(RRulePartBuilder? value) =>
      super.rrulePartBuilder = value;
}
