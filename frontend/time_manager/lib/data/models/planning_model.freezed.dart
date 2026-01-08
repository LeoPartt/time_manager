// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planning_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanningModel {

 int get id; int get userId; int get weekDay; String get startTime; String get endTime;
/// Create a copy of PlanningModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanningModelCopyWith<PlanningModel> get copyWith => _$PlanningModelCopyWithImpl<PlanningModel>(this as PlanningModel, _$identity);

  /// Serializes this PlanningModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanningModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weekDay, weekDay) || other.weekDay == weekDay)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,weekDay,startTime,endTime);

@override
String toString() {
  return 'PlanningModel(id: $id, userId: $userId, weekDay: $weekDay, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $PlanningModelCopyWith<$Res>  {
  factory $PlanningModelCopyWith(PlanningModel value, $Res Function(PlanningModel) _then) = _$PlanningModelCopyWithImpl;
@useResult
$Res call({
 int id, int userId, int weekDay, String startTime, String endTime
});




}
/// @nodoc
class _$PlanningModelCopyWithImpl<$Res>
    implements $PlanningModelCopyWith<$Res> {
  _$PlanningModelCopyWithImpl(this._self, this._then);

  final PlanningModel _self;
  final $Res Function(PlanningModel) _then;

/// Create a copy of PlanningModel
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


/// Adds pattern-matching-related methods to [PlanningModel].
extension PlanningModelPatterns on PlanningModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanningModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanningModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanningModel value)  $default,){
final _that = this;
switch (_that) {
case _PlanningModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanningModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlanningModel() when $default != null:
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
case _PlanningModel() when $default != null:
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
case _PlanningModel():
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
case _PlanningModel() when $default != null:
return $default(_that.id,_that.userId,_that.weekDay,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanningModel extends PlanningModel {
  const _PlanningModel({required this.id, required this.userId, required this.weekDay, required this.startTime, required this.endTime}): super._();
  factory _PlanningModel.fromJson(Map<String, dynamic> json) => _$PlanningModelFromJson(json);

@override final  int id;
@override final  int userId;
@override final  int weekDay;
@override final  String startTime;
@override final  String endTime;

/// Create a copy of PlanningModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanningModelCopyWith<_PlanningModel> get copyWith => __$PlanningModelCopyWithImpl<_PlanningModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanningModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanningModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weekDay, weekDay) || other.weekDay == weekDay)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,weekDay,startTime,endTime);

@override
String toString() {
  return 'PlanningModel(id: $id, userId: $userId, weekDay: $weekDay, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$PlanningModelCopyWith<$Res> implements $PlanningModelCopyWith<$Res> {
  factory _$PlanningModelCopyWith(_PlanningModel value, $Res Function(_PlanningModel) _then) = __$PlanningModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, int weekDay, String startTime, String endTime
});




}
/// @nodoc
class __$PlanningModelCopyWithImpl<$Res>
    implements _$PlanningModelCopyWith<$Res> {
  __$PlanningModelCopyWithImpl(this._self, this._then);

  final _PlanningModel _self;
  final $Res Function(_PlanningModel) _then;

/// Create a copy of PlanningModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? weekDay = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_PlanningModel(
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
