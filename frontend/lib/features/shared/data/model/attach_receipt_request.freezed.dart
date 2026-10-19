// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attach_receipt_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachReceiptRequest {

@JsonKey(name: 'receipt_key') String get receiptKey;
/// Create a copy of AttachReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachReceiptRequestCopyWith<AttachReceiptRequest> get copyWith => _$AttachReceiptRequestCopyWithImpl<AttachReceiptRequest>(this as AttachReceiptRequest, _$identity);

  /// Serializes this AttachReceiptRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttachReceiptRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachReceiptRequest&&(identical(other.receiptKey, _this.receiptKey) || other.receiptKey == _this.receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttachReceiptRequest;
  return Object.hash(runtimeType,_this.receiptKey);
}

@override
String toString() {
  final _this = this as AttachReceiptRequest;
  return 'AttachReceiptRequest(receiptKey: ${_this.receiptKey})';
}


}

/// @nodoc
abstract mixin class $AttachReceiptRequestCopyWith<$Res>  {
  factory $AttachReceiptRequestCopyWith(AttachReceiptRequest value, $Res Function(AttachReceiptRequest) _then) = _$AttachReceiptRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'receipt_key') String receiptKey
});




}
/// @nodoc
class _$AttachReceiptRequestCopyWithImpl<$Res>
    implements $AttachReceiptRequestCopyWith<$Res> {
  _$AttachReceiptRequestCopyWithImpl(this._self, this._then);

  final AttachReceiptRequest _self;
  final $Res Function(AttachReceiptRequest) _then;

/// Create a copy of AttachReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receiptKey = null,}) {
  return _then(AttachReceiptRequest(
receiptKey: null == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachReceiptRequest].
extension AttachReceiptRequestPatterns on AttachReceiptRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachReceiptRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachReceiptRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachReceiptRequest value)  $default,){
final _that = this;
switch (_that) {
case _AttachReceiptRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachReceiptRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AttachReceiptRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'receipt_key')  String receiptKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachReceiptRequest() when $default != null:
return $default(_that.receiptKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'receipt_key')  String receiptKey)  $default,) {final _that = this;
switch (_that) {
case _AttachReceiptRequest():
return $default(_that.receiptKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'receipt_key')  String receiptKey)?  $default,) {final _that = this;
switch (_that) {
case _AttachReceiptRequest() when $default != null:
return $default(_that.receiptKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachReceiptRequest implements AttachReceiptRequest {
  const _AttachReceiptRequest({@JsonKey(name: 'receipt_key') required this.receiptKey});
  factory _AttachReceiptRequest.fromJson(Map<String, dynamic> json) => _$AttachReceiptRequestFromJson(json);

@override@JsonKey(name: 'receipt_key') final  String receiptKey;

/// Create a copy of AttachReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachReceiptRequestCopyWith<_AttachReceiptRequest> get copyWith => __$AttachReceiptRequestCopyWithImpl<_AttachReceiptRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachReceiptRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachReceiptRequest&&(identical(other.receiptKey, receiptKey) || other.receiptKey == receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,receiptKey);
}

@override
String toString() {
    return 'AttachReceiptRequest(receiptKey: $receiptKey)';
}


}

/// @nodoc
abstract mixin class _$AttachReceiptRequestCopyWith<$Res> implements $AttachReceiptRequestCopyWith<$Res> {
  factory _$AttachReceiptRequestCopyWith(_AttachReceiptRequest value, $Res Function(_AttachReceiptRequest) _then) = __$AttachReceiptRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'receipt_key') String receiptKey
});




}
/// @nodoc
class __$AttachReceiptRequestCopyWithImpl<$Res>
    implements _$AttachReceiptRequestCopyWith<$Res> {
  __$AttachReceiptRequestCopyWithImpl(this._self, this._then);

  final _AttachReceiptRequest _self;
  final $Res Function(_AttachReceiptRequest) _then;

/// Create a copy of AttachReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receiptKey = null,}) {
  return _then(_AttachReceiptRequest(
receiptKey: null == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
