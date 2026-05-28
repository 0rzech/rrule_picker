// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class RRulePickerLocalizationsEt extends RRulePickerLocalizations {
  RRulePickerLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'päevadel',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iga',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iga',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Igapäevane',
      'weekly': 'Iganädalane',
      'monthly': 'Igakuine',
      'yearly': 'Iga-aastane',
      'other': 'Mitte kunagi',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Korda';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nädalad',
    );
    return '$_temp0';
  }
}
