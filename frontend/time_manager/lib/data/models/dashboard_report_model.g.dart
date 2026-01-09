// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateRangeModel _$DateRangeModelFromJson(Map<String, dynamic> json) =>
    _DateRangeModel(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$DateRangeModelToJson(_DateRangeModel instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
    };

_PercentKpiModel _$PercentKpiModelFromJson(Map<String, dynamic> json) =>
    _PercentKpiModel(percent: (json['percent'] as num).toDouble());

Map<String, dynamic> _$PercentKpiModelToJson(_PercentKpiModel instance) =>
    <String, dynamic>{'percent': instance.percent};

_WorkPointModel _$WorkPointModelFromJson(Map<String, dynamic> json) =>
    _WorkPointModel(
      label: json['label'] as String,
      start: DateTime.parse(json['start'] as String),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkPointModelToJson(_WorkPointModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'start': instance.start.toIso8601String(),
      'value': instance.value,
    };

_WorkSeriesModel _$WorkSeriesModelFromJson(Map<String, dynamic> json) =>
    _WorkSeriesModel(
      unit: json['unit'] as String,
      bucket: $enumDecode(_$WorkBucketEnumMap, json['bucket']),
      series: (json['series'] as List<dynamic>)
          .map((e) => WorkPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      average: (json['average'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkSeriesModelToJson(_WorkSeriesModel instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'bucket': _$WorkBucketEnumMap[instance.bucket]!,
      'series': instance.series,
      'average': instance.average,
    };

const _$WorkBucketEnumMap = {
  WorkBucket.day: 'DAY',
  WorkBucket.week: 'WEEK',
  WorkBucket.month: 'MONTH',
};

_DashboardReportModel _$DashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _DashboardReportModel(
  mode: $enumDecode(_$ReportModeEnumMap, json['mode']),
  range: DateRangeModel.fromJson(json['range'] as Map<String, dynamic>),
  punctuality: PercentKpiModel.fromJson(
    json['punctuality'] as Map<String, dynamic>,
  ),
  attendance: PercentKpiModel.fromJson(
    json['attendance'] as Map<String, dynamic>,
  ),
  work: WorkSeriesModel.fromJson(json['work'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardReportModelToJson(
  _DashboardReportModel instance,
) => <String, dynamic>{
  'mode': _$ReportModeEnumMap[instance.mode]!,
  'range': instance.range,
  'punctuality': instance.punctuality,
  'attendance': instance.attendance,
  'work': instance.work,
};

const _$ReportModeEnumMap = {
  ReportMode.week: 'W',
  ReportMode.month: 'M',
  ReportMode.year: 'Y',
};

_UserDashboardReportModel _$UserDashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _UserDashboardReportModel(
  userId: (json['userId'] as num).toInt(),
  dashboard: DashboardReportModel.fromJson(
    json['dashboard'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserDashboardReportModelToJson(
  _UserDashboardReportModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'dashboard': instance.dashboard,
};

_TeamDashboardReportModel _$TeamDashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _TeamDashboardReportModel(
  teamId: (json['teamId'] as num).toInt(),
  dashboard: DashboardReportModel.fromJson(
    json['dashboard'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TeamDashboardReportModelToJson(
  _TeamDashboardReportModel instance,
) => <String, dynamic>{
  'teamId': instance.teamId,
  'dashboard': instance.dashboard,
};

_GlobalDashboardReportModel _$GlobalDashboardReportModelFromJson(
  Map<String, dynamic> json,
) => _GlobalDashboardReportModel(
  dashboard: DashboardReportModel.fromJson(
    json['dashboard'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GlobalDashboardReportModelToJson(
  _GlobalDashboardReportModel instance,
) => <String, dynamic>{'dashboard': instance.dashboard};
