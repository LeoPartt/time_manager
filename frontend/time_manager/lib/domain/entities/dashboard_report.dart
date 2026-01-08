import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/report.dart';

part 'dashboard_report.freezed.dart';

@freezed
abstract class DashboardReport with _$DashboardReport {
  const factory DashboardReport({
    required int userId,
    required Report workAverages,
    required Report punctualityRates,
    required Report attendanceRates,
  }) = _DashboardReport;
}