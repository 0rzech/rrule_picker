// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/src/shared/global_state.dart' as global;
import 'package:rrule_picker/src/shared/labeled_switch.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class EndDate extends StatefulWidget {
  final EndDateController controller;

  const EndDate({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _EndDateState();
}

class _EndDateState extends State<EndDate> {
  late DateFormat dateFormatter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = RRulePickerLocalizations.of(context).localeName;
    dateFormatter = DateFormat.yMMMMEEEEd(locale);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);

    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, state, _) {
        final endSwitch = LabeledSwitch(
          value: state.enabled,
          onChanged: (value) => widget.controller.enabled = value,
          label: RRulePickerLocalizations.of(context).rrulePickerEndAfterDate,
        );

        final dateButton = OutlinedButton(
          style: theme.outlinedContentButtonStyle,
          onPressed: state.enabled ? datePicker : null,
          child: Text(dateFormatter.format(state.date)),
        );

        return LayoutBuilder(
          builder: (_, constraints) {
            final width = constraints.maxWidth - theme.padding.vertical;
            return width < global.narrowLayoutBreakpoint
                ? Column(spacing: 8, children: [endSwitch, dateButton])
                : Row(
                    spacing: 8,
                    children: [
                      Flexible(child: endSwitch),
                      Flexible(child: Center(child: dateButton)),
                    ],
                  );
          },
        );
      },
    );
  }

  void datePicker() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: widget.controller.value.date,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.add(const Duration(days: 200 * 365)).year),
    );

    if (date != null) {
      widget.controller.date = date;
    }
  }
}

@internal
class EndDateController extends ValueListenable<DateState> with ChangeNotifier {
  final DateFormat _dateFormatter;
  late DateState _state;

  EndDateController({String initialRRule = ''})
    : _dateFormatter = DateFormat('yyyyMMdd') {
    _state = parseRRule(initialRRule);
  }

  @override
  DateState get value => _state;

  set enabled(bool value) {
    _state = (enabled: value, date: _state.date);
    notifyListeners();
  }

  set date(DateTime value) {
    _state = (enabled: _state.enabled, date: value);
    notifyListeners();
  }

  void setRRule(String rrule) {
    _state = parseRRule(rrule);
    notifyListeners();
  }

  void buildRRulePart(StringBuffer sb) => switch (_state) {
    (enabled: false, date: _) => null,
    (enabled: true, :final date) =>
      sb
        ..write(';UNTIL=')
        ..write(_dateFormatter.format(date)),
  };
}

@visibleForTesting
@internal
DateState parseRRule(String rrule) {
  if (rrule.isEmpty) {
    return (enabled: false, date: DateTime.now());
  }

  const reDate = r'UNTIL=(\d{8})(?:;|$)';
  final match = RegExp(reDate, caseSensitive: false).firstMatch(rrule);

  switch (match?.group(1)) {
    case null:
      return (enabled: false, date: DateTime.now());
    case final matched:
      if (DateTime.tryParse(matched) case final parsed?) {
        return (enabled: true, date: parsed);
      } else {
        return (enabled: false, date: DateTime.now());
      }
  }
}

@visibleForTesting
@internal
typedef DateState = ({bool enabled, DateTime date});
