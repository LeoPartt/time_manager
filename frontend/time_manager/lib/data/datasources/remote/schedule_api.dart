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

   Future<Map<String, dynamic>> getClockStatus() async {
    final res = await client.get(ApiEndpoints.schedules);
    return res;
  }
}
