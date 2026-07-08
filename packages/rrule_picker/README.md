# RRULE Picker

A Flutter widget for RRULE manipulation.

## Features

* No external dependencies except for [intl](https://pub.dev/packages/intl).
* Supports the following types or recurrence rules:

  * Daily, for example `RRULE:FREQ=DAILY;INTERVAL=1`.
  * Weekly, by selected days of each nth week, for example `RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TH,SU`.
  * Monthly, by nth day of each nth month, for example `RRULE:FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=4`.
  * Monthly, by weekday of nth week of nth month, for example `RRULE:FREQ=MONTHLY;INTERVAL=5;BYDAY=FR;BYSETPOS=-1`.
  * Yearly, by nth day of nth month, for example `RRULE:FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=8`.
  * Yearly, by weekday of nth week of nth month, for example `RRULE:FREQ=YEARLY;BYMONTH=9;BYDAY=WE;BYSETPOS=4`.

* Allows picking multiple excluded dates,
for example `EXDATE;VALUE=DATE:20561112,20591101,20840330,20870510`.
* Translated to 36 languages.
* Uses [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/) and [intl](https://pub.dev/packages/intl) for fluent translations.

## Getting started

```shell
dart pub add rrule_picker
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rrule_picker/rrule_picker.dart';

void main() => runApp(const RRulePickerExampleApp());

class RRulePickerExampleApp extends StatelessWidget {
  const RRulePickerExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: [
      // YourAppLocalizations.delegate,
      RRulePickerLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: RRulePickerLocalizations.supportedLocales,  // YourAppLocalizations.supportedLocales,
    home: Scaffold(body:
      // YourAppWidget(child:
      RRulePicker(onRRuleChanged: (rrule) => print(rrule))),
      // );
  );
}
```

More elaborate example can be found in the demo web app's [source code](https://codeberg.org/0rzech/rrule_picker/src/branch/main/packages/rrule_picker_example/lib/main.dart).

You can also check the interactive [demo web app](https://0rzech.codeberg.page/rrule_picker/).

## Additional information

* This package is still in development; compatibility may be broken from time to time.
* **IMPORTANT:** The parser uses regular expressions and does not sanitize the data before processing.
  It is your responsibility to make sure that the RRULEs are safe before passing them to `RRulePicker` or `RRulePickerController`.
* The RRULE parser does not care about entry ordering and is case-insensitive but otherwise is strict when parsing values.
* When parsing fails, the parser falls back to defaults of each FREQ.
* The widget always returns RRULE entries in upper-case whenever it's recommended by the RFC and sticks to RFC-recommended ordering of the entries.

Example screenshot:

![Yearly recurrence rule screenshot](https://codeberg.org/0rzech/rrule_picker/raw/branch/main/packages/rrule_picker/screenshot.png)

### Translations

Currently, most translations are machine-generated, followed by a human review based on intuition rather than language proficiency.

The following example shows how to customize localizations for a specific language:

```dart
import 'package:flutter/material.dart';
import 'package:rrule_picker/l10n/l10n_en.dart';

// Extend the generated English localization class
class CustomRRulePickerLocalizationsEn extends RRulePickerLocalizationsEn {
  @override
  String get rrulePickerDayOfMonth => 'Custom Day of Month Translation';
}

// Create a custom delegate that falls back to the default delegate
class CustomRRulePickerDelegate
    extends LocalizationsDelegate<RRulePickerLocalizations> {
  const CustomRRulePickerDelegate();

  @override
  bool isSupported(Locale locale) =>
      RRulePickerLocalizations.delegate.isSupported(locale);

  @override
  Future<RRulePickerLocalizations> load(Locale locale) async =>
      switch (locale.languageCode) {
        'en' => CustomRRulePickerLocalizationsEn(),
        _ => RRulePickerLocalizations.delegate.load(locale),
      };

  @override
  bool shouldReload(
      covariant LocalizationsDelegate<RRulePickerLocalizations> old,
      ) => false;
}

// Use it in your app
void main() {
  runApp(MaterialApp(
    localizationsDelegates: const [
      YourAppLocalizations.delegate,
      // Use your custom delegate INSTEAD of RRulePickerLocalizations.delegate
      CustomRRulePickerDelegate(),
      // ... flutter default delegates (GlobalMaterialLocalizations.delegate, etc.)
    ],
    supportedLocales: YourAppLocalizations.supportedLocales,
    home: const Scaffold(/*...*/),
  ));
}
```

You can also introduce complete translations for a missing language this way, but it would be much better (and very welcome) to contribute your translations to the project on [Weblate](https://translate.codeberg.org/projects/rrule_picker/).

[![Translation status badge](https://translate.codeberg.org/widget/rrule_picker/multi-auto.svg)](https://translate.codeberg.org/engage/rrule_picker/)

###

[<img alt="Fork it on Codeberg badge" src="https://codeberg.org/0rzech/rrule_picker/raw/branch/main/packages/rrule_picker_example/assets/codeberg-badge.svg" width="200"/>](https://codeberg.org/0rzech/rrule_picker)
