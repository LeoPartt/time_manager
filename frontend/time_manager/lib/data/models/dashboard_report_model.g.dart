// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardReportModel _$DashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _DashboardReportModel(
  workAverageWeekly: (json['WorkAverageWeekly'] as num).toDouble(),
  workAverageMonthly: (json['WorkAverageMonthly'] as num).toDouble(),
  punctualityRate: (json['PunctualityRate'] as num).toDouble(),
  attendanceRate: (json['AttendanceRate'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardReportModelToJson(
  _DashboardReportModel instance,
) => <String, dynamic>{
  'WorkAverageWeekly': instance.workAverageWeekly,
  'WorkAverageMonthly': instance.workAverageMonthly,
  'PunctualityRate': instance.punctualityRate,
  'AttendanceRate': instance.attendanceRate,
};
