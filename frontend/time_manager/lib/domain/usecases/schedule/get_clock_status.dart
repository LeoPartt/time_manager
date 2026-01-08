
import 'package:time_manager/domain/entities/schedule.dart';
import 'package:time_manager/domain/repositories/schedule_repository.dart';

class GetClockStatus {
  final ClockRepository repository;
  GetClockStatus(this.repository);

  Future<Clock?> call(int userId) => repository.getClockStatus( userId);
}
