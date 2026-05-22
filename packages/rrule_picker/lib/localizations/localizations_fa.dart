// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class RRulePickerLocalizationsFa extends RRulePickerLocalizations {
  RRulePickerLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'روز',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'روزانه',
      'weekly': 'هفتگی',
      'monthly': 'ماهانه',
      'yearly': 'سالانه',
      'other': 'هرگز',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'تکرار';
}
