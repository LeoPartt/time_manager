


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/schedule/schedule.dart';


part 'clock_state.freezed.dart';

@freezed
class ClockState with _$ClockState {
  const factory ClockState.initial() = Initial;
  const factory ClockState.loading() = ClockLoading;
  
  // ✅ États pour afficher l'UI (status actuel)
  const factory ClockState.statusClockedIn(Clock clock) = StatusClockedIn;
  const factory ClockState.statusClockedOut(Clock clock) = StatusClockedOut;
  
  // ✅ États pour les actions utilisateur (avec notification)
  const factory ClockState.actionClockedIn(Clock clock) = ActionClockedIn;
  const factory ClockState.actionClockedOut(Clock clock) = ActionClockedOut;
  
  const factory ClockState.error(String message) = ClockError;
}