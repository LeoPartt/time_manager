import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/data/models/report_model.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/domain/entities/report.dart';

part 'dashboard_report_model.freezed.dart';
part 'dashboard_report_model.g.dart';

@freezed
abstract class DashboardReportModel with _$DashboardReportModel {
  const DashboardReportModel._();

  const factory DashboardReportModel({
    required int userId,
    @JsonKey(name: 'WorkAverages') required ReportModel workAverages,
    @JsonKey(name: 'PunctualityRates') required ReportModel punctualityRates,
    @JsonKey(name: 'AttendanceRates') required ReportModel attendanceRates,
  }) = _DashboardReportModel;

  factory DashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportModelFromJson(json);

  // Conversion vers Entity
  DashboardReport toEntity() {
    return DashboardReport(
      userId: userId,
      workAverages: Report(
        weekly: workAverages.weekly,
        monthly: workAverages.monthly,
        yearly: workAverages.yearly,
      ),
      punctualityRates: Report(
        weekly: punctualityRates.weekly,
        monthly: punctualityRates.monthly,
        yearly: punctualityRates.yearly,
      ),
      attendanceRates: Report(
        weekly: attendanceRates.weekly,
        monthly: attendanceRates.monthly,
        yearly: attendanceRates.yearly,
      ),
    );
  }
}
