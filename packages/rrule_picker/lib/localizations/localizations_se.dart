// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Northern Sami (`se`).
class RRulePickerLocalizationsSe extends RRulePickerLocalizations {
  RRulePickerLocalizationsSe([String locale = 'se']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'beaivi(t)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Beaivválaš',
      'weekly': 'Vahkkosaš',
      'monthly': 'Mánnui',
      'yearly': 'Jahkásaččat',
      'other': 'Ii goassige',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Geardduhit';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vahkku(t)',
    );
    return '$_temp0';
  }
}
