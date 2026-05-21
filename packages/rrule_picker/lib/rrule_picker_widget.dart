// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/rrule_picker.dart';

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

  @override
  void initState() {
    super.initState();
    recurrenceType = .new(.never);
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
            children: [title!, dropdown],
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

  void buildRRule(final StringBuffer sb) =>
      mounted ? null : sb.write(widget.controller.initialRRule);
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
