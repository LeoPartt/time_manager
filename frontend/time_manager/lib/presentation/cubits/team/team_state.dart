import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/team/team.dart';

part 'team_state.freezed.dart';

@freezed
class TeamState with _$TeamState {
  const factory TeamState.initial() = TeamInitial;
  const factory TeamState.loading() = TeamLoading;
  const factory TeamState.loaded(Team team, int? managerId) = TeamLoaded;
  const factory TeamState.loadedTeams(List<Team> teams) = TeamsLoaded;
  const factory TeamState.error(String message) = TeamError;
}