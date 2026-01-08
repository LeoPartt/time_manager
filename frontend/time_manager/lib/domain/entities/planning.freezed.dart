// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Planning {

 int get id; int get userId; int get weekDay;// 0=Monday, 1=Tuesday, ..., 6=Sunday
 String get startTime;// Format: "HH:mm"
 String get endTime;
/// Create a copy of Planning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanningCopyWith<Planning> get copyWith => _$PlanningCopyWithImpl<Planning>(this as Planning, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Planning&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weekDay, weekDay) || other.weekDay == weekDay)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,weekDay,startTime,endTime);

@override
String toString() {
  return 'Planning(id: $id, userId: $userId, weekDay: $weekDay, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $PlanningCopyWith<$Res>  {
  factory $PlanningCopyWith(Planning value, $Res Function(Planning) _then) = _$PlanningCopyWithImpl;
@useResult
$Res call({
 int id, int userId, int weekDay, String startTime, String endTime
});




}
/// @nodoc
class _$PlanningCopyWithImpl<$Res>
    implements $PlanningCopyWith<$Res> {
  _$PlanningCopyWithImpl(this._self, this._then);

  final Planning _self;
  final $Res Function(Planning) _then;

/// Create a copy of Planning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? weekDay = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,weekDay: null == weekDay ? _self.weekDay : weekDay // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Planning].
extension PlanningPatterns on Planning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Planning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Planning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Planning value)  $default,){
final _that = this;
switch (_that) {
case _Planning():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Planning value)?  $default,){
final _that = this;
switch (_that) {
case _Planning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  int weekDay,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Planning() when $default != null:
return $default(_that.id,_that.userId,_that.weekDay,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  int weekDay,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _Planning():
return $default(_that.id,_that.userId,_that.weekDay,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  int weekDay,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _Planning() when $default != null:
return $default(_that.id,_that.userId,_that.weekDay,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc


class _Planning implements Planning {
  const _Planning({required this.id, required this.userId, required this.weekDay, required this.startTime, required this.endTime});
  

@override final  int id;
@override final  int userId;
@override final  int weekDay;
// 0=Monday, 1=Tuesday, ..., 6=Sunday
@override final  String startTime;
// Format: "HH:mm"
@override final  String endTime;

/// Create a copy of Planning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanningCopyWith<_Planning> get copyWith => __$PlanningCopyWithImpl<_Planning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Planning&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weekDay, weekDay) || other.weekDay == weekDay)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,weekDay,startTime,endTime);

@override
String toString() {
  return 'Planning(id: $id, userId: $userId, weekDay: $weekDay, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$PlanningCopyWith<$Res> implements $PlanningCopyWith<$Res> {
  factory _$PlanningCopyWith(_Planning value, $Res Function(_Planning) _then) = __$PlanningCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, int weekDay, String startTime, String endTime
});




}
/// @nodoc
class __$PlanningCopyWithImpl<$Res>
    implements _$PlanningCopyWith<$Res> {
  __$PlanningCopyWithImpl(this._self, this._then);

  final _Planning _self;
  final $Res Function(_Planning) _then;

/// Create a copy of Planning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? weekDay = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_Planning(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,weekDay: null == weekDay ? _self.weekDay : weekDay // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
