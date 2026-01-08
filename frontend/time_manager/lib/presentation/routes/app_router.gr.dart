// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ClockingScreen]
class ClockingRoute extends PageRouteInfo<void> {
  const ClockingRoute({List<PageRouteInfo>? children})
    : super(ClockingRoute.name, initialChildren: children);

  static const String name = 'ClockingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClockingScreen();
    },
  );
}

/// generated route for
/// [CreateTeamScreen]
class CreateTeamRoute extends PageRouteInfo<void> {
  const CreateTeamRoute({List<PageRouteInfo>? children})
    : super(CreateTeamRoute.name, initialChildren: children);

  static const String name = 'CreateTeamRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateTeamScreen();
    },
  );
}

/// generated route for
/// [CreateUserScreen]
class CreateUserRoute extends PageRouteInfo<void> {
  const CreateUserRoute({List<PageRouteInfo>? children})
    : super(CreateUserRoute.name, initialChildren: children);

  static const String name = 'CreateUserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateUserScreen();
    },
  );
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({Key? key, int? userId, List<PageRouteInfo>? children})
    : super(
        DashboardRoute.name,
        args: DashboardRouteArgs(key: key, userId: userId),
        initialChildren: children,
      );

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DashboardRouteArgs>(
        orElse: () => const DashboardRouteArgs(),
      );
      return DashboardScreen(key: args.key, userId: args.userId);
    },
  );
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key, this.userId});

  final Key? key;

  final int? userId;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DashboardRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [ManagementScreen]
class ManagementRoute extends PageRouteInfo<void> {
  const ManagementRoute({List<PageRouteInfo>? children})
    : super(ManagementRoute.name, initialChildren: children);

  static const String name = 'ManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagementScreen();
    },
  );
}

/// generated route for
/// [PlanningCalendarScreen]
class PlanningCalendarRoute extends PageRouteInfo<PlanningCalendarRouteArgs> {
  PlanningCalendarRoute({Key? key, int? userId, List<PageRouteInfo>? children})
    : super(
        PlanningCalendarRoute.name,
        args: PlanningCalendarRouteArgs(key: key, userId: userId),
        initialChildren: children,
      );

  static const String name = 'PlanningCalendarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlanningCalendarRouteArgs>(
        orElse: () => const PlanningCalendarRouteArgs(),
      );
      return PlanningCalendarScreen(key: args.key, userId: args.userId);
    },
  );
}

class PlanningCalendarRouteArgs {
  const PlanningCalendarRouteArgs({this.key, this.userId});

  final Key? key;

  final int? userId;

  @override
  String toString() {
    return 'PlanningCalendarRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlanningCalendarRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [TeamDashboardScreen]
class TeamDashboardRoute extends PageRouteInfo<void> {
  const TeamDashboardRoute({List<PageRouteInfo>? children})
    : super(TeamDashboardRoute.name, initialChildren: children);

  static const String name = 'TeamDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TeamDashboardScreen();
    },
  );
}

/// generated route for
/// [UserEditScreen]
class UserEditRoute extends PageRouteInfo<UserEditRouteArgs> {
  UserEditRoute({Key? key, required int userId, List<PageRouteInfo>? children})
    : super(
        UserEditRoute.name,
        args: UserEditRouteArgs(key: key, userId: userId),
        initialChildren: children,
      );

  static const String name = 'UserEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserEditRouteArgs>();
      return UserEditScreen(key: args.key, userId: args.userId);
    },
  );
}

class UserEditRouteArgs {
  const UserEditRouteArgs({this.key, required this.userId});

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'UserEditRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserEditRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [UserScreen]
class UserRoute extends PageRouteInfo<void> {
  const UserRoute({List<PageRouteInfo>? children})
    : super(UserRoute.name, initialChildren: children);

  static const String name = 'UserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserScreen();
    },
  );
}
