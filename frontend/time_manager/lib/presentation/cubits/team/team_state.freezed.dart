// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeamState()';
}


}

/// @nodoc
class $TeamStateCopyWith<$Res>  {
$TeamStateCopyWith(TeamState _, $Res Function(TeamState) __);
}


/// Adds pattern-matching-related methods to [TeamState].
extension TeamStatePatterns on TeamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeamInitial value)?  initial,TResult Function( TeamLoading value)?  loading,TResult Function( TeamLoaded value)?  loaded,TResult Function( TeamsLoaded value)?  loadedTeams,TResult Function( TeamError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeamInitial() when initial != null:
return initial(_that);case TeamLoading() when loading != null:
return loading(_that);case TeamLoaded() when loaded != null:
return loaded(_that);case TeamsLoaded() when loadedTeams != null:
return loadedTeams(_that);case TeamError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeamInitial value)  initial,required TResult Function( TeamLoading value)  loading,required TResult Function( TeamLoaded value)  loaded,required TResult Function( TeamsLoaded value)  loadedTeams,required TResult Function( TeamError value)  error,}){
final _that = this;
switch (_that) {
case TeamInitial():
return initial(_that);case TeamLoading():
return loading(_that);case TeamLoaded():
return loaded(_that);case TeamsLoaded():
return loadedTeams(_that);case TeamError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeamInitial value)?  initial,TResult? Function( TeamLoading value)?  loading,TResult? Function( TeamLoaded value)?  loaded,TResult? Function( TeamsLoaded value)?  loadedTeams,TResult? Function( TeamError value)?  error,}){
final _that = this;
switch (_that) {
case TeamInitial() when initial != null:
return initial(_that);case TeamLoading() when loading != null:
return loading(_that);case TeamLoaded() when loaded != null:
return loaded(_that);case TeamsLoaded() when loadedTeams != null:
return loadedTeams(_that);case TeamError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Team team,  int? managerId)?  loaded,TResult Function( List<Team> teams)?  loadedTeams,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeamInitial() when initial != null:
return initial();case TeamLoading() when loading != null:
return loading();case TeamLoaded() when loaded != null:
return loaded(_that.team,_that.managerId);case TeamsLoaded() when loadedTeams != null:
return loadedTeams(_that.teams);case TeamError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Team team,  int? managerId)  loaded,required TResult Function( List<Team> teams)  loadedTeams,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TeamInitial():
return initial();case TeamLoading():
return loading();case TeamLoaded():
return loaded(_that.team,_that.managerId);case TeamsLoaded():
return loadedTeams(_that.teams);case TeamError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Team team,  int? managerId)?  loaded,TResult? Function( List<Team> teams)?  loadedTeams,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TeamInitial() when initial != null:
return initial();case TeamLoading() when loading != null:
return loading();case TeamLoaded() when loaded != null:
return loaded(_that.team,_that.managerId);case TeamsLoaded() when loadedTeams != null:
return loadedTeams(_that.teams);case TeamError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TeamInitial implements TeamState {
  const TeamInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeamState.initial()';
}


}




/// @nodoc


class TeamLoading implements TeamState {
  const TeamLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeamState.loading()';
}


}




/// @nodoc


class TeamLoaded implements TeamState {
  const TeamLoaded(this.team, this.managerId);
  

 final  Team team;
 final  int? managerId;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamLoadedCopyWith<TeamLoaded> get copyWith => _$TeamLoadedCopyWithImpl<TeamLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLoaded&&(identical(other.team, team) || other.team == team)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}


@override
int get hashCode => Object.hash(runtimeType,team,managerId);

@override
String toString() {
  return 'TeamState.loaded(team: $team, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class $TeamLoadedCopyWith<$Res> implements $TeamStateCopyWith<$Res> {
  factory $TeamLoadedCopyWith(TeamLoaded value, $Res Function(TeamLoaded) _then) = _$TeamLoadedCopyWithImpl;
@useResult
$Res call({
 Team team, int? managerId
});


$TeamCopyWith<$Res> get team;

}
/// @nodoc
class _$TeamLoadedCopyWithImpl<$Res>
    implements $TeamLoadedCopyWith<$Res> {
  _$TeamLoadedCopyWithImpl(this._self, this._then);

  final TeamLoaded _self;
  final $Res Function(TeamLoaded) _then;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? team = null,Object? managerId = freezed,}) {
  return _then(TeamLoaded(
null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as Team,freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res> get team {
  
  return $TeamCopyWith<$Res>(_self.team, (value) {
    return _then(_self.copyWith(team: value));
  });
}
}

/// @nodoc


class TeamsLoaded implements TeamState {
  const TeamsLoaded(final  List<Team> teams): _teams = teams;
  

 final  List<Team> _teams;
 List<Team> get teams {
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teams);
}


/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamsLoadedCopyWith<TeamsLoaded> get copyWith => _$TeamsLoadedCopyWithImpl<TeamsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamsLoaded&&const DeepCollectionEquality().equals(other._teams, _teams));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_teams));

@override
String toString() {
  return 'TeamState.loadedTeams(teams: $teams)';
}


}

/// @nodoc
abstract mixin class $TeamsLoadedCopyWith<$Res> implements $TeamStateCopyWith<$Res> {
  factory $TeamsLoadedCopyWith(TeamsLoaded value, $Res Function(TeamsLoaded) _then) = _$TeamsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Team> teams
});




}
/// @nodoc
class _$TeamsLoadedCopyWithImpl<$Res>
    implements $TeamsLoadedCopyWith<$Res> {
  _$TeamsLoadedCopyWithImpl(this._self, this._then);

  final TeamsLoaded _self;
  final $Res Function(TeamsLoaded) _then;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? teams = null,}) {
  return _then(TeamsLoaded(
null == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<Team>,
  ));
}


}

/// @nodoc


class TeamError implements TeamState {
  const TeamError(this.message);
  

 final  String message;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamErrorCopyWith<TeamError> get copyWith => _$TeamErrorCopyWithImpl<TeamError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TeamState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TeamErrorCopyWith<$Res> implements $TeamStateCopyWith<$Res> {
  factory $TeamErrorCopyWith(TeamError value, $Res Function(TeamError) _then) = _$TeamErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TeamErrorCopyWithImpl<$Res>
    implements $TeamErrorCopyWith<$Res> {
  _$TeamErrorCopyWithImpl(this._self, this._then);

  final TeamError _self;
  final $Res Function(TeamError) _then;

/// Create a copy of TeamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TeamError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
