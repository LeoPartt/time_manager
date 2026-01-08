import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/account/login_user.dart';
import 'package:time_manager/domain/usecases/account/logout_user.dart';
import 'package:time_manager/domain/usecases/account/register_account.dart';
import 'package:time_manager/l10n/app_localizations.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
  }) : super(const AuthState.initial());

  Future<void> login(BuildContext context, {required String username, required String password}) async {
            final tr = AppLocalizations.of(context)!;

    emit(const AuthState.loading());
    try {
      final user = await loginUser(username, password);
      
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(('${tr.error}: ${e.toString()}')));
    }
  }

  Future<void> register({required String name, required String username, required String password}) async {
    emit(const AuthState.loading());
    try {
      final user = await registerUser(name, username, password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await logoutUser();
    emit(const AuthState.initial());
  }

  
}
