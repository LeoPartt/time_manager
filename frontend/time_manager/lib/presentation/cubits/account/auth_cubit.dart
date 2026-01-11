// 📁 lib/presentation/cubits/account/auth_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/utils/jwt_decoder.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/usecases/account/login_user.dart';
import 'package:time_manager/domain/usecases/account/logout_user.dart';
import 'package:time_manager/domain/usecases/account/register_account.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final LocalStorageService storage;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.storage,
  }) : super(const AuthState.initial());

  /// ✅ Restaurer la session au démarrage (PAS de isNewLogin)
  Future<void> restoreSession() async {
    
    final token = await storage.getToken();
    if (token == null || token.isEmpty) {
      emit(const AuthState.unauthenticated());
      return;
    }

    if (JwtDecoder.isExpired(token)) {
      await logout();
      return;
    }

    final user = _createUserFromToken(token);
    
    // ✅ isNewLogin = false (restauration)
    emit(AuthState.authenticated(user, isNewLogin: false));
  }

  Future<void> login(
    BuildContext context, {
    required String username,
    required String password,
  }) async {
    final tr = AppLocalizations.of(context)!;

    emit(const AuthState.loading());
    
    try {
      await loginUser(username, password);

      final token = await storage.getToken();
      if (token == null) throw Exception('No token received');

      final user = _createUserFromToken(token);
      
      // ✅ isNewLogin = true (nouveau login)
      emit(AuthState.authenticated(user, isNewLogin: true));
    } catch (e) {
      emit(AuthState.error('${tr.error}: ${e.toString()}'));
    }
  }

  Future<void> register({
    required String name,
    required String username,
    required String password,
  }) async {
    emit(const AuthState.loading());
    try {
      await registerUser(name, username, password);

      final token = await storage.getToken();
      if (token == null) throw Exception('No token received');

      final user = _createUserFromToken(token);
      emit(AuthState.authenticated(user, isNewLogin: true));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await logoutUser();
    emit(const AuthState.unauthenticated());
  }

  User _createUserFromToken(String token) {
    final username = JwtDecoder.extractUsername(token) ?? 'User';
    final isAdmin = username.toLowerCase() == 'admin';

    return User(
      id: 0,
      username: username,
      email: '$username@temp.local',
      firstName: isAdmin ? 'Admin' : 'User',
      lastName: username,
      isManager: false,
      isAdministrator: isAdmin,
    );
  }
}