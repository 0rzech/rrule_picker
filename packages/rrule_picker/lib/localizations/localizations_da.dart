// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class RRulePickerLocalizationsDa extends RRulePickerLocalizations {
  RRulePickerLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dag(e)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hver',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Daglige',
      'weekly': 'Ugentlig',
      'monthly': 'Månedlige',
      'yearly': 'Årligt',
      'other': 'Aldrig',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Gentage';
}
