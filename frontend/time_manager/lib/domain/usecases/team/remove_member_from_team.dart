import 'package:time_manager/domain/repositories/team_repository.dart';

class RemoveMemberFromTeam {
  final TeamRepository repository;
  RemoveMemberFromTeam(this.repository);

  Future<void> call(int teamId, int userId) {
    return repository.removeMember(teamId, userId);
  }
}
