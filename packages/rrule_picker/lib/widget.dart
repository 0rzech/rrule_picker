// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/end_date.dart';
import 'package:rrule_picker/src/excluded_dates.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/global_state.dart' as global;
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/weekly.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:rrule_picker/theme.dart';

/// A widget that provides a user interface for creating and editing recurrence
/// rules (RRULE).
///
/// This widget allows users to select different recurrence types (daily,
/// weekly, monthly, yearly) and configure their specific parameters.
/// It also supports excluding specific dates from the recurrence.
class RRulePicker extends StatefulWidget {
  /// See [narrowLayoutBreakpoint].
  static const int defaultNarrowLayoutBreakpoint = 400;

  /// Below this width, [RRulePicker] will apply a narrow adaptive layout.
  ///
  /// The width equals to parent's width -
  /// [RRulePickerThemeData.padding].horizontal.
  ///
  /// The default is [defaultNarrowLayoutBreakpoint].
  static int get narrowLayoutBreakpoint => global.narrowLayoutBreakpoint;
  static set narrowLayoutBreakpoint(int value) =>
      global.narrowLayoutBreakpoint = value;

  /// The initial recurrence rule string to be displayed in the picker.
  ///
  /// Defaults to an empty string, which means no recurrence.
  ///
  /// The value set in [controller] takes precedence over this one,
  /// if not empty.
  final String initialRRule;

  /// The time zone to be used for the recurrence rule. It will *not* be
  /// validated by this package, but it should be a valid time zone name
  /// from the [timezone](https://pub.dev/packages/timezone) package database.
  ///
  /// If not provided, the default time zone will be used, which currently means
  /// an empty string, i.e. no time zone at all.
  ///
  /// The value set in [controller] takes precedence over this one,
  /// if not empty.
  final String timeZone;

  /// Whether to enable the excluded dates feature.
  ///
  /// Defaults to true.
  ///
  /// The value set in [controller] will take precedence over this one.
  final bool enableExcludedDates;

  /// Callback function called when the recurrence rule changes.
  ///
  /// The callback receives the new recurrence rule string as a parameter.
  final void Function(String)? onRRuleChanged;

  /// An optional controller for managing the state of the picker.
  ///
  /// You are responsible for disposing it.
  ///
  /// If not provided, a new controller will be created and managed internally.
  final RRulePickerController? controller;

  /// The theme data for customizing the appearance of the picker.
  final RRulePickerThemeData? theme;

  const RRulePicker({
    super.key,
    this.initialRRule = '',
    this.timeZone = '',
    this.enableExcludedDates = true,
    this.onRRuleChanged,
    this.controller,
    this.theme,
  });

  @override
  State<StatefulWidget> createState() => _RRulePickerState();
}

