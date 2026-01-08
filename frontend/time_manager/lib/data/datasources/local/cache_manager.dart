import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//Permet de mémoriser des réponses API (utile pour “offline-first”).

class CacheManager {
  Future<void> save(String key, Map<String, dynamic> data ,{
    int ttlSeconds = 3600, // 1h par défaut,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      "data": data,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "ttl": ttlSeconds,
    };
    await prefs.setString(key, jsonEncode(payload));
  }

Future<Map<String, dynamic>?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString);
    final timestamp = decoded["timestamp"] as int;
    final ttl = decoded["ttl"] as int;
    final expired =
        DateTime.now().millisecondsSinceEpoch > (timestamp + ttl * 1000);

    if (expired) {
      await prefs.remove(key);
      return null;
    }

    return Map<String, dynamic>.from(decoded["data"]);
  }


  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
