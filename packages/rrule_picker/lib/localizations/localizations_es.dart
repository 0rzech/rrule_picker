// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class RRulePickerLocalizationsEs extends RRulePickerLocalizations {
  RRulePickerLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Diario',
      'weekly': 'Semanal',
      'monthly': 'Mensual',
      'yearly': 'Anual',
      'other': 'Nunca',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Repetir';
}
