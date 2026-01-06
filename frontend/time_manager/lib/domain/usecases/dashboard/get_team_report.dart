import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class GetTeamReport {
  final DashboardRepository repository;

  GetTeamReport(this.repository);

  Future<DashboardReport> call(int teamId) async {
    return await repository.getTeamReport(teamId);
  }
}