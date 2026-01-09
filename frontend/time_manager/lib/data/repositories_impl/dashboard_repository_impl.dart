import 'package:time_manager/data/datasources/remote/dashboard_api.dart';
import 'package:time_manager/data/models/dashboard_report_model.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApi api;

  DashboardRepositoryImpl({required this.api});

  @override
  Future<UserDashboardReport> getUserDashboard({
    required int userId,
    required String mode,
    DateTime? at,
  }) async {
    try {
      final json = await api.getUserDashboard(
        userId: userId,
        mode: mode,
        at: at,
      );

      print('📦 [DashboardRepository] User JSON: $json');

      final model = UserDashboardReportModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      print('🔴 [DashboardRepository] User error: $e');
      rethrow;
    }
  }

  @override
  Future<TeamDashboardReport> getTeamDashboard({
    required int teamId,
    required String mode,
    DateTime? at,
  }) async {
    try {
      final json = await api.getTeamDashboard(
        teamId: teamId,
        mode: mode,
        at: at,
      );

      print('📦 [DashboardRepository] Team JSON: $json');

      final model = TeamDashboardReportModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      print('🔴 [DashboardRepository] Team error: $e');
      rethrow;
    }
  }

  @override
  Future<GlobalDashboardReport> getGlobalDashboard({
    required String mode,
    DateTime? at,
  }) async {
    try {
      final json = await api.getGlobalDashboard(
        mode: mode,
        at: at,
      );

      print('📦 [DashboardRepository] Global JSON: $json');

      final model = GlobalDashboardReportModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      print('🔴 [DashboardRepository] Global error: $e');
      rethrow;
    }
  }
}