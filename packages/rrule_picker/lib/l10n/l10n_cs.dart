// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class RRulePickerLocalizationsCs extends RRulePickerLocalizations {
  RRulePickerLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Den v měsíci';

  @override
  String get rrulePickerDayOfWeek => 'Den v týdnu';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dnů',
      few: 'dny',
      one: 'den',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'první'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'čtvrté',
      'tuesday': 'čtvrté',
      'thursday': 'čtvrtý',
      'friday': 'čtvrtý',
      'other': 'čtvrtá',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'poslední';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'poslední'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'měsíců',
      few: 'měsíce',
      one: 'měsíc',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Denně',
      'weekly': 'Týdně',
      'monthly': 'Měsíčně',
      'yearly': 'Ročně',
      'other': 'Nikdy',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'druhé',
      'tuesday': 'druhé',
      'thursday': 'druhý',
      'friday': 'druhý',
      'other': 'druhá',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Přeskočit';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'třetí'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Opakovat';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'týdnů',
      few: 'týdny',
      one: 'týden',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'let',
      few: 'roky',
      one: 'rok',
    );
    return '$_temp0';
  }
}
