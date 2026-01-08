
import 'package:time_manager/domain/repositories/schedule_repository.dart';

class GetClockStatus {
  final ClockRepository repository;
  GetClockStatus(this.repository);

  Future<void> call(DateTime timestamp) => repository.clockOut(timestamp);
}
