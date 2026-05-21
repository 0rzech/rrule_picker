// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class RRulePickerLocalizationsKo extends RRulePickerLocalizations {
  RRulePickerLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': '매일',
      'weekly': '매주',
      'monthly': '매월',
      'yearly': '매년',
      'other': '종료 없음',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => '반복';
}
