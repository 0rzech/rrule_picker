// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class RRulePickerLocalizationsLv extends RRulePickerLocalizations {
  RRulePickerLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dienas',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Katru',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Katru',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Ikdienas',
      'weekly': 'Iknedēļas',
      'monthly': 'Ikmēneša',
      'yearly': 'Ik gadu',
      'other': 'Nekad',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Atkārtot';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nedēļas',
    );
    return '$_temp0';
  }
}
