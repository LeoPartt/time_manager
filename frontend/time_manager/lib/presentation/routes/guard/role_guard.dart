import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    print('🔍 [RoleGuard] Checking role: $requiredRole');

    try {
      
      final token = await storage.getToken();
      if (token != null) {
        final username = JwtDecoder.extractUsername(token);
        print('👤 [RoleGuard] JWT username: $username');
        
        if (username?.toLowerCase() == 'admin') {
          print('✅ [RoleGuard] Pure admin detected, granting access');
          resolver.next(true);
          return;
        }
      }

      // ✅ 2. Sinon, vérifier via UserCubit
      final context = router.navigatorKey.currentContext;
      
      if (context == null) {
        print('❌ [RoleGuard] Context is null');
        await Future.delayed(const Duration(milliseconds: 100));
        final retryContext = router.navigatorKey.currentContext;
        
        if (retryContext == null) {
          print('❌ [RoleGuard] Context still null, denying access');
          resolver.next(false);
          return;
        }
        
        await _checkUserRoleAsync(retryContext, resolver, router);
        return;
      }

      await _checkUserRoleAsync(context, resolver, router);
    } catch (e, stackTrace) {
      print('❌ [RoleGuard] Exception: $e');
      print('❌ [RoleGuard] StackTrace: $stackTrace');
      resolver.next(false);
      router.push( DashboardRoute());
    }
  }

  Future<void> _checkUserRoleAsync(
    BuildContext context,
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    print('🔄 [RoleGuard] Checking user role via UserCubit...');
    
    final userCubit = context.read<UserCubit>();
    final userState = userCubit.state;
    
print('🆔 [RoleGuard] UserCubit hashCode: ${userCubit.hashCode}');

    print('📊 [RoleGuard] Current UserState: ${userState.runtimeType}');

    // ✅ Si initial, charger le profil et attendre
    if (userState is UserInitial) {
      print('⏳ [RoleGuard] State is initial, loading profile...');
      
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            userCubit.loadProfile();
          }
        });

      // Attendre que le state change
      final completer = Completer<UserState>();
      late final StreamSubscription subscription;

      subscription = userCubit.stream.listen((state) {
        print('👂 [RoleGuard] State changed to: ${state.runtimeType}');
        if (state is! UserInitial && state is! UserLoading) {
          completer.complete(state);
          subscription.cancel();
        }
      });

      try {
        final finalState = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print('⏱️ [RoleGuard] Timeout waiting for user state');
            subscription.cancel();
            return const UserState.error('Timeout loading user');
          },
        );

        _handleFinalState(finalState, resolver, router);
      } catch (e) {
        print('❌ [RoleGuard] Error waiting for state: $e');
        resolver.next(false);
        router.push( DashboardRoute());
      }
      return;
    }

    // ✅ Si loading, attendre
    if (userState is UserLoading) {
      print('⏳ [RoleGuard] State is loading, waiting...');

      final completer = Completer<UserState>();
      late final StreamSubscription subscription;

      subscription = userCubit.stream.listen((state) {
        print('👂 [RoleGuard] State changed to: ${state.runtimeType}');
        if (state is! UserLoading) {
          completer.complete(state);
          subscription.cancel();
        }
      });

      try {
        final finalState = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print('⏱️ [RoleGuard] Timeout waiting for loading');
            subscription.cancel();
            return const UserState.error('Timeout loading user');
          },
        );

        _handleFinalState(finalState, resolver, router);
      } catch (e) {
        print('❌ [RoleGuard] Error waiting for loading: $e');
        resolver.next(false);
        router.push( DashboardRoute());
      }
      return;
    }

    // ✅ State est déjà loaded/updated/error
    _handleFinalState(userState, resolver, router);
  }

  void _handleFinalState(
    UserState state,
    NavigationResolver resolver,
    StackRouter router,
  ) {
    print('🎯 [RoleGuard] Handling final state: ${state.runtimeType}');

    state.when(
      loaded: (user) {
        print('✅ [RoleGuard] User loaded: ${user.username}');
        print('🔐 [RoleGuard] isAdministrator: ${user.isAdministrator}');
        print('👔 [RoleGuard] isManager: ${user.isManager}');
        print('🎯 [RoleGuard] Required role: $requiredRole');

        final hasRole = RoleManager.hasRole(user, requiredRole);
        print('🎯 [RoleGuard] Has required role: $hasRole');

        if (hasRole) {
          print('✅ [RoleGuard] Access GRANTED');
          resolver.next(true);
        } else {
          print('❌ [RoleGuard] Access DENIED');
          resolver.next(false);
          router.push( DashboardRoute());
        }
      },
      updated: (user) {
        print('✅ [RoleGuard] User updated: ${user.username}');
        print('🔐 [RoleGuard] isAdministrator: ${user.isAdministrator}');
        print('👔 [RoleGuard] isManager: ${user.isManager}');

        final hasRole = RoleManager.hasRole(user, requiredRole);
        print('🎯 [RoleGuard] Has required role: $hasRole');

        if (hasRole) {
          print('✅ [RoleGuard] Access GRANTED (updated)');
          resolver.next(true);
        } else {
          print('❌ [RoleGuard] Access DENIED (updated)');
          resolver.next(false);
          router.push( DashboardRoute());
        }
      },
      error: (msg) {
        print('❌ [RoleGuard] User error: $msg');
        resolver.next(false);
        router.push(DashboardRoute());
      },
      initial: () {
        print('❌ [RoleGuard] Still initial (should not happen)');
        resolver.next(false);
      },
      loading: () {
        print('❌ [RoleGuard] Still loading (should not happen)');
        resolver.next(false);
      },
      listLoaded: (_) {
        print('❌ [RoleGuard] Unexpected listLoaded state');
        resolver.next(false);
      },
      deleted: () {
        print('❌ [RoleGuard] User deleted');
        resolver.next(false);
      },
    );
  }
}