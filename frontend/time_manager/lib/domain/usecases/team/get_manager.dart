import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';

class GetTeamManager {
  final TeamRepository repository;

  GetTeamManager(this.repository);

  Future<User?> call(int teamId) async {
    final raw = await repository.getManager(teamId);

    if (raw.isEmpty) return null;

    return User.fromJson(Map<String, dynamic>.from(raw));
  }
}