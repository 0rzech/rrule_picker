import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_ar.dart';
import 'localizations_bg.dart';
import 'localizations_cs.dart';
import 'localizations_da.dart';
import 'localizations_de.dart';
import 'localizations_el.dart';
import 'localizations_en.dart';
import 'localizations_es.dart';
import 'localizations_et.dart';
import 'localizations_fa.dart';
import 'localizations_fi.dart';
import 'localizations_fr.dart';
import 'localizations_hr.dart';
import 'localizations_hu.dart';
import 'localizations_id.dart';
import 'localizations_is.dart';
import 'localizations_it.dart';
import 'localizations_ja.dart';
import 'localizations_ko.dart';
import 'localizations_lt.dart';
import 'localizations_lv.dart';
import 'localizations_nl.dart';
import 'localizations_no.dart';
import 'localizations_pl.dart';
import 'localizations_pt.dart';
import 'localizations_ro.dart';
import 'localizations_ru.dart';
import 'localizations_se.dart';
import 'localizations_sk.dart';
import 'localizations_sl.dart';
import 'localizations_sq.dart';
import 'localizations_sr.dart';
import 'localizations_sv.dart';
import 'localizations_tr.dart';
import 'localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of RRulePickerLocalizations
/// returned by `RRulePickerLocalizations.of(context)`.
///
/// Applications need to include `RRulePickerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: RRulePickerLocalizations.localizationsDelegates,
///   supportedLocales: RRulePickerLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the RRulePickerLocalizations.supportedLocales
/// property.
abstract class RRulePickerLocalizations {
  RRulePickerLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static RRulePickerLocalizations of(BuildContext context) {
    return Localizations.of<RRulePickerLocalizations>(
      context,
      RRulePickerLocalizations,
    )!;
  }

  static const LocalizationsDelegate<RRulePickerLocalizations> delegate =
      _RRulePickerLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('se'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// Label for day of month selection
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get rrulePickerDayOfMonth;

  /// Label for day of week selection
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get rrulePickerDayOfWeek;

  /// No description provided for @rrulePickerDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String rrulePickerDays(int count);

  /// No description provided for @rrulePickerEveryDaily.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Every}}'**
  String rrulePickerEveryDaily(int count);

  /// No description provided for @rrulePickerEveryMonth.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get rrulePickerEveryMonth;

  /// No description provided for @rrulePickerEveryMonthly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Every}}'**
  String rrulePickerEveryMonthly(int count);

  /// No description provided for @rrulePickerEveryWeekly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Every}}'**
  String rrulePickerEveryWeekly(int count);

  /// Gendered 'first' day of week. Valid options are: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{first} tuesday{first} wednesday{first} thursday{first} friday{first} saturday{first} other{first}}'**
  String rrulePickerFirstDayOfWeek(String dayOfWeek);

  /// Gendered 'fourth' day of week. Valid options are: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{fourth} tuesday{fourth} wednesday{fourth} thursday{fourth} friday{fourth} saturday{fourth} other{fourth}}'**
  String rrulePickerFourthDayOfWeek(String dayOfWeek);

  /// Label for last day selection
  ///
  /// In en, this message translates to:
  /// **'last'**
  String get rrulePickerLastDay;

  /// Gendered 'last' day of week. Valid options are: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{last} tuesday{last} wednesday{last} thursday{last} friday{last} saturday{last} other{last}}'**
  String rrulePickerLastDayOfWeek(String dayOfWeek);

  /// No description provided for @rrulePickerMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{month} other{months}}'**
  String rrulePickerMonths(int count);

  /// Display values for recurrence type dropdown
  ///
  /// In en, this message translates to:
  /// **'{name, select, daily{Daily} weekly{Weekly} monthly{Monthly} yearly{Yearly} other{Never}}'**
  String rrulePickerRecurrenceType(String name);

  /// Gendered 'second' day of week. Valid options are: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{second} tuesday{second} wednesday{second} thursday{second} friday{second} saturday{second} other{second}}'**
  String rrulePickerSecondDayOfWeek(String dayOfWeek);

  /// Label on a 'skip' button used to skip dates during recurrence period
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get rrulePickerSkip;

  /// Gendered 'third' day of week. Valid options are: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{third} tuesday{third} wednesday{third} thursday{third} friday{third} saturday{third} other{third}}'**
  String rrulePickerThirdDayOfWeek(String dayOfWeek);

  /// Optional title of the whole widget
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get rrulePickerTitle;

  /// No description provided for @rrulePickerWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{week} other{weeks}}'**
  String rrulePickerWeeks(int count);
}

class _RRulePickerLocalizationsDelegate
    extends LocalizationsDelegate<RRulePickerLocalizations> {
  const _RRulePickerLocalizationsDelegate();

  @override
  Future<RRulePickerLocalizations> load(Locale locale) {
    return SynchronousFuture<RRulePickerLocalizations>(
      lookupRRulePickerLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fa',
    'fi',
    'fr',
    'hr',
    'hu',
    'id',
    'is',
    'it',
    'ja',
    'ko',
    'lt',
    'lv',
    'nl',
    'no',
    'pl',
    'pt',
    'ro',
    'ru',
    'se',
    'sk',
    'sl',
    'sq',
    'sr',
    'sv',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_RRulePickerLocalizationsDelegate old) => false;
}

RRulePickerLocalizations lookupRRulePickerLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return RRulePickerLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return RRulePickerLocalizationsAr();
    case 'bg':
      return RRulePickerLocalizationsBg();
    case 'cs':
      return RRulePickerLocalizationsCs();
    case 'da':
      return RRulePickerLocalizationsDa();
    case 'de':
      return RRulePickerLocalizationsDe();
    case 'el':
      return RRulePickerLocalizationsEl();
    case 'en':
      return RRulePickerLocalizationsEn();
    case 'es':
      return RRulePickerLocalizationsEs();
    case 'et':
      return RRulePickerLocalizationsEt();
    case 'fa':
      return RRulePickerLocalizationsFa();
    case 'fi':
      return RRulePickerLocalizationsFi();
    case 'fr':
      return RRulePickerLocalizationsFr();
    case 'hr':
      return RRulePickerLocalizationsHr();
    case 'hu':
      return RRulePickerLocalizationsHu();
    case 'id':
      return RRulePickerLocalizationsId();
    case 'is':
      return RRulePickerLocalizationsIs();
    case 'it':
      return RRulePickerLocalizationsIt();
    case 'ja':
      return RRulePickerLocalizationsJa();
    case 'ko':
      return RRulePickerLocalizationsKo();
    case 'lt':
      return RRulePickerLocalizationsLt();
    case 'lv':
      return RRulePickerLocalizationsLv();
    case 'nl':
      return RRulePickerLocalizationsNl();
    case 'no':
      return RRulePickerLocalizationsNo();
    case 'pl':
      return RRulePickerLocalizationsPl();
    case 'pt':
      return RRulePickerLocalizationsPt();
    case 'ro':
      return RRulePickerLocalizationsRo();
    case 'ru':
      return RRulePickerLocalizationsRu();
    case 'se':
      return RRulePickerLocalizationsSe();
    case 'sk':
      return RRulePickerLocalizationsSk();
    case 'sl':
      return RRulePickerLocalizationsSl();
    case 'sq':
      return RRulePickerLocalizationsSq();
    case 'sr':
      return RRulePickerLocalizationsSr();
    case 'sv':
      return RRulePickerLocalizationsSv();
    case 'tr':
      return RRulePickerLocalizationsTr();
    case 'zh':
      return RRulePickerLocalizationsZh();
  }

  throw FlutterError(
    'RRulePickerLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
