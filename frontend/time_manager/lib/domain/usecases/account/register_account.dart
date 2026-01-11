import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/account_repository.dart';

class RegisterUser {
  final AccountRepository repository;
  RegisterUser(this.repository);

  Future<User> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
