// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

@internal
class DailyPicker extends StatelessWidget {
  final DailyPickerController controller;

  const DailyPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);

    return IntervalPicker(
      everyUnitText: localizations.rrulePickerEveryDaily,
      intervalUnitText: localizations.rrulePickerDays,
      intervalNotifier: controller.intervalNotifier,
      intervalController: controller.intervalController,
    );
  }
}

@internal
class DailyPickerController with IntervalPickerState {
  DailyPickerController({
    String initialRRule = '',
    required VoidCallback listener,
  }) {
    initIntervalState(
      initialValue: _parseRRule(initialRRule),
      listener: listener,
    );
  }

  @mustCallSuper
  void dispose() => disposeIntervalState();

  int _parseRRule(String rrule) {
    if (rrule.isEmpty) {
      return defaultInterval;
    }

    return parseInterval(RegExp(r'INTERVAL=(\d+)').firstMatch(rrule)?.group(1));
  }

  void setRRule(String rrule) => setIntervalValue(_parseRRule(rrule));

  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=DAILY;INTERVAL=');
    sb.write(getIntervalValue());
  }
}
