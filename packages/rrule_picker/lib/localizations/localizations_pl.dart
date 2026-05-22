// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class RRulePickerLocalizationsPl extends RRulePickerLocalizations {
  RRulePickerLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dnia',
      many: 'dni',
      few: 'dni',
      one: 'dzień',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Każde',
      one: 'Każdy',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Dziennie',
      'weekly': 'Tygodniowo',
      'monthly': 'Miesięcznie',
      'yearly': 'Rocznie',
      'other': 'Nigdy',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Powtarzaj';
}
