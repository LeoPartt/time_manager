import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_report.freezed.dart';

enum ReportMode {
  @JsonValue('W')
  week,
  @JsonValue('M')
  month,
  @JsonValue('Y')
  year,
}

enum WorkBucket {
  @JsonValue('DAY')
  day,
  @JsonValue('WEEK')
  week,
  @JsonValue('MONTH')
  month,
}

@freezed
abstract class DateRange with _$DateRange {
  const factory DateRange({
    required DateTime from,
    required DateTime to,
  }) = _DateRange;
}

@freezed
abstract class PercentKpi with _$PercentKpi {
  const factory PercentKpi({
    required double percent,
  }) = _PercentKpi;
}

@freezed
abstract class WorkPoint with _$WorkPoint {
  const factory WorkPoint({
    required String label,
    required DateTime start,
    required double value,
  }) = _WorkPoint;
}

@freezed
abstract class WorkSeries with _$WorkSeries {
  const factory WorkSeries({
    required String unit,
    required WorkBucket bucket,
    required List<WorkPoint> series,
    required double average,
  }) = _WorkSeries;
}

@freezed
abstract class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    required ReportMode mode,
    required DateRange range,
    required PercentKpi punctuality,
    required PercentKpi attendance,
    required WorkSeries work,
  }) = _DashboardReport;
}

@freezed
abstract class UserDashboardReport with _$UserDashboardReport {
  const factory UserDashboardReport({
    required int userId,
    required DashboardReport dashboard,
  }) = _UserDashboardReport;
}

@freezed
abstract class TeamDashboardReport with _$TeamDashboardReport {
  const factory TeamDashboardReport({
    required int teamId,
    required DashboardReport dashboard,
  }) = _TeamDashboardReport;
}

@freezed
abstract class GlobalDashboardReport with _$GlobalDashboardReport {
  const factory GlobalDashboardReport({
    required DashboardReport dashboard,
  }) = _GlobalDashboardReport;
}