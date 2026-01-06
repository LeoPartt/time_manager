import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/presentation/routes/guard/auth_guard.dart';
import 'package:time_manager/presentation/screens/auth/login_screen.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/team_dashboard_screen.dart';
import 'package:time_manager/presentation/screens/management/create_team_screen.dart';
import 'package:time_manager/presentation/screens/schedule/clocking.dart';
import 'package:time_manager/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:time_manager/presentation/screens/home_screen.dart';
import 'package:time_manager/presentation/screens/management/create_user_screen.dart';
import 'package:time_manager/presentation/screens/management/management_screen.dart';
import 'package:time_manager/presentation/screens/settings_screen.dart';
import 'package:time_manager/presentation/screens/user/profile_screen.dart';
import 'package:time_manager/presentation/screens/user/user_edit_screen.dart';
import 'package:time_manager/presentation/screens/user/user_screen.dart';
// import '../screens/auth/login_screen.dart';
// import '../screens/home/home_screen.dart';
// import '../screens/reports/reports_screen.dart';

part 'app_router.gr.dart'; // Generated file

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter   {
    final AuthGuard authGuard;

    AppRouter(this.authGuard, {super.navigatorKey}); 

  @override
   List<AutoRoute> get routes =>  [
     AutoRoute(page: DashboardRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: ProfileRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: LoginRoute.page, initial: true),
     AutoRoute(page: SettingsRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: UserRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: UserEditRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: CreateUserRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: ClockingRoute.page, initial: false, guards: [authGuard]),
     AutoRoute(page: ManagementRoute.page, initial: false),
     AutoRoute(page: CreateTeamRoute.page, initial: false, guards: [authGuard])
  ];
}
