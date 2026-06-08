// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/shared/theme.dart';
import 'package:rrule_picker/src/weekly.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:rrule_picker/theme.dart';

class RRulePicker extends StatefulWidget {
  final RRulePickerController controller;
  final RRulePickerThemeData? theme;

  const RRulePicker({super.key, required this.controller, this.theme});

  @override
  State<StatefulWidget> createState() => _RRulePickerState();
}

class _RRulePickerState extends State<RRulePicker> {
  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final theme = RRulePickerResolvedThemeData.resolve(context, widget.theme);
    final controller = widget.controller;

    return RRulePickerTheme(
      theme: theme,
      child: Padding(
        padding: theme.padding,
        child: ValueListenableBuilder(
          valueListenable: controller._recurrenceType,
          builder: (context, type, title) {
            final dropdownButton = DropdownButton(
              style: theme.dropdownStyle,
              isExpanded: true,
              value: type,
              items: _RecurrenceType.values
                  .map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Container(
                        decoration: theme.dropdownMenuItemDecoration,
                        child: Text(
                          localizations.rrulePickerRecurrenceType(
                            value.toString(),
                          ),
                          style: theme.dropdownMenuItemStyle,
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
              onChanged: (type) => controller._recurrenceType.value = type!,
            );

            final dropdown = Container(
              decoration: theme.dropdownDecoration,
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
                  .monthly => RRulePickerMonthly(
                    controller: controller._monthly,
                  ),
                  .yearly => RRulePickerYearly(controller: controller._yearly),
                },
              ],
            );
          },
          child: theme.showHeader
              ? Text(localizations.rrulePickerTitle, style: theme.headerStyle)
              : const SizedBox.shrink(),
        ),
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
    _buildRRulePart(sb);
    return baseLength == sb.length ? '' : sb.toString();
  }

  void _buildRRulePart(StringBuffer sb) => switch (_recurrenceType.value) {
    .never => null,
    .daily => _daily.buildRRulePart(sb),
    .weekly => _weekly.buildRRulePart(sb),
    .monthly => _monthly.buildRRulePart(sb),
    .yearly => _yearly.buildRRulePart(sb),
  };
}

enum _RecurrenceType { never, daily, weekly, monthly, yearly }
