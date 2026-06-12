// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class RRulePickerLocalizationsSr extends RRulePickerLocalizations {
  RRulePickerLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Dan u mesecu';

  @override
  String get rrulePickerDayOfWeek => 'Dan u nedelji';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dani',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Svaki',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEveryMonth => 'Svaki';

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Svaki',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Svaki',
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
      'wednesday': 'četvrta',
      'saturday': 'četvrta',
      'sunday': 'četvrta',
      'other': 'četvrti',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'последњи';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'poslednja',
      'saturday': 'poslednja',
      'sunday': 'poslednja',
      'other': 'poslednji',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mjeseci',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Dnevno',
      'weekly': 'Tjedno',
      'monthly': 'Mjesečno',
      'yearly': 'Godišnje',
      'other': 'Nikada',
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
  String get rrulePickerSkip => 'Preskoči';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'treća',
      'saturday': 'treća',
      'sunday': 'treća',
      'other': 'treći',
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
      other: 'tjedni',
    );
    return '$_temp0';
  }
}
