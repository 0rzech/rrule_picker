// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class RRulePickerLocalizationsNl extends RRulePickerLocalizations {
  RRulePickerLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Dagelijks',
      'weekly': 'Wekelijks',
      'monthly': 'Maandelijks',
      'yearly': 'Jaarlijks',
      'other': 'Nooit',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Herhaal';
}
