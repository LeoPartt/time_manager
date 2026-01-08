import 'package:time_manager/domain/repositories/planning_repository.dart';

class DeletePlanning {
  final PlanningRepository repository;

  DeletePlanning(this.repository);

  Future<void> call(int planningId) async {
    return await repository.deletePlanning(planningId);
  }
}