import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class CreateTeam {
  final TeamRepository repository;
  CreateTeam(this.repository);

  Future<Team> call({required String name,required String description}) async {
    return await repository.createTeam(name: name, description: description);
  }
}
