

import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/data/datasources/local/cache_manager.dart';
import 'package:time_manager/data/datasources/remote/schedule_api.dart';
import 'package:time_manager/domain/entities/schedule/schedule.dart';

import 'package:time_manager/domain/repositories/schedule_repository.dart';

class ClockRepositoryImpl implements ClockRepository {
  final ClockApi api;
   final CacheManager cache;
  static const _cacheKeyClock = 'cached_clock_status';
  ClockRepositoryImpl({required this.cache, required this.api});

  @override
  Future<void> clockIn(DateTime timestamp) async {
    try {
      await api.clockIn(timestamp);
      // 🔹 On sauvegarde la réponse dans le cache
      await cache.save(_cacheKeyClock, {
        'io': 'IN',
        'timestamp': timestamp.toIso8601String(),
      }, ttlSeconds: 600); // 10 min
    } catch (e) {
      // En cas d'erreur réseau, on ne lève pas une exception fatale
      // (le cache précédent reste valide)
      rethrow;
    }
  }

  @override
  Future<void> clockOut(DateTime timestamp) async {
    try {
      await api.clockOut(timestamp);
      // 🔹 On sauvegarde la réponse dans le cache
      await cache.save(_cacheKeyClock, {
        'io': 'OUT',
        'timestamp': timestamp.toIso8601String(),
      }, ttlSeconds: 600);
    } catch (e) {
      rethrow;
    }
  }

    @override
  Future<List<int>> getUserClocks({
    required int userId,
    DateTime? from,
    DateTime? to,
    bool? current,
  }) async {
    try {
      final response = await api.getUserClocks(
        userId: userId,
        from: from,
        to: to,
        current: current,
      );

      if (response is List) {
        return response.map((e) => e as int).toList();
      }

      throw NetworkException('Invalid response format');
    } catch (e) {
      throw NetworkException('Error fetching clocks: $e');
    }
  }

  // @override
  // Future<Clock?> getClockStatus() async {
  //   try {
  //   //   final res = await api.getClockStatus();
  //     final dto = ClockModel.fromJson(res);
  //     // 🔹 Mise à jour du cache
  //     await cache.save(_cacheKeyClock, dto.toJson(), ttlSeconds: 600);
  //     return dto.toDomain();
  //   } catch (e) {
  //     // 🔸 Si erreur réseau, on lit le cache
  //     final cached = await cache.get(_cacheKeyClock);
  //     if (cached != null) {
  //     //   return ClockModel.fromJson(cached).toDomain();
  //     }
  //     rethrow;
  //   }
  // }
  //   Future<void> clearClockCache() async {
  //   await cache.remove(_cacheKeyClock);
  // // }

 @override
  @override
  Future<Clock?> getClockStatus(int userId) async {
    try {
      // ✅ Appelle TOUJOURS l'API en premier
      final status = await api.getClockStatus(userId);
      
      if (status == null) {
        await cache.remove(_cacheKeyClock);
        return null;
      }

      final io = status['io'] as String;
      final tsStr = status['timestamp'] as String;
      final ts = DateTime.parse(tsStr);

      // Met à jour le cache
      await cache.save(_cacheKeyClock, status, ttlSeconds: 600);

      if (io == 'IN') {
        return Clock(arrivalTs: ts, departureTs: null);
      } else {
        return Clock(arrivalTs: null, departureTs: ts);
      }
    } catch (e) {
      // ⚠️ Fallback sur le cache en cas d'erreur réseau
      final cached = await cache.get(_cacheKeyClock);
      if (cached != null) {
        final io = cached['io'] as String?;
        final tsStr = cached['timestamp'] as String?;
        final ts = tsStr != null ? DateTime.tryParse(tsStr) : null;

        if (io == 'IN') {
          return Clock(arrivalTs: ts, departureTs: null);
        }
        if (io == 'OUT') {
          return Clock(arrivalTs: null, departureTs: ts);
        }
      }
      return null;
    }
  }
}
