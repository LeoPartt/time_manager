import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

part 'update_user_profile.freezed.dart';

@freezed
abstract class UpdateUserProfileParams with _$UpdateUserProfileParams {
  const factory UpdateUserProfileParams({
    required int id,
    String? username,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
    String? firstName,
    String? lastName,
  }) = _UpdateUserProfileParams;
}

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<User> call(UpdateUserProfileParams params) =>
      repository.updateUserProfile(params);
}
