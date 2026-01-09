import 'package:time_manager/core/constants/api_endpoints.dart';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';

class DashboardApi {
  final ApiClient client;

  DashboardApi(this.client);

  /// 📊 Récupère le dashboard d'un utilisateur
  Future<Map<String, dynamic>> getUserDashboard({
    required int userId,
    required String mode,
    DateTime? at,
  }) async {
    try {
      final queryParams = <String, String>{
        'mode': mode,
        if (at != null) 'at': at.toIso8601String(),
      };

      final url = '${ApiEndpoints.userDashboard(userId)}?${_buildQueryString(queryParams)}';
      print('🔵 [DashboardApi] Fetching user dashboard: $url');

      final response = await client.get(url);

      print('🟢 [DashboardApi] User dashboard response: $response');

      if (response is Map<String, dynamic>) {
        return response;
      }

      throw NetworkException('Invalid response format for user dashboard');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching user dashboard: $e');
    }
  }

  /// 📊 Récupère le dashboard d'une équipe
  Future<Map<String, dynamic>> getTeamDashboard({
    required int teamId,
    required String mode,
    DateTime? at,
  }) async {
    try {
      final queryParams = <String, String>{
        'mode': mode,
        if (at != null) 'at': at.toIso8601String(),
      };

      final url = '${ApiEndpoints.teamDashboard(teamId)}?${_buildQueryString(queryParams)}';
      print('🔵 [DashboardApi] Fetching team dashboard: $url');

      final response = await client.get(url);

      print('🟢 [DashboardApi] Team dashboard response: $response');

      if (response is Map<String, dynamic>) {
        return response;
      }

      throw NetworkException('Invalid response format for team dashboard');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching team dashboard: $e');
    }
  }

  /// 📊 Récupère le dashboard global
  Future<Map<String, dynamic>> getGlobalDashboard({
    required String mode,
    DateTime? at,
  }) async {
    try {
      final queryParams = <String, String>{
        'mode': mode,
        if (at != null) 'at': at.toIso8601String(),
      };

      final url = '${ApiEndpoints.globalDashboard}?${_buildQueryString(queryParams)}';
      print('🔵 [DashboardApi] Fetching global dashboard: $url');

      final response = await client.get(url);

      print('🟢 [DashboardApi] Global dashboard response: $response');

      if (response is Map<String, dynamic>) {
        return response;
      }

      throw NetworkException('Invalid response format for global dashboard');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching global dashboard: $e');
    }
  }

  String _buildQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}