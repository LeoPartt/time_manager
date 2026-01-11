
import 'package:time_manager/data/datasources/remote/planning_api.dart';
import 'package:time_manager/data/models/planning/planning_model.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/domain/repositories/planning_repository.dart';

class PlanningRepositoryImpl implements PlanningRepository {
  final PlanningApi api;

  PlanningRepositoryImpl({required this.api});

  @override
  Future<List<Planning>> getUserPlannings(int userId) async {
    try {
      final jsonList = await api.getUserPlannings(userId);
      
      final models = jsonList
          .map((json) => PlanningModel.fromJson(json))
          .toList();
      
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Planning> getPlanning(int planningId) async {
    try {
      final json = await api.getPlanning(planningId);
      final model = PlanningModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Planning> createPlanning({
    required int userId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final json = await api.createPlanning(
        userId: userId,
        weekDay: weekDay,
        startTime: startTime,
        endTime: endTime,
      );
      final model = PlanningModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Planning> updatePlanning({
    required int planningId,
    required int weekDay,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final json = await api.updatePlanning(
        planningId: planningId,
        weekDay: weekDay,
        startTime: startTime,
        endTime: endTime,
      );
      final model = PlanningModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePlanning(int planningId) async {
    try {
      await api.deletePlanning(planningId);
    } catch (e) {
      rethrow;
    }
  }
}