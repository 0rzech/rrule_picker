// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class RRulePickerLocalizationsSk extends RRulePickerLocalizations {
  RRulePickerLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Denne',
      'weekly': 'Týždenne',
      'monthly': 'Mesačne',
      'yearly': 'Ročne',
      'other': 'Nikdy',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Opakovať';
}
