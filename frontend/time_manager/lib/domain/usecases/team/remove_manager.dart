import 'package:time_manager/domain/repositories/team_repository.dart';

class RemoveManager {
  final TeamRepository repository;

  RemoveManager(this.repository);

  Future<void> call(int teamId) async {
    return repository.removeManager(teamId);
  }
}
