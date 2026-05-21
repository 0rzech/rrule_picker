// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class RRulePickerLocalizationsBg extends RRulePickerLocalizations {
  RRulePickerLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Дневно',
      'weekly': 'Седмично',
      'monthly': 'Месечно',
      'yearly': 'Годишно',
      'other': 'Никога',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Повтори';
}
