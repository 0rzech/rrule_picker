// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/l10n/l10n.dart';
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
      controller: controller,
    );
  }
}

@internal
class DailyPickerController extends IntervalPickerController {
  DailyPickerController({required super.listener, String initialRRule = ''})
    : super(initialInterval: parseRRule(initialRRule));

  @override
  void setRRule(String rrule) => setIntervalValue(parseRRule(rrule));

  @override
  void buildRRulePart(StringBuffer sb) {
    sb.write('FREQ=DAILY;INTERVAL=');
    sb.write(getIntervalValue());
  }
}

@visibleForTesting
@internal
int parseRRule(String rrule) {
  if (rrule.isEmpty) {
    return defaultInterval;
  }

  const re = r'INTERVAL=(\d+)(?:;|$)';
  final interval = RegExp(re, caseSensitive: false).firstMatch(rrule)?.group(1);

  return parseInterval(interval);
}
