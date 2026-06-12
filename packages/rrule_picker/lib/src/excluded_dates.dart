// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/localizations/localizations.dart';

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
    final addButton = ElevatedButton.icon(
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
  static const defaultTimeZone = 'Etc/UTC';

  final _numberFormatter = NumberFormat('00');

  late final String _timezone;
  late final SplayTreeSet<DateTime> _dates;
  late final UnmodifiableSetView<DateTime> _unmodifiable;

  ExcludedDatesController({
    String initialRRule = '',
    String defaultTimeZone = defaultTimeZone,
  }) {
    final (timezone, dates) = _parseRRule(initialRRule);
    _timezone = timezone ?? defaultTimeZone;
    _dates = dates;
    _unmodifiable = UnmodifiableSetView(_dates);
  }

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

  void setRRule(String rrule, [String defaultTimeZone = defaultTimeZone]) {
    final (timezone, dates) = _parseRRule(rrule);
    _timezone = timezone ?? defaultTimeZone;
    _dates = dates;
    _unmodifiable = UnmodifiableSetView(_dates);
  }

  (String?, SplayTreeSet<DateTime>) _parseRRule(String rrule) {
    final dates = SplayTreeSet<DateTime>();

    if (rrule.isEmpty) {
      return (defaultTimeZone, dates);
    }

    const reTimeZone = r'TZID=([a-zA-Z/]{7-})';
    const reDates = r'VALUE=DATE:(\d{8})(?:,(\d{8}))*';

    var match = RegExp(reTimeZone).firstMatch(rrule);
    final timeZone = match?.group(1);

    match = RegExp(reDates).firstMatch(rrule);
    if (match != null) {
      for (var i = 0; i < match.groupCount; ++i) {
        if (match.group(i + 1) case final text?) {
          dates.add(DateTime.parse(text.replaceFirst(',', '')));
        }
      }
    }

    return (timeZone ?? defaultTimeZone, dates);
  }

  void buildRRulePart(StringBuffer sb) {
    if (_dates.isEmpty) {
      return;
    }

    sb.write(';EXDATE;TZID=');
    sb.write(_timezone);
    sb.write(';VALUE=DATE:');

    for (final (i, date) in _dates.indexed) {
      if (i > 0) {
        sb.write(',');
      }
      sb.write(date.year);
      sb.write(_numberFormatter.format(date.month));
      sb.write(_numberFormatter.format(date.day));
    }
  }
}
