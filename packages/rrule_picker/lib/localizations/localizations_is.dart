// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Icelandic (`is`).
class RRulePickerLocalizationsIs extends RRulePickerLocalizations {
  RRulePickerLocalizationsIs([String locale = 'is']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Dagur mánaðar';

  @override
  String get rrulePickerDayOfWeek => 'Dagur vikunnar';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dagar',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Á hverjum',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEveryMonth => 'Hver';

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Á hverjum',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Á hverjum',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'fyrsti'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'fjórði'});
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'síðasti';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'síðasti'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mánuðir',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Daglega',
      'weekly': 'Vikulega',
      'monthly': 'Mánaðarlega',
      'yearly': 'Árlega',
      'other': 'Aldrei',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'annar'});
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Sleppa';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'þriðji'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Endurtekning';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vikur',
    );
    return '$_temp0';
  }
}
