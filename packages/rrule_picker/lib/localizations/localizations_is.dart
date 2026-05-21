// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Icelandic (`is`).
class RRulePickerLocalizationsIs extends RRulePickerLocalizations {
  RRulePickerLocalizationsIs([String locale = 'is']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Daglega',
      'weekly': 'Vikulega',
      'monthly': 'Mánaðarlega',
      'yearly': 'Árlega',
      'other': 'Aldrei',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Endurtekning';
}
