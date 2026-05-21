// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class RRulePickerLocalizationsRo extends RRulePickerLocalizations {
  RRulePickerLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Zilnic',
      'weekly': 'Săptămânal',
      'monthly': 'Lunar',
      'yearly': 'Anual',
      'other': 'Niciodată',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Repetă';
}
