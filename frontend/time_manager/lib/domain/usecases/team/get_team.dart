import 'package:time_manager/domain/entities/team.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class GetTeamById {
  final TeamRepository repository;

  GetTeamById(this.repository);

  Future<Team> call(int teamId) {
    return repository.getTeam(teamId);
  }
}
