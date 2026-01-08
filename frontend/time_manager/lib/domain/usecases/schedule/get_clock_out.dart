


import 'package:time_manager/domain/repositories/schedule_repository.dart';

class ClockOut {
  final ClockRepository repository;
  ClockOut(this.repository);

  Future<void> call(DateTime timestamp) => repository.clockOut(timestamp);
}
