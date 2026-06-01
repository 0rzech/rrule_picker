// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class RRulePickerLocalizationsSl extends RRulePickerLocalizations {
  RRulePickerLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Dan v mesecu';

  @override
  String get rrulePickerDayOfWeek => 'Dan v tednu';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dni',
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
  String get rrulePickerEveryMonth => 'Vsak';

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
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'prva',
      'saturday': 'prva',
      'sunday': 'prva',
      'other': 'prvi',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'četrta',
      'saturday': 'četrta',
      'sunday': 'četrta',
      'other': 'četrti',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'zadnji';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'zadnja',
      'saturday': 'zadnja',
      'sunday': 'zadnja',
      'other': 'zadnji',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mesiacov',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Denne',
      'weekly': 'Týždenne',
      'monthly': 'Mesačne',
      'yearly': 'Ročne',
      'other': 'Nikdy',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'druga',
      'saturday': 'druga',
      'sunday': 'druga',
      'other': 'drugi',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'tretja',
      'saturday': 'tretja',
      'sunday': 'tretja',
      'other': 'tretji',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Ponovi';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'týždňov',
    );
    return '$_temp0';
  }
}
