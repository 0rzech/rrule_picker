// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class RRulePickerLocalizationsAr extends RRulePickerLocalizations {
  RRulePickerLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'يوميًا',
      'weekly': 'أسبوعيًا',
      'monthly': 'شهريًا',
      'yearly': 'سنويًا',
      'other': 'أبدًا',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'كرّر';
}
