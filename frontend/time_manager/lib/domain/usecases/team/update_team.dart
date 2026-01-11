import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class UpdateTeamParams {
  final int id;
  final String? name;
  final String? description;

  UpdateTeamParams({required this.id, this.name, this.description});
}

class UpdateTeam {
  final TeamRepository repository;
  UpdateTeam(this.repository);

  Future<Team> call(UpdateTeamParams params) async {
    return await repository.updateTeam(params);
  }
}
