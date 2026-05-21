// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class RRulePickerLocalizationsZh extends RRulePickerLocalizations {
  RRulePickerLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': '日常的',
      'weekly': '每周',
      'monthly': '每月',
      'yearly': '年度的',
      'other': '绝不',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => '重复';
}
