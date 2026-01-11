import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repo;
  GetUsers(this.repo);

  Future<List<User>> call() => repo.getUsers();
}
