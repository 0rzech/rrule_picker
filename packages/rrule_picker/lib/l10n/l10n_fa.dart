// ignore_for_file: public_member_api_docs

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class RRulePickerLocalizationsFa extends RRulePickerLocalizations {
  RRulePickerLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'روز ماه';

  @override
  String get rrulePickerDayOfWeek => 'روز هفته';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'روزها',
      one: 'روز',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEndAfterDate => 'اتمام پس از تاریخ';

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'اول'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'چهارم'});
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'آخر';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'آخر'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ماه‌ها',
      one: 'ماه',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'روزانه',
      'weekly': 'هفتگی',
      'monthly': 'ماهانه',
      'yearly': 'سالانه',
      'other': 'هرگز',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'دوم'});
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'رد کردن';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'سوم'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'تکرار';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هفته‌ها',
      one: 'هفته',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سال‌ها',
      one: 'سال',
    );
    return '$_temp0';
  }
}
