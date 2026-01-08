
import 'package:time_manager/domain/repositories/schedule_repository.dart';

class ClockIn {
  final ClockRepository repository;
  ClockIn(this.repository);

  Future<void> call(DateTime timestamp) => repository.clockIn(timestamp);
}
