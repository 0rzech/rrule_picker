// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/l10n/l10n.dart';

@internal
class ExcludedDates extends StatefulWidget {
  final ExcludedDatesController controller;

  const ExcludedDates({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _ExcludedDatesState();
}

class _ExcludedDatesState extends State<ExcludedDates> {
  late DateFormat dateFormatter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = RRulePickerLocalizations.of(context).localeName;
    dateFormatter = DateFormat.yMMMMEEEEd(locale);
  }

  @override
  Widget build(BuildContext context) {
    final addButton = OutlinedButton.icon(
      label: Text(RRulePickerLocalizations.of(context).rrulePickerSkip),
      icon: const Icon(Icons.add),
      onPressed: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime(now.year, now.month, now.day),
          firstDate: DateTime(1900),
          lastDate: DateTime(now.add(const Duration(days: 200 * 365)).year),
        );

        if (date != null) {
          widget.controller.addDate(date);
        }
      },
    );

    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (_, value, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          addButton,
          ...value.map((date) {
            return ListTile(
              title: Text(dateFormatter.format(date)),
              titleAlignment: .center,
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.controller.removeDate(date),
              ),
              visualDensity: .adaptivePlatformDensity,
            );
          }),
        ],
      ),
    );
  }
}

@internal
class ExcludedDatesController
    extends ValueListenable<UnmodifiableSetView<DateTime>>
    with ChangeNotifier {
  static const defaultTimeZone = '';

  final DateFormat _dateFormat;
  late String _timeZone;
  late SplayTreeSet<DateTime> _dates;
  late UnmodifiableSetView<DateTime> _unmodifiable;

  ExcludedDatesController({
    String initialRRule = '',
    String defaultTimeZone = defaultTimeZone,
  }) : _dateFormat = DateFormat('yyyyMMdd') {
    final (timeZone, dates) = parseRRule(initialRRule, defaultTimeZone);
    _timeZone = timeZone;
    _dates = dates;
    _unmodifiable = UnmodifiableSetView(dates);
  }

  String get timeZone => _timeZone;

  @override
  UnmodifiableSetView<DateTime> get value => _unmodifiable;

  void addDate(DateTime date) {
    if (_dates.add(date)) {
      notifyListeners();
    }
  }

  void removeDate(DateTime date) {
    if (_dates.remove(date)) {
      notifyListeners();
    }
  }

  void setRRule(String rrule, [String? defaultTimeZone]) {
    final (timeZone, dates) = parseRRule(rrule, defaultTimeZone ?? _timeZone);
    if (_timeZone == timeZone &&
        _dates.length == dates.length &&
        _dates.containsAll(dates)) {
      return;
    }

    _timeZone = timeZone;
    _dates = dates;
    _unmodifiable = UnmodifiableSetView(dates);

    notifyListeners();
  }

  void buildRRulePart(StringBuffer sb) {
    if (_dates.isEmpty) {
      return;
    }

    sb.write(';EXDATE');

    if (_timeZone.isNotEmpty) {
      sb.write(';TZID=');
      sb.write(_timeZone);
    }

    sb.write(';VALUE=DATE:');
    sb.write(_dates.map(_dateFormat.format).join(','));
  }
}

@visibleForTesting
@internal
(String, SplayTreeSet<DateTime>) parseRRule(
  String rrule,
  String defaultTimeZone,
) {
  final dates = SplayTreeSet<DateTime>();

  if (rrule.isEmpty) {
    return (defaultTimeZone, dates);
  }

  const reTimeZone = r'TZID=([a-zA-Z_/]{3,})(?:;|$)';
  const reDates = r'VALUE=DATE:(\d{8}(?:,\d{8})*)(?:;|$)';

  var match = RegExp(reTimeZone, caseSensitive: false).firstMatch(rrule);
  final timeZone = match?.group(1);

  match = RegExp(reDates, caseSensitive: false).firstMatch(rrule);
  if (match?.group(1) case final group?) {
    dates.addAll(group.split(',').map(DateTime.tryParse).whereType<DateTime>());
  }

  return (timeZone ?? defaultTimeZone, dates);
}
