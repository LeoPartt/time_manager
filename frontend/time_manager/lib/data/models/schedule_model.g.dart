// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClockModel _$ClockModelFromJson(Map<String, dynamic> json) => _ClockModel(
  id: (json['id'] as num?)?.toInt(),
  arrivalTs: json['arrivalTs'] as String,
  departureTs: json['departureTs'] as String?,
);

Map<String, dynamic> _$ClockModelToJson(_ClockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arrivalTs': instance.arrivalTs,
      'departureTs': instance.departureTs,
    };
