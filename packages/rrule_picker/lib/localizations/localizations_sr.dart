// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class RRulePickerLocalizationsSr extends RRulePickerLocalizations {
  RRulePickerLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dani',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Svaki',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Dnevno',
      'weekly': 'Tjedno',
      'monthly': 'Mjesečno',
      'yearly': 'Godišnje',
      'other': 'Nikada',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Ponovi';
}
