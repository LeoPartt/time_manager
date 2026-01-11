// 📁 lib/core/utils/role_manager.dart

import 'package:time_manager/domain/entities/user/user.dart';

enum UserRole {
  administrator,
  manager,
  employee;

  static UserRole fromUser(User user) {
    if (user.isAdministrator) {
      return UserRole.administrator;
    } else if (user.isManager) {
      return UserRole.manager;
    } else {
      return UserRole.employee;
    }
  }
}

class RoleManager {
  // ✅ Vérifier si l'utilisateur a le rôle minimum requis
  static bool hasRole(User user, UserRole requiredRole) {
    final userRole = UserRole.fromUser(user);
    return _getRoleLevel(userRole) >= _getRoleLevel(requiredRole);
  }

  // ✅ Obtenir le niveau hiérarchique du rôle
  static int _getRoleLevel(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 3;
      case UserRole.manager:
        return 2;
      case UserRole.employee:
        return 1;
    }
  }

  // ✅ Vérifier si l'utilisateur est admin
  static bool isAdministrator(User user) {
    return user.isAdministrator;
  }

  // ✅ Vérifier si l'utilisateur est manager (ou admin)
  static bool isManager(User user) {
    return user.isManager || user.isAdministrator;
  }

  // ✅ Vérifier si l'utilisateur est employé simple
  static bool isEmployee(User user) {
    return !user.isManager && !user.isAdministrator;
  }

  // ✅ Obtenir les routes autorisées pour un utilisateur
  static List<String> getAuthorizedRoutes(User user) {
    final role = UserRole.fromUser(user);

    switch (role) {
      case UserRole.administrator:
        return [
          '/dashboard',
          '/clocking',
          '/management',
          '/planning-management',
          '/users-teams-management',
          '/global-dashboard',
          '/team-dashboard',
          '/profile',
          '/settings',
        ];

      case UserRole.manager:
        return [
          '/dashboard',
          '/clocking',
          '/team-dashboard',
          '/team-management',
          '/profile',
          '/settings',
        ];

      case UserRole.employee:
        return [
          '/dashboard',
          '/clocking',
          '/profile',
          '/settings',
        ];
    }
  }

  // ✅ Vérifier si une route est autorisée pour un utilisateur
  static bool isRouteAuthorized(User user, String route) {
    return getAuthorizedRoutes(user).contains(route);
  }
}