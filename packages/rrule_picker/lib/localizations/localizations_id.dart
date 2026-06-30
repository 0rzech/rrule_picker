// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class RRulePickerLocalizationsId extends RRulePickerLocalizations {
  RRulePickerLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Tanggal bulan';

  @override
  String get rrulePickerDayOfWeek => 'Hari dalam seminggu';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hari',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'pertama'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'keempat'});
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'terakhir';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'terakhir'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bulan',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Harian',
      'weekly': 'Mingguan',
      'monthly': 'Bulanan',
      'yearly': 'Tahunan',
      'other': 'Tak pernah',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'kedua'});
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Lewati';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'ketiga'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Mengulang';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'minggu',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tahun',
    );
    return '$_temp0';
  }
}
