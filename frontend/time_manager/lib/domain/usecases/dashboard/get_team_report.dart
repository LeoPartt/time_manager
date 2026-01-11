import 'package:time_manager/domain/entities/dashboard/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class GetTeamDashboard {
  final DashboardRepository repository;

  GetTeamDashboard(this.repository);

  Future<TeamDashboardReport> call({
    required int teamId,
    required String mode,
    DateTime? at,
  }) async {
    return await repository.getTeamDashboard(
      teamId: teamId,
      mode: mode,
      at: at,
    );
  }
}