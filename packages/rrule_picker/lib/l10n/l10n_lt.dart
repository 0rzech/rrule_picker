// ignore_for_file: public_member_api_docs

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class RRulePickerLocalizationsLt extends RRulePickerLocalizations {
  RRulePickerLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Mėnesio diena';

  @override
  String get rrulePickerDayOfWeek => 'Savaitės diena';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dienų',
      few: 'dienus',
      one: 'dieną',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEndAfterDate => 'Pabaiga po datos';

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kiekvieną',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kiekvienas',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kiekvieną',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kiekvieną',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'pirmas'});
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'ketvirtas'});
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'paskutinis';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'paskutinis'});
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mėnesių',
      few: 'mėnesiai',
      one: 'mėnuo',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Kasdien',
      'weekly': 'Kas savaitę',
      'monthly': 'Kas mėnesį',
      'yearly': 'Metinis',
      'other': 'Niekada',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'antras'});
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Praleisti';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {'other': 'trečias'});
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Kartoti';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'savaičių',
      few: 'savaites',
      one: 'savaitę',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'metų',
      few: 'metus',
      one: 'metai',
    );
    return '$_temp0';
  }
}
