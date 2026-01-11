import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/domain/repositories/planning_repository.dart';

class GetUserPlannings {
  final PlanningRepository repository;

  GetUserPlannings(this.repository);

  Future<List<Planning>> call(int userId) async {
    return await repository.getUserPlannings(userId);
  }
}