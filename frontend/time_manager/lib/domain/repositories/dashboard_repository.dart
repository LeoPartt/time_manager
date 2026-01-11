import 'package:time_manager/domain/entities/dashboard/dashboard_report.dart';

abstract class DashboardRepository {
  Future<UserDashboardReport> getUserDashboard({
    required int userId,
    required String mode,
    DateTime? at,
  });

  Future<TeamDashboardReport> getTeamDashboard({
    required int teamId,
    required String mode,
    DateTime? at,
  });

  Future<GlobalDashboardReport> getGlobalDashboard({
    required String mode,
    DateTime? at,
  });
}