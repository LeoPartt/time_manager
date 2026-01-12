import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/presentation/routes/guard/auth_guard.dart';
import 'package:time_manager/presentation/routes/guard/role_guard.dart';
import 'package:time_manager/presentation/screens/auth/forgot_password_screen.dart';
import 'package:time_manager/presentation/screens/auth/login_screen.dart';
import 'package:time_manager/presentation/screens/dashboard/global_dashboard_screen.dart';
import 'package:time_manager/presentation/screens/management/edit_user_screen.dart';
import 'package:time_manager/presentation/screens/management/users_teams_management_screen.dart';
import 'package:time_manager/presentation/screens/planning/planning_calendar.dart';
import 'package:time_manager/presentation/screens/dashboard/team_dashboard_screen.dart';
import 'package:time_manager/presentation/screens/management/create_team_screen.dart';
import 'package:time_manager/presentation/screens/management/team_management_screen.dart';
import 'package:time_manager/presentation/screens/planning/planning_management_screen.dart';
import 'package:time_manager/presentation/screens/schedule/clocking.dart';
import 'package:time_manager/presentation/screens/dashboard/dashboard_screen.dart';

import 'package:time_manager/presentation/screens/management/create_user_screen.dart';
import 'package:time_manager/presentation/screens/management/management_screen.dart';
import 'package:time_manager/presentation/screens/settings_screen.dart';
import 'package:time_manager/presentation/screens/user/user_edit_screen.dart';
import 'package:time_manager/presentation/screens/user/user_screen.dart';


part 'app_router.gr.dart'; // Generated file

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;
  final RoleGuard adminGuard;
  final RoleGuard managerGuard;

  AppRouter(
    this.authGuard,
    this.adminGuard,
    this.managerGuard, {
    super.navigatorKey,
  });

  @override
  List<AutoRoute> get routes => [
    // ✅ Routes publiques
    AutoRoute(page: LoginRoute.page, initial: true),

    // ✅ Routes pour tous les utilisateurs authentifiés
    AutoRoute(page: DashboardRoute.page, guards: [authGuard]),
    AutoRoute(page: ClockingRoute.page, guards: [authGuard]),
    AutoRoute(page: UserRoute.page, guards: [authGuard]),
 
    AutoRoute(page: SettingsRoute.page, guards: [authGuard]),
    AutoRoute(page: UserEditRoute.page, guards: [authGuard]),

    // ✅ Routes MANAGER et ADMIN
    AutoRoute(
      page: TeamDashboardRoute.page,
      guards: [authGuard, managerGuard],
    ),
    AutoRoute(
      page: TeamManagementRoute.page,
      guards: [authGuard, managerGuard],
    ),
    AutoRoute(
      page: PlanningCalendarRoute.page,
      guards: [authGuard],
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
      guards: [authGuard],
    ),

    // ✅ Routes ADMIN UNIQUEMENT
    AutoRoute(
      page: ManagementRoute.page,
      guards: [authGuard, adminGuard],
    ),
    AutoRoute(
      page: PlanningManagementRoute.page,
      guards: [authGuard, adminGuard],
    ),
    AutoRoute(
      page: UsersTeamsManagementRoute.page,
      guards: [authGuard, adminGuard,managerGuard],
    ),
    AutoRoute(
      page: GlobalDashboardRoute.page,
      guards: [authGuard, adminGuard],
    ),
    AutoRoute(
      page: CreateUserRoute.page,
      guards: [authGuard, adminGuard,managerGuard],
    ),
    AutoRoute(
      page: CreateTeamRoute.page,
      guards: [authGuard, adminGuard],
    ),
    AutoRoute(
      page: EditManagementUserRoute.page,
      guards: [authGuard, adminGuard,managerGuard],
    ),
  ];
}

