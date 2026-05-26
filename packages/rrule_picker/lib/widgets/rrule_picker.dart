// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/widgets/daily.dart';

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
  late final ValueNotifier<_RecurrenceType> recurrenceType;

  late final RRulePickerDailyController dailyController;

  @override
  void initState() {
    super.initState();
    recurrenceType = .new(getRecurrenceType(widget.controller.initialRRule));

    dailyController = .new(widget.controller.initialRRule);

    widget.controller.rruleBuilder = buildRRule;
  }

  @override
  void dispose() {
    widget.controller.rruleBuilder = null;
    recurrenceType.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final config = widget.config;

    return Padding(
      padding: config.padding,
      child: ValueListenableBuilder(
        valueListenable: recurrenceType,
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
            onChanged: (type) => recurrenceType.value = type!,
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
              switch (recurrenceType.value) {
                .daily => RRulePickerDaily(controller: dailyController),
                _ => const SizedBox.shrink(),
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

  _RecurrenceType getRecurrenceType(final String rrule) {
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

  void buildRRule(final StringBuffer sb) => mounted
      ? switch (recurrenceType.value) {
          .never => null,
          .daily => dailyController.buildRRulePart(sb),
          .weekly => null,
          .monthly => null,
          .yearly => null,
        }
      : sb.write(widget.controller.initialRRule);
}

class RRulePickerController extends RRuleWidgetController<RRulePicker> {
  RRulePickerController([super.initialRRule = '']);

  @override
  set rruleBuilder(final RRuleBuilder? value) => super.rruleBuilder = value;

  String buildRRule() {
    final sb = StringBuffer('RRULE:');
    final baseLength = sb.length;
    buildRRulePart(sb);
    return baseLength == sb.length ? '' : sb.toString();
  }
}

enum _RecurrenceType { never, daily, weekly, monthly, yearly }
