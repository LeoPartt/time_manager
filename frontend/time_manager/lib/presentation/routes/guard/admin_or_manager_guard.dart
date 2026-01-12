import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

class AdminOrManagerGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;
    
    if (context == null) {
      print('❌ [AdminOrManagerGuard] Context is null');
      resolver.next(false);
      return;
    }

    final userState = context.read<UserCubit>().state;

    userState.whenOrNull(
      loaded: (user) {
        print('🔍 [AdminOrManagerGuard] User: ${user.username}');
        print('🔐 [AdminOrManagerGuard] isAdministrator: ${user.isAdministrator}');
        print('👔 [AdminOrManagerGuard] isManager: ${user.isManager}');

        // ✅ Autoriser si admin OU manager
        if (user.isAdministrator || user.isManager) {
          print('✅ [AdminOrManagerGuard] Access granted (admin or manager)');
          resolver.next(true);
        } else {
          print('❌ [AdminOrManagerGuard] Access denied (not admin or manager)');
          resolver.next(false);
          router.push(DashboardRoute()); // Rediriger vers dashboard
        }
      },
      updated: (user) {
        print('🔍 [AdminOrManagerGuard] User updated: ${user.username}');
        
        if (user.isAdministrator || user.isManager) {
          print('✅ [AdminOrManagerGuard] Access granted (updated state)');
          resolver.next(true);
        } else {
          print('❌ [AdminOrManagerGuard] Access denied (updated state)');
          resolver.next(false);
          router.push(DashboardRoute());
        }
      },
      
    );
  }
}