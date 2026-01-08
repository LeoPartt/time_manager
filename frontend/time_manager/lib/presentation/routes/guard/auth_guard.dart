import 'package:auto_route/auto_route.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

/// Guard to prevent unauthorized access.
class AuthGuard extends AutoRouteGuard {
  final LocalStorageService _storage;

  AuthGuard(this._storage);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await _storage.getToken();

    if (token != null && token.isNotEmpty) {
      // ✅ User is authenticated → proceed
      resolver.next(true);
    } else {
      // 🚫 User not authenticated → redirect to Login
      router.replace(const LoginRoute());
    }
  }
}
