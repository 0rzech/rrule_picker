// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class RRulePickerLocalizationsJa extends RRulePickerLocalizations {
  RRulePickerLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': '毎日',
      'weekly': '毎週',
      'monthly': '毎月',
      'yearly': '毎年',
      'other': '終了しない',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => '繰り返し';
}
