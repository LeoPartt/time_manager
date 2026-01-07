import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/user.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
abstract class Team with _$Team {
  const factory Team({
    required int id,
    required String name,
    String? description,
    @JsonKey(fromJson: _usersFromJson, toJson: _usersToJson)
    @Default([]) List<User> members,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

List<User> _usersFromJson(List<dynamic>? list) {
  if (list == null) return [];
  return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>> _usersToJson(List<User>? list) {
  if (list == null) return [];
  return list.map((u) => u.toJson()).toList();
}
