import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class GetTeamMembers {
  final TeamRepository repository;

  GetTeamMembers(this.repository);

  Future<List<User>> call(int teamId) async {
    return await repository.getMembers(teamId);
  }
}
