// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/weekly.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:rrule_picker/theme.dart';

class RRulePicker extends StatefulWidget {
  final String initialRRule;
  final RRulePickerController controller;
  final RRulePickerThemeData? theme;

  const RRulePicker({
    super.key,
    this.initialRRule = '',
    required this.controller,
    this.theme,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerState();
}

class _RRulePickerState extends State<RRulePicker> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.initialRRule.isEmpty &&
        widget.initialRRule.isNotEmpty) {
      widget.controller.setRRule(widget.initialRRule);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final theme = ResolvedThemeData.resolve(context, widget.theme);
    final decorate = widget.dropdownDecorators(theme.topDropdownTheme);
    final controller = widget.controller;

    return ResolvedTheme(
      theme: theme,
      child: Padding(
        padding: theme.padding,
        child: ValueListenableBuilder(
          valueListenable: controller._recurrenceType,
          builder: (context, type, title) {
            final dropdown = DropdownButton(
              value: type,
              isExpanded: true,
              style: theme.topDropdownTheme.style,
              items: _RecurrenceType.values
                  .map((value) {
                    final text = Text(
                      localizations.rrulePickerRecurrenceType(value.name),
                      style: theme.topDropdownTheme.menuItemStyle,
                    );

                    return DropdownMenuItem(
                      value: value,
                      child: decorate.dropdownMenuItem(text),
                    );
                  })
                  .toList(growable: false),
              onChanged: (type) => controller._recurrenceType.value = type!,
            );

            return Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                title!,
                decorate.dropdown(dropdown),
                switch (controller._recurrenceType.value) {
                  .never => const SizedBox.shrink(),
                  .daily => DailyPicker(controller: controller._daily),
                  .weekly => WeeklyPicker(controller: controller._weekly),
                  .monthly => MonthlyPicker(controller: controller._monthly),
                  .yearly => YearlyPicker(controller: controller._yearly),
                },
              ],
            );
          },
          child: theme.headerTheme.showHeaderOrDefault
              ? Text(
                  localizations.rrulePickerTitle,
                  style: theme.headerTheme.style,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class RRulePickerController {
  final String initialRRule;
  final ValueNotifier<_RecurrenceType> _recurrenceType;
  final DailyPickerController _daily;
  final WeeklyPickerController _weekly;
  final MonthlyPickerController _monthly;
  final YearlyPickerController _yearly;

  RRulePickerController({String initialRRule = ''})
    : initialRRule = initialRRule,
      _recurrenceType = .new(_RecurrenceType.fromRRule(initialRRule)),
      _daily = .new(initialRRule),
      _weekly = .new(initialRRule),
      _monthly = .new(initialRRule),
      _yearly = .new(initialRRule);

  @mustCallSuper
  void dispose() {
    _yearly.dispose();
    _monthly.dispose();
    _weekly.dispose();
    _daily.dispose();
    _recurrenceType.dispose();
  }

  void setRRule(String rrule) {
    _recurrenceType.value = _RecurrenceType.fromRRule(rrule);
    _daily.setRRule(rrule);
    _weekly.setRRule(rrule);
    _monthly.setRRule(rrule);
    _yearly.setRRule(rrule);
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

enum _RecurrenceType {
  never,
  daily,
  weekly,
  monthly,
  yearly;

  static _RecurrenceType fromRRule(String rrule) {
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
}
