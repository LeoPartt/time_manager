// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardReportModel {

@JsonKey(name: 'WorkAverageWeekly') double get workAverageWeekly;@JsonKey(name: 'WorkAverageMonthly') double get workAverageMonthly;@JsonKey(name: 'PunctualityRate') double get punctualityRate;@JsonKey(name: 'AttendanceRate') double get attendanceRate;
/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<DashboardReportModel> get copyWith => _$DashboardReportModelCopyWithImpl<DashboardReportModel>(this as DashboardReportModel, _$identity);

  /// Serializes this DashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReportModel&&(identical(other.workAverageWeekly, workAverageWeekly) || other.workAverageWeekly == workAverageWeekly)&&(identical(other.workAverageMonthly, workAverageMonthly) || other.workAverageMonthly == workAverageMonthly)&&(identical(other.punctualityRate, punctualityRate) || other.punctualityRate == punctualityRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workAverageWeekly,workAverageMonthly,punctualityRate,attendanceRate);

@override
String toString() {
  return 'DashboardReportModel(workAverageWeekly: $workAverageWeekly, workAverageMonthly: $workAverageMonthly, punctualityRate: $punctualityRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class $DashboardReportModelCopyWith<$Res>  {
  factory $DashboardReportModelCopyWith(DashboardReportModel value, $Res Function(DashboardReportModel) _then) = _$DashboardReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'WorkAverageWeekly') double workAverageWeekly,@JsonKey(name: 'WorkAverageMonthly') double workAverageMonthly,@JsonKey(name: 'PunctualityRate') double punctualityRate,@JsonKey(name: 'AttendanceRate') double attendanceRate
});




}
/// @nodoc
class _$DashboardReportModelCopyWithImpl<$Res>
    implements $DashboardReportModelCopyWith<$Res> {
  _$DashboardReportModelCopyWithImpl(this._self, this._then);

  final DashboardReportModel _self;
  final $Res Function(DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workAverageWeekly = null,Object? workAverageMonthly = null,Object? punctualityRate = null,Object? attendanceRate = null,}) {
  return _then(_self.copyWith(
workAverageWeekly: null == workAverageWeekly ? _self.workAverageWeekly : workAverageWeekly // ignore: cast_nullable_to_non_nullable
as double,workAverageMonthly: null == workAverageMonthly ? _self.workAverageMonthly : workAverageMonthly // ignore: cast_nullable_to_non_nullable
as double,punctualityRate: null == punctualityRate ? _self.punctualityRate : punctualityRate // ignore: cast_nullable_to_non_nullable
as double,attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardReportModel].
extension DashboardReportModelPatterns on DashboardReportModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReportModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReportModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'WorkAverageWeekly')  double workAverageWeekly, @JsonKey(name: 'WorkAverageMonthly')  double workAverageMonthly, @JsonKey(name: 'PunctualityRate')  double punctualityRate, @JsonKey(name: 'AttendanceRate')  double attendanceRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that.workAverageWeekly,_that.workAverageMonthly,_that.punctualityRate,_that.attendanceRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'WorkAverageWeekly')  double workAverageWeekly, @JsonKey(name: 'WorkAverageMonthly')  double workAverageMonthly, @JsonKey(name: 'PunctualityRate')  double punctualityRate, @JsonKey(name: 'AttendanceRate')  double attendanceRate)  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel():
return $default(_that.workAverageWeekly,_that.workAverageMonthly,_that.punctualityRate,_that.attendanceRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'WorkAverageWeekly')  double workAverageWeekly, @JsonKey(name: 'WorkAverageMonthly')  double workAverageMonthly, @JsonKey(name: 'PunctualityRate')  double punctualityRate, @JsonKey(name: 'AttendanceRate')  double attendanceRate)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that.workAverageWeekly,_that.workAverageMonthly,_that.punctualityRate,_that.attendanceRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReportModel extends DashboardReportModel {
  const _DashboardReportModel({@JsonKey(name: 'WorkAverageWeekly') required this.workAverageWeekly, @JsonKey(name: 'WorkAverageMonthly') required this.workAverageMonthly, @JsonKey(name: 'PunctualityRate') required this.punctualityRate, @JsonKey(name: 'AttendanceRate') required this.attendanceRate}): super._();
  factory _DashboardReportModel.fromJson(Map<String, dynamic> json) => _$DashboardReportModelFromJson(json);

@override@JsonKey(name: 'WorkAverageWeekly') final  double workAverageWeekly;
@override@JsonKey(name: 'WorkAverageMonthly') final  double workAverageMonthly;
@override@JsonKey(name: 'PunctualityRate') final  double punctualityRate;
@override@JsonKey(name: 'AttendanceRate') final  double attendanceRate;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportModelCopyWith<_DashboardReportModel> get copyWith => __$DashboardReportModelCopyWithImpl<_DashboardReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReportModel&&(identical(other.workAverageWeekly, workAverageWeekly) || other.workAverageWeekly == workAverageWeekly)&&(identical(other.workAverageMonthly, workAverageMonthly) || other.workAverageMonthly == workAverageMonthly)&&(identical(other.punctualityRate, punctualityRate) || other.punctualityRate == punctualityRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workAverageWeekly,workAverageMonthly,punctualityRate,attendanceRate);

@override
String toString() {
  return 'DashboardReportModel(workAverageWeekly: $workAverageWeekly, workAverageMonthly: $workAverageMonthly, punctualityRate: $punctualityRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportModelCopyWith<$Res> implements $DashboardReportModelCopyWith<$Res> {
  factory _$DashboardReportModelCopyWith(_DashboardReportModel value, $Res Function(_DashboardReportModel) _then) = __$DashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'WorkAverageWeekly') double workAverageWeekly,@JsonKey(name: 'WorkAverageMonthly') double workAverageMonthly,@JsonKey(name: 'PunctualityRate') double punctualityRate,@JsonKey(name: 'AttendanceRate') double attendanceRate
});




}
/// @nodoc
class __$DashboardReportModelCopyWithImpl<$Res>
    implements _$DashboardReportModelCopyWith<$Res> {
  __$DashboardReportModelCopyWithImpl(this._self, this._then);

  final _DashboardReportModel _self;
  final $Res Function(_DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workAverageWeekly = null,Object? workAverageMonthly = null,Object? punctualityRate = null,Object? attendanceRate = null,}) {
  return _then(_DashboardReportModel(
workAverageWeekly: null == workAverageWeekly ? _self.workAverageWeekly : workAverageWeekly // ignore: cast_nullable_to_non_nullable
as double,workAverageMonthly: null == workAverageMonthly ? _self.workAverageMonthly : workAverageMonthly // ignore: cast_nullable_to_non_nullable
as double,punctualityRate: null == punctualityRate ? _self.punctualityRate : punctualityRate // ignore: cast_nullable_to_non_nullable
as double,attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
