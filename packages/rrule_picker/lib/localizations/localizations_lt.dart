// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class RRulePickerLocalizationsLt extends RRulePickerLocalizations {
  RRulePickerLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dieną',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kiekvieną',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Kasdien',
      'weekly': 'Kas savaitę',
      'monthly': 'Kas mėnesį',
      'yearly': 'Metinis',
      'other': 'Niekada',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Kartoti';
}
