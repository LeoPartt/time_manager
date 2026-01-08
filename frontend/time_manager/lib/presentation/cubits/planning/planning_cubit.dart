
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/domain/usecases/planning/get_user_plannings.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';

class PlanningCubit extends Cubit<PlanningState> {
  final GetUserPlannings getUserPlanningsUseCase;

  PlanningCubit({
    required this.getUserPlanningsUseCase,
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
}
