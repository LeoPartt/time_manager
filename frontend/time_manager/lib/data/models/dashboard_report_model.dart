// 📁 lib/data/models/dashboard_report_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';

part 'dashboard_report_model.freezed.dart';
part 'dashboard_report_model.g.dart';

@freezed
abstract class DashboardReportModel with _$DashboardReportModel {
  const DashboardReportModel._();

  const factory DashboardReportModel({
    @JsonKey(name: 'WorkAverageWeekly') required double workAverageWeekly,
    @JsonKey(name: 'WorkAverageMonthly') required double workAverageMonthly,
    @JsonKey(name: 'PunctualityRate') required double punctualityRate,
    @JsonKey(name: 'AttendanceRate') required double attendanceRate,
  }) = _DashboardReportModel;

  factory DashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportModelFromJson(json);

  // ✅ Conversion vers Entity
  DashboardReport toEntity() {
    return DashboardReport(
      workAverageWeekly: workAverageWeekly,
      workAverageMonthly: workAverageMonthly,
      punctualityRate: punctualityRate,
      attendanceRate: attendanceRate,
    );
  }
}