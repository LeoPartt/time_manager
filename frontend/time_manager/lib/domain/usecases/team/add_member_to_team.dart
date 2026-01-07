import 'package:time_manager/domain/repositories/team_repository.dart';

class AddMemberToTeam {
  final TeamRepository repository;
  AddMemberToTeam(this.repository);

  Future<void> call(int teamId, int userId) async {
    await repository.addMember(teamId, userId);
  }
}
