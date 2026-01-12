import 'package:time_manager/core/constants/api_endpoints.dart';

import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';

/// Provides user-related API operations.
class UserApi {
  final ApiClient client;

  UserApi(this.client);

  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await client.get(ApiEndpoints.userProfile);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching user profile: $e');
    }
  }
  Future<Map<String, dynamic>> updateUser(
  int userId,
  Map<String, dynamic> body,
) async {
  try {
    return await client.patch(ApiEndpoints.userById(userId), body);
  } on NetworkException {
    rethrow;
  } catch (e) {
    throw NetworkException('Unexpected error updating user: $e');
  }
}

  Future<dynamic> getUser(int id) {
    try {
      return client.get(ApiEndpoints.userById(id));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error getting user profile: $e');
    }
  }


  
 Future<List<dynamic>> getUsers() async {
  try {
    final response = await client.get(ApiEndpoints.users);

    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic> &&
        response.containsKey('data') &&
        response['data'] is List) {
      return response['data'] as List<dynamic>;
    }

    throw Exception('Unexpected response format: $response');
  } on NetworkException {
    rethrow;
  } catch (e) {
    throw Exception('Unexpected error getting users: $e');
  }
}


  Future<Map<String, dynamic>> createUser(Map<String, dynamic> body) async {
    //
    try {
      return client.post(ApiEndpoints.users, body);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error creating user: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    int id,
    Map<String, dynamic> body,
  ) async {
    try {
      return await client.patch(ApiEndpoints.userById(id), body);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error updating profile: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await client.delete(ApiEndpoints.userById(id));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error deleting user: $e');
    }
  }
}
