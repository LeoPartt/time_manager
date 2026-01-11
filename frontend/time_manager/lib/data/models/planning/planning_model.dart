

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';

part 'planning_model.freezed.dart';
part 'planning_model.g.dart';

@freezed
abstract class PlanningModel with _$PlanningModel {
  const PlanningModel._();

  const factory PlanningModel({
    required int id,
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) = _PlanningModel;

  factory PlanningModel.fromJson(Map<String, dynamic> json) =>
      _$PlanningModelFromJson(json);

  // Conversion vers Entity
  Planning toEntity() {
    return Planning(
      id: id,
      userId: userId,
      weekDay: weekDay,
      startTime: startTime,
      endTime: endTime,
    );
  }
}