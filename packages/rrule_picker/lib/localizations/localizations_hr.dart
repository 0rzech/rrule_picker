// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class RRulePickerLocalizationsHr extends RRulePickerLocalizations {
  RRulePickerLocalizationsHr([String locale = 'hr']) : super(locale);

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
  String get rrulePickerTitle => 'Ponovi';
}
