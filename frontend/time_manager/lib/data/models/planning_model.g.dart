// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planning_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanningModel _$PlanningModelFromJson(Map<String, dynamic> json) =>
    _PlanningModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      weekDay: (json['weekDay'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$PlanningModelToJson(_PlanningModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weekDay': instance.weekDay,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
