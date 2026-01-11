import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;
  CreateUser(this.repository);

  Future<User> call({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    return repository.createUser(
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
