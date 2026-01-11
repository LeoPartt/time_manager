import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';

import 'package:time_manager/domain/repositories/planning_repository.dart';
import 'package:time_manager/domain/repositories/schedule_repository.dart';

class GetDailyWork {
  final ClockRepository clockRepository;
  final PlanningRepository planningRepository;

  GetDailyWork({
    required this.clockRepository,
    required this.planningRepository,
  });

  Future<DailyWork> call({
    required int userId,
    required DateTime date,
  }) async {
    // 1. Récupérer le planning pour ce jour de la semaine
    final plannings = await planningRepository.getUserPlannings(userId);
    final dayOfWeek = date.weekday - 1; // 0=Monday

    Planning? planning;
    PlannedSchedule? planned;

    try {
      planning = plannings.firstWhere((p) => p.weekDay == dayOfWeek);
      planned = PlannedSchedule(
        startTime: planning.startTime,
        endTime: planning.endTime,
        totalHours: _calculatePlannedHours(planning.startTime, planning.endTime),
      );
    } catch (e) {
      // Pas de planning pour ce jour
      planned = null;
    }

    // 2. Récupérer les clocks de cette journée
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final clockTimestamps = await clockRepository.getUserClocks(
      userId: userId,
      from: startOfDay,
      to: endOfDay,
    );

    // 3. Convertir les timestamps en WorkPeriods
    final workPeriods = _convertToWorkPeriods(clockTimestamps);

    // 4. Calculer le résumé
    final summary = _calculateSummary(workPeriods, planned);

    return DailyWork(
      date: date,
      dayOfWeek: dayOfWeek,
      planned: planned,
      workPeriods: workPeriods,
      summary: summary,
    );
  }

  /// Calcule les heures planifiées
  double _calculatePlannedHours(String startTime, String endTime) {
    try {
      final start = _parseTime(startTime);
      final end = _parseTime(endTime);

      final duration = end.difference(start);
      return duration.inMinutes / 60.0;
    } catch (e) {
      return 0;
    }
  }

  /// Parse un string time "HH:mm" en DateTime
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  List<WorkPeriod> _convertToWorkPeriods(List<int> timestamps) {
  final periods = <WorkPeriod>[];

  // ✅ CORRECTION: timestamps sont en SECONDES, pas millisecondes
  for (int i = 0; i < timestamps.length; i += 2) {
    final clockInTs = timestamps[i];
    final clockIn = DateTime.fromMillisecondsSinceEpoch(
      clockInTs * 1000, // ✅ Multiplier par 1000
      isUtc: true,
    );

    DateTime? clockOut;
    double durationHours = 0;
    WorkStatus status = WorkStatus.inProgress;

    if (i + 1 < timestamps.length) {
      final clockOutTs = timestamps[i + 1];
      clockOut = DateTime.fromMillisecondsSinceEpoch(
        clockOutTs * 1000, // ✅ Multiplier par 1000
        isUtc: true,
      );

      final duration = clockOut.difference(clockIn);
      durationHours = duration.inMinutes / 60.0;
      status = WorkStatus.completed;
    }

    periods.add(WorkPeriod(
      clockIn: clockIn,
      clockOut: clockOut,
      durationHours: durationHours,
      status: status,
    ));
  }

  return periods;
}
  WorkSummary _calculateSummary(
    List<WorkPeriod> workPeriods,
    PlannedSchedule? planned,
  ) {
    final totalHours = workPeriods.fold<double>(
      0,
      (sum, period) => sum + period.durationHours,
    );

    final periodCount = workPeriods.length;

    double? varianceHours;
    if (planned != null && totalHours > 0) {
      varianceHours = totalHours - planned.totalHours;
    }

    DayStatus dayStatus = DayStatus.absent;
    if (workPeriods.isNotEmpty) {
      final anyInProgress = workPeriods.any(
        (p) => p.status == WorkStatus.inProgress,
      );
      dayStatus = anyInProgress ? DayStatus.inProgress : DayStatus.completed;
    }

    return WorkSummary(
      totalHours: totalHours,
      periodCount: periodCount,
      varianceHours: varianceHours,
      dayStatus: dayStatus,
    );
  }
}