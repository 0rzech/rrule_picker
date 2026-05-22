// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class RRulePickerLocalizationsTr extends RRulePickerLocalizations {
  RRulePickerLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'gün(ler)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Her',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Günlük',
      'weekly': 'Haftalık',
      'monthly': 'Aylık',
      'yearly': 'Yıllık',
      'other': 'Asla',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Tekrarlamak';
}
