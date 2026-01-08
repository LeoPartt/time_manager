import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/data/datasources/remote/dashboard_api.dart';
import 'package:time_manager/data/models/dashboard_report_model.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApi api;
   final LocalStorageService storage;

  DashboardRepositoryImpl({required this.api,required this.storage});

  @override
  Future<DashboardReport> getGlobalReport() async {
    final json = await api.getGlobalReport();
    final model = DashboardReportModel.fromJson(json);
    return model.toEntity();
  }

  @override
  Future<DashboardReport> getUserReport(int userId) async {
    final json = await api.getUserReport(userId);
    final model = DashboardReportModel.fromJson(json);
    return model.toEntity();
  }

  @override
  Future<DashboardReport> getTeamReport(int teamId) async {
    final json = await api.getTeamReport(teamId);
    final model = DashboardReportModel.fromJson(json);
    return model.toEntity();
  }
}