// 📁 lib/data/datasources/remote/dashboard_api.dart

import 'package:time_manager/core/constants/api_endpoints.dart';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';

/// Gère les requêtes HTTP liées aux rapports (dashboard, KPIs)
class DashboardApi {
  final ApiClient client;

  DashboardApi(this.client);

  /// 📊 Récupère le rapport global de l'entreprise
  Future<Map<String, dynamic>> getGlobalReport() async {
    try {
      return await client.get(ApiEndpoints.globalReport);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching global report: $e');
    }
  }

  /// 👤 Récupère le rapport d'un utilisateur spécifique
  Future<Map<String, dynamic>> getUserReport(int userId) async {
    try {
      return await client.get(ApiEndpoints.userReport(userId));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching user report: $e');
    }
  }

  /// 👥 Récupère le rapport d'une équipe
  Future<Map<String, dynamic>> getTeamReport(int teamId) async {
    try {
      return await client.get(ApiEndpoints.teamReport(teamId));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching team report: $e');
    }
  }
}