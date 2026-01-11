import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/account_repository.dart';

class LoginUser {
  final AccountRepository repository;
  LoginUser(this.repository);

  Future<User> call(String username, String password) {
    return repository.login(username, password);
  }
}
