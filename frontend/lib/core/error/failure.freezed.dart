// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message; String? get code;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Failure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.code, _this.code) || other.code == _this.code));
}


@override
int get hashCode {
  final _this = this as Failure;
  return Object.hash(runtimeType,_this.message,_this.code);
}

@override
String toString() {
  final _this = this as Failure;
  return 'Failure(message: ${_this.message}, code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( TimeoutFailure value)?  timeout,TResult Function( BadRequestFailure value)?  badRequest,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( ForbiddenFailure value)?  forbidden,TResult Function( NotFoundFailure value)?  notFound,TResult Function( ConflictFailure value)?  conflict,TResult Function( ValidationFailure value)?  validation,TResult Function( TooManyRequestsFailure value)?  tooManyRequests,TResult Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult Function( ServerFailure value)?  server,TResult Function( CacheFailure value)?  cache,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case BadRequestFailure() when badRequest != null:
return badRequest(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case ValidationFailure() when validation != null:
return validation(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case ServerFailure() when server != null:
return server(_that);case CacheFailure() when cache != null:
return cache(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( TimeoutFailure value)  timeout,required TResult Function( BadRequestFailure value)  badRequest,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( ForbiddenFailure value)  forbidden,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( ConflictFailure value)  conflict,required TResult Function( ValidationFailure value)  validation,required TResult Function( TooManyRequestsFailure value)  tooManyRequests,required TResult Function( ServiceUnavailableFailure value)  serviceUnavailable,required TResult Function( ServerFailure value)  server,required TResult Function( CacheFailure value)  cache,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case TimeoutFailure():
return timeout(_that);case BadRequestFailure():
return badRequest(_that);case UnauthorizedFailure():
return unauthorized(_that);case ForbiddenFailure():
return forbidden(_that);case NotFoundFailure():
return notFound(_that);case ConflictFailure():
return conflict(_that);case ValidationFailure():
return validation(_that);case TooManyRequestsFailure():
return tooManyRequests(_that);case ServiceUnavailableFailure():
return serviceUnavailable(_that);case ServerFailure():
return server(_that);case CacheFailure():
return cache(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( TimeoutFailure value)?  timeout,TResult? Function( BadRequestFailure value)?  badRequest,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( ForbiddenFailure value)?  forbidden,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( ConflictFailure value)?  conflict,TResult? Function( ValidationFailure value)?  validation,TResult? Function( TooManyRequestsFailure value)?  tooManyRequests,TResult? Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult? Function( ServerFailure value)?  server,TResult? Function( CacheFailure value)?  cache,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case BadRequestFailure() when badRequest != null:
return badRequest(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case ValidationFailure() when validation != null:
return validation(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case ServerFailure() when server != null:
return server(_that);case CacheFailure() when cache != null:
return cache(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? code)?  network,TResult Function( String message,  String? code)?  timeout,TResult Function( String message,  String? code)?  badRequest,TResult Function( String message,  String? code)?  unauthorized,TResult Function( String message,  String? code)?  forbidden,TResult Function( String message,  String? code)?  notFound,TResult Function( String message,  String? code)?  conflict,TResult Function( List<FieldError> fieldErrors,  String message,  String? code)?  validation,TResult Function( String message,  String? code)?  tooManyRequests,TResult Function( String message,  String? code)?  serviceUnavailable,TResult Function( int statusCode,  String message,  String? code)?  server,TResult Function( String message,  String? code)?  cache,TResult Function( String message,  String? code)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message,_that.code);case TimeoutFailure() when timeout != null:
return timeout(_that.message,_that.code);case BadRequestFailure() when badRequest != null:
return badRequest(_that.message,_that.code);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.code);case ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.code);case NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.code);case ConflictFailure() when conflict != null:
return conflict(_that.message,_that.code);case ValidationFailure() when validation != null:
return validation(_that.fieldErrors,_that.message,_that.code);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message,_that.code);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message,_that.code);case ServerFailure() when server != null:
return server(_that.statusCode,_that.message,_that.code);case CacheFailure() when cache != null:
return cache(_that.message,_that.code);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? code)  network,required TResult Function( String message,  String? code)  timeout,required TResult Function( String message,  String? code)  badRequest,required TResult Function( String message,  String? code)  unauthorized,required TResult Function( String message,  String? code)  forbidden,required TResult Function( String message,  String? code)  notFound,required TResult Function( String message,  String? code)  conflict,required TResult Function( List<FieldError> fieldErrors,  String message,  String? code)  validation,required TResult Function( String message,  String? code)  tooManyRequests,required TResult Function( String message,  String? code)  serviceUnavailable,required TResult Function( int statusCode,  String message,  String? code)  server,required TResult Function( String message,  String? code)  cache,required TResult Function( String message,  String? code)  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that.message,_that.code);case TimeoutFailure():
return timeout(_that.message,_that.code);case BadRequestFailure():
return badRequest(_that.message,_that.code);case UnauthorizedFailure():
return unauthorized(_that.message,_that.code);case ForbiddenFailure():
return forbidden(_that.message,_that.code);case NotFoundFailure():
return notFound(_that.message,_that.code);case ConflictFailure():
return conflict(_that.message,_that.code);case ValidationFailure():
return validation(_that.fieldErrors,_that.message,_that.code);case TooManyRequestsFailure():
return tooManyRequests(_that.message,_that.code);case ServiceUnavailableFailure():
return serviceUnavailable(_that.message,_that.code);case ServerFailure():
return server(_that.statusCode,_that.message,_that.code);case CacheFailure():
return cache(_that.message,_that.code);case UnknownFailure():
return unknown(_that.message,_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? code)?  network,TResult? Function( String message,  String? code)?  timeout,TResult? Function( String message,  String? code)?  badRequest,TResult? Function( String message,  String? code)?  unauthorized,TResult? Function( String message,  String? code)?  forbidden,TResult? Function( String message,  String? code)?  notFound,TResult? Function( String message,  String? code)?  conflict,TResult? Function( List<FieldError> fieldErrors,  String message,  String? code)?  validation,TResult? Function( String message,  String? code)?  tooManyRequests,TResult? Function( String message,  String? code)?  serviceUnavailable,TResult? Function( int statusCode,  String message,  String? code)?  server,TResult? Function( String message,  String? code)?  cache,TResult? Function( String message,  String? code)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message,_that.code);case TimeoutFailure() when timeout != null:
return timeout(_that.message,_that.code);case BadRequestFailure() when badRequest != null:
return badRequest(_that.message,_that.code);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.code);case ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.code);case NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.code);case ConflictFailure() when conflict != null:
return conflict(_that.message,_that.code);case ValidationFailure() when validation != null:
return validation(_that.fieldErrors,_that.message,_that.code);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message,_that.code);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message,_that.code);case ServerFailure() when server != null:
return server(_that.statusCode,_that.message,_that.code);case CacheFailure() when cache != null:
return cache(_that.message,_that.code);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.code);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({this.message = 'No internet connection', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.network(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TimeoutFailure implements Failure {
  const TimeoutFailure({this.message = 'Request timed out', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeoutFailureCopyWith<TimeoutFailure> get copyWith => _$TimeoutFailureCopyWithImpl<TimeoutFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.timeout(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $TimeoutFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TimeoutFailureCopyWith(TimeoutFailure value, $Res Function(TimeoutFailure) _then) = _$TimeoutFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$TimeoutFailureCopyWithImpl<$Res>
    implements $TimeoutFailureCopyWith<$Res> {
  _$TimeoutFailureCopyWithImpl(this._self, this._then);

  final TimeoutFailure _self;
  final $Res Function(TimeoutFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(TimeoutFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class BadRequestFailure implements Failure {
  const BadRequestFailure({this.message = 'Bad request', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadRequestFailureCopyWith<BadRequestFailure> get copyWith => _$BadRequestFailureCopyWithImpl<BadRequestFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequestFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.badRequest(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $BadRequestFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $BadRequestFailureCopyWith(BadRequestFailure value, $Res Function(BadRequestFailure) _then) = _$BadRequestFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$BadRequestFailureCopyWithImpl<$Res>
    implements $BadRequestFailureCopyWith<$Res> {
  _$BadRequestFailureCopyWithImpl(this._self, this._then);

  final BadRequestFailure _self;
  final $Res Function(BadRequestFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(BadRequestFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnauthorizedFailure implements Failure {
  const UnauthorizedFailure({this.message = 'Unauthorized', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedFailureCopyWith<UnauthorizedFailure> get copyWith => _$UnauthorizedFailureCopyWithImpl<UnauthorizedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.unauthorized(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnauthorizedFailureCopyWith(UnauthorizedFailure value, $Res Function(UnauthorizedFailure) _then) = _$UnauthorizedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$UnauthorizedFailureCopyWithImpl<$Res>
    implements $UnauthorizedFailureCopyWith<$Res> {
  _$UnauthorizedFailureCopyWithImpl(this._self, this._then);

  final UnauthorizedFailure _self;
  final $Res Function(UnauthorizedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(UnauthorizedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ForbiddenFailure implements Failure {
  const ForbiddenFailure({this.message = 'Forbidden', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForbiddenFailureCopyWith<ForbiddenFailure> get copyWith => _$ForbiddenFailureCopyWithImpl<ForbiddenFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForbiddenFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.forbidden(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ForbiddenFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ForbiddenFailureCopyWith(ForbiddenFailure value, $Res Function(ForbiddenFailure) _then) = _$ForbiddenFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ForbiddenFailureCopyWithImpl<$Res>
    implements $ForbiddenFailureCopyWith<$Res> {
  _$ForbiddenFailureCopyWithImpl(this._self, this._then);

  final ForbiddenFailure _self;
  final $Res Function(ForbiddenFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ForbiddenFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotFoundFailure implements Failure {
  const NotFoundFailure({this.message = 'Not found', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundFailureCopyWith<NotFoundFailure> get copyWith => _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.notFound(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(NotFoundFailure value, $Res Function(NotFoundFailure) _then) = _$NotFoundFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NotFoundFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConflictFailure implements Failure {
  const ConflictFailure({this.message = 'Conflict', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictFailureCopyWith<ConflictFailure> get copyWith => _$ConflictFailureCopyWithImpl<ConflictFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.conflict(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ConflictFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConflictFailureCopyWith(ConflictFailure value, $Res Function(ConflictFailure) _then) = _$ConflictFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ConflictFailureCopyWithImpl<$Res>
    implements $ConflictFailureCopyWith<$Res> {
  _$ConflictFailureCopyWithImpl(this._self, this._then);

  final ConflictFailure _self;
  final $Res Function(ConflictFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ConflictFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ValidationFailure implements Failure {
  const ValidationFailure( List<FieldError> fieldErrors, {this.message = 'Validation failed', this.code}): _fieldErrors = fieldErrors;
  

 final  List<FieldError> _fieldErrors;
 List<FieldError> get fieldErrors {
  if (_fieldErrors is EqualUnmodifiableListView) return _fieldErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fieldErrors);
}

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&const DeepCollectionEquality().equals(other.fieldErrors, _fieldErrors)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_fieldErrors),message,code);
}

@override
String toString() {
    return 'Failure.validation(fieldErrors: $fieldErrors, message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@override @useResult
$Res call({
 List<FieldError> fieldErrors, String message, String? code
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldErrors = null,Object? message = null,Object? code = freezed,}) {
  return _then(ValidationFailure(
null == fieldErrors ? _self._fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as List<FieldError>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TooManyRequestsFailure implements Failure {
  const TooManyRequestsFailure({this.message = 'Too many requests', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooManyRequestsFailureCopyWith<TooManyRequestsFailure> get copyWith => _$TooManyRequestsFailureCopyWithImpl<TooManyRequestsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequestsFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.tooManyRequests(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $TooManyRequestsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TooManyRequestsFailureCopyWith(TooManyRequestsFailure value, $Res Function(TooManyRequestsFailure) _then) = _$TooManyRequestsFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$TooManyRequestsFailureCopyWithImpl<$Res>
    implements $TooManyRequestsFailureCopyWith<$Res> {
  _$TooManyRequestsFailureCopyWithImpl(this._self, this._then);

  final TooManyRequestsFailure _self;
  final $Res Function(TooManyRequestsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(TooManyRequestsFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServiceUnavailableFailure implements Failure {
  const ServiceUnavailableFailure({this.message = 'Service unavailable', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUnavailableFailureCopyWith<ServiceUnavailableFailure> get copyWith => _$ServiceUnavailableFailureCopyWithImpl<ServiceUnavailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailableFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.serviceUnavailable(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ServiceUnavailableFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServiceUnavailableFailureCopyWith(ServiceUnavailableFailure value, $Res Function(ServiceUnavailableFailure) _then) = _$ServiceUnavailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ServiceUnavailableFailureCopyWithImpl<$Res>
    implements $ServiceUnavailableFailureCopyWith<$Res> {
  _$ServiceUnavailableFailureCopyWithImpl(this._self, this._then);

  final ServiceUnavailableFailure _self;
  final $Res Function(ServiceUnavailableFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ServiceUnavailableFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerFailure implements Failure {
  const ServerFailure(this.statusCode, {this.message = 'Server error', this.code});
  

 final  int statusCode;
@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,statusCode,message,code);
}

@override
String toString() {
    return 'Failure.server(statusCode: $statusCode, message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@override @useResult
$Res call({
 int statusCode, String message, String? code
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? message = null,Object? code = freezed,}) {
  return _then(ServerFailure(
null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CacheFailure implements Failure {
  const CacheFailure({this.message = 'Cache error', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.cache(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(CacheFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnknownFailure implements Failure {
  const UnknownFailure({this.message = 'Unexpected error', this.code});
  

@override@JsonKey() final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code);
}

@override
String toString() {
    return 'Failure.unknown(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(UnknownFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
