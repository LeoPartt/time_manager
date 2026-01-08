
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/planning/create_planning.dart';
import 'package:time_manager/domain/usecases/planning/delete_planning.dart';
import 'package:time_manager/domain/usecases/planning/get_user_plannings.dart';
import 'package:time_manager/domain/usecases/planning/update_planning.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';

class PlanningCubit extends Cubit<PlanningState> {
  final GetUserPlannings getUserPlanningsUseCase;
  final CreatePlanning createPlanningUseCase;
  final UpdatePlanning updatePlanningUseCase;
  final DeletePlanning deletePlanningUseCase;

  PlanningCubit({
    required this.getUserPlanningsUseCase,
    required this.createPlanningUseCase,
    required this.updatePlanningUseCase,
    required this.deletePlanningUseCase,
  }) : super(const PlanningState.initial());

  /// 📅 Charge les plannings d'un utilisateur
  Future<void> loadUserPlannings(BuildContext context, int userId) async {
    final tr = AppLocalizations.of(context)!;
    
    print('🔵 [PlanningCubit] loadUserPlannings called with userId: $userId');
    emit(const PlanningState.loading());

    try {
      print('🔵 [PlanningCubit] Calling getUserPlanningsUseCase...');
      final plannings = await getUserPlanningsUseCase(userId);
      
      print('🟢 [PlanningCubit] Plannings received: ${plannings.length} items');
      
      emit(PlanningState.loaded(plannings));
    } catch (e, stackTrace) {
      print('🔴 [PlanningCubit] Error: $e');
      print('🔴 [PlanningCubit] StackTrace: $stackTrace');
      emit(PlanningState.error('${tr.error}: $e'));
    }
  }
  Future<void> createPlanning(
    BuildContext context, {
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    final tr = AppLocalizations.of(context)!;
    
    print('🔵 [PlanningCubit] createPlanning called');
    emit(const PlanningState.loading());

    try {
      await createPlanningUseCase(
        userId: userId,
        weekDay: weekDay,
        startTime: startTime,
        endTime: endTime,
      );
      
      print('🟢 [PlanningCubit] Planning created successfully');
      
      // Recharge la liste après création
      await loadUserPlannings(context, userId);
    } catch (e, stackTrace) {
      print('🔴 [PlanningCubit] Error creating planning: $e');
      print('🔴 [PlanningCubit] StackTrace: $stackTrace');
      emit(PlanningState.error('${tr.error}: $e'));
    }
  }

  /// ✏️ Mettre à jour un planning
  Future<void> updatePlanning(
    BuildContext context, {
    required int userId,
    required int planningId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    final tr = AppLocalizations.of(context)!;
    
    print('🔵 [PlanningCubit] updatePlanning called for planningId: $planningId');
    emit(const PlanningState.loading());

    try {
      await updatePlanningUseCase(
        planningId: planningId,
        weekDay: weekDay,
        startTime: startTime,
        endTime: endTime,
      );
      
      print('🟢 [PlanningCubit] Planning updated successfully');
      
      // Recharge la liste après mise à jour
      await loadUserPlannings(context, userId);
    } catch (e, stackTrace) {
      print('🔴 [PlanningCubit] Error updating planning: $e');
      print('🔴 [PlanningCubit] StackTrace: $stackTrace');
      emit(PlanningState.error('${tr.error}: $e'));
    }
  }

  /// 🗑️ Supprimer un planning
  Future<void> deletePlanning(
    BuildContext context, {
    required int userId,
    required int planningId,
  }) async {
    final tr = AppLocalizations.of(context)!;
    
    print('🔵 [PlanningCubit] deletePlanning called for planningId: $planningId');
    emit(const PlanningState.loading());

    try {
      await deletePlanningUseCase(planningId);
      
      print('🟢 [PlanningCubit] Planning deleted successfully');
      
      // Recharge la liste après suppression
      await loadUserPlannings(context, userId);
    } catch (e, stackTrace) {
      print('🔴 [PlanningCubit] Error deleting planning: $e');
      print('🔴 [PlanningCubit] StackTrace: $stackTrace');
      emit(PlanningState.error('${tr.error}: $e'));
    }
  }
}
