// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_receipt_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParseReceiptRequest {

@JsonKey(name: 'ocr_text') String get ocrText;/// The user's date, `yyyy-MM-dd`.
@JsonKey(name: 'today') String get today;/// IANA name, e.g. `Asia/Jakarta`.
@JsonKey(name: 'timezone') String get timezone;
/// Create a copy of ParseReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseReceiptRequestCopyWith<ParseReceiptRequest> get copyWith => _$ParseReceiptRequestCopyWithImpl<ParseReceiptRequest>(this as ParseReceiptRequest, _$identity);

  /// Serializes this ParseReceiptRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseReceiptRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseReceiptRequest&&(identical(other.ocrText, _this.ocrText) || other.ocrText == _this.ocrText)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseReceiptRequest;
  return Object.hash(runtimeType,_this.ocrText,_this.today,_this.timezone);
}

@override
String toString() {
  final _this = this as ParseReceiptRequest;
  return 'ParseReceiptRequest(ocrText: ${_this.ocrText}, today: ${_this.today}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $ParseReceiptRequestCopyWith<$Res>  {
  factory $ParseReceiptRequestCopyWith(ParseReceiptRequest value, $Res Function(ParseReceiptRequest) _then) = _$ParseReceiptRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ocr_text') String ocrText,@JsonKey(name: 'today') String today,@JsonKey(name: 'timezone') String timezone
});




}
/// @nodoc
class _$ParseReceiptRequestCopyWithImpl<$Res>
    implements $ParseReceiptRequestCopyWith<$Res> {
  _$ParseReceiptRequestCopyWithImpl(this._self, this._then);

  final ParseReceiptRequest _self;
  final $Res Function(ParseReceiptRequest) _then;

/// Create a copy of ParseReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ocrText = null,Object? today = null,Object? timezone = null,}) {
  return _then(ParseReceiptRequest(
ocrText: null == ocrText ? _self.ocrText : ocrText // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseReceiptRequest].
extension ParseReceiptRequestPatterns on ParseReceiptRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseReceiptRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseReceiptRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseReceiptRequest value)  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseReceiptRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ocr_text')  String ocrText, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseReceiptRequest() when $default != null:
return $default(_that.ocrText,_that.today,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ocr_text')  String ocrText, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptRequest():
return $default(_that.ocrText,_that.today,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ocr_text')  String ocrText, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptRequest() when $default != null:
return $default(_that.ocrText,_that.today,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseReceiptRequest implements ParseReceiptRequest {
  const _ParseReceiptRequest({@JsonKey(name: 'ocr_text') required this.ocrText, @JsonKey(name: 'today') required this.today, @JsonKey(name: 'timezone') required this.timezone});
  factory _ParseReceiptRequest.fromJson(Map<String, dynamic> json) => _$ParseReceiptRequestFromJson(json);

@override@JsonKey(name: 'ocr_text') final  String ocrText;
/// The user's date, `yyyy-MM-dd`.
@override@JsonKey(name: 'today') final  String today;
/// IANA name, e.g. `Asia/Jakarta`.
@override@JsonKey(name: 'timezone') final  String timezone;

/// Create a copy of ParseReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseReceiptRequestCopyWith<_ParseReceiptRequest> get copyWith => __$ParseReceiptRequestCopyWithImpl<_ParseReceiptRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseReceiptRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseReceiptRequest&&(identical(other.ocrText, ocrText) || other.ocrText == ocrText)&&(identical(other.today, today) || other.today == today)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ocrText,today,timezone);
}

@override
String toString() {
    return 'ParseReceiptRequest(ocrText: $ocrText, today: $today, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$ParseReceiptRequestCopyWith<$Res> implements $ParseReceiptRequestCopyWith<$Res> {
  factory _$ParseReceiptRequestCopyWith(_ParseReceiptRequest value, $Res Function(_ParseReceiptRequest) _then) = __$ParseReceiptRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ocr_text') String ocrText,@JsonKey(name: 'today') String today,@JsonKey(name: 'timezone') String timezone
});




}
/// @nodoc
class __$ParseReceiptRequestCopyWithImpl<$Res>
    implements _$ParseReceiptRequestCopyWith<$Res> {
  __$ParseReceiptRequestCopyWithImpl(this._self, this._then);

  final _ParseReceiptRequest _self;
  final $Res Function(_ParseReceiptRequest) _then;

/// Create a copy of ParseReceiptRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ocrText = null,Object? today = null,Object? timezone = null,}) {
  return _then(_ParseReceiptRequest(
ocrText: null == ocrText ? _self.ocrText : ocrText // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
