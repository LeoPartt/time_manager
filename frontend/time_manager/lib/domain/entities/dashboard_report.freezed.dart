// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardReport {

 double get workAverageWeekly; double get workAverageMonthly; double get punctualityRate; double get attendanceRate;
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<DashboardReport> get copyWith => _$DashboardReportCopyWithImpl<DashboardReport>(this as DashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReport&&(identical(other.workAverageWeekly, workAverageWeekly) || other.workAverageWeekly == workAverageWeekly)&&(identical(other.workAverageMonthly, workAverageMonthly) || other.workAverageMonthly == workAverageMonthly)&&(identical(other.punctualityRate, punctualityRate) || other.punctualityRate == punctualityRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}


@override
int get hashCode => Object.hash(runtimeType,workAverageWeekly,workAverageMonthly,punctualityRate,attendanceRate);

@override
String toString() {
  return 'DashboardReport(workAverageWeekly: $workAverageWeekly, workAverageMonthly: $workAverageMonthly, punctualityRate: $punctualityRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class $DashboardReportCopyWith<$Res>  {
  factory $DashboardReportCopyWith(DashboardReport value, $Res Function(DashboardReport) _then) = _$DashboardReportCopyWithImpl;
@useResult
$Res call({
 double workAverageWeekly, double workAverageMonthly, double punctualityRate, double attendanceRate
});




}
/// @nodoc
class _$DashboardReportCopyWithImpl<$Res>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._self, this._then);

  final DashboardReport _self;
  final $Res Function(DashboardReport) _then;

/// Create a copy of DashboardReport
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


/// Adds pattern-matching-related methods to [DashboardReport].
extension DashboardReportPatterns on DashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double workAverageWeekly,  double workAverageMonthly,  double punctualityRate,  double attendanceRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double workAverageWeekly,  double workAverageMonthly,  double punctualityRate,  double attendanceRate)  $default,) {final _that = this;
switch (_that) {
case _DashboardReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double workAverageWeekly,  double workAverageMonthly,  double punctualityRate,  double attendanceRate)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.workAverageWeekly,_that.workAverageMonthly,_that.punctualityRate,_that.attendanceRate);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardReport implements DashboardReport {
  const _DashboardReport({required this.workAverageWeekly, required this.workAverageMonthly, required this.punctualityRate, required this.attendanceRate});
  

@override final  double workAverageWeekly;
@override final  double workAverageMonthly;
@override final  double punctualityRate;
@override final  double attendanceRate;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportCopyWith<_DashboardReport> get copyWith => __$DashboardReportCopyWithImpl<_DashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReport&&(identical(other.workAverageWeekly, workAverageWeekly) || other.workAverageWeekly == workAverageWeekly)&&(identical(other.workAverageMonthly, workAverageMonthly) || other.workAverageMonthly == workAverageMonthly)&&(identical(other.punctualityRate, punctualityRate) || other.punctualityRate == punctualityRate)&&(identical(other.attendanceRate, attendanceRate) || other.attendanceRate == attendanceRate));
}


@override
int get hashCode => Object.hash(runtimeType,workAverageWeekly,workAverageMonthly,punctualityRate,attendanceRate);

@override
String toString() {
  return 'DashboardReport(workAverageWeekly: $workAverageWeekly, workAverageMonthly: $workAverageMonthly, punctualityRate: $punctualityRate, attendanceRate: $attendanceRate)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportCopyWith<$Res> implements $DashboardReportCopyWith<$Res> {
  factory _$DashboardReportCopyWith(_DashboardReport value, $Res Function(_DashboardReport) _then) = __$DashboardReportCopyWithImpl;
@override @useResult
$Res call({
 double workAverageWeekly, double workAverageMonthly, double punctualityRate, double attendanceRate
});




}
/// @nodoc
class __$DashboardReportCopyWithImpl<$Res>
    implements _$DashboardReportCopyWith<$Res> {
  __$DashboardReportCopyWithImpl(this._self, this._then);

  final _DashboardReport _self;
  final $Res Function(_DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workAverageWeekly = null,Object? workAverageMonthly = null,Object? punctualityRate = null,Object? attendanceRate = null,}) {
  return _then(_DashboardReport(
workAverageWeekly: null == workAverageWeekly ? _self.workAverageWeekly : workAverageWeekly // ignore: cast_nullable_to_non_nullable
as double,workAverageMonthly: null == workAverageMonthly ? _self.workAverageMonthly : workAverageMonthly // ignore: cast_nullable_to_non_nullable
as double,punctualityRate: null == punctualityRate ? _self.punctualityRate : punctualityRate // ignore: cast_nullable_to_non_nullable
as double,attendanceRate: null == attendanceRate ? _self.attendanceRate : attendanceRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
