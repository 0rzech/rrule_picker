// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class RRulePickerLocalizationsId extends RRulePickerLocalizations {
  RRulePickerLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Harian',
      'weekly': 'Mingguan',
      'monthly': 'Bulanan',
      'yearly': 'Tahunan',
      'other': 'Tak pernah',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Mengulang';
}
