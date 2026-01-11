import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/usecases/team/update_team.dart';

abstract class TeamRepository {
  Future<List<Team>> getTeams();
  Future<Team> getTeam(int id);
  Future<Team> createTeam({
    required String name,
    String? description,
  });
  Future<Team> updateTeam(UpdateTeamParams params);
  Future<void> deleteTeam(int id);
  Future<void> addMember(int teamId, int userId);
  Future<void> removeMember(int teamId, int userId);
  Future<List<User>> getMembers(int teamId);
  Future<void> assignManager(int teamId, int userId);
  Future<void> removeManager(int teamId);
  Future<Map<String, dynamic>> getManager(int teamId);
}
