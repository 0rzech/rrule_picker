// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class RRulePickerLocalizationsSq extends RRulePickerLocalizations {
  RRulePickerLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Ditor',
      'weekly': 'Javor',
      'monthly': 'Mujor',
      'yearly': 'Vjetor',
      'other': 'Kurrë',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Përsërit';
}
