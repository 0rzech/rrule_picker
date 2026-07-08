// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class RRulePickerLocalizationsPl extends RRulePickerLocalizations {
  RRulePickerLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Dzień miesiąca';

  @override
  String get rrulePickerDayOfWeek => 'Dzień tygodnia';

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
      other: 'co',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'co',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'co',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'co',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'pierwsza',
      'saturday': 'pierwsza',
      'sunday': 'pierwsza',
      'other': 'pierwszy',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'czwarta',
      'saturday': 'czwarta',
      'sunday': 'czwarta',
      'other': 'czwarty',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'ostatni';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'ostatnia',
      'saturday': 'ostatnia',
      'sunday': 'ostatnia',
      'other': 'ostatni',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miesiąca',
      many: 'miesięcy',
      few: 'miesiące',
      one: 'miesiąc',
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
  String get rrulePickerSkip => 'Pomiń';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'trzecia',
      'saturday': 'trzecia',
      'sunday': 'trzecia',
      'other': 'trzeci',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Powtarzaj';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tygodnia',
      many: 'tygodni',
      few: 'tygodnie',
      one: 'tydzień',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'roku',
      many: 'lat',
      few: 'lata',
      one: 'rok',
    );
    return '$_temp0';
  }
}
