// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class RRulePickerLocalizationsNo extends RRulePickerLocalizations {
  RRulePickerLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Daglig',
      'weekly': 'Ukentlig',
      'monthly': 'Månedlig',
      'yearly': 'Årlig',
      'other': 'Aldri',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Gjenta';
}
