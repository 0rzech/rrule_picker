import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_bg.dart';
import 'l10n_cs.dart';
import 'l10n_da.dart';
import 'l10n_de.dart';
import 'l10n_el.dart';
import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_et.dart';
import 'l10n_fa.dart';
import 'l10n_fi.dart';
import 'l10n_fr.dart';
import 'l10n_hr.dart';
import 'l10n_hu.dart';
import 'l10n_id.dart';
import 'l10n_is.dart';
import 'l10n_it.dart';
import 'l10n_ja.dart';
import 'l10n_ko.dart';
import 'l10n_lt.dart';
import 'l10n_lv.dart';
import 'l10n_nl.dart';
import 'l10n_no.dart';
import 'l10n_pl.dart';
import 'l10n_pt.dart';
import 'l10n_ro.dart';
import 'l10n_ru.dart';
import 'l10n_se.dart';
import 'l10n_sk.dart';
import 'l10n_sl.dart';
import 'l10n_sq.dart';
import 'l10n_sr.dart';
import 'l10n_sv.dart';
import 'l10n_tr.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of RRulePickerLocalizations
/// returned by `RRulePickerLocalizations.of(context)`.
///
/// Applications need to include `RRulePickerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
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

  /// Label for day of month selection.
  ///
  /// Returns a noun phrase (singular nominative + genitive singular).
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get rrulePickerDayOfMonth;

  /// Label for day of week selection.
  ///
  /// Returns a noun phrase (singular nominative + genitive singular).
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get rrulePickerDayOfWeek;

  /// Returns a plural noun with case variations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{day} other{days}}'**
  String rrulePickerDays(int count);

  /// Returns a preposition indicating frequency/distribution.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{every}}'**
  String rrulePickerEveryDaily(int count);

  /// Returns a preposition indicating frequency/distribution.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{every}}'**
  String rrulePickerEveryMonthly(int count);

  /// Returns a preposition indicating frequency/distribution.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{every}}'**
  String rrulePickerEveryWeekly(int count);

  /// Returns a preposition indicating frequency/distribution.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{every}}'**
  String rrulePickerEveryYearly(int count);

  /// First `dayOfWeek`. Valid options are: `'monday'`, `'tuesday'`, `'wednesday'`, `'thursday'`, `'friday'`, `'saturday'`, `'sunday'`.
  ///
  /// Returns an ordinal number with gender-sensitive case variations.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{first} tuesday{first} wednesday{first} thursday{first} friday{first} saturday{first} sunday{first} other{first}}'**
  String rrulePickerFirstDayOfWeek(String dayOfWeek);

  /// Fourth `dayOfWeek`. Valid options are: `'monday'`, `'tuesday'`, `'wednesday'`, `'thursday'`, `'friday'`, `'saturday'`, `'sunday'`.
  ///
  /// Returns an ordinal number with gender-sensitive case variations.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{fourth} tuesday{fourth} wednesday{fourth} thursday{fourth} friday{fourth} saturday{fourth} sunday{fourth} other{fourth}}'**
  String rrulePickerFourthDayOfWeek(String dayOfWeek);

  /// Label for last day selection.
  ///
  /// Returns an ordinal adjective.
  ///
  /// In en, this message translates to:
  /// **'last'**
  String get rrulePickerLastDay;

  /// Last `dayOfWeek`. Valid options are: `'monday'`, `'tuesday'`, `'wednesday'`, `'thursday'`, `'friday'`, `'saturday'`, `'sunday'`.
  ///
  /// Returns an ordinal adjective with gender-sensitive case variations.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{last} tuesday{last} wednesday{last} thursday{last} friday{last} saturday{last} sunday{last} other{last}}'**
  String rrulePickerLastDayOfWeek(String dayOfWeek);

  /// Returns a plural noun with case variations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{month} other{months}}'**
  String rrulePickerMonths(int count);

  /// Display values for recurrence type dropdown. Valid options are: `'daily'`, `'weekly'`, `'monthly'`, `'yearly'`, `'never'`.
  ///
  /// Returns an adverb.
  ///
  /// In en, this message translates to:
  /// **'{name, select, daily{Daily} weekly{Weekly} monthly{Monthly} yearly{Yearly} never{Never} other{Never}}'**
  String rrulePickerRecurrenceType(String name);

  /// Second `dayOfWeek`. Valid options are: `'monday'`, `'tuesday'`, `'wednesday'`, `'thursday'`, `'friday'`, `'saturday'`, `'sunday'`.
  ///
  /// Returns an ordinal number with gender-sensitive case variations.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{second} tuesday{second} wednesday{second} thursday{second} friday{second} saturday{second} sunday{second} other{second}}'**
  String rrulePickerSecondDayOfWeek(String dayOfWeek);

  /// Label on a 'skip' button used to skip dates during recurrence period.
  ///
  /// Returns an imperative verb.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get rrulePickerSkip;

  /// Third `dayOfWeek`. Valid options are: `'monday'`, `'tuesday'`, `'wednesday'`, `'thursday'`, `'friday'`, `'saturday'`, `'sunday'`.
  ///
  /// Returns an ordinal number with gender-sensitive case variations.
  ///
  /// In en, this message translates to:
  /// **'{dayOfWeek, select, monday{third} tuesday{third} wednesday{third} thursday{third} friday{third} saturday{third} sunday{third} other{third}}'**
  String rrulePickerThirdDayOfWeek(String dayOfWeek);

  /// Optional title of the whole widget.
  ///
  /// Returns an imperative verb.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get rrulePickerTitle;

  /// Returns a plural noun with case variations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{week} other{weeks}}'**
  String rrulePickerWeeks(int count);

  /// Returns a plural noun with case variations.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{year} other{years}}'**
  String rrulePickerYears(int count);
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
