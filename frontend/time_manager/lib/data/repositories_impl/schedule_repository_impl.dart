

import 'package:time_manager/data/datasources/local/cache_manager.dart';
import 'package:time_manager/data/datasources/remote/schedule_api.dart';
import 'package:time_manager/domain/entities/schedule.dart';

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
  Future<Clock?> getClockStatus() async {
    try {
      final res = await api.getClockStatus(); // Map<String,dynamic>

      // 🔹 Si ton backend renvoie io/timestamp
      if (res.containsKey('io')) {
        final io = (res['io'] as String?)?.toUpperCase();
        final tsStr = res['timestamp'] as String?;
        final ts = tsStr != null ? DateTime.tryParse(tsStr) : null;

        // cache la vérité backend
        await cache.save(
          _cacheKeyClock,
          {'io': io, 'timestamp': tsStr},
          ttlSeconds: 600,
        );

        if (io == 'IN') return Clock(arrivalTs: ts, departureTs: null);
        if (io == 'OUT') return Clock(arrivalTs: null, departureTs: ts);
        return null;
      }

      // 🔹 Si ton backend renvoie arrivalTs/departureTs
      if (res.containsKey('arrivalTs') || res.containsKey('departureTs')) {
        final arrival = res['arrivalTs'] != null ? DateTime.tryParse(res['arrivalTs']) : null;
        final departure = res['departureTs'] != null ? DateTime.tryParse(res['departureTs']) : null;

        // dérive io pour cache
        final io = departure == null ? 'IN' : 'OUT';
        await cache.save(
          _cacheKeyClock,
          {'io': io, 'timestamp': (departure ?? arrival)?.toIso8601String()},
          ttlSeconds: 600,
        );

        return Clock(arrivalTs: arrival, departureTs: departure);
      }

      return null;
    } catch (_) {
      // fallback cache si offline / erreur
      final cached = await cache.get(_cacheKeyClock);
      if (cached == null) return null;

      final io = (cached['io'] as String?)?.toUpperCase();
      final tsStr = cached['timestamp'] as String?;
      final ts = tsStr != null ? DateTime.tryParse(tsStr) : null;

      if (io == 'IN') return Clock(arrivalTs: ts, departureTs: null);
      if (io == 'OUT') return Clock(arrivalTs: null, departureTs: ts);
      return null;
    }
  }
}
