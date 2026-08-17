// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

/// # rrule_picker
///
/// This is a widget that allows users to set a subset of recurrence rules
/// in accordance to [RFC 5545](https://datatracker.ietf.org/doc/html/rfc5545),
/// which, for now, means Gregorian calendar only.
///
/// ## Example Usage
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:flutter_localizations/flutter_localizations.dart';
/// import 'package:rrule_picker/rrule_picker.dart';
///
/// void main() => runApp(const App());
///
/// class App extends StatelessWidget {
///   const App({super.key});
///
///   @override
///   Widget build(BuildContext context) => MaterialApp(
///     // It necessary to always set up localizations:
///     localizationsDelegates: [
///       RRulePickerLocalizations.delegate,
///       GlobalMaterialLocalizations.delegate,
///       GlobalCupertinoLocalizations.delegate,
///       GlobalWidgetsLocalizations.delegate,
///     ],
///     home: RRulePicker(
///       // Optional initial RRULE:
///       initialRRule:
///           'RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TH,SU;'
///           'EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20840330,20870510',
///       // Optional time zone:
///       timeZone: 'Europe/Warsaw',
///       // Optional 'RRULE changed' callback:
///       onRRuleChanged: (rrule) {
///         final snackBar = SnackBar(content: Text(rrule));
///         Scaffold.of(context).showSnackBar(snackBar);
///       },
///       // Optional per-instance theme override:
///       theme: .new(padding: 8),
///     ),
///   );
/// }
/// ```
///
/// ## Supported RRULE types
///
/// The widget allows creating the following types of recurrence rules:
/// * Daily, for example `RRULE:FREQ=DAILY;INTERVAL=1`.
/// * Weekly, by selected days of each nth week, for example
/// `RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TH,SU`.
/// * Monthly, by nth day of each nth month, for example
/// `RRULE:FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=4`.
/// * Monthly, by weekday of nth week of nth month, for example
/// `RRULE:FREQ=MONTHLY;INTERVAL=5;BYDAY=FR;BYSETPOS=-1`.
/// * Yearly, by nth day of nth month, for example
/// `RRULE:FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=8`.
/// * Yearly, by weekday of nth week of nth month, for example
/// `RRULE:FREQ=YEARLY;BYMONTH=9;BYDAY=WE;BYSETPOS=4`.
///
/// By default, the widget additionally allows picking multiple excluded dates,
/// for example
/// `EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20561112,20591101,20840330,20870510`.
///
/// ### RRULE Parsing
///
/// When [RRulePicker.initialRRule] is used, or [RRulePickerController.new]
/// is provided with one, the RRULE will be parsed, assuming field ordering
/// as shown above.
///
/// The parser is lax in the sense that if any of the supported
/// `FREQ`s is detected, it will set default values when further parsing fails.
/// But at the same time, it will not allow any spaces within the rrule string.
///
/// ## Custom Theming
///
/// [RRulePickerThemeData] extends [ThemeExtension], so it can be either set
/// globally in [MaterialApp], or per-instance through [RRulePicker.theme]
/// constructor parameter.
///
/// ## Custom Localizations
///
/// This package allows overriding default localizations. In order to do that,
/// you need to inherit from the [RRulePickerLocalizations] class and any of
/// language-specific localization classes from the same directory and then
/// provide your custom `localizationDelegates` when instantiating
/// [MaterialApp].
library;

export 'package:rrule_picker/l10n/l10n.dart';
export 'package:rrule_picker/theme.dart';
export 'package:rrule_picker/widget.dart';
