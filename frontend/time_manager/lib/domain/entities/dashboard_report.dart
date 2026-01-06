import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_report.freezed.dart';

@freezed
abstract class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    required double workAverageWeekly,
    required double workAverageMonthly,
    required double punctualityRate,
    required double attendanceRate,
  }) = _DashboardReport;
}