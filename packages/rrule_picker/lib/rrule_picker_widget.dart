// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/rrule_picker_config.dart';
import 'package:rrule_picker/src/widgets/daily.dart';
import 'package:rrule_picker/src/widgets/monthly.dart';
import 'package:rrule_picker/src/widgets/weekly.dart';
import 'package:rrule_picker/src/widgets/yearly.dart';

class RRulePicker extends StatefulWidget {
  final RRulePickerController controller;
  final RRulePickerConfig config;

  const RRulePicker({
    super.key,
    required this.controller,
    this.config = const .new(),
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerState();
}

class _RRulePickerState extends State<RRulePicker> {
  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final controller = widget.controller;
    final config = widget.config;

    return Padding(
      padding: config.padding,
      child: ValueListenableBuilder(
        valueListenable: controller._recurrenceType,
        builder: (context, type, title) {
          final dropdownButton = DropdownButton(
            style: config.dropdownStyle.textStyle,
            isExpanded: true,
            value: type,
            items: _RecurrenceType.values
                .map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Container(
                      decoration: config.dropdownStyle.menuItemDecoration,
                      child: Text(
                        localizations.rrulePickerRecurrenceType(
                          value.toString(),
                        ),
                        style: config.dropdownStyle.textStyle,
                      ),
                    ),
                  );
                })
                .toList(growable: false),
            onChanged: (type) => controller._recurrenceType.value = type!,
          );

          final dropdown = Container(
            decoration: config.dropdownStyle.decoration,
            child: DropdownButtonHideUnderline(child: dropdownButton),
          );

          return Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              title!,
              dropdown,
              switch (controller._recurrenceType.value) {
                .never => const SizedBox.shrink(),
                .daily => RRulePickerDaily(controller: controller._daily),
                .weekly => RRulePickerWeekly(controller: controller._weekly),
                .monthly => RRulePickerMonthly(controller: controller._monthly),
                .yearly => RRulePickerYearly(controller: controller._yearly),
              },
            ],
          );
        },
        child: config.headerStyle.enabled
            ? Text(
                localizations.rrulePickerTitle,
                style: config.headerStyle.textStyle,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class RRulePickerController {
  late final ValueNotifier<_RecurrenceType> _recurrenceType;

  late final RRulePickerDailyController _daily;
  late final RRulePickerWeeklyController _weekly;
  late final RRulePickerMonthlyController _monthly;
  late final RRulePickerYearlyController _yearly;

  RRulePickerController([String initialRRule = '']) {
    _recurrenceType = .new(_getRecurrenceType(initialRRule));

    _daily = .new(initialRRule);
    _weekly = .new(initialRRule);
    _monthly = .new(initialRRule);
    _yearly = .new(initialRRule);
  }

  @mustCallSuper
  void dispose() {
    _yearly.dispose();
    _monthly.dispose();
    _weekly.dispose();
    _daily.dispose();
    _recurrenceType.dispose();
  }

  _RecurrenceType _getRecurrenceType(String rrule) {
    if (rrule.isEmpty) {
      return .never;
    } else if (rrule.contains('DAILY')) {
      return .daily;
    } else if (rrule.contains('WEEKLY')) {
      return .weekly;
    } else if (rrule.contains('MONTHLY')) {
      return .monthly;
    } else {
      return .yearly;
    }
  }

  String buildRRule() {
    final sb = StringBuffer('RRULE:');
    final baseLength = sb.length;
    buildRRulePart(sb);
    return baseLength == sb.length ? '' : sb.toString();
  }

  void buildRRulePart(StringBuffer sb) => switch (_recurrenceType.value) {
    .never => null,
    .daily => _daily.buildRRulePart(sb),
    .weekly => _weekly.buildRRulePart(sb),
    .monthly => _monthly.buildRRulePart(sb),
    .yearly => _yearly.buildRRulePart(sb),
  };
}

enum _RecurrenceType { never, daily, weekly, monthly, yearly }
