import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';

part 'dashboard_report_model.freezed.dart';
part 'dashboard_report_model.g.dart';

@freezed
abstract class DateRangeModel with _$DateRangeModel {
  const DateRangeModel._();

  const factory DateRangeModel({
    required DateTime from,
    required DateTime to,
  }) = _DateRangeModel;

  factory DateRangeModel.fromJson(Map<String, dynamic> json) =>
      _$DateRangeModelFromJson(json);

  DateRange toEntity() => DateRange(from: from, to: to);
}

@freezed
abstract class PercentKpiModel with _$PercentKpiModel {
  const PercentKpiModel._();

  const factory PercentKpiModel({
    required double percent,
  }) = _PercentKpiModel;

  factory PercentKpiModel.fromJson(Map<String, dynamic> json) =>
      _$PercentKpiModelFromJson(json);

  PercentKpi toEntity() => PercentKpi(percent: percent);
}

@freezed
abstract class WorkPointModel with _$WorkPointModel {
  const WorkPointModel._();

  const factory WorkPointModel({
    required String label,
    required DateTime start,
    required double value,
  }) = _WorkPointModel;

  factory WorkPointModel.fromJson(Map<String, dynamic> json) =>
      _$WorkPointModelFromJson(json);

  WorkPoint toEntity() => WorkPoint(label: label, start: start, value: value);
}

@freezed
abstract class WorkSeriesModel with _$WorkSeriesModel {
  const WorkSeriesModel._();

  const factory WorkSeriesModel({
    required String unit,
    required WorkBucket bucket,
    required List<WorkPointModel> series,
    required double average,
  }) = _WorkSeriesModel;

  factory WorkSeriesModel.fromJson(Map<String, dynamic> json) =>
      _$WorkSeriesModelFromJson(json);

  WorkSeries toEntity() => WorkSeries(
        unit: unit,
        bucket: bucket,
        series: series.map((e) => e.toEntity()).toList(),
        average: average,
      );
}

@freezed
abstract class DashboardReportModel with _$DashboardReportModel {
  const DashboardReportModel._();

  const factory DashboardReportModel({
    required ReportMode mode,
    required DateRangeModel range,
    required PercentKpiModel punctuality,
    required PercentKpiModel attendance,
    required WorkSeriesModel work,
  }) = _DashboardReportModel;

  factory DashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardReportModelFromJson(json);

  DashboardReport toEntity() => DashboardReport(
        mode: mode,
        range: range.toEntity(),
        punctuality: punctuality.toEntity(),
        attendance: attendance.toEntity(),
        work: work.toEntity(),
      );
}

@freezed
abstract class UserDashboardReportModel with _$UserDashboardReportModel {
  const UserDashboardReportModel._();

  const factory UserDashboardReportModel({
    required int userId,
    required DashboardReportModel dashboard,
  }) = _UserDashboardReportModel;

  factory UserDashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$UserDashboardReportModelFromJson(json);

  UserDashboardReport toEntity() => UserDashboardReport(
        userId: userId,
        dashboard: dashboard.toEntity(),
      );
}

@freezed
abstract class TeamDashboardReportModel with _$TeamDashboardReportModel {
  const TeamDashboardReportModel._();

  const factory TeamDashboardReportModel({
    required int teamId,
    required DashboardReportModel dashboard,
  }) = _TeamDashboardReportModel;

  factory TeamDashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$TeamDashboardReportModelFromJson(json);

  TeamDashboardReport toEntity() => TeamDashboardReport(
        teamId: teamId,
        dashboard: dashboard.toEntity(),
      );
}

@freezed
abstract class GlobalDashboardReportModel with _$GlobalDashboardReportModel {
  const GlobalDashboardReportModel._();

  const factory GlobalDashboardReportModel({
    required DashboardReportModel dashboard,
  }) = _GlobalDashboardReportModel;

  factory GlobalDashboardReportModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalDashboardReportModelFromJson(json);

  GlobalDashboardReport toEntity() => GlobalDashboardReport(
        dashboard: dashboard.toEntity(),
      );
}