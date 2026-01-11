// 📁 lib/domain/entities/daily_work.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_work.freezed.dart';

enum WorkStatus {
  completed,
  inProgress,
}

enum DayStatus {
  completed,
  inProgress,
  absent,
}

@freezed
abstract class PlannedSchedule with _$PlannedSchedule {
  const factory PlannedSchedule({
    required String startTime,
    required String endTime,
    required double totalHours,
  }) = _PlannedSchedule;
}

@freezed
abstract class WorkPeriod with _$WorkPeriod {
  const factory WorkPeriod({
    required DateTime clockIn,
    DateTime? clockOut,
    required double durationHours,
    required WorkStatus status,
  }) = _WorkPeriod;
}

@freezed
abstract class WorkSummary with _$WorkSummary {
  const factory WorkSummary({
    required double totalHours,
    required int periodCount,
    double? varianceHours,
    required DayStatus dayStatus,
  }) = _WorkSummary;
}

@freezed
abstract class DailyWork with _$DailyWork {
  const factory DailyWork({
    required DateTime date,
    required int dayOfWeek,
    PlannedSchedule? planned,
    required List<WorkPeriod> workPeriods,
    required WorkSummary summary,
  }) = _DailyWork;
}