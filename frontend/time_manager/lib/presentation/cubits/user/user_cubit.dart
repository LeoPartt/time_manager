import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/user/create_user.dart';

import 'package:time_manager/domain/usecases/user/delete_user.dart';
import 'package:time_manager/domain/usecases/user/get_current_user.dart';
import 'package:time_manager/domain/usecases/user/get_user.dart';
import 'package:time_manager/domain/usecases/user/get_user_profile.dart';
import 'package:time_manager/domain/usecases/user/get_users.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteUser deleteUser;
  final CreateUser createUserUsecase;
  final GetUser getUserUseCase;
  final GetUsers getUsersUseCase;
  final GetCurrentUser getCurrentUser;

  UserCubit( {
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteUser,
    required this.getUserUseCase,
    required this.getUsersUseCase,
    required this.getCurrentUser,
    required this.createUserUsecase,
  }) : super(const UserState.initial());

  Future<void> loadProfile() async {
    emit(const UserState.loading());
    try {
      final user = await getUserProfile();
      emit(UserState.loaded(user));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }
   Future<void> restoreSession() async {
    emit(const UserState.loading());
    try {
      // 1) Essaye le cache local
      final cached = await getCurrentUser();
      if (cached != null) {
        emit(UserState.loaded(cached));
        return;
      }

      // 2) Sinon, tente de récupérer le profil depuis l’API (si token valide)
      final remote = await getUserProfile();
      emit(UserState.loaded(remote));
    } catch (_) {
      // Si token absent/expiré ou erreur → session vide
      emit(const UserState.initial());
    }
  }

  Future<void> getUser(BuildContext context, int id) async {
        final tr = AppLocalizations.of(context)!;

    emit(const UserState.loading());
    try {
      final user = await getUserUseCase(id);
      emit(UserState.loaded(user));
    } catch (e) {

      emit(UserState.error(('${tr.error}: ${e.toString()}')));
    }
  }

  Future<void> getUsers() async {
    emit(const UserState.loading());

    try {
      final users = await getUsersUseCase();
      emit(UserState.listLoaded(users));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> updateProfile(BuildContext context, UpdateUserProfileParams params) async {
       final tr = AppLocalizations.of(context)!;

    emit(const UserState.loading());
    try {
      final user = await updateUserProfile(params);
         emit(UserState.updated(user)); // ✅ succès explicite

    } catch (e) {
      emit(UserState.error(('${tr.error}: ${e.toString()}')));
    }
  }

  Future<void> createUser(BuildContext context, {
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
       final tr = AppLocalizations.of(context)!;

    emit(const UserState.loading());
    try {
      final user = await createUserUsecase(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
      emit(UserState.loaded(user));
    } catch (e) {
      emit(UserState.error(('${tr.error}: ${e.toString()}')));
    }
  }

  Future<void> removeAccount(BuildContext context, int id) async {
       final tr = AppLocalizations.of(context)!;

    emit(const UserState.loading());
    try {
      await deleteUser(id);
      emit(const UserState.deleted());
    } catch (e) {
      emit(UserState.error(('${tr.error}: ${e.toString()}')));
    }
  }
}
