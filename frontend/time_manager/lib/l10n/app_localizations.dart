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

  /// No description provided for @clocking.
  ///
  /// In en, this message translates to:
  /// **'Clocking'**
  String get clocking;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noPlanning.
  ///
  /// In en, this message translates to:
  /// **'No planning'**
  String get noPlanning;

  /// No description provided for @variance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get variance;

  /// No description provided for @clockedIn.
  ///
  /// In en, this message translates to:
  /// **'Clocked in'**
  String get clockedIn;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @planningManagement.
  ///
  /// In en, this message translates to:
  /// **'Planning Management'**
  String get planningManagement;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create a user'**
  String get createUser;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add a user'**
  String get addUser;

  /// No description provided for @addTeam.
  ///
  /// In en, this message translates to:
  /// **'Add a team'**
  String get addTeam;

  /// No description provided for @addDay.
  ///
  /// In en, this message translates to:
  /// **'Add a day'**
  String get addDay;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamName;

  /// No description provided for @teamDescription.
  ///
  /// In en, this message translates to:
  /// **'Team description'**
  String get teamDescription;

  /// No description provided for @teamNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Team name is required'**
  String get teamNameRequired;

  /// No description provided for @selectUserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to find a user'**
  String get selectUserSubtitle;

  /// No description provided for @noPlanningConfigured.
  ///
  /// In en, this message translates to:
  /// **'No planning configured'**
  String get noPlanningConfigured;

  /// No description provided for @noPlanningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding working days'**
  String get noPlanningSubtitle;

  /// No description provided for @noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members'**
  String get noMembers;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMember;

  /// No description provided for @deleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Delete team'**
  String get deleteTeam;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmDelete;

  /// No description provided for @confirmDeletePlanning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the planning from'**
  String get confirmDeletePlanning;

  /// No description provided for @confirmDeleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this team? This action is irreversible.'**
  String get confirmDeleteTeam;

  /// No description provided for @confirmRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove'**
  String get confirmRemoveMember;

  /// No description provided for @planningDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Planning deleted successfully'**
  String get planningDeletedSuccess;

  /// No description provided for @teamCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Team created successfully'**
  String get teamCreatedSuccess;

  /// No description provided for @teamDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Team deleted successfully'**
  String get teamDeletedSuccess;

  /// No description provided for @memberAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get memberAddedSuccess;

  /// No description provided for @memberRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Member removed successfully'**
  String get memberRemovedSuccess;

  /// No description provided for @createdSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'created successfully'**
  String get createdSuccessfully;

  /// No description provided for @createNewUserAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new user account'**
  String get createNewUserAccount;

  /// No description provided for @createNewTeam.
  ///
  /// In en, this message translates to:
  /// **'Create a new team'**
  String get createNewTeam;

  /// No description provided for @configurePlanningsForUsers.
  ///
  /// In en, this message translates to:
  /// **'Configure user plannings'**
  String get configurePlanningsForUsers;

  /// No description provided for @managePlanning.
  ///
  /// In en, this message translates to:
  /// **'Manage planning'**
  String get managePlanning;

  /// No description provided for @userSelected.
  ///
  /// In en, this message translates to:
  /// **'User selected'**
  String get userSelected;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @editPlanning.
  ///
  /// In en, this message translates to:
  /// **'Edit planning'**
  String get editPlanning;

  /// No description provided for @addPlanning.
  ///
  /// In en, this message translates to:
  /// **'Add planning'**
  String get addPlanning;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival time'**
  String get arrivalTime;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get departureTime;

  /// No description provided for @selectArrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Select arrival time'**
  String get selectArrivalTime;

  /// No description provided for @selectDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Select departure time'**
  String get selectDepartureTime;

  /// No description provided for @weekDay.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekDay;

  /// No description provided for @workDay.
  ///
  /// In en, this message translates to:
  /// **'Weekly Work'**
  String get workDay;

  /// No description provided for @workYear.
  ///
  /// In en, this message translates to:
  /// **'Annual Work'**
  String get workYear;

  /// No description provided for @equipDashboard.
  ///
  /// In en, this message translates to:
  /// **'Team Dashboard'**
  String get equipDashboard;

  /// No description provided for @noDataForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No data for this day'**
  String get noDataForThisDay;

  /// No description provided for @simplifiedView.
  ///
  /// In en, this message translates to:
  /// **'Simplified view'**
  String get simplifiedView;

  /// No description provided for @detailedView.
  ///
  /// In en, this message translates to:
  /// **'Detailed view'**
  String get detailedView;

  /// No description provided for @planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get planned;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// No description provided for @noClocking.
  ///
  /// In en, this message translates to:
  /// **'No clocking'**
  String get noClocking;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @noTeamsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No teams available'**
  String get noTeamsAvailable;

  /// No description provided for @selectTeam.
  ///
  /// In en, this message translates to:
  /// **'Select a team'**
  String get selectTeam;

  /// No description provided for @selectATeam.
  ///
  /// In en, this message translates to:
  /// **'Select a team'**
  String get selectATeam;

  /// No description provided for @selectTeamToViewStatistics.
  ///
  /// In en, this message translates to:
  /// **'Choose a team to view its statistics'**
  String get selectTeamToViewStatistics;

  /// No description provided for @loadingTeamDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading team dashboard...'**
  String get loadingTeamDashboard;

  /// No description provided for @avgPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get avgPerMonth;

  /// No description provided for @increasedBy.
  ///
  /// In en, this message translates to:
  /// **'Increased by'**
  String get increasedBy;

  /// No description provided for @decreasedBy.
  ///
  /// In en, this message translates to:
  /// **'Decreased by'**
  String get decreasedBy;

  /// No description provided for @workMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly work'**
  String get workMonth;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @invalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Departure time must be after arrival time'**
  String get invalidTimeRange;

  /// No description provided for @planningCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Planning created successfully'**
  String get planningCreatedSuccess;

  /// No description provided for @planningUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Planning updated successfully'**
  String get planningUpdatedSuccess;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User details'**
  String get userDetails;

  /// No description provided for @viewDashboard.
  ///
  /// In en, this message translates to:
  /// **'View dashboard'**
  String get viewDashboard;

  /// No description provided for @featureInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Feature in development'**
  String get featureInDevelopment;

  /// No description provided for @confirmDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get confirmDeleteUser;

  /// No description provided for @userDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccess;

  /// No description provided for @loadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// No description provided for @loadingTeams.
  ///
  /// In en, this message translates to:
  /// **'Loading teams...'**
  String get loadingTeams;

  /// No description provided for @noUsers.
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get noUsers;

  /// No description provided for @noUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No users have been found'**
  String get noUsersSubtitle;

  /// No description provided for @noTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams'**
  String get noTeams;

  /// No description provided for @noTeamsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No teams have been created'**
  String get noTeamsSubtitle;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get member;

  /// No description provided for @globalDashboard.
  ///
  /// In en, this message translates to:
  /// **'Global Dashboard'**
  String get globalDashboard;

  /// No description provided for @companyOverview.
  ///
  /// In en, this message translates to:
  /// **'Company Overview'**
  String get companyOverview;

  /// No description provided for @globalStatisticsAllEmployees.
  ///
  /// In en, this message translates to:
  /// **'Global statistics for all employees'**
  String get globalStatisticsAllEmployees;

  /// No description provided for @loadingGlobalDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading global dashboard...'**
  String get loadingGlobalDashboard;

  /// No description provided for @daysConfigured.
  ///
  /// In en, this message translates to:
  /// **'days configured'**
  String get daysConfigured;

  /// No description provided for @outOf5WorkingDays.
  ///
  /// In en, this message translates to:
  /// **'out of 5 working days'**
  String get outOf5WorkingDays;

  /// No description provided for @changeUser.
  ///
  /// In en, this message translates to:
  /// **'Change user'**
  String get changeUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get editUser;

  /// No description provided for @editTeam.
  ///
  /// In en, this message translates to:
  /// **'Edit team'**
  String get editTeam;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @userUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccess;

  /// No description provided for @teamUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Team updated successfully'**
  String get teamUpdatedSuccess;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @irreversibleAction.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible'**
  String get irreversibleAction;

  /// No description provided for @searchByNameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get searchByNameOrEmail;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @myPlanning.
  ///
  /// In en, this message translates to:
  /// **'My planning'**
  String get myPlanning;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @loadingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get loadingDashboard;

  /// No description provided for @loadingPlanning.
  ///
  /// In en, this message translates to:
  /// **'Loading planning...'**
  String get loadingPlanning;

  /// No description provided for @viewingPlanningFor.
  ///
  /// In en, this message translates to:
  /// **'Planning for'**
  String get viewingPlanningFor;

  /// No description provided for @selectUser.
  ///
  /// In en, this message translates to:
  /// **'Select a user'**
  String get selectUser;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get workingDays;

  /// No description provided for @weeklyHours.
  ///
  /// In en, this message translates to:
  /// **'Hours/week'**
  String get weeklyHours;

  /// No description provided for @avgPerDay.
  ///
  /// In en, this message translates to:
  /// **'Average/day'**
  String get avgPerDay;

  /// No description provided for @clockedOut.
  ///
  /// In en, this message translates to:
  /// **'Clocked out'**
  String get clockedOut;

  /// No description provided for @clockinConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm clock-in now?'**
  String get clockinConfirmation;

  /// No description provided for @clockoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm clock-out now?'**
  String get clockoutConfirmation;

  /// No description provided for @clockinSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Clock-in recorded successfully'**
  String get clockinSuccessful;

  /// No description provided for @clockoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Clock-out recorded successfully'**
  String get clockoutSuccessful;

  /// No description provided for @clockedInAt.
  ///
  /// In en, this message translates to:
  /// **'Clocked in at'**
  String get clockedInAt;

  /// No description provided for @clockoutAt.
  ///
  /// In en, this message translates to:
  /// **'Clock-out at'**
  String get clockoutAt;

  /// No description provided for @workingFor.
  ///
  /// In en, this message translates to:
  /// **'Working for'**
  String get workingFor;

  /// No description provided for @manualTime.
  ///
  /// In en, this message translates to:
  /// **'Manual time'**
  String get manualTime;

  /// No description provided for @selectClockinTime.
  ///
  /// In en, this message translates to:
  /// **'Select clock-in time'**
  String get selectClockinTime;

  /// No description provided for @selectClockoutTime.
  ///
  /// In en, this message translates to:
  /// **'Select clock-out time'**
  String get selectClockoutTime;

  /// No description provided for @cannotClockInFuture.
  ///
  /// In en, this message translates to:
  /// **'Cannot clock in the future'**
  String get cannotClockInFuture;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @todayStats.
  ///
  /// In en, this message translates to:
  /// **'Today\'s stats'**
  String get todayStats;

  /// No description provided for @firstClockin.
  ///
  /// In en, this message translates to:
  /// **'First clock-in'**
  String get firstClockin;

  /// No description provided for @totalWorked.
  ///
  /// In en, this message translates to:
  /// **'Total worked'**
  String get totalWorked;

  /// No description provided for @expectedTime.
  ///
  /// In en, this message translates to:
  /// **'Expected time'**
  String get expectedTime;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

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

  /// No description provided for @searchUser.
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get searchUser;

  /// No description provided for @searchUsersOrTeams.
  ///
  /// In en, this message translates to:
  /// **'Search users or teams...'**
  String get searchUsersOrTeams;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get noUserFound;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccessful;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to discard your changes?'**
  String get unsavedChangesMessage;

  /// No description provided for @unsavedChangesHint.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get unsavedChangesHint;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'successful'**
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
  /// **'Create a user'**
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

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teamDetails.
  ///
  /// In en, this message translates to:
  /// **'Team details'**
  String get teamDetails;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @kpiTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
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
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive emails for important events'**
  String get emailNotificationsDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get buildNumber;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

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
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
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
  /// **'Field cannot be empty'**
  String get fieldRequired;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
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
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your time efficiently'**
  String get appSubtitle;

  /// No description provided for @addanewuser.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get addanewuser;

  /// No description provided for @addanewteam.
  ///
  /// In en, this message translates to:
  /// **'New team'**
  String get addanewteam;

  /// No description provided for @searchbarhint.
  ///
  /// In en, this message translates to:
  /// **'User or team...'**
  String get searchbarhint;

  /// Displayed when a network error occurs.
  ///
  /// In en, this message translates to:
  /// **'Network error ({code})'**
  String networkError(int code);

  /// Error message when a required field is missing.
  ///
  /// In en, this message translates to:
  /// **'The field \'{field}\' is required.'**
  String fieldIsRequired(String field);

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
  /// **'Example: +33 6 12 34 56 78'**
  String get phoneFormatHint;

  /// No description provided for @toggleThemeHint.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable dark mode'**
  String get toggleThemeHint;

  /// No description provided for @languageSelectionHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get languageSelectionHint;

  /// No description provided for @accessibilityInfo.
  ///
  /// In en, this message translates to:
  /// **'These settings improve accessibility and readability for all users.'**
  String get accessibilityInfo;

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
  /// **'Name:'**
  String get teamNameLabel;

  /// No description provided for @teamDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get teamDescriptionLabel;

  /// No description provided for @teamNoMember.
  ///
  /// In en, this message translates to:
  /// **'No member'**
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

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile...'**
  String get loadingProfile;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @dashboardLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get dashboardLoading;

  /// No description provided for @planningLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading planning...'**
  String get planningLoading;

  /// No description provided for @planningCalendar.
  ///
  /// In en, this message translates to:
  /// **'Planning calendar'**
  String get planningCalendar;

  /// No description provided for @planning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planning;

  /// No description provided for @noPlanningForTodat.
  ///
  /// In en, this message translates to:
  /// **'No planning for this day'**
  String get noPlanningForTodat;

  /// No description provided for @planingWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly planning'**
  String get planingWeekly;

  /// No description provided for @noConfigplanning.
  ///
  /// In en, this message translates to:
  /// **'No planning configured'**
  String get noConfigplanning;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @teamDashboard.
  ///
  /// In en, this message translates to:
  /// **'Team Dashboard'**
  String get teamDashboard;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @dashboardTeam.
  ///
  /// In en, this message translates to:
  /// **'Team dashboard'**
  String get dashboardTeam;

  /// No description provided for @selectEquip.
  ///
  /// In en, this message translates to:
  /// **'Select a team'**
  String get selectEquip;

  /// No description provided for @ponctuality.
  ///
  /// In en, this message translates to:
  /// **'Punctuality'**
  String get ponctuality;

  /// No description provided for @assiduity.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get assiduity;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @atUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get atUpgrade;
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
