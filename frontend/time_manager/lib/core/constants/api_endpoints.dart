import 'package:time_manager/initialization/environment.dart';

/// Centralized definition of all backend API endpoints.
class ApiEndpoints {
  // ───────────────────────────────
  //  Base URL (comes from Environment)
  // ───────────────────────────────
  static String get base => Environment.baseUrl;

  // ───────────────────────────────
  //  AUTH endpoints
  // ───────────────────────────────
  static String get login => '/auth/login';
  static String get register => '/auth/register';
  static String get logout => '/auth/logout';
  static String get refresh => '/auth/refresh';

  // ───────────────────────────────
  //  USER endpoints
  // ───────────────────────────────
  static String get users => '/users';
  static String get userProfile => '/users/me';
  static String userById(int id) => '/users/$id';
  static String get updateProfile => '/users';
    static String userClocks(int userId) => '/users/$userId/clocks';
  static String userTeams(int userId) => '/users/$userId/teams';
  static String userPlannings(int userId) => '/users/$userId/plannings';

  // ───────────────────────────────
  //  TEAMS endpoints
  // ───────────────────────────────
  static String get teams => '/teams';
  static String teamById(int id) => '/teams/$id';
  static String get createTeam => '/teams';

  // ───────────────────────────────
  //  MEMBERSHIPS endpoints
  // ───────────────────────────────
  static String get memberships => '/memberships';
  static String membershipById(int id) => '/memberships/$id';

  // ───────────────────────────────
  //  SCHEDULE endpoints
  // ───────────────────────────────
  static String get schedules => '/clocks';
  static String scheduleById(int id) => '/schedules/$id';
  // static String get clockIn => '/clocks';
  // static String get clockOut => '/clocks';
  static String get history => '/schedules/history';
   
  static String get clockStatus => '/clocks/status';

  // ───────────────────────────────
  // REPORTS / KPI endpoints
  // ───────────────────────────────

  static const String globalReport = '/reports';
  static String userReport(int userId) => '/reports/users/$userId';
  static String teamReport(int teamId) => '/reports/teams/$teamId';

  // ═══════════════════════════════════════════════════════
  // 📅 PLANNINGS
  // ═══════════════════════════════════════════════════════
  static const String plannings = '/plannings';
  static String planning(int id) => '/plannings/$id';
}

