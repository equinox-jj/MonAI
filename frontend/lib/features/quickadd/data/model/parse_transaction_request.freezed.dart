// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_transaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParseTransactionRequest {

/// 1 to 300 characters.
@JsonKey(name: 'text') String get text;/// The user's date, `yyyy-MM-dd`.
@JsonKey(name: 'today') String get today;/// IANA name, e.g. `Asia/Jakarta`.
@JsonKey(name: 'timezone') String get timezone;
/// Create a copy of ParseTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseTransactionRequestCopyWith<ParseTransactionRequest> get copyWith => _$ParseTransactionRequestCopyWithImpl<ParseTransactionRequest>(this as ParseTransactionRequest, _$identity);

  /// Serializes this ParseTransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseTransactionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseTransactionRequest&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseTransactionRequest;
  return Object.hash(runtimeType,_this.text,_this.today,_this.timezone);
}

@override
String toString() {
  final _this = this as ParseTransactionRequest;
  return 'ParseTransactionRequest(text: ${_this.text}, today: ${_this.today}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $ParseTransactionRequestCopyWith<$Res>  {
  factory $ParseTransactionRequestCopyWith(ParseTransactionRequest value, $Res Function(ParseTransactionRequest) _then) = _$ParseTransactionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'text') String text,@JsonKey(name: 'today') String today,@JsonKey(name: 'timezone') String timezone
});




}
/// @nodoc
class _$ParseTransactionRequestCopyWithImpl<$Res>
    implements $ParseTransactionRequestCopyWith<$Res> {
  _$ParseTransactionRequestCopyWithImpl(this._self, this._then);

  final ParseTransactionRequest _self;
  final $Res Function(ParseTransactionRequest) _then;

/// Create a copy of ParseTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? today = null,Object? timezone = null,}) {
  return _then(ParseTransactionRequest(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseTransactionRequest].
extension ParseTransactionRequestPatterns on ParseTransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseTransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseTransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseTransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'text')  String text, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseTransactionRequest() when $default != null:
return $default(_that.text,_that.today,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'text')  String text, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionRequest():
return $default(_that.text,_that.today,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'text')  String text, @JsonKey(name: 'today')  String today, @JsonKey(name: 'timezone')  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionRequest() when $default != null:
return $default(_that.text,_that.today,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseTransactionRequest implements ParseTransactionRequest {
  const _ParseTransactionRequest({@JsonKey(name: 'text') required this.text, @JsonKey(name: 'today') required this.today, @JsonKey(name: 'timezone') required this.timezone});
  factory _ParseTransactionRequest.fromJson(Map<String, dynamic> json) => _$ParseTransactionRequestFromJson(json);

/// 1 to 300 characters.
@override@JsonKey(name: 'text') final  String text;
/// The user's date, `yyyy-MM-dd`.
@override@JsonKey(name: 'today') final  String today;
/// IANA name, e.g. `Asia/Jakarta`.
@override@JsonKey(name: 'timezone') final  String timezone;

/// Create a copy of ParseTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseTransactionRequestCopyWith<_ParseTransactionRequest> get copyWith => __$ParseTransactionRequestCopyWithImpl<_ParseTransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseTransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseTransactionRequest&&(identical(other.text, text) || other.text == text)&&(identical(other.today, today) || other.today == today)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,today,timezone);
}

@override
String toString() {
    return 'ParseTransactionRequest(text: $text, today: $today, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$ParseTransactionRequestCopyWith<$Res> implements $ParseTransactionRequestCopyWith<$Res> {
  factory _$ParseTransactionRequestCopyWith(_ParseTransactionRequest value, $Res Function(_ParseTransactionRequest) _then) = __$ParseTransactionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'text') String text,@JsonKey(name: 'today') String today,@JsonKey(name: 'timezone') String timezone
});




}
/// @nodoc
class __$ParseTransactionRequestCopyWithImpl<$Res>
    implements _$ParseTransactionRequestCopyWith<$Res> {
  __$ParseTransactionRequestCopyWithImpl(this._self, this._then);

  final _ParseTransactionRequest _self;
  final $Res Function(_ParseTransactionRequest) _then;

/// Create a copy of ParseTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? today = null,Object? timezone = null,}) {
  return _then(_ParseTransactionRequest(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
