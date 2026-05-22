// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class RRulePickerLocalizationsSl extends RRulePickerLocalizations {
  RRulePickerLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dni',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Denne',
      'weekly': 'Týždenne',
      'monthly': 'Mesačne',
      'yearly': 'Ročne',
      'other': 'Nikdy',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Ponovi';
}
