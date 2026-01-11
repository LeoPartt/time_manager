import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

class GetUser {
  final UserRepository repo;
  GetUser(this.repo);

  Future<User> call(int id) => repo.getUser(id);
}
