// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class RRulePickerLocalizationsPt extends RRulePickerLocalizations {
  RRulePickerLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get rrulePickerDayOfMonth => 'Dia do mês';

  @override
  String get rrulePickerDayOfWeek => 'Dia da semana';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dia(s)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEveryMonth => 'Cada';

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'primeiro',
      'sunday': 'primeiro',
      'other': 'primeira',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'quarto',
      'sunday': 'quarto',
      'other': 'quarta',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'último';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'último',
      'sunday': 'último',
      'other': 'última',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mês(es)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Diário',
      'weekly': 'Semanal',
      'monthly': 'Mensal',
      'yearly': 'Anual',
      'other': 'Nunca',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'segundo',
      'sunday': 'segundo',
      'other': 'segunda',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Pular';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'terceiro',
      'sunday': 'terceiro',
      'other': 'terceira',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Repetir';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'semana(s)',
    );
    return '$_temp0';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class RRulePickerLocalizationsPtBr extends RRulePickerLocalizationsPt {
  RRulePickerLocalizationsPtBr() : super('pt_BR');

  @override
  String get rrulePickerDayOfMonth => 'Dia do mês';

  @override
  String get rrulePickerDayOfWeek => 'Dia da semana';

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dia(s)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String get rrulePickerEveryMonth => 'Cada';

  @override
  String rrulePickerEveryMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Todo',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerFirstDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'primeiro',
      'sunday': 'primeiro',
      'other': 'primeira',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerFourthDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'quarto',
      'sunday': 'quarto',
      'other': 'quarta',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerLastDay => 'último';

  @override
  String rrulePickerLastDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'último',
      'sunday': 'último',
      'other': 'última',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mês(es)',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Diário',
      'weekly': 'Semanal',
      'monthly': 'Mensal',
      'yearly': 'Anual',
      'other': 'Nunca',
    });
    return '$_temp0';
  }

  @override
  String rrulePickerSecondDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'segundo',
      'sunday': 'segundo',
      'other': 'segunda',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerSkip => 'Pular';

  @override
  String rrulePickerThirdDayOfWeek(String dayOfWeek) {
    String _temp0 = intl.Intl.selectLogic(dayOfWeek, {
      'saturday': 'terceiro',
      'sunday': 'terceiro',
      'other': 'terceira',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Repetir';

  @override
  String rrulePickerWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'semana(s)',
    );
    return '$_temp0';
  }
}
