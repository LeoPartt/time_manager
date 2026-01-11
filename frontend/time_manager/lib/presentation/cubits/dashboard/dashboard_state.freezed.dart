// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardState()';
}


}

/// @nodoc
class $DashboardStateCopyWith<$Res>  {
$DashboardStateCopyWith(DashboardState _, $Res Function(DashboardState) __);
}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( UserLoaded value)?  userLoaded,TResult Function( TeamLoaded value)?  teamLoaded,TResult Function( GlobalLoaded value)?  globalLoaded,TResult Function( Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case UserLoaded() when userLoaded != null:
return userLoaded(_that);case TeamLoaded() when teamLoaded != null:
return teamLoaded(_that);case GlobalLoaded() when globalLoaded != null:
return globalLoaded(_that);case Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( UserLoaded value)  userLoaded,required TResult Function( TeamLoaded value)  teamLoaded,required TResult Function( GlobalLoaded value)  globalLoaded,required TResult Function( Error value)  error,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case UserLoaded():
return userLoaded(_that);case TeamLoaded():
return teamLoaded(_that);case GlobalLoaded():
return globalLoaded(_that);case Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( UserLoaded value)?  userLoaded,TResult? Function( TeamLoaded value)?  teamLoaded,TResult? Function( GlobalLoaded value)?  globalLoaded,TResult? Function( Error value)?  error,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case UserLoaded() when userLoaded != null:
return userLoaded(_that);case TeamLoaded() when teamLoaded != null:
return teamLoaded(_that);case GlobalLoaded() when globalLoaded != null:
return globalLoaded(_that);case Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserDashboardReport report)?  userLoaded,TResult Function( TeamDashboardReport report)?  teamLoaded,TResult Function( GlobalDashboardReport report)?  globalLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case UserLoaded() when userLoaded != null:
return userLoaded(_that.report);case TeamLoaded() when teamLoaded != null:
return teamLoaded(_that.report);case GlobalLoaded() when globalLoaded != null:
return globalLoaded(_that.report);case Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserDashboardReport report)  userLoaded,required TResult Function( TeamDashboardReport report)  teamLoaded,required TResult Function( GlobalDashboardReport report)  globalLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case UserLoaded():
return userLoaded(_that.report);case TeamLoaded():
return teamLoaded(_that.report);case GlobalLoaded():
return globalLoaded(_that.report);case Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserDashboardReport report)?  userLoaded,TResult? Function( TeamDashboardReport report)?  teamLoaded,TResult? Function( GlobalDashboardReport report)?  globalLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case UserLoaded() when userLoaded != null:
return userLoaded(_that.report);case TeamLoaded() when teamLoaded != null:
return teamLoaded(_that.report);case GlobalLoaded() when globalLoaded != null:
return globalLoaded(_that.report);case Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements DashboardState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardState.initial()';
}


}




/// @nodoc


class Loading implements DashboardState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DashboardState.loading()';
}


}




/// @nodoc


class UserLoaded implements DashboardState {
  const UserLoaded(this.report);
  

 final  UserDashboardReport report;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLoadedCopyWith<UserLoaded> get copyWith => _$UserLoadedCopyWithImpl<UserLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,report);

@override
String toString() {
  return 'DashboardState.userLoaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $UserLoadedCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory $UserLoadedCopyWith(UserLoaded value, $Res Function(UserLoaded) _then) = _$UserLoadedCopyWithImpl;
@useResult
$Res call({
 UserDashboardReport report
});


$UserDashboardReportCopyWith<$Res> get report;

}
/// @nodoc
class _$UserLoadedCopyWithImpl<$Res>
    implements $UserLoadedCopyWith<$Res> {
  _$UserLoadedCopyWithImpl(this._self, this._then);

  final UserLoaded _self;
  final $Res Function(UserLoaded) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(UserLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as UserDashboardReport,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDashboardReportCopyWith<$Res> get report {
  
  return $UserDashboardReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class TeamLoaded implements DashboardState {
  const TeamLoaded(this.report);
  

 final  TeamDashboardReport report;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamLoadedCopyWith<TeamLoaded> get copyWith => _$TeamLoadedCopyWithImpl<TeamLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,report);

@override
String toString() {
  return 'DashboardState.teamLoaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $TeamLoadedCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory $TeamLoadedCopyWith(TeamLoaded value, $Res Function(TeamLoaded) _then) = _$TeamLoadedCopyWithImpl;
@useResult
$Res call({
 TeamDashboardReport report
});


$TeamDashboardReportCopyWith<$Res> get report;

}
/// @nodoc
class _$TeamLoadedCopyWithImpl<$Res>
    implements $TeamLoadedCopyWith<$Res> {
  _$TeamLoadedCopyWithImpl(this._self, this._then);

  final TeamLoaded _self;
  final $Res Function(TeamLoaded) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(TeamLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as TeamDashboardReport,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamDashboardReportCopyWith<$Res> get report {
  
  return $TeamDashboardReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class GlobalLoaded implements DashboardState {
  const GlobalLoaded(this.report);
  

 final  GlobalDashboardReport report;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalLoadedCopyWith<GlobalLoaded> get copyWith => _$GlobalLoadedCopyWithImpl<GlobalLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,report);

@override
String toString() {
  return 'DashboardState.globalLoaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $GlobalLoadedCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory $GlobalLoadedCopyWith(GlobalLoaded value, $Res Function(GlobalLoaded) _then) = _$GlobalLoadedCopyWithImpl;
@useResult
$Res call({
 GlobalDashboardReport report
});


$GlobalDashboardReportCopyWith<$Res> get report;

}
/// @nodoc
class _$GlobalLoadedCopyWithImpl<$Res>
    implements $GlobalLoadedCopyWith<$Res> {
  _$GlobalLoadedCopyWithImpl(this._self, this._then);

  final GlobalLoaded _self;
  final $Res Function(GlobalLoaded) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(GlobalLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as GlobalDashboardReport,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlobalDashboardReportCopyWith<$Res> get report {
  
  return $GlobalDashboardReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class Error implements DashboardState {
  const Error(this.message);
  

 final  String message;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DashboardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
