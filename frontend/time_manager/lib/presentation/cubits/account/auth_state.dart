// 📁 lib/presentation/cubits/account/auth_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/user/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(
    User user, {
    @Default(false) bool isNewLogin, // ✅ Nouveau flag
  }) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(String message) = AuthError;
}