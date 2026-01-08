// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'SETTINGS';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get currentThemeDark => 'Current theme: dark';

  @override
  String get currentThemeLight => 'Current theme: light';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get me => 'ME';

  @override
  String get modify => 'Modify';

  @override
  String get successful => 'with success';

  @override
  String get delete => 'Delete';

  @override
  String get clockin => 'CLOCK IN';

  @override
  String get clockout => 'CLOCK OUT';

  @override
  String get validate => 'Validate';

  @override
  String get arrival => 'Arrival time';

  @override
  String get registerTitle => 'Create an user';

  @override
  String get welcome => 'Welcome';

  @override
  String get teams => 'Teams';

  @override
  String get teamDetails => 'Team Details';

  @override
  String get reports => 'Reports';

  @override
  String get kpiTitle => 'Performance Indicators';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get userNameLabel => 'Username';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Create';

  @override
  String get emailRequired => 'Email address is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get shortPassword => 'Password must be at least 6 characters';

  @override
  String get fieldRequired => 'The field cannot be empty';

  @override
  String get departure => 'departure time';

  @override
  String get badRequest => 'Invalid request (400)';

  @override
  String get unauthorized => 'Unauthorized access (401)';

  @override
  String get notFound => 'Resource not found (404)';

  @override
  String get serverError => 'Server error (500)';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get management => 'MANAGEMENT';

  @override
  String get addanewuser => 'new user';

  @override
  String get addanewteam => 'new team';

  @override
  String get searchbarhint => 'User or team...';

  @override
  String networkError(int code) {
    return 'Network error ($code)';
  }

  @override
  String fieldIsRequired(String field) {
    return 'The \'$field\' field is required.';
  }

  @override
  String get toggleThemeHint => 'Toggle between dark and light mode';

  @override
  String get languageSelectionHint => 'Select the application language';

  @override
  String get accessibilityInfo => 'These settings improve accessibility and readability for all users.';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get phoneFormatHint => 'Example: +1 202 555 0123';
}
