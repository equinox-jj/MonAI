// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_expired_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionExpiredState {

/// The server rejected the token; the dialog is shown until the user
/// signs in again.
 bool get expired;
/// Create a copy of SessionExpiredState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionExpiredStateCopyWith<SessionExpiredState> get copyWith => _$SessionExpiredStateCopyWithImpl<SessionExpiredState>(this as SessionExpiredState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionExpiredState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionExpiredState&&(identical(other.expired, _this.expired) || other.expired == _this.expired));
}


@override
int get hashCode {
  final _this = this as SessionExpiredState;
  return Object.hash(runtimeType,_this.expired);
}

@override
String toString() {
  final _this = this as SessionExpiredState;
  return 'SessionExpiredState(expired: ${_this.expired})';
}


}

/// @nodoc
abstract mixin class $SessionExpiredStateCopyWith<$Res>  {
  factory $SessionExpiredStateCopyWith(SessionExpiredState value, $Res Function(SessionExpiredState) _then) = _$SessionExpiredStateCopyWithImpl;
@useResult
$Res call({
 bool expired
});




}
/// @nodoc
class _$SessionExpiredStateCopyWithImpl<$Res>
    implements $SessionExpiredStateCopyWith<$Res> {
  _$SessionExpiredStateCopyWithImpl(this._self, this._then);

  final SessionExpiredState _self;
  final $Res Function(SessionExpiredState) _then;

/// Create a copy of SessionExpiredState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expired = null,}) {
  return _then(SessionExpiredState(
expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionExpiredState].
extension SessionExpiredStatePatterns on SessionExpiredState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionExpiredState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionExpiredState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionExpiredState value)  $default,){
final _that = this;
switch (_that) {
case _SessionExpiredState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionExpiredState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionExpiredState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool expired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionExpiredState() when $default != null:
return $default(_that.expired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool expired)  $default,) {final _that = this;
switch (_that) {
case _SessionExpiredState():
return $default(_that.expired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool expired)?  $default,) {final _that = this;
switch (_that) {
case _SessionExpiredState() when $default != null:
return $default(_that.expired);case _:
  return null;

}
}

}

/// @nodoc


class _SessionExpiredState implements SessionExpiredState {
  const _SessionExpiredState({this.expired = false});
  

/// The server rejected the token; the dialog is shown until the user
/// signs in again.
@override@JsonKey() final  bool expired;

/// Create a copy of SessionExpiredState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionExpiredStateCopyWith<_SessionExpiredState> get copyWith => __$SessionExpiredStateCopyWithImpl<_SessionExpiredState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExpiredState&&(identical(other.expired, expired) || other.expired == expired));
}


@override
int get hashCode {
    return Object.hash(runtimeType,expired);
}

@override
String toString() {
    return 'SessionExpiredState(expired: $expired)';
}


}

/// @nodoc
abstract mixin class _$SessionExpiredStateCopyWith<$Res> implements $SessionExpiredStateCopyWith<$Res> {
  factory _$SessionExpiredStateCopyWith(_SessionExpiredState value, $Res Function(_SessionExpiredState) _then) = __$SessionExpiredStateCopyWithImpl;
@override @useResult
$Res call({
 bool expired
});




}
/// @nodoc
class __$SessionExpiredStateCopyWithImpl<$Res>
    implements _$SessionExpiredStateCopyWith<$Res> {
  __$SessionExpiredStateCopyWithImpl(this._self, this._then);

  final _SessionExpiredState _self;
  final $Res Function(_SessionExpiredState) _then;

/// Create a copy of SessionExpiredState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expired = null,}) {
  return _then(_SessionExpiredState(
expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
