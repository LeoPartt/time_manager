import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/services/http_client.dart';
import 'package:time_manager/core/constants/api_endpoints.dart';

class ClockApi {
  final ApiClient client;
  ClockApi(this.client);

  Future<void> clockIn(DateTime timestamp) async {
    try {
      
final body = {
        "io": "IN",
        "timestamp": timestamp.toUtc().toIso8601String(), // ✅ converti en UTC ISO8601
      };
       await client.post(ApiEndpoints.schedules, body);
    } on NetworkException {
      rethrow;
    }
  }

  Future<void> clockOut(DateTime timestamp) async {
    try {
final body = {
        "io": "OUT",
        "timestamp": timestamp.toUtc().toIso8601String(), // ✅ converti en UTC ISO8601
      };
       await client.post(ApiEndpoints.schedules, body);
    } on NetworkException {
      rethrow;
    }
  }

   Future<Map<String, dynamic>?> getClockStatus(int userId) async {
    try {
      // ✅ Appel API avec current=true pour récupérer le clock actif
      final response = await client.get(
        ApiEndpoints.userClocks(userId),
        queryParameters: {'current': 'true'},
      );

      // Le backend retourne Long[] (timestamps en secondes)
      final clocks = (response as List).map((e) => e as int).toList();

      if (clocks.isEmpty) {
        return null; // Pas de clock actif
      }

      // ✅ Si nombre impair → dernier est IN, sinon OUT
      final isOdd = clocks.length % 2 == 1;
      final lastTimestamp = DateTime.fromMillisecondsSinceEpoch(
        clocks.last * 1000,
        isUtc: true,
      );

      return {
        'io': isOdd ? 'IN' : 'OUT',
        'timestamp': lastTimestamp.toIso8601String(),
      };
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching clock status: $e');
    }
  }

  Future<dynamic> getUserClocks({
    required int userId,
    DateTime? from,
    DateTime? to,
    bool? current,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (from != null) {
        queryParams['from'] = from.toUtc().toIso8601String();
      }
      if (to != null) {
        queryParams['to'] = to.toUtc().toIso8601String();
      }
      if (current != null) {
        queryParams['current'] = current.toString();
      }

      final query = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';

      final url = '${ApiEndpoints.userClocks(userId)}$query';


      final response = await client.get(url);


      return response;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error fetching user clocks: $e');
    }
  }
}
