// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClockState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockState()';
}


}

/// @nodoc
class $ClockStateCopyWith<$Res>  {
$ClockStateCopyWith(ClockState _, $Res Function(ClockState) __);
}


/// Adds pattern-matching-related methods to [ClockState].
extension ClockStatePatterns on ClockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( ClockLoading value)?  loading,TResult Function( StatusClockedIn value)?  statusClockedIn,TResult Function( StatusClockedOut value)?  statusClockedOut,TResult Function( ActionClockedIn value)?  actionClockedIn,TResult Function( ActionClockedOut value)?  actionClockedOut,TResult Function( ClockError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case ClockLoading() when loading != null:
return loading(_that);case StatusClockedIn() when statusClockedIn != null:
return statusClockedIn(_that);case StatusClockedOut() when statusClockedOut != null:
return statusClockedOut(_that);case ActionClockedIn() when actionClockedIn != null:
return actionClockedIn(_that);case ActionClockedOut() when actionClockedOut != null:
return actionClockedOut(_that);case ClockError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( ClockLoading value)  loading,required TResult Function( StatusClockedIn value)  statusClockedIn,required TResult Function( StatusClockedOut value)  statusClockedOut,required TResult Function( ActionClockedIn value)  actionClockedIn,required TResult Function( ActionClockedOut value)  actionClockedOut,required TResult Function( ClockError value)  error,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case ClockLoading():
return loading(_that);case StatusClockedIn():
return statusClockedIn(_that);case StatusClockedOut():
return statusClockedOut(_that);case ActionClockedIn():
return actionClockedIn(_that);case ActionClockedOut():
return actionClockedOut(_that);case ClockError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( ClockLoading value)?  loading,TResult? Function( StatusClockedIn value)?  statusClockedIn,TResult? Function( StatusClockedOut value)?  statusClockedOut,TResult? Function( ActionClockedIn value)?  actionClockedIn,TResult? Function( ActionClockedOut value)?  actionClockedOut,TResult? Function( ClockError value)?  error,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case ClockLoading() when loading != null:
return loading(_that);case StatusClockedIn() when statusClockedIn != null:
return statusClockedIn(_that);case StatusClockedOut() when statusClockedOut != null:
return statusClockedOut(_that);case ActionClockedIn() when actionClockedIn != null:
return actionClockedIn(_that);case ActionClockedOut() when actionClockedOut != null:
return actionClockedOut(_that);case ClockError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Clock clock)?  statusClockedIn,TResult Function( Clock clock)?  statusClockedOut,TResult Function( Clock clock)?  actionClockedIn,TResult Function( Clock clock)?  actionClockedOut,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case ClockLoading() when loading != null:
return loading();case StatusClockedIn() when statusClockedIn != null:
return statusClockedIn(_that.clock);case StatusClockedOut() when statusClockedOut != null:
return statusClockedOut(_that.clock);case ActionClockedIn() when actionClockedIn != null:
return actionClockedIn(_that.clock);case ActionClockedOut() when actionClockedOut != null:
return actionClockedOut(_that.clock);case ClockError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Clock clock)  statusClockedIn,required TResult Function( Clock clock)  statusClockedOut,required TResult Function( Clock clock)  actionClockedIn,required TResult Function( Clock clock)  actionClockedOut,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case ClockLoading():
return loading();case StatusClockedIn():
return statusClockedIn(_that.clock);case StatusClockedOut():
return statusClockedOut(_that.clock);case ActionClockedIn():
return actionClockedIn(_that.clock);case ActionClockedOut():
return actionClockedOut(_that.clock);case ClockError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Clock clock)?  statusClockedIn,TResult? Function( Clock clock)?  statusClockedOut,TResult? Function( Clock clock)?  actionClockedIn,TResult? Function( Clock clock)?  actionClockedOut,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case ClockLoading() when loading != null:
return loading();case StatusClockedIn() when statusClockedIn != null:
return statusClockedIn(_that.clock);case StatusClockedOut() when statusClockedOut != null:
return statusClockedOut(_that.clock);case ActionClockedIn() when actionClockedIn != null:
return actionClockedIn(_that.clock);case ActionClockedOut() when actionClockedOut != null:
return actionClockedOut(_that.clock);case ClockError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements ClockState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockState.initial()';
}


}




/// @nodoc


class ClockLoading implements ClockState {
  const ClockLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockState.loading()';
}


}




/// @nodoc


class StatusClockedIn implements ClockState {
  const StatusClockedIn(this.clock);
  

 final  Clock clock;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusClockedInCopyWith<StatusClockedIn> get copyWith => _$StatusClockedInCopyWithImpl<StatusClockedIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusClockedIn&&(identical(other.clock, clock) || other.clock == clock));
}


@override
int get hashCode => Object.hash(runtimeType,clock);

@override
String toString() {
  return 'ClockState.statusClockedIn(clock: $clock)';
}


}

