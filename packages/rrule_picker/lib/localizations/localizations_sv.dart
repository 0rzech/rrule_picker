// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class RRulePickerLocalizationsSv extends RRulePickerLocalizations {
  RRulePickerLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Dagligen',
      'weekly': 'Veckovis',
      'monthly': 'Månadsvis',
      'yearly': 'Årligen',
      'other': 'Aldrig',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Upprepa';
}
