// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class RRulePickerLocalizationsFi extends RRulePickerLocalizations {
  RRulePickerLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String rrulePickerDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'päivä',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerEveryDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Joka',
    );
    return '$_temp0';
  }

  @override
  String rrulePickerRecurrenceType(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'daily': 'Päivittäin',
      'weekly': 'Viikoittain',
      'monthly': 'Kuukausittain',
      'yearly': 'Vuotuinen',
      'other': 'Ei koskaan',
    });
    return '$_temp0';
  }

  @override
  String get rrulePickerTitle => 'Toistaa';
}
