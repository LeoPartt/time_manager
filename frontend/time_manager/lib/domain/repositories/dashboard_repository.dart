import 'package:time_manager/domain/entities/dashboard_report.dart';

abstract class DashboardRepository {
  Future<DashboardReport> getGlobalReport();
  Future<DashboardReport> getUserReport(int userId);
  Future<DashboardReport> getTeamReport(int teamId);
}