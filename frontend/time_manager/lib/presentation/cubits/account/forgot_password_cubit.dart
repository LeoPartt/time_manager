import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/account/change_password.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ChangePassword changePasswordUseCase;

  ForgotPasswordCubit({
    required this.changePasswordUseCase,
  }) : super(const ForgotPasswordState.initial());

  Future<void> changePassword(
    BuildContext context, {
    required String code,
    required String password,
  }) async {
    final tr = AppLocalizations.of(context)!;

    emit(const ForgotPasswordState.loading());

    try {
      await changePasswordUseCase(
        code: code,
        password: password,
      );

      emit(const ForgotPasswordState.success());
    } catch (e, stackTrace) {
      emit(ForgotPasswordState.error('${tr.error}: $e'));
    }
  }
}