import 'package:time_manager/domain/entities/user/user.dart';

abstract class AccountRepository {
  Future<User> login(String username, String password);
  Future<User> register(String username, String email, String password);
  Future<void> logout();
  

}
