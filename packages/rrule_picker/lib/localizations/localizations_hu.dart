// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class RRulePickerLocalizationsHu extends RRulePickerLocalizations {
  RRulePickerLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Napi',
      'weekly': 'Heti',
      'monthly': 'Havi',
      'yearly': 'Évi',
      'other': 'Soha',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Ismétlés';
}
