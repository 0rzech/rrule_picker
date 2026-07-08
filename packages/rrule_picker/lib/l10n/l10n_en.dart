// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class RRulePickerLocalizationsEn extends RRulePickerLocalizations {
  RRulePickerLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Day of month';

  @override
  String get rrulePickerDayOfWeek => 'Day of week';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'first',
      'tuesday': 'first',
      'wednesday': 'first',
      'thursday': 'first',
      'friday': 'first',
      'saturday': 'first',
      'sunday': 'first',
      'other': 'first',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'fourth',
      'tuesday': 'fourth',
      'wednesday': 'fourth',
      'thursday': 'fourth',
      'friday': 'fourth',
      'saturday': 'fourth',
      'sunday': 'fourth',
      'other': 'fourth',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'last';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'last',
      'tuesday': 'last',
      'wednesday': 'last',
      'thursday': 'last',
      'friday': 'last',
      'saturday': 'last',
      'sunday': 'last',
      'other': 'last',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'never': 'Never',
      'other': 'Never',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'second',
      'tuesday': 'second',
      'wednesday': 'second',
      'thursday': 'second',
      'friday': 'second',
      'saturday': 'second',
      'sunday': 'second',
      'other': 'second',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Skip';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'monday': 'third',
      'tuesday': 'third',
      'wednesday': 'third',
      'thursday': 'third',
      'friday': 'third',
      'saturday': 'third',
      'sunday': 'third',
      'other': 'third',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Repeat';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$_temp0';
  }
}
