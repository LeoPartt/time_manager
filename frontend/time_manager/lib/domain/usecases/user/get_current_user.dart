import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';

class GetCurrentUser {
  final UserRepository _repo;
  GetCurrentUser(this._repo);

  Future<User?> call() => _repo.getCurrentUser();
}
