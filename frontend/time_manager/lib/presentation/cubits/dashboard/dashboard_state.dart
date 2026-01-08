import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = Initial;
  const factory DashboardState.loading() = Loading;
  const factory DashboardState.loaded(DashboardReport report) = Loaded;
  const factory DashboardState.error(String message) = Error;
}