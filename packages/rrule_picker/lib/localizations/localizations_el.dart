// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class RRulePickerLocalizationsEl extends RRulePickerLocalizations {
  RRulePickerLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ημέρες',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Ημέρες',
      'weekly': 'Εβδομάδες',
      'monthly': 'Μήνες',
      'yearly': 'Ετη',
      'other': 'Χωρίς επανάληψη',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Επανάλαβε';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εβδομάδες',
    );
    return '$_temp0';
  }
}
