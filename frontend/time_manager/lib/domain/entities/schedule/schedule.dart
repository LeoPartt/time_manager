import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';

@freezed
abstract class Clock with _$Clock {
  const Clock._(); // 🔹 nécessaire pour ajouter des getters

  const factory Clock({
    int? id,
    DateTime? arrivalTs,
    DateTime? departureTs,
  }) = _Clock;

  /// 🔹 L'utilisateur est clocké IN
  bool get isClockedIn => arrivalTs != null && departureTs == null;

  /// 🔹 L'utilisateur est clocké OUT
  bool get isClockedOut => departureTs != null;
}
