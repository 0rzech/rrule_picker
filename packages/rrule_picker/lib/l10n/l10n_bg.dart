// ignore_for_file: public_member_api_docs

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class RRulePickerLocalizationsBg extends RRulePickerLocalizations {
  RRulePickerLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Ден от месеца';

  @override
  String get rrulePickerDayOfWeek => 'Ден от седмицата';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'дни',
      one: 'ден',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEndAfterDate => 'Край след дата';

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на всеки',
      one: 'всеки',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на всеки',
      one: 'всеки',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на всеки',
      one: 'всяка',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на всеки',
      one: 'всяка',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'първа',
      'saturday': 'първа',
      'sunday': 'първа',
      'other': 'първи',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'четвърта',
      'saturday': 'четвърта',
      'sunday': 'четвърта',
      'other': 'четвърти',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'последен';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'последна',
      'saturday': 'последна',
      'sunday': 'последна',
      'other': 'последен',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'месеци',
      one: 'месец',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Дневно',
      'weekly': 'Седмично',
      'monthly': 'Месечно',
      'yearly': 'Годишно',
      'other': 'Никога',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'втора',
      'saturday': 'втора',
      'sunday': 'втора',
      'other': 'втори',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Пропусни';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'wednesday': 'трета',
      'saturday': 'трета',
      'sunday': 'трета',
      'other': 'трети',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Повтори';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'седмици',
      one: 'седмица',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'години',
      one: 'година',
    );
    return '$_temp0';
  }
}
