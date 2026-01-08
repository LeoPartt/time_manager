import 'dart:convert';
import 'package:time_manager/data/datasources/local/cache_manager.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/data/datasources/remote/user_api.dart';
import 'package:time_manager/data/models/user_model.dart';
import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi api;
  final LocalStorageService storage;
    final CacheManager cache;


static const String _cacheKeyProfile = 'cached_user_profile';
  static const String _cacheKeyUsers = 'cached_user_list';


  UserRepositoryImpl({
    required this.api,
    required this.storage,
        required this.cache,

  });


  @override
  Future<User> getUserProfile() async {
    try {
          final data = await api.getProfile();
    final dto = UserModel.fromJson(data);
         await cache.save(_cacheKeyProfile, dto.toJson(), ttlSeconds: 1800); // 30min

    await storage.saveUser(jsonEncode(dto.toJson()));
    return dto.toDomain();
    } catch (e) {
      final cached = await cache.get(_cacheKeyProfile);
      if (cached != null) {
        return UserModel.fromJson(cached).toDomain();
      }
      rethrow;
    }
  }

@override
  Future<List<User>> getUsers() async {
    try {
      final list = await api.getUsers();
      final users = list
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>).toDomain())
          .toList();

      await cache.save(
        _cacheKeyUsers,
        {'list': list},
        ttlSeconds: 300, // 5 minutes
      );

      return users;
    } catch (e) {
      final cached = await cache.get(_cacheKeyUsers);
      if (cached != null && cached['list'] != null) {
        return (cached['list'] as List)
            .map((e) => UserModel.fromJson(e).toDomain())
            .toList();
      }
      rethrow;
    }
  

  
  }


  @override
  Future<User> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final res = await api.createUser({
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    });
    final dto = UserModel.fromJson(res);
    await storage.saveUser(jsonEncode(dto.toJson()));
    return dto.toDomain();
  }




  @override
  Future<User> updateUserProfile(UpdateUserProfileParams params) async {
    final body = <String, dynamic>{};
    if (params.username != null) body['username'] = params.username;
    if (params.email != null) body['email'] = params.email;
    if (params.firstName != null) body['firstName'] = params.firstName;
    if (params.phoneNumber != null) body['phoneNumber'] = params.phoneNumber;
    if (params.lastName != null) body['lastName'] = params.lastName;

    final data = await api.updateProfile(params.id, body);
    final dto = UserModel.fromJson(data);

    await cache.save(_cacheKeyProfile, dto.toJson());
    return dto.toDomain();
  }

  @override
  Future<void> deleteUser(int id) async {
    await api.deleteUser(id);
    await cache.remove(_cacheKeyProfile);
    await cache.remove(_cacheKeyUsers);
    await storage.clear();
  }

  @override
  Future<User> getUser(int id) async {
    final response = await api.getUser(id);
    final dto = UserModel.fromJson(response);
    await cache.save('cached_user_$id', dto.toJson(), ttlSeconds: 600);
    return dto.toDomain();
  }
 @override
  Future<User?> getCurrentUser() async {
    final token = await storage.getToken();
    if (token == null || token.isEmpty) return null;

    final userJson = await storage.getUser();
    if (userJson == null || userJson.isEmpty) return null;

    try {
      final dto = UserModel.fromJson(jsonDecode(userJson));
      return dto.toDomain();
    } catch (_) {
      return null;
    }
  }

  
}
