// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

@internal
class RRulePickerDaily extends StatelessWidget {
  final RRulePickerDailyController controller;

  const RRulePickerDaily({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);

    return RRulePickerInterval(
      everyUnitText: localizations.rrulePickerEveryDaily,
      intervalUnitText: localizations.rrulePickerDays,
      intervalNotifier: controller.intervalNotifier,
      intervalController: controller.intervalController,
    );
  }
}

@internal
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
