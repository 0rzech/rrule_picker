// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class RRulePickerLocalizationsLv extends RRulePickerLocalizations {
  RRulePickerLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Ikdienas',
      'weekly': 'Iknedēļas',
      'monthly': 'Ikmēneša',
      'yearly': 'Ik gadu',
      'other': 'Nekad',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Atkārtot';
}
