
import 'package:time_manager/domain/entities/schedule.dart';

abstract class ClockRepository {
  Future<void> clockIn(DateTime timestamp);
  Future<void> clockOut(DateTime timestamp);
  Future<Clock?> getClockStatus();
 // Future<Clock?> getClockStatus();
}
