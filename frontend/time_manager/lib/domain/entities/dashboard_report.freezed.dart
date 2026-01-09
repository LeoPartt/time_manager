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
mixin _$DateRange {

 DateTime get from; DateTime get to;
/// Create a copy of DateRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateRangeCopyWith<DateRange> get copyWith => _$DateRangeCopyWithImpl<DateRange>(this as DateRange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'DateRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $DateRangeCopyWith<$Res>  {
  factory $DateRangeCopyWith(DateRange value, $Res Function(DateRange) _then) = _$DateRangeCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$DateRangeCopyWithImpl<$Res>
    implements $DateRangeCopyWith<$Res> {
  _$DateRangeCopyWithImpl(this._self, this._then);

  final DateRange _self;
  final $Res Function(DateRange) _then;

/// Create a copy of DateRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DateRange].
extension DateRangePatterns on DateRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateRange value)  $default,){
final _that = this;
switch (_that) {
case _DateRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateRange value)?  $default,){
final _that = this;
switch (_that) {
case _DateRange() when $default != null:
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
case _DateRange() when $default != null:
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
case _DateRange():
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
case _DateRange() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _DateRange implements DateRange {
  const _DateRange({required this.from, required this.to});
  

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of DateRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateRangeCopyWith<_DateRange> get copyWith => __$DateRangeCopyWithImpl<_DateRange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'DateRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$DateRangeCopyWith<$Res> implements $DateRangeCopyWith<$Res> {
  factory _$DateRangeCopyWith(_DateRange value, $Res Function(_DateRange) _then) = __$DateRangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$DateRangeCopyWithImpl<$Res>
    implements _$DateRangeCopyWith<$Res> {
  __$DateRangeCopyWithImpl(this._self, this._then);

  final _DateRange _self;
  final $Res Function(_DateRange) _then;

/// Create a copy of DateRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_DateRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$PercentKpi {

 double get percent;
/// Create a copy of PercentKpi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PercentKpiCopyWith<PercentKpi> get copyWith => _$PercentKpiCopyWithImpl<PercentKpi>(this as PercentKpi, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PercentKpi&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,percent);

@override
String toString() {
  return 'PercentKpi(percent: $percent)';
}


}

/// @nodoc
abstract mixin class $PercentKpiCopyWith<$Res>  {
  factory $PercentKpiCopyWith(PercentKpi value, $Res Function(PercentKpi) _then) = _$PercentKpiCopyWithImpl;
@useResult
$Res call({
 double percent
});




}
/// @nodoc
class _$PercentKpiCopyWithImpl<$Res>
    implements $PercentKpiCopyWith<$Res> {
  _$PercentKpiCopyWithImpl(this._self, this._then);

  final PercentKpi _self;
  final $Res Function(PercentKpi) _then;

/// Create a copy of PercentKpi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? percent = null,}) {
  return _then(_self.copyWith(
percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PercentKpi].
extension PercentKpiPatterns on PercentKpi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PercentKpi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PercentKpi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PercentKpi value)  $default,){
final _that = this;
switch (_that) {
case _PercentKpi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PercentKpi value)?  $default,){
final _that = this;
switch (_that) {
case _PercentKpi() when $default != null:
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
case _PercentKpi() when $default != null:
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
case _PercentKpi():
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
case _PercentKpi() when $default != null:
return $default(_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _PercentKpi implements PercentKpi {
  const _PercentKpi({required this.percent});
  

@override final  double percent;

/// Create a copy of PercentKpi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PercentKpiCopyWith<_PercentKpi> get copyWith => __$PercentKpiCopyWithImpl<_PercentKpi>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PercentKpi&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,percent);

@override
String toString() {
  return 'PercentKpi(percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$PercentKpiCopyWith<$Res> implements $PercentKpiCopyWith<$Res> {
  factory _$PercentKpiCopyWith(_PercentKpi value, $Res Function(_PercentKpi) _then) = __$PercentKpiCopyWithImpl;
@override @useResult
$Res call({
 double percent
});




}
/// @nodoc
class __$PercentKpiCopyWithImpl<$Res>
    implements _$PercentKpiCopyWith<$Res> {
  __$PercentKpiCopyWithImpl(this._self, this._then);

  final _PercentKpi _self;
  final $Res Function(_PercentKpi) _then;

/// Create a copy of PercentKpi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? percent = null,}) {
  return _then(_PercentKpi(
percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$WorkPoint {

 String get label; DateTime get start; double get value;
/// Create a copy of WorkPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkPointCopyWith<WorkPoint> get copyWith => _$WorkPointCopyWithImpl<WorkPoint>(this as WorkPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,label,start,value);

@override
String toString() {
  return 'WorkPoint(label: $label, start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class $WorkPointCopyWith<$Res>  {
  factory $WorkPointCopyWith(WorkPoint value, $Res Function(WorkPoint) _then) = _$WorkPointCopyWithImpl;
@useResult
$Res call({
 String label, DateTime start, double value
});




}
/// @nodoc
class _$WorkPointCopyWithImpl<$Res>
    implements $WorkPointCopyWith<$Res> {
  _$WorkPointCopyWithImpl(this._self, this._then);

  final WorkPoint _self;
  final $Res Function(WorkPoint) _then;

/// Create a copy of WorkPoint
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


/// Adds pattern-matching-related methods to [WorkPoint].
extension WorkPointPatterns on WorkPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkPoint value)  $default,){
final _that = this;
switch (_that) {
case _WorkPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkPoint value)?  $default,){
final _that = this;
switch (_that) {
case _WorkPoint() when $default != null:
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
case _WorkPoint() when $default != null:
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
case _WorkPoint():
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
case _WorkPoint() when $default != null:
return $default(_that.label,_that.start,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _WorkPoint implements WorkPoint {
  const _WorkPoint({required this.label, required this.start, required this.value});
  

@override final  String label;
@override final  DateTime start;
@override final  double value;

/// Create a copy of WorkPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkPointCopyWith<_WorkPoint> get copyWith => __$WorkPointCopyWithImpl<_WorkPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,label,start,value);

@override
String toString() {
  return 'WorkPoint(label: $label, start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class _$WorkPointCopyWith<$Res> implements $WorkPointCopyWith<$Res> {
  factory _$WorkPointCopyWith(_WorkPoint value, $Res Function(_WorkPoint) _then) = __$WorkPointCopyWithImpl;
@override @useResult
$Res call({
 String label, DateTime start, double value
});




}
/// @nodoc
class __$WorkPointCopyWithImpl<$Res>
    implements _$WorkPointCopyWith<$Res> {
  __$WorkPointCopyWithImpl(this._self, this._then);

  final _WorkPoint _self;
  final $Res Function(_WorkPoint) _then;

/// Create a copy of WorkPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? start = null,Object? value = null,}) {
  return _then(_WorkPoint(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$WorkSeries {

 String get unit; WorkBucket get bucket; List<WorkPoint> get series; double get average;
/// Create a copy of WorkSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkSeriesCopyWith<WorkSeries> get copyWith => _$WorkSeriesCopyWithImpl<WorkSeries>(this as WorkSeries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkSeries&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other.series, series)&&(identical(other.average, average) || other.average == average));
}


@override
int get hashCode => Object.hash(runtimeType,unit,bucket,const DeepCollectionEquality().hash(series),average);

@override
String toString() {
  return 'WorkSeries(unit: $unit, bucket: $bucket, series: $series, average: $average)';
}


}

/// @nodoc
abstract mixin class $WorkSeriesCopyWith<$Res>  {
  factory $WorkSeriesCopyWith(WorkSeries value, $Res Function(WorkSeries) _then) = _$WorkSeriesCopyWithImpl;
@useResult
$Res call({
 String unit, WorkBucket bucket, List<WorkPoint> series, double average
});




}
/// @nodoc
class _$WorkSeriesCopyWithImpl<$Res>
    implements $WorkSeriesCopyWith<$Res> {
  _$WorkSeriesCopyWithImpl(this._self, this._then);

  final WorkSeries _self;
  final $Res Function(WorkSeries) _then;

/// Create a copy of WorkSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? bucket = null,Object? series = null,Object? average = null,}) {
  return _then(_self.copyWith(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as WorkBucket,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<WorkPoint>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkSeries].
extension WorkSeriesPatterns on WorkSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkSeries value)  $default,){
final _that = this;
switch (_that) {
case _WorkSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkSeries value)?  $default,){
final _that = this;
switch (_that) {
case _WorkSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unit,  WorkBucket bucket,  List<WorkPoint> series,  double average)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkSeries() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unit,  WorkBucket bucket,  List<WorkPoint> series,  double average)  $default,) {final _that = this;
switch (_that) {
case _WorkSeries():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unit,  WorkBucket bucket,  List<WorkPoint> series,  double average)?  $default,) {final _that = this;
switch (_that) {
case _WorkSeries() when $default != null:
return $default(_that.unit,_that.bucket,_that.series,_that.average);case _:
  return null;

}
}

}

/// @nodoc


class _WorkSeries implements WorkSeries {
  const _WorkSeries({required this.unit, required this.bucket, required final  List<WorkPoint> series, required this.average}): _series = series;
  

@override final  String unit;
@override final  WorkBucket bucket;
 final  List<WorkPoint> _series;
@override List<WorkPoint> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

@override final  double average;

/// Create a copy of WorkSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkSeriesCopyWith<_WorkSeries> get copyWith => __$WorkSeriesCopyWithImpl<_WorkSeries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkSeries&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other._series, _series)&&(identical(other.average, average) || other.average == average));
}


@override
int get hashCode => Object.hash(runtimeType,unit,bucket,const DeepCollectionEquality().hash(_series),average);

@override
String toString() {
  return 'WorkSeries(unit: $unit, bucket: $bucket, series: $series, average: $average)';
}


}

/// @nodoc
abstract mixin class _$WorkSeriesCopyWith<$Res> implements $WorkSeriesCopyWith<$Res> {
  factory _$WorkSeriesCopyWith(_WorkSeries value, $Res Function(_WorkSeries) _then) = __$WorkSeriesCopyWithImpl;
@override @useResult
$Res call({
 String unit, WorkBucket bucket, List<WorkPoint> series, double average
});




}
/// @nodoc
class __$WorkSeriesCopyWithImpl<$Res>
    implements _$WorkSeriesCopyWith<$Res> {
  __$WorkSeriesCopyWithImpl(this._self, this._then);

  final _WorkSeries _self;
  final $Res Function(_WorkSeries) _then;

/// Create a copy of WorkSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? bucket = null,Object? series = null,Object? average = null,}) {
  return _then(_WorkSeries(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as WorkBucket,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<WorkPoint>,average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DashboardReport {

 ReportMode get mode; DateRange get range; PercentKpi get punctuality; PercentKpi get attendance; WorkSeries get work;
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<DashboardReport> get copyWith => _$DashboardReportCopyWithImpl<DashboardReport>(this as DashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReport&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.range, range) || other.range == range)&&(identical(other.punctuality, punctuality) || other.punctuality == punctuality)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.work, work) || other.work == work));
}


@override
int get hashCode => Object.hash(runtimeType,mode,range,punctuality,attendance,work);

@override
String toString() {
  return 'DashboardReport(mode: $mode, range: $range, punctuality: $punctuality, attendance: $attendance, work: $work)';
}


}

/// @nodoc
abstract mixin class $DashboardReportCopyWith<$Res>  {
  factory $DashboardReportCopyWith(DashboardReport value, $Res Function(DashboardReport) _then) = _$DashboardReportCopyWithImpl;
@useResult
$Res call({
 ReportMode mode, DateRange range, PercentKpi punctuality, PercentKpi attendance, WorkSeries work
});


$DateRangeCopyWith<$Res> get range;$PercentKpiCopyWith<$Res> get punctuality;$PercentKpiCopyWith<$Res> get attendance;$WorkSeriesCopyWith<$Res> get work;

}
/// @nodoc
class _$DashboardReportCopyWithImpl<$Res>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._self, this._then);

  final DashboardReport _self;
  final $Res Function(DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? range = null,Object? punctuality = null,Object? attendance = null,Object? work = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ReportMode,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,punctuality: null == punctuality ? _self.punctuality : punctuality // ignore: cast_nullable_to_non_nullable
as PercentKpi,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as PercentKpi,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as WorkSeries,
  ));
}
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get range {
  
  return $DateRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiCopyWith<$Res> get punctuality {
  
  return $PercentKpiCopyWith<$Res>(_self.punctuality, (value) {
    return _then(_self.copyWith(punctuality: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiCopyWith<$Res> get attendance {
  
  return $PercentKpiCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkSeriesCopyWith<$Res> get work {
  
  return $WorkSeriesCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportMode mode,  DateRange range,  PercentKpi punctuality,  PercentKpi attendance,  WorkSeries work)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportMode mode,  DateRange range,  PercentKpi punctuality,  PercentKpi attendance,  WorkSeries work)  $default,) {final _that = this;
switch (_that) {
case _DashboardReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportMode mode,  DateRange range,  PercentKpi punctuality,  PercentKpi attendance,  WorkSeries work)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.mode,_that.range,_that.punctuality,_that.attendance,_that.work);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardReport implements DashboardReport {
  const _DashboardReport({required this.mode, required this.range, required this.punctuality, required this.attendance, required this.work});
  

@override final  ReportMode mode;
@override final  DateRange range;
@override final  PercentKpi punctuality;
@override final  PercentKpi attendance;
@override final  WorkSeries work;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportCopyWith<_DashboardReport> get copyWith => __$DashboardReportCopyWithImpl<_DashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReport&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.range, range) || other.range == range)&&(identical(other.punctuality, punctuality) || other.punctuality == punctuality)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.work, work) || other.work == work));
}


@override
int get hashCode => Object.hash(runtimeType,mode,range,punctuality,attendance,work);

@override
String toString() {
  return 'DashboardReport(mode: $mode, range: $range, punctuality: $punctuality, attendance: $attendance, work: $work)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportCopyWith<$Res> implements $DashboardReportCopyWith<$Res> {
  factory _$DashboardReportCopyWith(_DashboardReport value, $Res Function(_DashboardReport) _then) = __$DashboardReportCopyWithImpl;
@override @useResult
$Res call({
 ReportMode mode, DateRange range, PercentKpi punctuality, PercentKpi attendance, WorkSeries work
});


@override $DateRangeCopyWith<$Res> get range;@override $PercentKpiCopyWith<$Res> get punctuality;@override $PercentKpiCopyWith<$Res> get attendance;@override $WorkSeriesCopyWith<$Res> get work;

}
/// @nodoc
class __$DashboardReportCopyWithImpl<$Res>
    implements _$DashboardReportCopyWith<$Res> {
  __$DashboardReportCopyWithImpl(this._self, this._then);

  final _DashboardReport _self;
  final $Res Function(_DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? range = null,Object? punctuality = null,Object? attendance = null,Object? work = null,}) {
  return _then(_DashboardReport(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ReportMode,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,punctuality: null == punctuality ? _self.punctuality : punctuality // ignore: cast_nullable_to_non_nullable
as PercentKpi,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as PercentKpi,work: null == work ? _self.work : work // ignore: cast_nullable_to_non_nullable
as WorkSeries,
  ));
}

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get range {
  
  return $DateRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiCopyWith<$Res> get punctuality {
  
  return $PercentKpiCopyWith<$Res>(_self.punctuality, (value) {
    return _then(_self.copyWith(punctuality: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentKpiCopyWith<$Res> get attendance {
  
  return $PercentKpiCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkSeriesCopyWith<$Res> get work {
  
  return $WorkSeriesCopyWith<$Res>(_self.work, (value) {
    return _then(_self.copyWith(work: value));
  });
}
}

/// @nodoc
mixin _$UserDashboardReport {

 int get userId; DashboardReport get dashboard;
/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDashboardReportCopyWith<UserDashboardReport> get copyWith => _$UserDashboardReportCopyWithImpl<UserDashboardReport>(this as UserDashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDashboardReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,userId,dashboard);

@override
String toString() {
  return 'UserDashboardReport(userId: $userId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $UserDashboardReportCopyWith<$Res>  {
  factory $UserDashboardReportCopyWith(UserDashboardReport value, $Res Function(UserDashboardReport) _then) = _$UserDashboardReportCopyWithImpl;
@useResult
$Res call({
 int userId, DashboardReport dashboard
});


$DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$UserDashboardReportCopyWithImpl<$Res>
    implements $UserDashboardReportCopyWith<$Res> {
  _$UserDashboardReportCopyWithImpl(this._self, this._then);

  final UserDashboardReport _self;
  final $Res Function(UserDashboardReport) _then;

/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? dashboard = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}
/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserDashboardReport].
extension UserDashboardReportPatterns on UserDashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _UserDashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _UserDashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  DashboardReport dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDashboardReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  DashboardReport dashboard)  $default,) {final _that = this;
switch (_that) {
case _UserDashboardReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  DashboardReport dashboard)?  $default,) {final _that = this;
switch (_that) {
case _UserDashboardReport() when $default != null:
return $default(_that.userId,_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc


class _UserDashboardReport implements UserDashboardReport {
  const _UserDashboardReport({required this.userId, required this.dashboard});
  

@override final  int userId;
@override final  DashboardReport dashboard;

/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDashboardReportCopyWith<_UserDashboardReport> get copyWith => __$UserDashboardReportCopyWithImpl<_UserDashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDashboardReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,userId,dashboard);

@override
String toString() {
  return 'UserDashboardReport(userId: $userId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$UserDashboardReportCopyWith<$Res> implements $UserDashboardReportCopyWith<$Res> {
  factory _$UserDashboardReportCopyWith(_UserDashboardReport value, $Res Function(_UserDashboardReport) _then) = __$UserDashboardReportCopyWithImpl;
@override @useResult
$Res call({
 int userId, DashboardReport dashboard
});


@override $DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$UserDashboardReportCopyWithImpl<$Res>
    implements _$UserDashboardReportCopyWith<$Res> {
  __$UserDashboardReportCopyWithImpl(this._self, this._then);

  final _UserDashboardReport _self;
  final $Res Function(_UserDashboardReport) _then;

/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? dashboard = null,}) {
  return _then(_UserDashboardReport(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}

/// Create a copy of UserDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

/// @nodoc
mixin _$TeamDashboardReport {

 int get teamId; DashboardReport get dashboard;
/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamDashboardReportCopyWith<TeamDashboardReport> get copyWith => _$TeamDashboardReportCopyWithImpl<TeamDashboardReport>(this as TeamDashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamDashboardReport&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,teamId,dashboard);

@override
String toString() {
  return 'TeamDashboardReport(teamId: $teamId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $TeamDashboardReportCopyWith<$Res>  {
  factory $TeamDashboardReportCopyWith(TeamDashboardReport value, $Res Function(TeamDashboardReport) _then) = _$TeamDashboardReportCopyWithImpl;
@useResult
$Res call({
 int teamId, DashboardReport dashboard
});


$DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$TeamDashboardReportCopyWithImpl<$Res>
    implements $TeamDashboardReportCopyWith<$Res> {
  _$TeamDashboardReportCopyWithImpl(this._self, this._then);

  final TeamDashboardReport _self;
  final $Res Function(TeamDashboardReport) _then;

/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? dashboard = null,}) {
  return _then(_self.copyWith(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}
/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamDashboardReport].
extension TeamDashboardReportPatterns on TeamDashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamDashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamDashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamDashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _TeamDashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamDashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _TeamDashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int teamId,  DashboardReport dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamDashboardReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int teamId,  DashboardReport dashboard)  $default,) {final _that = this;
switch (_that) {
case _TeamDashboardReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int teamId,  DashboardReport dashboard)?  $default,) {final _that = this;
switch (_that) {
case _TeamDashboardReport() when $default != null:
return $default(_that.teamId,_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc


class _TeamDashboardReport implements TeamDashboardReport {
  const _TeamDashboardReport({required this.teamId, required this.dashboard});
  

@override final  int teamId;
@override final  DashboardReport dashboard;

/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamDashboardReportCopyWith<_TeamDashboardReport> get copyWith => __$TeamDashboardReportCopyWithImpl<_TeamDashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamDashboardReport&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,teamId,dashboard);

@override
String toString() {
  return 'TeamDashboardReport(teamId: $teamId, dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$TeamDashboardReportCopyWith<$Res> implements $TeamDashboardReportCopyWith<$Res> {
  factory _$TeamDashboardReportCopyWith(_TeamDashboardReport value, $Res Function(_TeamDashboardReport) _then) = __$TeamDashboardReportCopyWithImpl;
@override @useResult
$Res call({
 int teamId, DashboardReport dashboard
});


@override $DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$TeamDashboardReportCopyWithImpl<$Res>
    implements _$TeamDashboardReportCopyWith<$Res> {
  __$TeamDashboardReportCopyWithImpl(this._self, this._then);

  final _TeamDashboardReport _self;
  final $Res Function(_TeamDashboardReport) _then;

/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? dashboard = null,}) {
  return _then(_TeamDashboardReport(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}

/// Create a copy of TeamDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

/// @nodoc
mixin _$GlobalDashboardReport {

 DashboardReport get dashboard;
/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalDashboardReportCopyWith<GlobalDashboardReport> get copyWith => _$GlobalDashboardReportCopyWithImpl<GlobalDashboardReport>(this as GlobalDashboardReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalDashboardReport&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard);

@override
String toString() {
  return 'GlobalDashboardReport(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $GlobalDashboardReportCopyWith<$Res>  {
  factory $GlobalDashboardReportCopyWith(GlobalDashboardReport value, $Res Function(GlobalDashboardReport) _then) = _$GlobalDashboardReportCopyWithImpl;
@useResult
$Res call({
 DashboardReport dashboard
});


$DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$GlobalDashboardReportCopyWithImpl<$Res>
    implements $GlobalDashboardReportCopyWith<$Res> {
  _$GlobalDashboardReportCopyWithImpl(this._self, this._then);

  final GlobalDashboardReport _self;
  final $Res Function(GlobalDashboardReport) _then;

/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashboard = null,}) {
  return _then(_self.copyWith(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}
/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [GlobalDashboardReport].
extension GlobalDashboardReportPatterns on GlobalDashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalDashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalDashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalDashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _GlobalDashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalDashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalDashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardReport dashboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalDashboardReport() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardReport dashboard)  $default,) {final _that = this;
switch (_that) {
case _GlobalDashboardReport():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardReport dashboard)?  $default,) {final _that = this;
switch (_that) {
case _GlobalDashboardReport() when $default != null:
return $default(_that.dashboard);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalDashboardReport implements GlobalDashboardReport {
  const _GlobalDashboardReport({required this.dashboard});
  

@override final  DashboardReport dashboard;

/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalDashboardReportCopyWith<_GlobalDashboardReport> get copyWith => __$GlobalDashboardReportCopyWithImpl<_GlobalDashboardReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalDashboardReport&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard);

@override
String toString() {
  return 'GlobalDashboardReport(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class _$GlobalDashboardReportCopyWith<$Res> implements $GlobalDashboardReportCopyWith<$Res> {
  factory _$GlobalDashboardReportCopyWith(_GlobalDashboardReport value, $Res Function(_GlobalDashboardReport) _then) = __$GlobalDashboardReportCopyWithImpl;
@override @useResult
$Res call({
 DashboardReport dashboard
});


@override $DashboardReportCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$GlobalDashboardReportCopyWithImpl<$Res>
    implements _$GlobalDashboardReportCopyWith<$Res> {
  __$GlobalDashboardReportCopyWithImpl(this._self, this._then);

  final _GlobalDashboardReport _self;
  final $Res Function(_GlobalDashboardReport) _then;

/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashboard = null,}) {
  return _then(_GlobalDashboardReport(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as DashboardReport,
  ));
}

/// Create a copy of GlobalDashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<$Res> get dashboard {
  
  return $DashboardReportCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

// dart format on
