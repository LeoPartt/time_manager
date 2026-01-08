import 'package:time_manager/core/constants/api_endpoints.dart';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';

class PlanningApi {
  final ApiClient client;

  PlanningApi(this.client);

  /// 📅 Récupère les plannings d'un utilisateur
  Future<List<Map<String, dynamic>>> getUserPlannings(int userId) async {
    try {
      final response = await client.get(ApiEndpoints.userPlannings(userId));
      
      print('🔵 [PlanningApi] Response: $response');
      
      // Le backend retourne un tableau
      if (response is List) {
        return response.map((e) => e as Map<String, dynamic>).toList();
      }
      
      throw NetworkException('Invalid response format for user plannings');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching user plannings: $e');
    }
  }

  /// 📅 Récupère un planning spécifique
  Future<Map<String, dynamic>> getPlanning(int planningId) async {
    try {
      final response = await client.get(ApiEndpoints.planning(planningId));
      
      if (response is Map<String, dynamic>) {
        return response;
      }
      
      throw NetworkException('Invalid response format for planning');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching planning: $e');
    }
  }

  /// 📅 Créer un planning (Manager only)
  Future<Map<String, dynamic>> createPlanning({
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final body = {
        'userId': userId,
        'weekDay': weekDay,
        'startTime': startTime,
        'endTime': endTime,
      };
      
      final response = await client.post(ApiEndpoints.plannings, body);
      
      return response;
          
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error creating planning: $e');
    }
  }

  /// 📅 Mettre à jour un planning (Manager only)
  Future<Map<String, dynamic>> updatePlanning({
    required int planningId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final body = {
        'weekDay': weekDay,
        'startTime': startTime,
        'endTime': endTime,
      };
      
      final response = await client.patch(
        ApiEndpoints.planning(planningId),
        body,
      );
      
      return response;
          
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error updating planning: $e');
    }
  }

  /// 📅 Supprimer un planning (Manager only)
  Future<void> deletePlanning(int planningId) async {
    try {
      await client.delete(ApiEndpoints.planning(planningId));
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error deleting planning: $e');
    }
  }
}