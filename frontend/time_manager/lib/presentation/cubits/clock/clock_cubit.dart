
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/exceptions/network_exception.dart';
import 'package:time_manager/domain/entities/schedule/schedule.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_in.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_out.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_status.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/clock/clock_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';

class ClockCubit extends Cubit<ClockState> {
  final ClockIn clockInUseCase;
  final ClockOut clockOutUseCase;
  final GetClockStatus getStatusUseCase;

  ClockCubit({
    required this.clockInUseCase,
    required this.clockOutUseCase,
    required this.getStatusUseCase,
  }) : super(const ClockState.initial());

  /// 🕐 Clock IN (action utilisateur)
  Future<void> clockIn(BuildContext context, TimeOfDay selectedTime) async {
    final tr = AppLocalizations.of(context)!;
    emit(const ClockState.loading());

    try {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await clockInUseCase(dt);
      
      // ✅ Émettre un état d'ACTION (déclenche la notification)
      emit(ClockState.actionClockedIn(Clock(arrivalTs: dt, departureTs: null)));
      
      // Attendre un peu puis recharger le status
      await Future.delayed(const Duration(milliseconds: 300));
      await getStatus(context);
      
    } on NetworkException catch (e) {
      if (e.message.contains('409') || 
          e.message.contains('Conflict') || 
          e.message.contains('expected')) {
        await getStatus(context);
        emit(ClockState.error(
          'Vous êtes déjà clocké IN. Veuillez d\'abord faire Clock OUT.',
        ));
      } else {
        emit(ClockState.error('${tr.clockin} ${tr.error.toLowerCase()}: ${e.message}'));
      }
    } catch (e) {
      emit(ClockState.error('${tr.clockin} ${tr.error.toLowerCase()}: $e'));
    }
  }

  /// 🕐 Clock OUT (action utilisateur)
  Future<void> clockOut(BuildContext context, TimeOfDay selectedTime) async {
    final tr = AppLocalizations.of(context)!;
    emit(const ClockState.loading());

    try {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await clockOutUseCase(dt);
      
      // ✅ Émettre un état d'ACTION (déclenche la notification)
      emit(ClockState.actionClockedOut(Clock(arrivalTs: null, departureTs: dt)));
      
      // Attendre un peu puis recharger le status
      await Future.delayed(const Duration(milliseconds: 300));
      await getStatus(context);
      
    } on NetworkException catch (e) {
      if (e.message.contains('409') || 
          e.message.contains('Conflict') || 
          e.message.contains('expected')) {
        await getStatus(context);
        emit(ClockState.error(
          'Vous devez d\'abord faire Clock IN avant de faire Clock OUT.',
        ));
      } else {
        emit(ClockState.error('${tr.clockout} ${tr.error.toLowerCase()}: ${e.message}'));
      }
    } catch (e) {
      emit(ClockState.error('${tr.clockout} ${tr.error.toLowerCase()}: $e'));
    }
  }

  /// 🔄 Bascule entre IN et OUT
  Future<void> toggleClockState(BuildContext context, TimeOfDay timestamp) async {
    final current = state;

    if (current is StatusClockedIn || current is ActionClockedIn) {
      await clockOut(context, timestamp);
    } else if (current is Initial || current is StatusClockedOut) {
      await clockIn(context, timestamp);
    }
  }

  /// 📍 Récupère le statut actuel (simple refresh, pas d'action)
  Future<void> getStatus(BuildContext context) async {
    emit(const ClockState.loading());

    try {
      final userCubit = context.read<UserCubit>();
      final userState = userCubit.state;

      int? userId;
      userState.whenOrNull(
        loaded: (user) => userId = user.id,
      );

      if (userId == null) {
        emit(const ClockState.initial());
        return;
      }

      final status = await getStatusUseCase(userId!);

      if (status == null) {
        emit(const ClockState.initial());
        return;
      }

      if (status.isClockedIn) {
        // ✅ Émettre un état de STATUS (pas de notification)
        emit(ClockState.statusClockedIn(status));
      } else {
        emit(const ClockState.initial());
      }
    } catch (e) {
      emit(const ClockState.initial());
    }
  }
}