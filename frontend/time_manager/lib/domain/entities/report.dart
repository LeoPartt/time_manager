import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';

@freezed
abstract class Report with _$Report {
  const factory Report({
    required double weekly,
    required double monthly,
    required double yearly,
  }) = _Report;
}