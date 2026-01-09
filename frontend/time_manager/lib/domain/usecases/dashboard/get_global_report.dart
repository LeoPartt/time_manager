import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class GetGlobalDashboard {
  final DashboardRepository repository;

  GetGlobalDashboard(this.repository);

  Future<GlobalDashboardReport> call({
    required String mode,
    DateTime? at,
  }) async {
    return await repository.getGlobalDashboard(
      mode: mode,
      at: at,
    );
  }
}