// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/excluded_dates.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/weekly.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:rrule_picker/theme.dart';

class RRulePicker extends StatefulWidget {
  final String initialRRule;
  final String timezone;
  final bool enableExcludedDates;
  final void Function(String)? onRRuleChanged;
  final RRulePickerController? controller;
  final RRulePickerThemeData? theme;

  const RRulePicker({
    super.key,
    this.initialRRule = '',
    this.timezone = '',
    this.enableExcludedDates = true,
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
      controller = RRulePickerController(
        initialRRule: widget.initialRRule,
        defaultTimeZone: widget.timezone,
        enableExcludedDates: widget.enableExcludedDates,
      );
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
        controller = RRulePickerController(
          initialRRule: widget.initialRRule,
          enableExcludedDates: widget.enableExcludedDates,
        )..addListener(onRRuleChanged);
      } else if (newController != null) {
        // old controller provided internally, new one provided externally
        controller.dispose();
        controller = newController..addListener(onRRuleChanged);
      }
    }

    if (widget.controller != null) {
      controller.excludedDatesEnabled = widget.enableExcludedDates;
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
        child: ListenableBuilder(
          listenable: .merge([
            controller._recurrenceType,
            controller._excludedDatesEnabled,
          ]),
          builder: (_, title) {
            final type = controller._recurrenceType.value;

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

            final picker = switch (type) {
              .never => const SizedBox.shrink(),
              .daily => DailyPicker(controller: controller._daily),
              .weekly => WeeklyPicker(controller: controller._weekly),
              .monthly => MonthlyPicker(controller: controller._monthly),
              .yearly => YearlyPicker(controller: controller._yearly),
            };

            final excluder = type != .never && controller.excludedDatesEnabled
                ? ExcludedDates(controller: controller._excludedDates)
                : const SizedBox.shrink();

            return Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [title!, decorate.dropdown(dropdown), picker, excluder],
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
  late final ExcludedDatesController _excludedDates;
  late final ValueNotifier<bool> _excludedDatesEnabled;

  String _rrule;

  RRulePickerController({
    String initialRRule = '',
    String defaultTimeZone = ExcludedDatesController.defaultTimeZone,
    bool enableExcludedDates = true,
  }) : _rrule = initialRRule,
       _excludedDatesEnabled = ValueNotifier(enableExcludedDates),
       _recurrenceType = .new(_RecurrenceType.fromRRule(initialRRule)) {
    _recurrenceType.addListener(_rruleChanged);

    _daily = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _weekly = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _monthly = .new(initialRRule: initialRRule, listener: _rruleChanged);
    _yearly = .new(initialRRule: initialRRule, listener: _rruleChanged);

    _excludedDates = .new(
      initialRRule: initialRRule,
      defaultTimeZone: defaultTimeZone,
    );

    if (_excludedDatesEnabled.value) {
      _excludedDates.addListener(_rruleChanged);
    }
  }

  @override
  void dispose() {
    _excludedDatesEnabled.dispose();
    _excludedDates.dispose();
    _yearly.dispose();
    _monthly.dispose();
    _weekly.dispose();
    _daily.dispose();
    _recurrenceType.dispose();
    super.dispose();
  }

  bool get excludedDatesEnabled => _excludedDatesEnabled.value;

  set excludedDatesEnabled(bool value) {
    if (_excludedDatesEnabled.value == value) {
      return;
    }

    _excludedDatesEnabled.value = value;

    value
        ? _excludedDates.addListener(_rruleChanged)
        : _excludedDates.removeListener(_rruleChanged);
  }

  @override
  String get value => _rrule;

  void _rruleChanged() {
    _rrule = _buildRRule();
    notifyListeners();
  }

  void setRRule(
    String rrule, {
    String defaultTimeZone = ExcludedDatesController.defaultTimeZone,
  }) {
    if (_rrule == rrule) {
      return;
    }

    _recurrenceType.value = _RecurrenceType.fromRRule(rrule);
    _daily.setRRule(rrule);
    _weekly.setRRule(rrule);
    _monthly.setRRule(rrule);
    _yearly.setRRule(rrule);
    _excludedDates.setRRule(rrule, defaultTimeZone);
  }

  String _buildRRule() {
    final sb = StringBuffer('RRULE:');
    final baseLength = sb.length;
    _buildRRulePart(sb);
    return baseLength == sb.length ? '' : sb.toString();
  }

  void _buildRRulePart(StringBuffer sb) {
    switch (_recurrenceType.value) {
      case .never:
        ;
      case .daily:
        _daily.buildRRulePart(sb);
      case .weekly:
        _weekly.buildRRulePart(sb);
      case .monthly:
        _monthly.buildRRulePart(sb);
      case .yearly:
        _yearly.buildRRulePart(sb);
    }

    if (_recurrenceType.value != .never && excludedDatesEnabled) {
      _excludedDates.buildRRulePart(sb);
    }
  }
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
