import 'package:time_manager/core/constants/api_endpoints.dart';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';

/// Handles authentication and account-related HTTP requests.
class AccountApi {
  final ApiClient client;

  AccountApi(this.client);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      return await client.post(ApiEndpoints.login, {
        'username': username,
        'password': password,
      }, withAuth: false);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during login: $e');
    }
  }
 Future<void> changePassword({
    required String code,
    required String password,
  }) async {
    try {
      await client.post(
        ApiEndpoints.changePassword,
        {
          'code': code,
          'password': password,
        },
      );
      
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error changing password: $e');
    }
  }
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      return await client.post(ApiEndpoints.register, {
        'username': username,
        'email': email,
        'password': password,
      }, withAuth: false);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during registration: $e');
    }
  }

  Future<void> logout() async {
    try {
      await client.post(ApiEndpoints.logout, {});
    } on NetworkException {
      rethrow;
    }
  }
}
