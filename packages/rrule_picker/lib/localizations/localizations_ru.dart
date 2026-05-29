// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class RRulePickerLocalizationsRu extends RRulePickerLocalizations {
  RRulePickerLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'День месяца';

  @override
  String get rrulePickerDayOfWeek => 'День недели';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'день(и)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Каждый',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Каждый',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Каждый',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'первая',
      'friday': 'первая',
      'saturday': 'первая',
      'sunday': 'первое',
      'other': 'первый',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'четвёртая',
      'friday': 'четвёртая',
      'saturday': 'четвёртая',
      'sunday': 'четвёртое',
      'other': 'четвёртый',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'последний';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'последняя',
      'friday': 'последняя',
      'saturday': 'последняя',
      'sunday': 'последнее',
      'other': 'последний',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'месяц(ы)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'День',
      'weekly': 'Неделя',
      'monthly': 'Месяц',
      'yearly': 'Год',
      'other': 'Никогда',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'вторая',
      'friday': 'вторая',
      'saturday': 'вторая',
      'sunday': 'второе',
      'other': 'второй',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'третья',
      'friday': 'третья',
      'saturday': 'третья',
      'sunday': 'третье',
      'other': 'третий',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Повторять';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'неделя(и)',
    );
    return '$_temp0';
  }
}
