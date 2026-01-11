
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/utils/jwt_decoder.dart';
import 'package:time_manager/core/utils/role/role_manager.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

class RoleGuard extends AutoRouteGuard {
  final UserRepository userRepository;
  final LocalStorageService storage;
  final UserRole requiredRole;

  RoleGuard(
    this.userRepository,
    this.storage,
    this.requiredRole,
  );

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {

    try {
      // ✅ 1. Vérifier si c'est un admin pur via JWT
      final token = await storage.getToken();
      if (token != null) {
        final username = JwtDecoder.extractUsername(token);
        if (username?.toLowerCase() == 'admin') {
          resolver.next(true);
          return;
        }
      }

      // ✅ 2. Sinon, vérifier via UserCubit
      final context = router.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        final userCubit = context.read<UserCubit>();
        final userState = userCubit.state;

        await userState.when(
          initial: () async {
            // Charger le profil si pas encore chargé
            await userCubit.loadProfile();
            await _checkUserRole(resolver, router, userCubit);
          },
          loading: () async {
            // Attendre la fin du chargement
            await Future.delayed(const Duration(milliseconds: 500));
            await _checkUserRole(resolver, router, userCubit);
          },
          loaded: (user) async {
            await _checkUserRole(resolver, router, userCubit);
          },
          updated: (user) async {
            await _checkUserRole(resolver, router, userCubit);
          },
          listLoaded: (_) async {
            resolver.redirect(const LoginRoute());
          },
          deleted: () async {
            resolver.redirect(const LoginRoute());
          },
          error: (msg) async {
            resolver.redirect(const LoginRoute());
          },
        );
      } else {
        resolver.redirect(const LoginRoute());
      }
    } catch (e) {
      resolver.redirect(const LoginRoute());
    }
  }

  Future<void> _checkUserRole(
    NavigationResolver resolver,
    StackRouter router,
    UserCubit userCubit,
  ) async {
    final userState = userCubit.state;

    userState.whenOrNull(
      loaded: (user) {
        final hasRole = RoleManager.hasRole(user, requiredRole);

        if (hasRole) {
          resolver.next(true);
        } else {
          resolver.redirect(const LoginRoute());
        }
      },
      updated: (user) {
        final hasRole = RoleManager.hasRole(user, requiredRole);

        if (hasRole) {
          resolver.next(true);
        } else {
          resolver.redirect(const LoginRoute());
        }
      },
    );
  }
}