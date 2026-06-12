// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
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
  final void Function(String)? onRRuleChanged;
  final RRulePickerController? controller;
  final RRulePickerThemeData? theme;

  const RRulePicker({
    super.key,
    this.initialRRule = '',
    this.onRRuleChanged,
    this.controller,
    this.theme,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerState();
}

class _RRulePickerState extends State<RRulePicker> {
  late final RRulePickerController controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller case final controller?) {
      if (controller.value.isEmpty) {
        controller.setRRule(widget.initialRRule);
      }
      this.controller = controller;
    } else {
      controller = RRulePickerController(initialRRule: widget.initialRRule);
    }

    controller.addListener(onRRuleChanged);
  }

  @override
  void didUpdateWidget(covariant RRulePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldController = oldWidget.controller;
    final newController = widget.controller;

    if (oldController != newController) {
      if (oldController != null && newController != null) {
        // both controllers provided externally
        oldController.removeListener(onRRuleChanged);
        controller = newController..addListener(onRRuleChanged);
      } else if (oldController != null) {
        // old controller provided externally, new one provided internally
        oldController.removeListener(onRRuleChanged);
        controller = RRulePickerController(initialRRule: widget.initialRRule)
          ..addListener(onRRuleChanged);
      } else if (newController != null) {
        // old controller provided internally, new one provided externally
        controller.dispose();
        controller = newController..addListener(onRRuleChanged);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      controller.dispose();
    }
  }

  void onRRuleChanged() => widget.onRRuleChanged?.call(controller.value);

  @override
  Widget build(BuildContext context) {
    final localizations = RRulePickerLocalizations.of(context);
    final theme = ResolvedThemeData.resolve(context, widget.theme);
    final decorate = widget.dropdownDecorators(theme.topDropdownTheme);

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

class RRulePickerController extends ValueListenable<String>
    with ChangeNotifier {
  final ValueNotifier<_RecurrenceType> _recurrenceType;
  late final DailyPickerController _daily;
  late final WeeklyPickerController _weekly;
  late final MonthlyPickerController _monthly;
  late final YearlyPickerController _yearly;
  String _rrule;

  RRulePickerController({String initialRRule = ''})
    : _rrule = initialRRule,
      _recurrenceType = .new(_RecurrenceType.fromRRule(initialRRule)) {
    _recurrenceType.addListener(_rruleChanged);
    _daily = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _weekly = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _monthly = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _yearly = .new(initialRRule: initialRRule, listener: _rruleChanged);
  }

  @override
  void dispose() {
    _yearly.dispose();
    _monthly.dispose();
    _weekly.dispose();
    _daily.dispose();
    _recurrenceType.dispose();
    super.dispose();
  }

  @override
  String get value => _rrule;

  void _rruleChanged() {
    _rrule = _buildRRule();
    notifyListeners();
  }

  void setRRule(String rrule) {
    if (_rrule == rrule) {
      return;
    }

    _recurrenceType.value = _RecurrenceType.fromRRule(rrule);
    _daily.setRRule(rrule);
    _weekly.setRRule(rrule);
    _monthly.setRRule(rrule);
    _yearly.setRRule(rrule);
  }

  String _buildRRule() {
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
