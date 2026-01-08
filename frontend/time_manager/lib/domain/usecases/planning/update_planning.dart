import 'package:time_manager/domain/entities/planning.dart';
import 'package:time_manager/domain/repositories/planning_repository.dart';

class UpdatePlanning {
  final PlanningRepository repository;

  UpdatePlanning(this.repository);

  Future<Planning> call({
    required int planningId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    return await repository.updatePlanning(
      planningId: planningId,
      weekDay: weekDay,
      startTime: startTime,
      endTime: endTime,
    );
  }
}