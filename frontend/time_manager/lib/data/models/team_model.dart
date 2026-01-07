import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/team.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

@freezed
abstract class TeamModel with _$TeamModel {
  const factory TeamModel({
    required int id,
    required String name,
    String? description,
  }) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  const TeamModel._();

  Team toDomain() => Team(
        id: id,
        name: name,
        description: description,
      );
}
