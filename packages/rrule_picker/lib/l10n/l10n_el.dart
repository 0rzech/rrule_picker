// ignore_for_file: public_member_api_docs

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class RRulePickerLocalizationsEl extends RRulePickerLocalizations {
  RRulePickerLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Ημέρα του μήνα';

  @override
  String get rrulePickerDayOfWeek => 'Ημέρα της εβδομάδας';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ημέρες',
      one: 'Ημέρα',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'κάθε',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'πρώτο',
      'other': 'πρώτη',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'τέταρτο',
      'other': 'τέταρτη',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'τελευταία';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'τελευταίο',
      'other': 'τελευταία',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'μήνες',
      one: 'μήνας',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Ημέρες',
      'weekly': 'Εβδομάδες',
      'monthly': 'Μήνες',
      'yearly': 'Ετη',
      'other': 'Χωρίς επανάληψη',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'δεύτερο',
      'other': 'δεύτερη',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Παράλειψε';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'τρίτο',
      'other': 'τρίτη',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Επανάλαβε';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εβδομάδες',
      one: 'Εβδομάδα',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'χρόνια',
      one: 'χρόνος',
    );
    return '$_temp0';
  }
}
