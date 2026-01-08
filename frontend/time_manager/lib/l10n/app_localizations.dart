import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @currentThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Current theme: dark'**
  String get currentThemeDark;

  /// No description provided for @currentThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Current theme: light'**
  String get currentThemeLight;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'ME'**
  String get me;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'with success'**
  String get successful;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clockin.
  ///
  /// In en, this message translates to:
  /// **'CLOCK IN'**
  String get clockin;

  /// No description provided for @clockout.
  ///
  /// In en, this message translates to:
  /// **'CLOCK OUT'**
  String get clockout;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival time'**
  String get arrival;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an user'**
  String get registerTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teamDetails.
  ///
  /// In en, this message translates to:
  /// **'Team Details'**
  String get teamDetails;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @kpiTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Indicators'**
  String get kpiTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @userNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userNameLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get registerButton;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get shortPassword;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'The field cannot be empty'**
  String get fieldRequired;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'departure time'**
  String get departure;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request (400)'**
  String get badRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access (401)'**
  String get unauthorized;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found (404)'**
  String get notFound;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error (500)'**
  String get serverError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'MANAGEMENT'**
  String get management;

  /// No description provided for @addanewuser.
  ///
  /// In en, this message translates to:
  /// **'new user'**
  String get addanewuser;

  /// No description provided for @addanewteam.
  ///
  /// In en, this message translates to:
  /// **'new team'**
  String get addanewteam;

  /// No description provided for @searchbarhint.
  ///
  /// In en, this message translates to:
  /// **'User or team...'**
  String get searchbarhint;

  /// Displayed when a network error occurs
  ///
  /// In en, this message translates to:
  /// **'Network error ({code})'**
  String networkError(int code);

  /// Error message when a required field is missing.
  ///
  /// In en, this message translates to:
  /// **'The \'{field}\' field is required.'**
  String fieldIsRequired(String field);

  /// No description provided for @toggleThemeHint.
  ///
  /// In en, this message translates to:
  /// **'Toggle between dark and light mode'**
  String get toggleThemeHint;

  /// No description provided for @languageSelectionHint.
  ///
  /// In en, this message translates to:
  /// **'Select the application language'**
  String get languageSelectionHint;

  /// No description provided for @accessibilityInfo.
  ///
  /// In en, this message translates to:
  /// **'These settings improve accessibility and readability for all users.'**
  String get accessibilityInfo;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @phoneFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Example: +1 202 555 0123'**
  String get phoneFormatHint;

  /// No description provided for @teamManagement.
  ///
  /// In en, this message translates to:
  /// **'TEAM MANAGEMENT'**
  String get teamManagement;

  /// No description provided for @teamHintName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a team name'**
  String get teamHintName;

  /// No description provided for @createTeam.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get createTeam;

  /// No description provided for @teamNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name :'**
  String get teamNameLabel;

  /// No description provided for @teamDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description :'**
  String get teamDescriptionLabel;

  /// No description provided for @teamNoMember.
  ///
  /// In en, this message translates to:
  /// **'No members'**
  String get teamNoMember;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get addMembers;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