/// @nodoc
abstract mixin class $StatusClockedInCopyWith<$Res> implements $ClockStateCopyWith<$Res> {
  factory $StatusClockedInCopyWith(StatusClockedIn value, $Res Function(StatusClockedIn) _then) = _$StatusClockedInCopyWithImpl;
@useResult
$Res call({
 Clock clock
});




}
/// @nodoc
class _$StatusClockedInCopyWithImpl<$Res>
    implements $StatusClockedInCopyWith<$Res> {
  _$StatusClockedInCopyWithImpl(this._self, this._then);

  final StatusClockedIn _self;
  final $Res Function(StatusClockedIn) _then;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? clock = null,}) {
  return _then(StatusClockedIn(
null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Clock,
  ));
}


}

/// @nodoc


class StatusClockedOut implements ClockState {
  const StatusClockedOut(this.clock);
  

 final  Clock clock;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusClockedOutCopyWith<StatusClockedOut> get copyWith => _$StatusClockedOutCopyWithImpl<StatusClockedOut>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusClockedOut&&(identical(other.clock, clock) || other.clock == clock));
}


@override
int get hashCode => Object.hash(runtimeType,clock);

@override
String toString() {
  return 'ClockState.statusClockedOut(clock: $clock)';
}


}

/// @nodoc
abstract mixin class $StatusClockedOutCopyWith<$Res> implements $ClockStateCopyWith<$Res> {
  factory $StatusClockedOutCopyWith(StatusClockedOut value, $Res Function(StatusClockedOut) _then) = _$StatusClockedOutCopyWithImpl;
@useResult
$Res call({
 Clock clock
});




}
/// @nodoc
class _$StatusClockedOutCopyWithImpl<$Res>
    implements $StatusClockedOutCopyWith<$Res> {
  _$StatusClockedOutCopyWithImpl(this._self, this._then);

  final StatusClockedOut _self;
  final $Res Function(StatusClockedOut) _then;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? clock = null,}) {
  return _then(StatusClockedOut(
null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Clock,
  ));
}


}

/// @nodoc


class ActionClockedIn implements ClockState {
  const ActionClockedIn(this.clock);
  

 final  Clock clock;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionClockedInCopyWith<ActionClockedIn> get copyWith => _$ActionClockedInCopyWithImpl<ActionClockedIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionClockedIn&&(identical(other.clock, clock) || other.clock == clock));
}


@override
int get hashCode => Object.hash(runtimeType,clock);

@override
String toString() {
  return 'ClockState.actionClockedIn(clock: $clock)';
}


}

/// @nodoc
abstract mixin class $ActionClockedInCopyWith<$Res> implements $ClockStateCopyWith<$Res> {
  factory $ActionClockedInCopyWith(ActionClockedIn value, $Res Function(ActionClockedIn) _then) = _$ActionClockedInCopyWithImpl;
@useResult
$Res call({
 Clock clock
});




}
/// @nodoc
class _$ActionClockedInCopyWithImpl<$Res>
    implements $ActionClockedInCopyWith<$Res> {
  _$ActionClockedInCopyWithImpl(this._self, this._then);

  final ActionClockedIn _self;
  final $Res Function(ActionClockedIn) _then;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? clock = null,}) {
  return _then(ActionClockedIn(
null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Clock,
  ));
}


}

/// @nodoc


class ActionClockedOut implements ClockState {
  const ActionClockedOut(this.clock);
  

 final  Clock clock;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionClockedOutCopyWith<ActionClockedOut> get copyWith => _$ActionClockedOutCopyWithImpl<ActionClockedOut>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionClockedOut&&(identical(other.clock, clock) || other.clock == clock));
}


@override
int get hashCode => Object.hash(runtimeType,clock);

@override
String toString() {
  return 'ClockState.actionClockedOut(clock: $clock)';
}


}

/// @nodoc
abstract mixin class $ActionClockedOutCopyWith<$Res> implements $ClockStateCopyWith<$Res> {
  factory $ActionClockedOutCopyWith(ActionClockedOut value, $Res Function(ActionClockedOut) _then) = _$ActionClockedOutCopyWithImpl;
@useResult
$Res call({
 Clock clock
});




}
/// @nodoc
class _$ActionClockedOutCopyWithImpl<$Res>
    implements $ActionClockedOutCopyWith<$Res> {
  _$ActionClockedOutCopyWithImpl(this._self, this._then);

  final ActionClockedOut _self;
  final $Res Function(ActionClockedOut) _then;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? clock = null,}) {
  return _then(ActionClockedOut(
null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Clock,
  ));
}


}

/// @nodoc


class ClockError implements ClockState {
  const ClockError(this.message);
  

 final  String message;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClockErrorCopyWith<ClockError> get copyWith => _$ClockErrorCopyWithImpl<ClockError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ClockState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ClockErrorCopyWith<$Res> implements $ClockStateCopyWith<$Res> {
  factory $ClockErrorCopyWith(ClockError value, $Res Function(ClockError) _then) = _$ClockErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ClockErrorCopyWithImpl<$Res>
    implements $ClockErrorCopyWith<$Res> {
  _$ClockErrorCopyWithImpl(this._self, this._then);

  final ClockError _self;
  final $Res Function(ClockError) _then;

/// Create a copy of ClockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ClockError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
