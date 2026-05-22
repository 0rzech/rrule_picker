// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class RRulePickerLocalizationsPt extends RRulePickerLocalizations {
  RRulePickerLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get rrulePickerTitle => 'Repetir';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class RRulePickerLocalizationsPtBr extends RRulePickerLocalizationsPt {
  RRulePickerLocalizationsPtBr() : super('pt_BR');

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
  String get rrulePickerTitle => 'Repetir';
}
