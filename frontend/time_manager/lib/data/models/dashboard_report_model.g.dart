// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardReportModel _$DashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _DashboardReportModel(
  userId: (json['userId'] as num).toInt(),
  workAverages: ReportModel.fromJson(
    json['WorkAverages'] as Map<String, dynamic>,
  ),
  punctualityRates: ReportModel.fromJson(
    json['PunctualityRates'] as Map<String, dynamic>,
  ),
  attendanceRates: ReportModel.fromJson(
    json['AttendanceRates'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DashboardReportModelToJson(
  _DashboardReportModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'WorkAverages': instance.workAverages,
  'PunctualityRates': instance.punctualityRates,
  'AttendanceRates': instance.attendanceRates,
};
