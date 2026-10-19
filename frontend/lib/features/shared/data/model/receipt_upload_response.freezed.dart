// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptUploadResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') ReceiptUploadData? get data;
/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptUploadResponseCopyWith<ReceiptUploadResponse> get copyWith => _$ReceiptUploadResponseCopyWithImpl<ReceiptUploadResponse>(this as ReceiptUploadResponse, _$identity);

  /// Serializes this ReceiptUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptUploadResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptUploadResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptUploadResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ReceiptUploadResponse;
  return 'ReceiptUploadResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ReceiptUploadResponseCopyWith<$Res>  {
  factory $ReceiptUploadResponseCopyWith(ReceiptUploadResponse value, $Res Function(ReceiptUploadResponse) _then) = _$ReceiptUploadResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ReceiptUploadData? data
});


$ReceiptUploadDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$ReceiptUploadResponseCopyWithImpl<$Res>
    implements $ReceiptUploadResponseCopyWith<$Res> {
  _$ReceiptUploadResponseCopyWithImpl(this._self, this._then);

  final ReceiptUploadResponse _self;
  final $Res Function(ReceiptUploadResponse) _then;

/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(ReceiptUploadResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ReceiptUploadData?,
  ));
}
/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptUploadDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ReceiptUploadDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptUploadResponse].
extension ReceiptUploadResponsePatterns on ReceiptUploadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptUploadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptUploadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptUploadResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptUploadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptUploadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptUploadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ReceiptUploadData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptUploadResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ReceiptUploadData? data)  $default,) {final _that = this;
switch (_that) {
case _ReceiptUploadResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ReceiptUploadData? data)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptUploadResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptUploadResponse implements ReceiptUploadResponse {
  const _ReceiptUploadResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _ReceiptUploadResponse.fromJson(Map<String, dynamic> json) => _$ReceiptUploadResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  ReceiptUploadData? data;

/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptUploadResponseCopyWith<_ReceiptUploadResponse> get copyWith => __$ReceiptUploadResponseCopyWithImpl<_ReceiptUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptUploadResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'ReceiptUploadResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ReceiptUploadResponseCopyWith<$Res> implements $ReceiptUploadResponseCopyWith<$Res> {
  factory _$ReceiptUploadResponseCopyWith(_ReceiptUploadResponse value, $Res Function(_ReceiptUploadResponse) _then) = __$ReceiptUploadResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ReceiptUploadData? data
});


@override $ReceiptUploadDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$ReceiptUploadResponseCopyWithImpl<$Res>
    implements _$ReceiptUploadResponseCopyWith<$Res> {
  __$ReceiptUploadResponseCopyWithImpl(this._self, this._then);

  final _ReceiptUploadResponse _self;
  final $Res Function(_ReceiptUploadResponse) _then;

/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_ReceiptUploadResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ReceiptUploadData?,
  ));
}

/// Create a copy of ReceiptUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptUploadDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ReceiptUploadDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ReceiptUploadData {

@JsonKey(name: 'receipt_key') String? get receiptKey;
/// Create a copy of ReceiptUploadData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptUploadDataCopyWith<ReceiptUploadData> get copyWith => _$ReceiptUploadDataCopyWithImpl<ReceiptUploadData>(this as ReceiptUploadData, _$identity);

  /// Serializes this ReceiptUploadData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptUploadData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptUploadData&&(identical(other.receiptKey, _this.receiptKey) || other.receiptKey == _this.receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptUploadData;
  return Object.hash(runtimeType,_this.receiptKey);
}

@override
String toString() {
  final _this = this as ReceiptUploadData;
  return 'ReceiptUploadData(receiptKey: ${_this.receiptKey})';
}


}

/// @nodoc
abstract mixin class $ReceiptUploadDataCopyWith<$Res>  {
  factory $ReceiptUploadDataCopyWith(ReceiptUploadData value, $Res Function(ReceiptUploadData) _then) = _$ReceiptUploadDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'receipt_key') String? receiptKey
});




}
/// @nodoc
class _$ReceiptUploadDataCopyWithImpl<$Res>
    implements $ReceiptUploadDataCopyWith<$Res> {
  _$ReceiptUploadDataCopyWithImpl(this._self, this._then);

  final ReceiptUploadData _self;
  final $Res Function(ReceiptUploadData) _then;

/// Create a copy of ReceiptUploadData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receiptKey = freezed,}) {
  return _then(ReceiptUploadData(
receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptUploadData].
extension ReceiptUploadDataPatterns on ReceiptUploadData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptUploadData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptUploadData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptUploadData value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptUploadData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptUploadData value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptUploadData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'receipt_key')  String? receiptKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptUploadData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'receipt_key')  String? receiptKey)  $default,) {final _that = this;
switch (_that) {
case _ReceiptUploadData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'receipt_key')  String? receiptKey)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptUploadData() when $default != null:
return $default(_that.receiptKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptUploadData implements ReceiptUploadData {
  const _ReceiptUploadData({@JsonKey(name: 'receipt_key') this.receiptKey});
  factory _ReceiptUploadData.fromJson(Map<String, dynamic> json) => _$ReceiptUploadDataFromJson(json);

@override@JsonKey(name: 'receipt_key') final  String? receiptKey;

/// Create a copy of ReceiptUploadData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptUploadDataCopyWith<_ReceiptUploadData> get copyWith => __$ReceiptUploadDataCopyWithImpl<_ReceiptUploadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptUploadDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptUploadData&&(identical(other.receiptKey, receiptKey) || other.receiptKey == receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,receiptKey);
}

@override
String toString() {
    return 'ReceiptUploadData(receiptKey: $receiptKey)';
}


}

/// @nodoc
abstract mixin class _$ReceiptUploadDataCopyWith<$Res> implements $ReceiptUploadDataCopyWith<$Res> {
  factory _$ReceiptUploadDataCopyWith(_ReceiptUploadData value, $Res Function(_ReceiptUploadData) _then) = __$ReceiptUploadDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'receipt_key') String? receiptKey
});




}
/// @nodoc
class __$ReceiptUploadDataCopyWithImpl<$Res>
    implements _$ReceiptUploadDataCopyWith<$Res> {
  __$ReceiptUploadDataCopyWithImpl(this._self, this._then);

  final _ReceiptUploadData _self;
  final $Res Function(_ReceiptUploadData) _then;

/// Create a copy of ReceiptUploadData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receiptKey = freezed,}) {
  return _then(_ReceiptUploadData(
receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
