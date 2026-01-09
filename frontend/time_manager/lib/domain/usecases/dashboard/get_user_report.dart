import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/repositories/dashboard_repository.dart';

class GetUserDashboard {
  final DashboardRepository repository;

  GetUserDashboard(this.repository);

  Future<UserDashboardReport> call({
    required int userId,
    required String mode,
    DateTime? at,
  }) async {
    return await repository.getUserDashboard(
      userId: userId,
      mode: mode,
      at: at,
    );
  }
}