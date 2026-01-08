// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClockModel {

 int? get id; String get arrivalTs; String? get departureTs;
/// Create a copy of ClockModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClockModelCopyWith<ClockModel> get copyWith => _$ClockModelCopyWithImpl<ClockModel>(this as ClockModel, _$identity);

  /// Serializes this ClockModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockModel&&(identical(other.id, id) || other.id == id)&&(identical(other.arrivalTs, arrivalTs) || other.arrivalTs == arrivalTs)&&(identical(other.departureTs, departureTs) || other.departureTs == departureTs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arrivalTs,departureTs);

@override
String toString() {
  return 'ClockModel(id: $id, arrivalTs: $arrivalTs, departureTs: $departureTs)';
}


}

/// @nodoc
abstract mixin class $ClockModelCopyWith<$Res>  {
  factory $ClockModelCopyWith(ClockModel value, $Res Function(ClockModel) _then) = _$ClockModelCopyWithImpl;
@useResult
$Res call({
 int? id, String arrivalTs, String? departureTs
});




}
/// @nodoc
class _$ClockModelCopyWithImpl<$Res>
    implements $ClockModelCopyWith<$Res> {
  _$ClockModelCopyWithImpl(this._self, this._then);

  final ClockModel _self;
  final $Res Function(ClockModel) _then;

/// Create a copy of ClockModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? arrivalTs = null,Object? departureTs = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,arrivalTs: null == arrivalTs ? _self.arrivalTs : arrivalTs // ignore: cast_nullable_to_non_nullable
as String,departureTs: freezed == departureTs ? _self.departureTs : departureTs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClockModel].
extension ClockModelPatterns on ClockModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClockModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClockModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClockModel value)  $default,){
final _that = this;
switch (_that) {
case _ClockModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClockModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClockModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String arrivalTs,  String? departureTs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClockModel() when $default != null:
return $default(_that.id,_that.arrivalTs,_that.departureTs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String arrivalTs,  String? departureTs)  $default,) {final _that = this;
switch (_that) {
case _ClockModel():
return $default(_that.id,_that.arrivalTs,_that.departureTs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String arrivalTs,  String? departureTs)?  $default,) {final _that = this;
switch (_that) {
case _ClockModel() when $default != null:
return $default(_that.id,_that.arrivalTs,_that.departureTs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClockModel implements ClockModel {
  const _ClockModel({this.id, required this.arrivalTs, this.departureTs});
  factory _ClockModel.fromJson(Map<String, dynamic> json) => _$ClockModelFromJson(json);

@override final  int? id;
@override final  String arrivalTs;
@override final  String? departureTs;

/// Create a copy of ClockModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClockModelCopyWith<_ClockModel> get copyWith => __$ClockModelCopyWithImpl<_ClockModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClockModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClockModel&&(identical(other.id, id) || other.id == id)&&(identical(other.arrivalTs, arrivalTs) || other.arrivalTs == arrivalTs)&&(identical(other.departureTs, departureTs) || other.departureTs == departureTs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arrivalTs,departureTs);

@override
String toString() {
  return 'ClockModel(id: $id, arrivalTs: $arrivalTs, departureTs: $departureTs)';
}


}

/// @nodoc
abstract mixin class _$ClockModelCopyWith<$Res> implements $ClockModelCopyWith<$Res> {
  factory _$ClockModelCopyWith(_ClockModel value, $Res Function(_ClockModel) _then) = __$ClockModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String arrivalTs, String? departureTs
});




}
/// @nodoc
class __$ClockModelCopyWithImpl<$Res>
    implements _$ClockModelCopyWith<$Res> {
  __$ClockModelCopyWithImpl(this._self, this._then);

  final _ClockModel _self;
  final $Res Function(_ClockModel) _then;

/// Create a copy of ClockModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? arrivalTs = null,Object? departureTs = freezed,}) {
  return _then(_ClockModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,arrivalTs: null == arrivalTs ? _self.arrivalTs : arrivalTs // ignore: cast_nullable_to_non_nullable
as String,departureTs: freezed == departureTs ? _self.departureTs : departureTs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
