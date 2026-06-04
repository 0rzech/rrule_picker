// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/interval.dart';

class RRulePickerDaily extends StatelessWidget {
  final RRulePickerConfig config;
  final RRulePickerDailyController controller;

  const RRulePickerDaily({
    super.key,
    this.config = const .new(),
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);

    return RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryDaily,
      intervalUnitText: localizations.rrulePickerDays,
      intervalNotifier: controller.intervalNotifier,
      intervalController: controller.intervalController,
      config: config,
    );
  }
}

class RRulePickerDailyController with RRulePickerIntervalState {
  RRulePickerDailyController([String initialRRule = '']) {
    initIntervalState(_parseRRule(initialRRule));
  }

  @mustCallSuper
  void dispose() => disposeIntervalState();

  int _parseRRule(String rule) {
    if (rule.isEmpty) {
      return defaultInterval;
    }

    return parseInterval(RegExp(r'INTERVAL=(\d+)').firstMatch(rule)?.group(1));
  }

  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=DAILY;INTERVAL=');
    sb.write(getIntervalValue());
  }
}
