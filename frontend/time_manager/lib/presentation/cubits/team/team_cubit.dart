import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/team/add_member_to_team.dart';
import 'package:time_manager/domain/usecases/team/create_team.dart';
import 'package:time_manager/domain/usecases/team/delete_team.dart';
import 'package:time_manager/domain/usecases/team/get_team.dart';
import 'package:time_manager/domain/usecases/team/get_team_members.dart';
import 'package:time_manager/domain/usecases/team/get_teams.dart';
import 'package:time_manager/domain/usecases/team/remove_member_from_team.dart';
import 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final CreateTeam createTeamUseCase;
  final GetTeams getTeamsUseCase;
  final AddMemberToTeam addMemberToTeamUseCase;
  final RemoveMemberFromTeam removeMemberFromTeamUseCase;
  final GetTeamById getTeamByIdUseCase;
  final GetTeamMembers getTeamMembersUseCase;
  final DeleteTeam deleteTeamUseCase;



  TeamCubit({required this.createTeamUseCase, required this.getTeamsUseCase, required this.getTeamByIdUseCase, required this.addMemberToTeamUseCase, required this.removeMemberFromTeamUseCase, required this.getTeamMembersUseCase, required this.deleteTeamUseCase}) : super(const TeamState.initial());

  Future<void> createTeam({required String name, required String description}) async {
    emit(const TeamState.loading());
    try {
      final team = await createTeamUseCase(name: name, description: description);
      emit(TeamState.loaded(team));
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }

  Future<void> getTeams() async {
    emit(const TeamState.loading());
    try {
      final teams = await getTeamsUseCase();
      emit(TeamState.loadedTeams(teams));
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }

  Future<void> getTeam(int id) async {
    emit(const TeamState.loading());

    try {
      final team = await getTeamByIdUseCase(id);
      final members = await getTeamMembersUseCase(id);

      emit(TeamState.loaded(
        team.copyWith(members: members),
      ));
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }

  Future<void> addMember(int teamId, int userId) async {
    final current = state;
    if (current is! TeamLoaded) return;

    try {
      await addMemberToTeamUseCase(teamId, userId);

      final members = await getTeamMembersUseCase(teamId);

      emit(TeamState.loaded(
        current.team.copyWith(members: members),
      ));
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }

  Future<void> removeMember(int teamId, int userId) async {
    final current = state;
    if (current is! TeamLoaded) return;

    try {
      await removeMemberFromTeamUseCase(teamId, userId);

      final members = await getTeamMembersUseCase(teamId);

      emit(TeamState.loaded(
        current.team.copyWith(members: members),
      ));
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }

  Future<void> deleteTeam(int teamId) async {
    emit(const TeamState.loading());

    try {
      await deleteTeamUseCase(teamId);

      emit(const TeamState.initial());
    } catch (e) {
      emit(TeamState.error(e.toString()));
    }
  }
}
