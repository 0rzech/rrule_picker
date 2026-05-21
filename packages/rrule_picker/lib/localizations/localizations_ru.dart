// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class RRulePickerLocalizationsRu extends RRulePickerLocalizations {
  RRulePickerLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'День',
      'weekly': 'Неделя',
      'monthly': 'Месяц',
      'yearly': 'Год',
      'other': 'Никогда',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Повторять';
}
