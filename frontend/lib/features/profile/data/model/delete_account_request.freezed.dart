// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteAccountRequest {

@JsonKey(name: 'password') String get password;
/// Create a copy of DeleteAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountRequestCopyWith<DeleteAccountRequest> get copyWith => _$DeleteAccountRequestCopyWithImpl<DeleteAccountRequest>(this as DeleteAccountRequest, _$identity);

  /// Serializes this DeleteAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeleteAccountRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountRequest&&(identical(other.password, _this.password) || other.password == _this.password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeleteAccountRequest;
  return Object.hash(runtimeType,_this.password);
}

@override
String toString() {
  final _this = this as DeleteAccountRequest;
  return 'DeleteAccountRequest(password: ${_this.password})';
}


}

/// @nodoc
abstract mixin class $DeleteAccountRequestCopyWith<$Res>  {
  factory $DeleteAccountRequestCopyWith(DeleteAccountRequest value, $Res Function(DeleteAccountRequest) _then) = _$DeleteAccountRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'password') String password
});




}
/// @nodoc
class _$DeleteAccountRequestCopyWithImpl<$Res>
    implements $DeleteAccountRequestCopyWith<$Res> {
  _$DeleteAccountRequestCopyWithImpl(this._self, this._then);

  final DeleteAccountRequest _self;
  final $Res Function(DeleteAccountRequest) _then;

/// Create a copy of DeleteAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,}) {
  return _then(DeleteAccountRequest(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteAccountRequest].
extension DeleteAccountRequestPatterns on DeleteAccountRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteAccountRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteAccountRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteAccountRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteAccountRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'password')  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteAccountRequest() when $default != null:
return $default(_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'password')  String password)  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountRequest():
return $default(_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'password')  String password)?  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountRequest() when $default != null:
return $default(_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteAccountRequest implements DeleteAccountRequest {
  const _DeleteAccountRequest({@JsonKey(name: 'password') required this.password});
  factory _DeleteAccountRequest.fromJson(Map<String, dynamic> json) => _$DeleteAccountRequestFromJson(json);

@override@JsonKey(name: 'password') final  String password;

/// Create a copy of DeleteAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAccountRequestCopyWith<_DeleteAccountRequest> get copyWith => __$DeleteAccountRequestCopyWithImpl<_DeleteAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccountRequest&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString() {
    return 'DeleteAccountRequest(password: $password)';
}


}

/// @nodoc
abstract mixin class _$DeleteAccountRequestCopyWith<$Res> implements $DeleteAccountRequestCopyWith<$Res> {
  factory _$DeleteAccountRequestCopyWith(_DeleteAccountRequest value, $Res Function(_DeleteAccountRequest) _then) = __$DeleteAccountRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'password') String password
});




}
/// @nodoc
class __$DeleteAccountRequestCopyWithImpl<$Res>
    implements _$DeleteAccountRequestCopyWith<$Res> {
  __$DeleteAccountRequestCopyWithImpl(this._self, this._then);

  final _DeleteAccountRequest _self;
  final $Res Function(_DeleteAccountRequest) _then;

/// Create a copy of DeleteAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_DeleteAccountRequest(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
