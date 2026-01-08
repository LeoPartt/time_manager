import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/dashboard/get_user_report.dart';
import 'package:time_manager/domain/usecases/dashboard/get_team_report.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetUserReport getUserReportUseCase;
  final GetTeamReport getTeamReportUseCase;

  DashboardCubit({
    required this.getUserReportUseCase,
    required this.getTeamReportUseCase,
  }) : super(const DashboardState.initial());

  /// 📊 Charge le rapport utilisateur
  Future<void> loadUserReport(BuildContext context, int userId) async {
    final tr = AppLocalizations.of(context)!;
    emit(const DashboardState.loading());
    
    try {
      final report = await getUserReportUseCase(userId);
      emit(DashboardState.loaded(report));
    } catch (e) {
      emit(DashboardState.error('${tr.error}: $e'));
    }
  }

  /// 👥 Charge le rapport équipe
  Future<void> loadTeamReport(BuildContext context, int teamId) async {
    final tr = AppLocalizations.of(context)!;
    emit(const DashboardState.loading());
    
    try {
      final report = await getTeamReportUseCase(teamId);
      emit(DashboardState.loaded(report));
    } catch (e) {
      emit(DashboardState.error('${tr.error}: $e'));
    }
  }
}