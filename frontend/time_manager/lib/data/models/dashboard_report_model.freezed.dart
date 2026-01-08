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

 int get userId;@JsonKey(name: 'WorkAverages') ReportModel get workAverages;@JsonKey(name: 'PunctualityRates') ReportModel get punctualityRates;@JsonKey(name: 'AttendanceRates') ReportModel get attendanceRates;
/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<DashboardReportModel> get copyWith => _$DashboardReportModelCopyWithImpl<DashboardReportModel>(this as DashboardReportModel, _$identity);

  /// Serializes this DashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReportModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workAverages, workAverages) || other.workAverages == workAverages)&&(identical(other.punctualityRates, punctualityRates) || other.punctualityRates == punctualityRates)&&(identical(other.attendanceRates, attendanceRates) || other.attendanceRates == attendanceRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,workAverages,punctualityRates,attendanceRates);

@override
String toString() {
  return 'DashboardReportModel(userId: $userId, workAverages: $workAverages, punctualityRates: $punctualityRates, attendanceRates: $attendanceRates)';
}


}

/// @nodoc
abstract mixin class $DashboardReportModelCopyWith<$Res>  {
  factory $DashboardReportModelCopyWith(DashboardReportModel value, $Res Function(DashboardReportModel) _then) = _$DashboardReportModelCopyWithImpl;
@useResult
$Res call({
 int userId,@JsonKey(name: 'WorkAverages') ReportModel workAverages,@JsonKey(name: 'PunctualityRates') ReportModel punctualityRates,@JsonKey(name: 'AttendanceRates') ReportModel attendanceRates
});


$ReportModelCopyWith<$Res> get workAverages;$ReportModelCopyWith<$Res> get punctualityRates;$ReportModelCopyWith<$Res> get attendanceRates;

}
/// @nodoc
class _$DashboardReportModelCopyWithImpl<$Res>
    implements $DashboardReportModelCopyWith<$Res> {
  _$DashboardReportModelCopyWithImpl(this._self, this._then);

  final DashboardReportModel _self;
  final $Res Function(DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? workAverages = null,Object? punctualityRates = null,Object? attendanceRates = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,workAverages: null == workAverages ? _self.workAverages : workAverages // ignore: cast_nullable_to_non_nullable
as ReportModel,punctualityRates: null == punctualityRates ? _self.punctualityRates : punctualityRates // ignore: cast_nullable_to_non_nullable
as ReportModel,attendanceRates: null == attendanceRates ? _self.attendanceRates : attendanceRates // ignore: cast_nullable_to_non_nullable
as ReportModel,
  ));
}
/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get workAverages {
  
  return $ReportModelCopyWith<$Res>(_self.workAverages, (value) {
    return _then(_self.copyWith(workAverages: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get punctualityRates {
  
  return $ReportModelCopyWith<$Res>(_self.punctualityRates, (value) {
    return _then(_self.copyWith(punctualityRates: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get attendanceRates {
  
  return $ReportModelCopyWith<$Res>(_self.attendanceRates, (value) {
    return _then(_self.copyWith(attendanceRates: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId, @JsonKey(name: 'WorkAverages')  ReportModel workAverages, @JsonKey(name: 'PunctualityRates')  ReportModel punctualityRates, @JsonKey(name: 'AttendanceRates')  ReportModel attendanceRates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId, @JsonKey(name: 'WorkAverages')  ReportModel workAverages, @JsonKey(name: 'PunctualityRates')  ReportModel punctualityRates, @JsonKey(name: 'AttendanceRates')  ReportModel attendanceRates)  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId, @JsonKey(name: 'WorkAverages')  ReportModel workAverages, @JsonKey(name: 'PunctualityRates')  ReportModel punctualityRates, @JsonKey(name: 'AttendanceRates')  ReportModel attendanceRates)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that.userId,_that.workAverages,_that.punctualityRates,_that.attendanceRates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReportModel extends DashboardReportModel {
  const _DashboardReportModel({required this.userId, @JsonKey(name: 'WorkAverages') required this.workAverages, @JsonKey(name: 'PunctualityRates') required this.punctualityRates, @JsonKey(name: 'AttendanceRates') required this.attendanceRates}): super._();
  factory _DashboardReportModel.fromJson(Map<String, dynamic> json) => _$DashboardReportModelFromJson(json);

@override final  int userId;
@override@JsonKey(name: 'WorkAverages') final  ReportModel workAverages;
@override@JsonKey(name: 'PunctualityRates') final  ReportModel punctualityRates;
@override@JsonKey(name: 'AttendanceRates') final  ReportModel attendanceRates;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReportModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workAverages, workAverages) || other.workAverages == workAverages)&&(identical(other.punctualityRates, punctualityRates) || other.punctualityRates == punctualityRates)&&(identical(other.attendanceRates, attendanceRates) || other.attendanceRates == attendanceRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,workAverages,punctualityRates,attendanceRates);

@override
String toString() {
  return 'DashboardReportModel(userId: $userId, workAverages: $workAverages, punctualityRates: $punctualityRates, attendanceRates: $attendanceRates)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportModelCopyWith<$Res> implements $DashboardReportModelCopyWith<$Res> {
  factory _$DashboardReportModelCopyWith(_DashboardReportModel value, $Res Function(_DashboardReportModel) _then) = __$DashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
 int userId,@JsonKey(name: 'WorkAverages') ReportModel workAverages,@JsonKey(name: 'PunctualityRates') ReportModel punctualityRates,@JsonKey(name: 'AttendanceRates') ReportModel attendanceRates
});


@override $ReportModelCopyWith<$Res> get workAverages;@override $ReportModelCopyWith<$Res> get punctualityRates;@override $ReportModelCopyWith<$Res> get attendanceRates;

}
/// @nodoc
class __$DashboardReportModelCopyWithImpl<$Res>
    implements _$DashboardReportModelCopyWith<$Res> {
  __$DashboardReportModelCopyWithImpl(this._self, this._then);

  final _DashboardReportModel _self;
  final $Res Function(_DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? workAverages = null,Object? punctualityRates = null,Object? attendanceRates = null,}) {
  return _then(_DashboardReportModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,workAverages: null == workAverages ? _self.workAverages : workAverages // ignore: cast_nullable_to_non_nullable
as ReportModel,punctualityRates: null == punctualityRates ? _self.punctualityRates : punctualityRates // ignore: cast_nullable_to_non_nullable
as ReportModel,attendanceRates: null == attendanceRates ? _self.attendanceRates : attendanceRates // ignore: cast_nullable_to_non_nullable
as ReportModel,
  ));
}

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get workAverages {
  
  return $ReportModelCopyWith<$Res>(_self.workAverages, (value) {
    return _then(_self.copyWith(workAverages: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get punctualityRates {
  
  return $ReportModelCopyWith<$Res>(_self.punctualityRates, (value) {
    return _then(_self.copyWith(punctualityRates: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportModelCopyWith<$Res> get attendanceRates {
  
  return $ReportModelCopyWith<$Res>(_self.attendanceRates, (value) {
    return _then(_self.copyWith(attendanceRates: value));
  });
}
}

// dart format on
