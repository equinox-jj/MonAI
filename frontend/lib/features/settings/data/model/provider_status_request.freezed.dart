// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_status_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderStatusRequest {

@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProviderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderStatusRequestCopyWith<ProviderStatusRequest> get copyWith => _$ProviderStatusRequestCopyWithImpl<ProviderStatusRequest>(this as ProviderStatusRequest, _$identity);

  /// Serializes this ProviderStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderStatusRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderStatusRequest&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderStatusRequest;
  return Object.hash(runtimeType,_this.isActive);
}

@override
String toString() {
  final _this = this as ProviderStatusRequest;
  return 'ProviderStatusRequest(isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $ProviderStatusRequestCopyWith<$Res>  {
  factory $ProviderStatusRequestCopyWith(ProviderStatusRequest value, $Res Function(ProviderStatusRequest) _then) = _$ProviderStatusRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProviderStatusRequestCopyWithImpl<$Res>
    implements $ProviderStatusRequestCopyWith<$Res> {
  _$ProviderStatusRequestCopyWithImpl(this._self, this._then);

  final ProviderStatusRequest _self;
  final $Res Function(ProviderStatusRequest) _then;

/// Create a copy of ProviderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isActive = null,}) {
  return _then(ProviderStatusRequest(
isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderStatusRequest].
extension ProviderStatusRequestPatterns on ProviderStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProviderStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderStatusRequest() when $default != null:
return $default(_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProviderStatusRequest():
return $default(_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProviderStatusRequest() when $default != null:
return $default(_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderStatusRequest implements ProviderStatusRequest {
  const _ProviderStatusRequest({@JsonKey(name: 'is_active') required this.isActive});
  factory _ProviderStatusRequest.fromJson(Map<String, dynamic> json) => _$ProviderStatusRequestFromJson(json);

@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProviderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderStatusRequestCopyWith<_ProviderStatusRequest> get copyWith => __$ProviderStatusRequestCopyWithImpl<_ProviderStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderStatusRequest&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isActive);
}

@override
String toString() {
    return 'ProviderStatusRequest(isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProviderStatusRequestCopyWith<$Res> implements $ProviderStatusRequestCopyWith<$Res> {
  factory _$ProviderStatusRequestCopyWith(_ProviderStatusRequest value, $Res Function(_ProviderStatusRequest) _then) = __$ProviderStatusRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProviderStatusRequestCopyWithImpl<$Res>
    implements _$ProviderStatusRequestCopyWith<$Res> {
  __$ProviderStatusRequestCopyWithImpl(this._self, this._then);

  final _ProviderStatusRequest _self;
  final $Res Function(_ProviderStatusRequest) _then;

/// Create a copy of ProviderStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isActive = null,}) {
  return _then(_ProviderStatusRequest(
isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
