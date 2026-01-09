// 📁 lib/presentation/cubits/dashboard/dashboard_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/dashboard/get_global_report.dart';
import 'package:time_manager/domain/usecases/dashboard/get_team_report.dart';
import 'package:time_manager/domain/usecases/dashboard/get_user_report.dart';

import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetUserDashboard getUserDashboardUseCase;
  final GetTeamDashboard getTeamDashboardUseCase;
  final GetGlobalDashboard getGlobalDashboardUseCase;

  DashboardCubit({
    required this.getUserDashboardUseCase,
    required this.getTeamDashboardUseCase,
    required this.getGlobalDashboardUseCase,
  }) : super(const DashboardState.initial());

  /// 📊 Charge le dashboard d'un utilisateur
  Future<void> loadUserDashboard(
    BuildContext context, {
    required int userId,
    required String mode,
    DateTime? at,
  }) async {
    final tr = AppLocalizations.of(context)!;

    print('🔵 [DashboardCubit] loadUserDashboard');
    print('🔵 [DashboardCubit] userId: $userId, mode: $mode');

    emit(const DashboardState.loading());

    try {
      final report = await getUserDashboardUseCase(
        userId: userId,
        mode: mode,
        at: at,
      );

      print('🟢 [DashboardCubit] User dashboard loaded');

      emit(DashboardState.userLoaded(report));
    } catch (e, stackTrace) {
      print('🔴 [DashboardCubit] Error: $e');
      print('🔴 [DashboardCubit] StackTrace: $stackTrace');
      emit(DashboardState.error('${tr.error}: $e'));
    }
  }

  /// 📊 Charge le dashboard d'une équipe
  Future<void> loadTeamDashboard(
    BuildContext context, {
    required int teamId,
    required String mode,
    DateTime? at,
  }) async {
    final tr = AppLocalizations.of(context)!;

    print('🔵 [DashboardCubit] loadTeamDashboard');
    print('🔵 [DashboardCubit] teamId: $teamId, mode: $mode');

    emit(const DashboardState.loading());

    try {
      final report = await getTeamDashboardUseCase(
        teamId: teamId,
        mode: mode,
        at: at,
      );

      print('🟢 [DashboardCubit] Team dashboard loaded');

      emit(DashboardState.teamLoaded(report));
    } catch (e, stackTrace) {
      print('🔴 [DashboardCubit] Error: $e');
      print('🔴 [DashboardCubit] StackTrace: $stackTrace');
      emit(DashboardState.error('${tr.error}: $e'));
    }
  }

  /// 📊 Charge le dashboard global
  Future<void> loadGlobalDashboard(
    BuildContext context, {
    required String mode,
    DateTime? at,
  }) async {
    final tr = AppLocalizations.of(context)!;

    print('🔵 [DashboardCubit] loadGlobalDashboard');
    print('🔵 [DashboardCubit] mode: $mode');

    emit(const DashboardState.loading());

    try {
      final report = await getGlobalDashboardUseCase(
        mode: mode,
        at: at,
      );

      print('🟢 [DashboardCubit] Global dashboard loaded');

      emit(DashboardState.globalLoaded(report));
    } catch (e, stackTrace) {
      print('🔴 [DashboardCubit] Error: $e');
      print('🔴 [DashboardCubit] StackTrace: $stackTrace');
      emit(DashboardState.error('${tr.error}: $e'));
    }
  }
}
