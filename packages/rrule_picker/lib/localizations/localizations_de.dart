// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class RRulePickerLocalizationsDe extends RRulePickerLocalizations {
  RRulePickerLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Täglich',
      'weekly': 'Wöchentlich',
      'monthly': 'Monatlich',
      'yearly': 'Jährlich',
      'other': 'Keine Wiederholung',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Wiederhole';
}
