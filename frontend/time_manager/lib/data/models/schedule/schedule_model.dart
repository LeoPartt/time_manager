import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/schedule/schedule.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

@freezed
abstract class ClockModel with _$ClockModel {
  const factory ClockModel({
     int? id,
   required String arrivalTs,
    String? departureTs,
  }) = _ClockModel;

  factory ClockModel.fromJson(Map<String, dynamic> json) =>
      _$ClockModelFromJson(json);
}

extension ClockModelX on ClockModel {
  Clock toDomain() => Clock(
        id: id,
         arrivalTs: DateTime.parse(arrivalTs),
        departureTs: departureTs != null ? DateTime.parse(departureTs!) : null,
     

      );
}
