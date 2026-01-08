
abstract class ClockRepository {
  Future<void> clockIn(DateTime timestamp);
  Future<void> clockOut(DateTime timestamp);
 // Future<Clock?> getClockStatus();
}
