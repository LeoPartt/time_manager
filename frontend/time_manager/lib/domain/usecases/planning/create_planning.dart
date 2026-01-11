import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/domain/repositories/planning_repository.dart';

class CreatePlanning {
  final PlanningRepository repository;

  CreatePlanning(this.repository);

  Future<Planning> call({
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    return await repository.createPlanning(
      userId: userId,
      weekDay: weekDay,
      startTime: startTime,
      endTime: endTime,
    );
  }
}