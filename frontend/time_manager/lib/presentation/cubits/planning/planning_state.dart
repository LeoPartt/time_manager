import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';

part 'planning_state.freezed.dart';

@freezed
class PlanningState with _$PlanningState {
  const factory PlanningState.initial() = Initial;
  const factory PlanningState.loading() = Loading;
  const factory PlanningState.loaded(List<Planning> plannings) = Loaded;
  const factory PlanningState.error(String message) = Error;
}