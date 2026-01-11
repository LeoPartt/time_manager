import 'dart:convert';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/data/datasources/remote/team_api.dart';
import 'package:time_manager/data/models/team/team_model.dart';
import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';
import 'package:time_manager/domain/usecases/team/update_team.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamApi api;
  final LocalStorageService storage;

  TeamRepositoryImpl({
    required this.api,
    required this.storage,
  });

  @override
  Future<List<Team>> getTeams() async {
    final list = await api.getTeams();
    return list
        .map((e) => TeamModel.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }

  @override
  Future<Team> getTeam(int id) async {
    try {
      final res = await api.getTeam(id);

      final membersRes = await api.getMembers(id);

      final members = membersRes.map<User>((m) => User(
        id: m['id'],
        username: m['username'],
        email: m['email'],
        firstName: m['firstName'],
        lastName: m['lastName'],
        phoneNumber: m['phoneNumber'],
      )).toList();

      return Team(
        id: res['id'],
        name: res['name'],
        description: res['description'] ?? '',
        members: members,
      );
    } catch (e) {
      throw NetworkException('Erreur lors du chargement de la team : $e');
    }
  }


  @override
  Future<Team> createTeam({
    required String name,
    String? description,
  }) async {
    final data = await api.createTeam({
      'name': name,
      'description': description,
    });
    final dto = TeamModel.fromJson(data);
    await storage.saveData('last_team', jsonEncode(dto.toJson()));
    return dto.toDomain();
  }

  @override
  Future<Team> updateTeam(UpdateTeamParams params) async {
    final body = <String, dynamic>{};
    if (params.name != null) body['name'] = params.name;
    if (params.description != null) body['description'] = params.description;

    final data = await api.updateTeam(params.id, body);
    final dto = TeamModel.fromJson(data);
    await storage.saveData('last_team', jsonEncode(dto.toJson()));
    return dto.toDomain();
  }

  @override
  Future<void> deleteTeam(int id) async {
    await api.deleteTeam(id);
    await storage.removeData('last_team');
  }

  @override
  Future<void> addMember(int teamId, int userId) async {
    try {
      await api.addMember(teamId, userId);
    } catch (e) {
      rethrow; 
    }
  }

  @override
  Future<void> removeMember(int teamId, int userId) async {
    await api.removeMember(teamId, userId);
  }

  @override
  Future<List<User>> getMembers(int teamId) async {
    final raw = await api.getMembers(teamId);

    if (raw.isEmpty) return [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList();
  }

  @override
  Future<void> assignManager(int teamId, int userId) async {
    await api.assignManager(teamId, userId);
  }

  @override
  Future<void> removeManager(int teamId) async {
    await api.removeManager(teamId);
  }

  @override
  Future<Map<String, dynamic>> getManager(int teamId) async {
    return await api.getManager(teamId);
  }
}
