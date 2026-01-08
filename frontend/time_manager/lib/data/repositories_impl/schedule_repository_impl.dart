

import 'package:time_manager/data/datasources/local/cache_manager.dart';
import 'package:time_manager/data/datasources/remote/schedule_api.dart';

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
        'io': 'IN',
        'timestamp': timestamp.toIso8601String(),
      }, ttlSeconds: 600);
    } catch (e) {
      rethrow;
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
}
