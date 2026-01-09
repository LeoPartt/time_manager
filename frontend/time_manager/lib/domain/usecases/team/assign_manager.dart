import 'package:time_manager/domain/repositories/team_repository.dart';

class AssignManager {
  final TeamRepository repository;

  AssignManager(this.repository);

  Future<void> call({
    required int teamId,
    required int userId,
  }) async {
    return repository.assignManager(teamId, userId);
  }
}
