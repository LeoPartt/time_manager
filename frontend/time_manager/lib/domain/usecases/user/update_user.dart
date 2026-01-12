import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<User> call({
    required int userId,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
  }) {
    return repository.updateUser(
      userId: userId,
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}