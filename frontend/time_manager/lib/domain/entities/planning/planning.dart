import 'package:freezed_annotation/freezed_annotation.dart';

part 'planning.freezed.dart';

@freezed
abstract class Planning with _$Planning {
  const factory Planning({
    required int id,
    required int userId,
    required int weekDay, // 0=Monday, 1=Tuesday, ..., 6=Sunday
    required String startTime, // Format: "HH:mm"
    required String endTime, // Format: "HH:mm"
  }) = _Planning;
}