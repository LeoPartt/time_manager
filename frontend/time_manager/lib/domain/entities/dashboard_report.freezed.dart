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

 int get userId; Report get workAverages; Report get punctualityRates; Report get attendanceRates;
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<DashboardReport> get copyWith => _$DashboardReportCopyWithImpl<DashboardReport>(this as DashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workAverages, workAverages) || other.workAverages == workAverages)&&(identical(other.punctualityRates, punctualityRates) || other.punctualityRates == punctualityRates)&&(identical(other.attendanceRates, attendanceRates) || other.attendanceRates == attendanceRates));
}


@override
int get hashCode => Object.hash(runtimeType,userId,workAverages,punctualityRates,attendanceRates);

@override
String toString() {
  return 'DashboardReport(userId: $userId, workAverages: $workAverages, punctualityRates: $punctualityRates, attendanceRates: $attendanceRates)';
}


}

/// @nodoc
abstract mixin class $DashboardReportCopyWith<$Res>  {
  factory $DashboardReportCopyWith(DashboardReport value, $Res Function(DashboardReport) _then) = _$DashboardReportCopyWithImpl;
@useResult
$Res call({
 int userId, Report workAverages, Report punctualityRates, Report attendanceRates
});


$ReportCopyWith<$Res> get workAverages;$ReportCopyWith<$Res> get punctualityRates;$ReportCopyWith<$Res> get attendanceRates;

}
/// @nodoc
class _$DashboardReportCopyWithImpl<$Res>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._self, this._then);

  final DashboardReport _self;
  final $Res Function(DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? workAverages = null,Object? punctualityRates = null,Object? attendanceRates = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,workAverages: null == workAverages ? _self.workAverages : workAverages // ignore: cast_nullable_to_non_nullable
as Report,punctualityRates: null == punctualityRates ? _self.punctualityRates : punctualityRates // ignore: cast_nullable_to_non_nullable
as Report,attendanceRates: null == attendanceRates ? _self.attendanceRates : attendanceRates // ignore: cast_nullable_to_non_nullable
as Report,
  ));
}
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get workAverages {
  
  return $ReportCopyWith<$Res>(_self.workAverages, (value) {
    return _then(_self.copyWith(workAverages: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get punctualityRates {
  
  return $ReportCopyWith<$Res>(_self.punctualityRates, (value) {
    return _then(_self.copyWith(punctualityRates: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get attendanceRates {
  
  return $ReportCopyWith<$Res>(_self.attendanceRates, (value) {
    return _then(_self.copyWith(attendanceRates: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  Report workAverages,  Report punctualityRates,  Report attendanceRates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.userId,_that.workAverages,_that.punctualityRates,_that.attendanceRates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  Report workAverages,  Report punctualityRates,  Report attendanceRates)  $default,) {final _that = this;
switch (_that) {
case _DashboardReport():
return $default(_that.userId,_that.workAverages,_that.punctualityRates,_that.attendanceRates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  Report workAverages,  Report punctualityRates,  Report attendanceRates)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.userId,_that.workAverages,_that.punctualityRates,_that.attendanceRates);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardReport implements DashboardReport {
  const _DashboardReport({required this.userId, required this.workAverages, required this.punctualityRates, required this.attendanceRates});
  

@override final  int userId;
@override final  Report workAverages;
@override final  Report punctualityRates;
@override final  Report attendanceRates;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportCopyWith<_DashboardReport> get copyWith => __$DashboardReportCopyWithImpl<_DashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workAverages, workAverages) || other.workAverages == workAverages)&&(identical(other.punctualityRates, punctualityRates) || other.punctualityRates == punctualityRates)&&(identical(other.attendanceRates, attendanceRates) || other.attendanceRates == attendanceRates));
}


@override
int get hashCode => Object.hash(runtimeType,userId,workAverages,punctualityRates,attendanceRates);

@override
String toString() {
  return 'DashboardReport(userId: $userId, workAverages: $workAverages, punctualityRates: $punctualityRates, attendanceRates: $attendanceRates)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportCopyWith<$Res> implements $DashboardReportCopyWith<$Res> {
  factory _$DashboardReportCopyWith(_DashboardReport value, $Res Function(_DashboardReport) _then) = __$DashboardReportCopyWithImpl;
@override @useResult
$Res call({
 int userId, Report workAverages, Report punctualityRates, Report attendanceRates
});


@override $ReportCopyWith<$Res> get workAverages;@override $ReportCopyWith<$Res> get punctualityRates;@override $ReportCopyWith<$Res> get attendanceRates;

}
/// @nodoc
class __$DashboardReportCopyWithImpl<$Res>
    implements _$DashboardReportCopyWith<$Res> {
  __$DashboardReportCopyWithImpl(this._self, this._then);

  final _DashboardReport _self;
  final $Res Function(_DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? workAverages = null,Object? punctualityRates = null,Object? attendanceRates = null,}) {
  return _then(_DashboardReport(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,workAverages: null == workAverages ? _self.workAverages : workAverages // ignore: cast_nullable_to_non_nullable
as Report,punctualityRates: null == punctualityRates ? _self.punctualityRates : punctualityRates // ignore: cast_nullable_to_non_nullable
as Report,attendanceRates: null == attendanceRates ? _self.attendanceRates : attendanceRates // ignore: cast_nullable_to_non_nullable
as Report,
  ));
}

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get workAverages {
  
  return $ReportCopyWith<$Res>(_self.workAverages, (value) {
    return _then(_self.copyWith(workAverages: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get punctualityRates {
  
  return $ReportCopyWith<$Res>(_self.punctualityRates, (value) {
    return _then(_self.copyWith(punctualityRates: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportCopyWith<$Res> get attendanceRates {
  
  return $ReportCopyWith<$Res>(_self.attendanceRates, (value) {
    return _then(_self.copyWith(attendanceRates: value));
  });
}
}

// dart format on
