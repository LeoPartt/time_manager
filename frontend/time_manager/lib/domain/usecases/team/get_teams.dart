import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class GetTeams {
  final TeamRepository repository;

  GetTeams(this.repository);

  Future<List<Team>> call() async {
    return await repository.getTeams();
  }
}
