// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_form_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFormError {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFormError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFormError()';
}


}

/// @nodoc
class $AuthFormErrorCopyWith<$Res>  {
$AuthFormErrorCopyWith(AuthFormError _, $Res Function(AuthFormError) __);
}


/// Adds pattern-matching-related methods to [AuthFormError].
extension AuthFormErrorPatterns on AuthFormError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvalidCredentialsError value)?  invalidCredentials,TResult Function( RateLimitedError value)?  rateLimited,TResult Function( NetworkError value)?  network,TResult Function( UnexpectedError value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvalidCredentialsError() when invalidCredentials != null:
return invalidCredentials(_that);case RateLimitedError() when rateLimited != null:
return rateLimited(_that);case NetworkError() when network != null:
return network(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvalidCredentialsError value)  invalidCredentials,required TResult Function( RateLimitedError value)  rateLimited,required TResult Function( NetworkError value)  network,required TResult Function( UnexpectedError value)  unexpected,}){
final _that = this;
switch (_that) {
case InvalidCredentialsError():
return invalidCredentials(_that);case RateLimitedError():
return rateLimited(_that);case NetworkError():
return network(_that);case UnexpectedError():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvalidCredentialsError value)?  invalidCredentials,TResult? Function( RateLimitedError value)?  rateLimited,TResult? Function( NetworkError value)?  network,TResult? Function( UnexpectedError value)?  unexpected,}){
final _that = this;
switch (_that) {
case InvalidCredentialsError() when invalidCredentials != null:
return invalidCredentials(_that);case RateLimitedError() when rateLimited != null:
return rateLimited(_that);case NetworkError() when network != null:
return network(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function( int? minutes)?  rateLimited,TResult Function()?  network,TResult Function()?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvalidCredentialsError() when invalidCredentials != null:
return invalidCredentials();case RateLimitedError() when rateLimited != null:
return rateLimited(_that.minutes);case NetworkError() when network != null:
return network();case UnexpectedError() when unexpected != null:
return unexpected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function( int? minutes)  rateLimited,required TResult Function()  network,required TResult Function()  unexpected,}) {final _that = this;
switch (_that) {
case InvalidCredentialsError():
return invalidCredentials();case RateLimitedError():
return rateLimited(_that.minutes);case NetworkError():
return network();case UnexpectedError():
return unexpected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function( int? minutes)?  rateLimited,TResult? Function()?  network,TResult? Function()?  unexpected,}) {final _that = this;
switch (_that) {
case InvalidCredentialsError() when invalidCredentials != null:
return invalidCredentials();case RateLimitedError() when rateLimited != null:
return rateLimited(_that.minutes);case NetworkError() when network != null:
return network();case UnexpectedError() when unexpected != null:
return unexpected();case _:
  return null;

}
}

}

/// @nodoc


class InvalidCredentialsError implements AuthFormError {
  const InvalidCredentialsError();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCredentialsError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFormError.invalidCredentials()';
}


}




/// @nodoc


class RateLimitedError implements AuthFormError {
  const RateLimitedError({this.minutes});
  

 final  int? minutes;

/// Create a copy of AuthFormError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitedErrorCopyWith<RateLimitedError> get copyWith => _$RateLimitedErrorCopyWithImpl<RateLimitedError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitedError&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,minutes);
}

@override
String toString() {
    return 'AuthFormError.rateLimited(minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class $RateLimitedErrorCopyWith<$Res> implements $AuthFormErrorCopyWith<$Res> {
  factory $RateLimitedErrorCopyWith(RateLimitedError value, $Res Function(RateLimitedError) _then) = _$RateLimitedErrorCopyWithImpl;
@useResult
$Res call({
 int? minutes
});




}
/// @nodoc
class _$RateLimitedErrorCopyWithImpl<$Res>
    implements $RateLimitedErrorCopyWith<$Res> {
  _$RateLimitedErrorCopyWithImpl(this._self, this._then);

  final RateLimitedError _self;
  final $Res Function(RateLimitedError) _then;

/// Create a copy of AuthFormError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? minutes = freezed,}) {
  return _then(RateLimitedError(
minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class NetworkError implements AuthFormError {
  const NetworkError();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFormError.network()';
}


}




/// @nodoc


class UnexpectedError implements AuthFormError {
  const UnexpectedError();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthFormError.unexpected()';
}


}




// dart format on
