import 'package:time_manager/domain/repositories/team_repository.dart';

class DeleteTeam {
  final TeamRepository repository;

  DeleteTeam(this.repository);

  Future<void> call(int teamId) async {
    return repository.deleteTeam(teamId);
  }
}
