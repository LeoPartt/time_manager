import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
abstract class ReportModel with _$ReportModel {
  const factory ReportModel({
    required double weekly,
    required double monthly,
    required double yearly,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}