
import 'package:time_manager/domain/entities/planning/planning.dart';

abstract class PlanningRepository {
  Future<List<Planning>> getUserPlannings(int userId);
  Future<Planning> getPlanning(int planningId);
  Future<Planning> createPlanning({
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  });
  Future<Planning> updatePlanning({
    required int planningId,
    required int weekDay,
    required String startTime,
    required String endTime,
  });
  Future<void> deletePlanning(int planningId);
}