import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class GetUserReport {
  final DashboardRepository repository;

  GetUserReport(this.repository);

  Future<DashboardReport> call(int userId) async {
    return await repository.getUserReport(userId);
  }
}