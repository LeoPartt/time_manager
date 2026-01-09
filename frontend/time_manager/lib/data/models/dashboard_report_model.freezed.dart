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
mixin _$DateRangeModel {

 DateTime get from; DateTime get to;
/// Create a copy of DateRangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateRangeModelCopyWith<DateRangeModel> get copyWith => _$DateRangeModelCopyWithImpl<DateRangeModel>(this as DateRangeModel, _$identity);

  /// Serializes this DateRangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateRangeModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'DateRangeModel(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $DateRangeModelCopyWith<$Res>  {
  factory $DateRangeModelCopyWith(DateRangeModel value, $Res Function(DateRangeModel) _then) = _$DateRangeModelCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$DateRangeModelCopyWithImpl<$Res>
    implements $DateRangeModelCopyWith<$Res> {
  _$DateRangeModelCopyWithImpl(this._self, this._then);

  final DateRangeModel _self;
  final $Res Function(DateRangeModel) _then;

/// Create a copy of DateRangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DateRangeModel].
extension DateRangeModelPatterns on DateRangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateRangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateRangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateRangeModel value)  $default,){
final _that = this;
switch (_that) {
case _DateRangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateRangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _DateRangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateRangeModel() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)  $default,) {final _that = this;
switch (_that) {
case _DateRangeModel():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to)?  $default,) {final _that = this;
switch (_that) {
case _DateRangeModel() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateRangeModel extends DateRangeModel {
  const _DateRangeModel({required this.from, required this.to}): super._();
  factory _DateRangeModel.fromJson(Map<String, dynamic> json) => _$DateRangeModelFromJson(json);

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of DateRangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateRangeModelCopyWith<_DateRangeModel> get copyWith => __$DateRangeModelCopyWithImpl<_DateRangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateRangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateRangeModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'DateRangeModel(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$DateRangeModelCopyWith<$Res> implements $DateRangeModelCopyWith<$Res> {
  factory _$DateRangeModelCopyWith(_DateRangeModel value, $Res Function(_DateRangeModel) _then) = __$DateRangeModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$DateRangeModelCopyWithImpl<$Res>
    implements _$DateRangeModelCopyWith<$Res> {
  __$DateRangeModelCopyWithImpl(this._self, this._then);

  final _DateRangeModel _self;
  final $Res Function(_DateRangeModel) _then;

/// Create a copy of DateRangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_DateRangeModel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PercentKpiModel {

 double get percent;
/// Create a copy of PercentKpiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PercentKpiModelCopyWith<PercentKpiModel> get copyWith => _$PercentKpiModelCopyWithImpl<PercentKpiModel>(this as PercentKpiModel, _$identity);

  /// Serializes this PercentKpiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PercentKpiModel&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,percent);

@override
String toString() {
  return 'PercentKpiModel(percent: $percent)';
}


}

/// @nodoc
abstract mixin class $PercentKpiModelCopyWith<$Res>  {
  factory $PercentKpiModelCopyWith(PercentKpiModel value, $Res Function(PercentKpiModel) _then) = _$PercentKpiModelCopyWithImpl;
@useResult
$Res call({
 double percent
});




}
/// @nodoc
class _$PercentKpiModelCopyWithImpl<$Res>
    implements $PercentKpiModelCopyWith<$Res> {
  _$PercentKpiModelCopyWithImpl(this._self, this._then);

  final PercentKpiModel _self;
  final $Res Function(PercentKpiModel) _then;

/// Create a copy of PercentKpiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? percent = null,}) {
  return _then(_self.copyWith(
percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PercentKpiModel].
extension PercentKpiModelPatterns on PercentKpiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PercentKpiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PercentKpiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PercentKpiModel value)  $default,){
final _that = this;
switch (_that) {
case _PercentKpiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PercentKpiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PercentKpiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PercentKpiModel() when $default != null:
return $default(_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double percent)  $default,) {final _that = this;
switch (_that) {
case _PercentKpiModel():
return $default(_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double percent)?  $default,) {final _that = this;
switch (_that) {
case _PercentKpiModel() when $default != null:
return $default(_that.percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PercentKpiModel extends PercentKpiModel {
  const _PercentKpiModel({required this.percent}): super._();
  factory _PercentKpiModel.fromJson(Map<String, dynamic> json) => _$PercentKpiModelFromJson(json);

@override final  double percent;

/// Create a copy of PercentKpiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PercentKpiModelCopyWith<_PercentKpiModel> get copyWith => __$PercentKpiModelCopyWithImpl<_PercentKpiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PercentKpiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PercentKpiModel&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,percent);

@override
String toString() {
  return 'PercentKpiModel(percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$PercentKpiModelCopyWith<$Res> implements $PercentKpiModelCopyWith<$Res> {
  factory _$PercentKpiModelCopyWith(_PercentKpiModel value, $Res Function(_PercentKpiModel) _then) = __$PercentKpiModelCopyWithImpl;
@override @useResult
$Res call({
 double percent
});




}
/// @nodoc
class __$PercentKpiModelCopyWithImpl<$Res>
    implements _$PercentKpiModelCopyWith<$Res> {
  __$PercentKpiModelCopyWithImpl(this._self, this._then);

  final _PercentKpiModel _self;
  final $Res Function(_PercentKpiModel) _then;

/// Create a copy of PercentKpiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? percent = null,}) {
  return _then(_PercentKpiModel(
percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WorkPointModel {

 String get label; DateTime get start; double get value;
/// Create a copy of WorkPointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkPointModelCopyWith<WorkPointModel> get copyWith => _$WorkPointModelCopyWithImpl<WorkPointModel>(this as WorkPointModel, _$identity);

  /// Serializes this WorkPointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkPointModel&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,start,value);

@override
String toString() {
  return 'WorkPointModel(label: $label, start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class $WorkPointModelCopyWith<$Res>  {
  factory $WorkPointModelCopyWith(WorkPointModel value, $Res Function(WorkPointModel) _then) = _$WorkPointModelCopyWithImpl;
@useResult
$Res call({
 String label, DateTime start, double value
});




}
/// @nodoc
class _$WorkPointModelCopyWithImpl<$Res>
    implements $WorkPointModelCopyWith<$Res> {
  _$WorkPointModelCopyWithImpl(this._self, this._then);

  final WorkPointModel _self;
  final $Res Function(WorkPointModel) _then;

/// Create a copy of WorkPointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? start = null,Object? value = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkPointModel].
extension WorkPointModelPatterns on WorkPointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkPointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkPointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkPointModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkPointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkPointModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkPointModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  DateTime start,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkPointModel() when $default != null:
return $default(_that.label,_that.start,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  DateTime start,  double value)  $default,) {final _that = this;
switch (_that) {
case _WorkPointModel():
return $default(_that.label,_that.start,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  DateTime start,  double value)?  $default,) {final _that = this;
switch (_that) {
case _WorkPointModel() when $default != null:
return $default(_that.label,_that.start,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkPointModel extends WorkPointModel {
  const _WorkPointModel({required this.label, required this.start, required this.value}): super._();
  factory _WorkPointModel.fromJson(Map<String, dynamic> json) => _$WorkPointModelFromJson(json);

@override final  String label;
@override final  DateTime start;
@override final  double value;

/// Create a copy of WorkPointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkPointModelCopyWith<_WorkPointModel> get copyWith => __$WorkPointModelCopyWithImpl<_WorkPointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkPointModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkPointModel&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,start,value);

@override
String toString() {
  return 'WorkPointModel(label: $label, start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class _$WorkPointModelCopyWith<$Res> implements $WorkPointModelCopyWith<$Res> {
  factory _$WorkPointModelCopyWith(_WorkPointModel value, $Res Function(_WorkPointModel) _then) = __$WorkPointModelCopyWithImpl;
@override @useResult
$Res call({
 String label, DateTime start, double value
});




}
/// @nodoc
class __$WorkPointModelCopyWithImpl<$Res>
    implements _$WorkPointModelCopyWith<$Res> {
  __$WorkPointModelCopyWithImpl(this._self, this._then);

  final _WorkPointModel _self;
  final $Res Function(_WorkPointModel) _then;

/// Create a copy of WorkPointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? start = null,Object? value = null,}) {
  return _then(_WorkPointModel(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WorkSeriesModel {

 String get unit; WorkBucket get bucket; List<WorkPointModel> get series; double get average;
/// Create a copy of WorkSeriesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkSeriesModelCopyWith<WorkSeriesModel> get copyWith => _$WorkSeriesModelCopyWithImpl<WorkSeriesModel>(this as WorkSeriesModel, _$identity);

  /// Serializes this WorkSeriesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkSeriesModel&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other.series, series)&&(identical(other.average, average) || other.average == average));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unit,bucket,const DeepCollectionEquality().hash(series),average);

@override
String toString() {
  return 'WorkSeriesModel(unit: $unit, bucket: $bucket, series: $series, average: $average)';
}


}

/// @nodoc
abstract mixin class $WorkSeriesModelCopyWith<$Res>  {
  factory $WorkSeriesModelCopyWith(WorkSeriesModel value, $Res Function(WorkSeriesModel) _then) = _$WorkSeriesModelCopyWithImpl;
@useResult
$Res call({
 String unit, WorkBucket bucket, List<WorkPointModel> series, double average
});




}
/// @nodoc
class _$WorkSeriesModelCopyWithImpl<$Res>
    implements $WorkSeriesModelCopyWith<$Res> {
  _$WorkSeriesModelCopyWithImpl(this._self, this._then);

  final WorkSeriesModel _self;
  final $Res Function(WorkSeriesModel) _then;

/// Create a copy of WorkSeriesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? bucket = null,Object? series = null,Object? average = null,}) {
  return _then(_self.copyWith(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as WorkBucket,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<WorkPointModel>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkSeriesModel].
extension WorkSeriesModelPatterns on WorkSeriesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkSeriesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkSeriesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkSeriesModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkSeriesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkSeriesModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkSeriesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unit,  WorkBucket bucket,  List<WorkPointModel> series,  double average)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkSeriesModel() when $default != null:
return $default(_that.unit,_that.bucket,_that.series,_that.average);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unit,  WorkBucket bucket,  List<WorkPointModel> series,  double average)  $default,) {final _that = this;
switch (_that) {
case _WorkSeriesModel():
return $default(_that.unit,_that.bucket,_that.series,_that.average);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unit,  WorkBucket bucket,  List<WorkPointModel> series,  double average)?  $default,) {final _that = this;
switch (_that) {
case _WorkSeriesModel() when $default != null:
return $default(_that.unit,_that.bucket,_that.series,_that.average);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkSeriesModel extends WorkSeriesModel {
  const _WorkSeriesModel({required this.unit, required this.bucket, required final  List<WorkPointModel> series, required this.average}): _series = series,super._();
  factory _WorkSeriesModel.fromJson(Map<String, dynamic> json) => _$WorkSeriesModelFromJson(json);

@override final  String unit;
@override final  WorkBucket bucket;
 final  List<WorkPointModel> _series;
@override List<WorkPointModel> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

@override final  double average;

/// Create a copy of WorkSeriesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkSeriesModelCopyWith<_WorkSeriesModel> get copyWith => __$WorkSeriesModelCopyWithImpl<_WorkSeriesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkSeriesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkSeriesModel&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other._series, _series)&&(identical(other.average, average) || other.average == average));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unit,bucket,const DeepCollectionEquality().hash(_series),average);

@override
String toString() {
  return 'WorkSeriesModel(unit: $unit, bucket: $bucket, series: $series, average: $average)';
}


}

/// @nodoc
abstract mixin class _$WorkSeriesModelCopyWith<$Res> implements $WorkSeriesModelCopyWith<$Res> {
  factory _$WorkSeriesModelCopyWith(_WorkSeriesModel value, $Res Function(_WorkSeriesModel) _then) = __$WorkSeriesModelCopyWithImpl;
@override @useResult
$Res call({
 String unit, WorkBucket bucket, List<WorkPointModel> series, double average
});




}
/// @nodoc
class __$WorkSeriesModelCopyWithImpl<$Res>
    implements _$WorkSeriesModelCopyWith<$Res> {
  __$WorkSeriesModelCopyWithImpl(this._self, this._then);

  final _WorkSeriesModel _self;
  final $Res Function(_WorkSeriesModel) _then;

/// Create a copy of WorkSeriesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? bucket = null,Object? series = null,Object? average = null,}) {
  return _then(_WorkSeriesModel(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as WorkBucket,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<WorkPointModel>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardReportModel {

 ReportMode get mode; DateRangeModel get range; PercentKpiModel get punctuality; PercentKpiModel get attendance; WorkSeriesModel get work;
/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<DashboardReportModel> get copyWith => _$DashboardReportModelCopyWithImpl<DashboardReportModel>(this as DashboardReportModel, _$identity);

  /// Serializes this DashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReportModel&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.range, range) || other.range == range)&&(identical(other.punctuality, punctuality) || other.punctuality == punctuality)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.work, work) || other.work == work));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,range,punctuality,attendance,work);

@override
String toString() {
  return 'DashboardReportModel(mode: $mode, range: $range, punctuality: $punctuality, attendance: $attendance, work: $work)';
}


}

/// @nodoc
abstract mixin class $DashboardReportModelCopyWith<$Res>  {
  factory $DashboardReportModelCopyWith(DashboardReportModel value, $Res Function(DashboardReportModel) _then) = _$DashboardReportModelCopyWithImpl;
@useResult
$Res call({
 ReportMode mode, DateRangeModel range, PercentKpiModel punctuality, PercentKpiModel attendance, WorkSeriesModel work
});


$DateRangeModelCopyWith<$Res> get range;$PercentKpiModelCopyWith<$Res> get punctuality;$PercentKpiModelCopyWith<$Res> get attendance;$WorkSeriesModelCopyWith<$Res> get work;

}
/// @nodoc
class _$DashboardReportModelCopyWithImpl<$Res>
    implements $DashboardReportModelCopyWith<$Res> {
  _$DashboardReportModelCopyWithImpl(this._self, this._then);

  final DashboardReportModel _self;
  final $Res Function(DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? range = null,Object? punctuality = null,Object? attendance = null,Object? work = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ReportMode,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRangeModel,punctuality: null == punctuality ? _self.punctuality : punctuality // ignore: cast_nullable_to_non_nullable
as PercentKpiModel,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as PercentKpiModel,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as WorkSeriesModel,
  ));
}
/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeModelCopyWith<$Res> get range {
  
  return $DateRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiModelCopyWith<$Res> get punctuality {
  
  return $PercentKpiModelCopyWith<$Res>(_self.punctuality, (value) {
    return _then(_self.copyWith(punctuality: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiModelCopyWith<$Res> get attendance {
  
  return $PercentKpiModelCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkSeriesModelCopyWith<$Res> get work {
  
  return $WorkSeriesModelCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportMode mode,  DateRangeModel range,  PercentKpiModel punctuality,  PercentKpiModel attendance,  WorkSeriesModel work)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that.mode,_that.range,_that.punctuality,_that.attendance,_that.work);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportMode mode,  DateRangeModel range,  PercentKpiModel punctuality,  PercentKpiModel attendance,  WorkSeriesModel work)  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel():
return $default(_that.mode,_that.range,_that.punctuality,_that.attendance,_that.work);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportMode mode,  DateRangeModel range,  PercentKpiModel punctuality,  PercentKpiModel attendance,  WorkSeriesModel work)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReportModel() when $default != null:
return $default(_that.mode,_that.range,_that.punctuality,_that.attendance,_that.work);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReportModel extends DashboardReportModel {
  const _DashboardReportModel({required this.mode, required this.range, required this.punctuality, required this.attendance, required this.work}): super._();
  factory _DashboardReportModel.fromJson(Map<String, dynamic> json) => _$DashboardReportModelFromJson(json);

@override final  ReportMode mode;
@override final  DateRangeModel range;
@override final  PercentKpiModel punctuality;
@override final  PercentKpiModel attendance;
@override final  WorkSeriesModel work;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReportModel&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.range, range) || other.range == range)&&(identical(other.punctuality, punctuality) || other.punctuality == punctuality)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.work, work) || other.work == work));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,range,punctuality,attendance,work);

@override
String toString() {
  return 'DashboardReportModel(mode: $mode, range: $range, punctuality: $punctuality, attendance: $attendance, work: $work)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportModelCopyWith<$Res> implements $DashboardReportModelCopyWith<$Res> {
  factory _$DashboardReportModelCopyWith(_DashboardReportModel value, $Res Function(_DashboardReportModel) _then) = __$DashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
 ReportMode mode, DateRangeModel range, PercentKpiModel punctuality, PercentKpiModel attendance, WorkSeriesModel work
});


@override $DateRangeModelCopyWith<$Res> get range;@override $PercentKpiModelCopyWith<$Res> get punctuality;@override $PercentKpiModelCopyWith<$Res> get attendance;@override $WorkSeriesModelCopyWith<$Res> get work;

}
/// @nodoc
class __$DashboardReportModelCopyWithImpl<$Res>
    implements _$DashboardReportModelCopyWith<$Res> {
  __$DashboardReportModelCopyWithImpl(this._self, this._then);

  final _DashboardReportModel _self;
  final $Res Function(_DashboardReportModel) _then;

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? range = null,Object? punctuality = null,Object? attendance = null,Object? work = null,}) {
  return _then(_DashboardReportModel(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ReportMode,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRangeModel,punctuality: null == punctuality ? _self.punctuality : punctuality // ignore: cast_nullable_to_non_nullable
as PercentKpiModel,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as PercentKpiModel,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as WorkSeriesModel,
  ));
}

/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeModelCopyWith<$Res> get range {
  
  return $DateRangeModelCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiModelCopyWith<$Res> get punctuality {
  
  return $PercentKpiModelCopyWith<$Res>(_self.punctuality, (value) {
    return _then(_self.copyWith(punctuality: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiModelCopyWith<$Res> get attendance {
  
  return $PercentKpiModelCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkSeriesModelCopyWith<$Res> get work {
  
  return $WorkSeriesModelCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
  });
}
}


/// @nodoc
mixin _$UserDashboardReportModel {

 int get userId; DashboardReportModel get dashboard;
/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDashboardReportModelCopyWith<UserDashboardReportModel> get copyWith => _$UserDashboardReportModelCopyWithImpl<UserDashboardReportModel>(this as UserDashboardReportModel, _$identity);

  /// Serializes this UserDashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDashboardReportModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,dashboard);

@override
String toString() {
  return 'UserDashboardReportModel(userId: $userId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $UserDashboardReportModelCopyWith<$Res>  {
  factory $UserDashboardReportModelCopyWith(UserDashboardReportModel value, $Res Function(UserDashboardReportModel) _then) = _$UserDashboardReportModelCopyWithImpl;
@useResult
$Res call({
 int userId, DashboardReportModel dashboard
});


$DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$UserDashboardReportModelCopyWithImpl<$Res>
    implements $UserDashboardReportModelCopyWith<$Res> {
  _$UserDashboardReportModelCopyWithImpl(this._self, this._then);

  final UserDashboardReportModel _self;
  final $Res Function(UserDashboardReportModel) _then;

/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? dashboard = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}
/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserDashboardReportModel].
extension UserDashboardReportModelPatterns on UserDashboardReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDashboardReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDashboardReportModel value)  $default,){
final _that = this;
switch (_that) {
case _UserDashboardReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDashboardReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  DashboardReportModel dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDashboardReportModel() when $default != null:
return $default(_that.userId,_that.dashboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  DashboardReportModel dashboard)  $default,) {final _that = this;
switch (_that) {
case _UserDashboardReportModel():
return $default(_that.userId,_that.dashboard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  DashboardReportModel dashboard)?  $default,) {final _that = this;
switch (_that) {
case _UserDashboardReportModel() when $default != null:
return $default(_that.userId,_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDashboardReportModel extends UserDashboardReportModel {
  const _UserDashboardReportModel({required this.userId, required this.dashboard}): super._();
  factory _UserDashboardReportModel.fromJson(Map<String, dynamic> json) => _$UserDashboardReportModelFromJson(json);

@override final  int userId;
@override final  DashboardReportModel dashboard;

/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDashboardReportModelCopyWith<_UserDashboardReportModel> get copyWith => __$UserDashboardReportModelCopyWithImpl<_UserDashboardReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDashboardReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDashboardReportModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,dashboard);

@override
String toString() {
  return 'UserDashboardReportModel(userId: $userId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$UserDashboardReportModelCopyWith<$Res> implements $UserDashboardReportModelCopyWith<$Res> {
  factory _$UserDashboardReportModelCopyWith(_UserDashboardReportModel value, $Res Function(_UserDashboardReportModel) _then) = __$UserDashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
 int userId, DashboardReportModel dashboard
});


@override $DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$UserDashboardReportModelCopyWithImpl<$Res>
    implements _$UserDashboardReportModelCopyWith<$Res> {
  __$UserDashboardReportModelCopyWithImpl(this._self, this._then);

  final _UserDashboardReportModel _self;
  final $Res Function(_UserDashboardReportModel) _then;

/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? dashboard = null,}) {
  return _then(_UserDashboardReportModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}

/// Create a copy of UserDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// @nodoc
mixin _$TeamDashboardReportModel {

 int get teamId; DashboardReportModel get dashboard;
/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamDashboardReportModelCopyWith<TeamDashboardReportModel> get copyWith => _$TeamDashboardReportModelCopyWithImpl<TeamDashboardReportModel>(this as TeamDashboardReportModel, _$identity);

  /// Serializes this TeamDashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamDashboardReportModel&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,dashboard);

@override
String toString() {
  return 'TeamDashboardReportModel(teamId: $teamId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $TeamDashboardReportModelCopyWith<$Res>  {
  factory $TeamDashboardReportModelCopyWith(TeamDashboardReportModel value, $Res Function(TeamDashboardReportModel) _then) = _$TeamDashboardReportModelCopyWithImpl;
@useResult
$Res call({
 int teamId, DashboardReportModel dashboard
});


$DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$TeamDashboardReportModelCopyWithImpl<$Res>
    implements $TeamDashboardReportModelCopyWith<$Res> {
  _$TeamDashboardReportModelCopyWithImpl(this._self, this._then);

  final TeamDashboardReportModel _self;
  final $Res Function(TeamDashboardReportModel) _then;

/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? dashboard = null,}) {
  return _then(_self.copyWith(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}
/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamDashboardReportModel].
extension TeamDashboardReportModelPatterns on TeamDashboardReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamDashboardReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamDashboardReportModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamDashboardReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamDashboardReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int teamId,  DashboardReportModel dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamDashboardReportModel() when $default != null:
return $default(_that.teamId,_that.dashboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int teamId,  DashboardReportModel dashboard)  $default,) {final _that = this;
switch (_that) {
case _TeamDashboardReportModel():
return $default(_that.teamId,_that.dashboard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int teamId,  DashboardReportModel dashboard)?  $default,) {final _that = this;
switch (_that) {
case _TeamDashboardReportModel() when $default != null:
return $default(_that.teamId,_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamDashboardReportModel extends TeamDashboardReportModel {
  const _TeamDashboardReportModel({required this.teamId, required this.dashboard}): super._();
  factory _TeamDashboardReportModel.fromJson(Map<String, dynamic> json) => _$TeamDashboardReportModelFromJson(json);

@override final  int teamId;
@override final  DashboardReportModel dashboard;

/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamDashboardReportModelCopyWith<_TeamDashboardReportModel> get copyWith => __$TeamDashboardReportModelCopyWithImpl<_TeamDashboardReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamDashboardReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamDashboardReportModel&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,dashboard);

@override
String toString() {
  return 'TeamDashboardReportModel(teamId: $teamId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$TeamDashboardReportModelCopyWith<$Res> implements $TeamDashboardReportModelCopyWith<$Res> {
  factory _$TeamDashboardReportModelCopyWith(_TeamDashboardReportModel value, $Res Function(_TeamDashboardReportModel) _then) = __$TeamDashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
 int teamId, DashboardReportModel dashboard
});


@override $DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$TeamDashboardReportModelCopyWithImpl<$Res>
    implements _$TeamDashboardReportModelCopyWith<$Res> {
  __$TeamDashboardReportModelCopyWithImpl(this._self, this._then);

  final _TeamDashboardReportModel _self;
  final $Res Function(_TeamDashboardReportModel) _then;

/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? dashboard = null,}) {
  return _then(_TeamDashboardReportModel(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}

/// Create a copy of TeamDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// @nodoc
mixin _$GlobalDashboardReportModel {

 DashboardReportModel get dashboard;
/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalDashboardReportModelCopyWith<GlobalDashboardReportModel> get copyWith => _$GlobalDashboardReportModelCopyWithImpl<GlobalDashboardReportModel>(this as GlobalDashboardReportModel, _$identity);

  /// Serializes this GlobalDashboardReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalDashboardReportModel&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dashboard);

@override
String toString() {
  return 'GlobalDashboardReportModel(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $GlobalDashboardReportModelCopyWith<$Res>  {
  factory $GlobalDashboardReportModelCopyWith(GlobalDashboardReportModel value, $Res Function(GlobalDashboardReportModel) _then) = _$GlobalDashboardReportModelCopyWithImpl;
@useResult
$Res call({
 DashboardReportModel dashboard
});


$DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$GlobalDashboardReportModelCopyWithImpl<$Res>
    implements $GlobalDashboardReportModelCopyWith<$Res> {
  _$GlobalDashboardReportModelCopyWithImpl(this._self, this._then);

  final GlobalDashboardReportModel _self;
  final $Res Function(GlobalDashboardReportModel) _then;

/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashboard = null,}) {
  return _then(_self.copyWith(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}
/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [GlobalDashboardReportModel].
extension GlobalDashboardReportModelPatterns on GlobalDashboardReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalDashboardReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalDashboardReportModel value)  $default,){
final _that = this;
switch (_that) {
case _GlobalDashboardReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalDashboardReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalDashboardReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardReportModel dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalDashboardReportModel() when $default != null:
return $default(_that.dashboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardReportModel dashboard)  $default,) {final _that = this;
switch (_that) {
case _GlobalDashboardReportModel():
return $default(_that.dashboard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardReportModel dashboard)?  $default,) {final _that = this;
switch (_that) {
case _GlobalDashboardReportModel() when $default != null:
return $default(_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalDashboardReportModel extends GlobalDashboardReportModel {
  const _GlobalDashboardReportModel({required this.dashboard}): super._();
  factory _GlobalDashboardReportModel.fromJson(Map<String, dynamic> json) => _$GlobalDashboardReportModelFromJson(json);

@override final  DashboardReportModel dashboard;

/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalDashboardReportModelCopyWith<_GlobalDashboardReportModel> get copyWith => __$GlobalDashboardReportModelCopyWithImpl<_GlobalDashboardReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalDashboardReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalDashboardReportModel&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dashboard);

@override
String toString() {
  return 'GlobalDashboardReportModel(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$GlobalDashboardReportModelCopyWith<$Res> implements $GlobalDashboardReportModelCopyWith<$Res> {
  factory _$GlobalDashboardReportModelCopyWith(_GlobalDashboardReportModel value, $Res Function(_GlobalDashboardReportModel) _then) = __$GlobalDashboardReportModelCopyWithImpl;
@override @useResult
$Res call({
 DashboardReportModel dashboard
});


@override $DashboardReportModelCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$GlobalDashboardReportModelCopyWithImpl<$Res>
    implements _$GlobalDashboardReportModelCopyWith<$Res> {
  __$GlobalDashboardReportModelCopyWithImpl(this._self, this._then);

  final _GlobalDashboardReportModel _self;
  final $Res Function(_GlobalDashboardReportModel) _then;

/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashboard = null,}) {
  return _then(_GlobalDashboardReportModel(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReportModel,
  ));
}

/// Create a copy of GlobalDashboardReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportModelCopyWith<$Res> get dashboard {
  
  return $DashboardReportModelCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

// dart format on
