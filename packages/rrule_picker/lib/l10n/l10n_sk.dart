// ignore_for_file: public_member_api_docs

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class RRulePickerLocalizationsSk extends RRulePickerLocalizations {
  RRulePickerLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Deň v mesiaci';

  @override
  String get rrulePickerDayOfWeek => 'Deň v týždni';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dní',
      few: 'dni',
      one: 'deň',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'každých',
      few: 'každé',
      one: 'každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'každých',
      few: 'každé',
      one: 'každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'každých',
      few: 'každé',
      one: 'každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'každých',
      few: 'každé',
      one: 'každý',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'prvá',
      'saturday': 'prvá',
      'sunday': 'prvá',
      'other': 'prvý',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'štvrtá',
      'saturday': 'štvrtá',
      'sunday': 'štvrtá',
      'other': 'štvrtý',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'posledný';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'posledná',
      'saturday': 'posledná',
      'sunday': 'posledná',
      'other': 'posledný',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mesiacov',
      few: 'mesiace',
      one: 'mesiac',
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
      'wednesday': 'druhá',
      'saturday': 'druhá',
      'sunday': 'druhá',
      'other': 'druhý',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Preskočiť';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'tretia',
      'saturday': 'tretia',
      'sunday': 'tretia',
      'other': 'tretí',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Opakovať';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'týždňov',
      few: 'týždne',
      one: 'týždeň',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'rokov',
      few: 'roky',
      one: 'rok',
    );
    return '$_temp0';
  }
}
