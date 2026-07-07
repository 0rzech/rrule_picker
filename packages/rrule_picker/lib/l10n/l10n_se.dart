// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Northern Sami (`se`).
class RRulePickerLocalizationsSe extends RRulePickerLocalizations {
  RRulePickerLocalizationsSe([String locale = 'se']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Mánno beaivi';

  @override
  String get rrulePickerDayOfWeek => 'Beaivvi vahkku';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'beaivvi',
      two: 'beaivvit',
      one: 'beaivi',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Juohke',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'vuosttaš'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'njealját'});
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'maŋimuš';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'maŋemus'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mánut',
      one: 'mánnu',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Beaivválaš',
      'weekly': 'Vahkkosaš',
      'monthly': 'Mánnui',
      'yearly': 'Jahkásaččat',
      'other': 'Ii goassige',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'nubbi'});
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Skoahkka';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'goalmmát'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Geardduhit';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vahkut',
      one: 'vahkku',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jagit',
      one: 'jahki',
    );
    return '$_temp0';
  }
}
