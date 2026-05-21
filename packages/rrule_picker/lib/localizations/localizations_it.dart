// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class RRulePickerLocalizationsIt extends RRulePickerLocalizations {
  RRulePickerLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Quotidiano',
      'weekly': 'Settimanalmente',
      'monthly': 'Mensile',
      'yearly': 'Annuale',
      'other': 'Mai',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Ripetere';
}
