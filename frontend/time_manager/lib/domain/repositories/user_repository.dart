import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';

abstract class UserRepository {
  Future<User> getUser(int id);
  Future<List<User>> getUsers();
    Future<User?> getCurrentUser();

  Future<User> getUserProfile();
  Future<User> updateUserProfile(UpdateUserProfileParams params);
  Future<void> deleteUser(int id);
  Future<User> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  });
}
