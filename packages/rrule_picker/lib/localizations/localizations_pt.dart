// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class RRulePickerLocalizationsPt extends RRulePickerLocalizations {
  RRulePickerLocalizationsPt([String locale = 'pt']) : super(locale);

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
