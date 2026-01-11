
import 'package:time_manager/domain/entities/schedule/schedule.dart';

abstract class ClockRepository {
  Future<void> clockIn(DateTime timestamp);
  Future<void> clockOut(DateTime timestamp);
  Future<Clock?> getClockStatus(int userId);
  Future<List<int>> getUserClocks({
    required int userId,
    DateTime? from,
    DateTime? to,
    bool? current,
  });
 // Future<Clock?> getClockStatus();
}