class _RRulePickerState extends State<RRulePicker> {
  late RRulePickerController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller case final controller?) {
      if (controller.value.isEmpty) {
        controller.setRRule(widget.initialRRule);
      }
      _controller = controller;
    } else {
      _controller = RRulePickerController(
        initialRRule: widget.initialRRule,
        defaultTimeZone: widget.timeZone,
        enableExcludedDates: widget.enableExcludedDates,
      );
    }

    _controller.addListener(onRRuleChanged);
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
        _controller = newController..addListener(onRRuleChanged);
      } else if (oldController != null) {
        // old controller provided externally, new one provided internally
        oldController.removeListener(onRRuleChanged);
        _controller = RRulePickerController(
          initialRRule: widget.initialRRule,
          enableExcludedDates: widget.enableExcludedDates,
        )..addListener(onRRuleChanged);
      } else if (newController != null) {
        // old controller provided internally, new one provided externally
        _controller.dispose();
        _controller = newController..addListener(onRRuleChanged);
      }
    }

    _controller.excludedDatesEnabled = widget.enableExcludedDates;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void onRRuleChanged() => widget.onRRuleChanged?.call(_controller.value);

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
            _controller._recurrenceType,
            _controller._excludedDatesEnabled,
          ]),
          builder: (_, title) {
            final type = _controller._recurrenceType.value;

            final dropdown = DropdownButton(
              value: type,
              isExpanded: true,
              style: theme.topDropdownTheme.style,
              items: RecurrenceType.values
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
              onChanged: (type) => _controller._recurrenceType.value = type!,
            );

            final picker = switch (type) {
              .never => const SizedBox.shrink(),
              .daily => DailyPicker(controller: _controller._daily),
              .weekly => WeeklyPicker(controller: _controller._weekly),
              .monthly => MonthlyPicker(controller: _controller._monthly),
              .yearly => YearlyPicker(controller: _controller._yearly),
            };

            final endDate = type != .never
                ? EndDate(controller: _controller._endDate)
                : const SizedBox.shrink();

            final excluder = type != .never && _controller.excludedDatesEnabled
                ? ExcludedDates(controller: _controller._excludedDates)
                : const SizedBox.shrink();

            return Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              spacing: theme.spacing.column,
              children: [
                title!,
                decorate.dropdown(dropdown),
                picker,
                endDate,
                excluder,
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

/// A controller for managing the state of an [RRulePicker].
///
/// This controller handles the recurrence rule string and provides methods
/// for updating it. It also manages the state of the different recurrence type
/// pickers (daily, weekly, monthly, yearly) and the excluded dates picker.
class RRulePickerController extends ValueListenable<String>
    with ChangeNotifier {
  final ValueNotifier<RecurrenceType> _recurrenceType;
  late final DailyPickerController _daily;
  late final WeeklyPickerController _weekly;
  late final MonthlyPickerController _monthly;
  late final YearlyPickerController _yearly;
  late final EndDateController _endDate;
  late final ExcludedDatesController _excludedDates;
  late final ValueNotifier<bool> _excludedDatesEnabled;

  late String _rrule;

  /// Creates a new [RRulePickerController].
  ///
  /// [initialRRule] is the initial recurrence rule string. Defaults to an empty
  /// string. Takes precedence over [RRulePicker.initialRRule].
  ///
  /// [defaultTimeZone] is the default time zone to be used for the excluded
  /// dates. Defaults to [ExcludedDatesController.defaultTimeZone].
  /// Takes precedence over [RRulePicker.timeZone].
  ///
  /// [enableExcludedDates] determines whether the excluded dates feature
  /// is enabled. Defaults to true. Takes precedence over
  /// [RRulePicker.enableExcludedDates].
  RRulePickerController({
    String initialRRule = '',
    String defaultTimeZone = ExcludedDatesController.defaultTimeZone,
    bool enableExcludedDates = true,
  }) : _excludedDatesEnabled = ValueNotifier(enableExcludedDates),
       _recurrenceType = .new(RecurrenceType.fromRRule(initialRRule)) {
    _recurrenceType.addListener(_rruleChanged);

    _daily = .new(listener: _rruleChanged, initialRRule: initialRRule);
    _weekly = .new(listener: _rruleChanged, initialRRule: initialRRule);
    _monthly = .new(listener: _rruleChanged, initialRRule: initialRRule);
    _yearly = .new(listener: _rruleChanged, initialRRule: initialRRule);
    _endDate = .new(initialRRule: initialRRule)..addListener(_rruleChanged);

    _excludedDates = .new(
      initialRRule: initialRRule,
      defaultTimeZone: defaultTimeZone,
    );

    if (_excludedDatesEnabled.value) {
      _excludedDates.addListener(_rruleChanged);
    }

    _rrule = _buildRRule();
  }

  @override
  void dispose() {
    _excludedDatesEnabled.dispose();
    _excludedDates.dispose();
    _endDate.dispose();
    _yearly.dispose();
    _monthly.dispose();
    _weekly.dispose();
    _daily.dispose();
    _recurrenceType.dispose();
    super.dispose();
  }

  /// Whether the excluded dates feature is enabled.
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

  /// Current recurrence rule string.
  @override
  String get value => _rrule;

  void _rruleChanged() {
    _rrule = _buildRRule();
    notifyListeners();
  }

  /// Sets the recurrence rule string. Empty string means no time zone.
  ///
  /// [rrule] is the new recurrence rule string.
  /// [defaultTimeZone] is the default time zone to be used for the excluded
  /// dates.
  void setRRule(
    String rrule, {
    String defaultTimeZone = ExcludedDatesController.defaultTimeZone,
  }) {
    if (_rrule == rrule) {
      return;
    }

    _recurrenceType.value = RecurrenceType.fromRRule(rrule);
    _daily.setRRule(rrule);
    _weekly.setRRule(rrule);
    _monthly.setRRule(rrule);
    _yearly.setRRule(rrule);
    _endDate.setRRule(rrule);
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
      case .never: // noop
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

    if (_recurrenceType.value != .never) {
      _endDate.buildRRulePart(sb);

      if (_excludedDatesEnabled.value) {
        _excludedDates.buildRRulePart(sb);
      }
    }
  }
}

@visibleForTesting
enum RecurrenceType {
  never,
  daily,
  weekly,
  monthly,
  yearly;

  static RecurrenceType fromRRule(String rrule) =>
      switch (rrule.toUpperCase()) {
        final r when r.isEmpty => .never,
        final r when r.contains('DAILY') => .daily,
        final r when r.contains('WEEKLY') => .weekly,
        final r when r.contains('MONTHLY') => .monthly,
        final r when r.contains('YEARLY') => .yearly,
        _ => .never,
      };
}
