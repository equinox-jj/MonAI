// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_receipt_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParseReceiptResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') ParseReceiptData? get data;
/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseReceiptResponseCopyWith<ParseReceiptResponse> get copyWith => _$ParseReceiptResponseCopyWithImpl<ParseReceiptResponse>(this as ParseReceiptResponse, _$identity);

  /// Serializes this ParseReceiptResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseReceiptResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseReceiptResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseReceiptResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ParseReceiptResponse;
  return 'ParseReceiptResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ParseReceiptResponseCopyWith<$Res>  {
  factory $ParseReceiptResponseCopyWith(ParseReceiptResponse value, $Res Function(ParseReceiptResponse) _then) = _$ParseReceiptResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ParseReceiptData? data
});


$ParseReceiptDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$ParseReceiptResponseCopyWithImpl<$Res>
    implements $ParseReceiptResponseCopyWith<$Res> {
  _$ParseReceiptResponseCopyWithImpl(this._self, this._then);

  final ParseReceiptResponse _self;
  final $Res Function(ParseReceiptResponse) _then;

/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(ParseReceiptResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ParseReceiptData?,
  ));
}
/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParseReceiptDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ParseReceiptDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParseReceiptResponse].
extension ParseReceiptResponsePatterns on ParseReceiptResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseReceiptResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseReceiptResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseReceiptResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseReceiptResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseReceiptData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseReceiptResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseReceiptData? data)  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseReceiptData? data)?  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseReceiptResponse implements ParseReceiptResponse {
  const _ParseReceiptResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _ParseReceiptResponse.fromJson(Map<String, dynamic> json) => _$ParseReceiptResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  ParseReceiptData? data;

/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseReceiptResponseCopyWith<_ParseReceiptResponse> get copyWith => __$ParseReceiptResponseCopyWithImpl<_ParseReceiptResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseReceiptResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseReceiptResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'ParseReceiptResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ParseReceiptResponseCopyWith<$Res> implements $ParseReceiptResponseCopyWith<$Res> {
  factory _$ParseReceiptResponseCopyWith(_ParseReceiptResponse value, $Res Function(_ParseReceiptResponse) _then) = __$ParseReceiptResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ParseReceiptData? data
});


@override $ParseReceiptDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$ParseReceiptResponseCopyWithImpl<$Res>
    implements _$ParseReceiptResponseCopyWith<$Res> {
  __$ParseReceiptResponseCopyWithImpl(this._self, this._then);

  final _ParseReceiptResponse _self;
  final $Res Function(_ParseReceiptResponse) _then;

/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_ParseReceiptResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ParseReceiptData?,
  ));
}

/// Create a copy of ParseReceiptResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParseReceiptDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ParseReceiptDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ParseReceiptData {

@JsonKey(name: 'draft') ReceiptDraftData? get draft;
/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseReceiptDataCopyWith<ParseReceiptData> get copyWith => _$ParseReceiptDataCopyWithImpl<ParseReceiptData>(this as ParseReceiptData, _$identity);

  /// Serializes this ParseReceiptData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseReceiptData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseReceiptData&&(identical(other.draft, _this.draft) || other.draft == _this.draft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseReceiptData;
  return Object.hash(runtimeType,_this.draft);
}

@override
String toString() {
  final _this = this as ParseReceiptData;
  return 'ParseReceiptData(draft: ${_this.draft})';
}


}

/// @nodoc
abstract mixin class $ParseReceiptDataCopyWith<$Res>  {
  factory $ParseReceiptDataCopyWith(ParseReceiptData value, $Res Function(ParseReceiptData) _then) = _$ParseReceiptDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'draft') ReceiptDraftData? draft
});


$ReceiptDraftDataCopyWith<$Res>? get draft;

}
/// @nodoc
class _$ParseReceiptDataCopyWithImpl<$Res>
    implements $ParseReceiptDataCopyWith<$Res> {
  _$ParseReceiptDataCopyWithImpl(this._self, this._then);

  final ParseReceiptData _self;
  final $Res Function(ParseReceiptData) _then;

/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = freezed,}) {
  return _then(ParseReceiptData(
draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraftData?,
  ));
}
/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftDataCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ReceiptDraftDataCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParseReceiptData].
extension ParseReceiptDataPatterns on ParseReceiptData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseReceiptData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseReceiptData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseReceiptData value)  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseReceiptData value)?  $default,){
final _that = this;
switch (_that) {
case _ParseReceiptData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'draft')  ReceiptDraftData? draft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseReceiptData() when $default != null:
return $default(_that.draft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'draft')  ReceiptDraftData? draft)  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptData():
return $default(_that.draft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'draft')  ReceiptDraftData? draft)?  $default,) {final _that = this;
switch (_that) {
case _ParseReceiptData() when $default != null:
return $default(_that.draft);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseReceiptData implements ParseReceiptData {
  const _ParseReceiptData({@JsonKey(name: 'draft') this.draft});
  factory _ParseReceiptData.fromJson(Map<String, dynamic> json) => _$ParseReceiptDataFromJson(json);

@override@JsonKey(name: 'draft') final  ReceiptDraftData? draft;

/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseReceiptDataCopyWith<_ParseReceiptData> get copyWith => __$ParseReceiptDataCopyWithImpl<_ParseReceiptData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseReceiptDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseReceiptData&&(identical(other.draft, draft) || other.draft == draft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,draft);
}

@override
String toString() {
    return 'ParseReceiptData(draft: $draft)';
}


}

/// @nodoc
abstract mixin class _$ParseReceiptDataCopyWith<$Res> implements $ParseReceiptDataCopyWith<$Res> {
  factory _$ParseReceiptDataCopyWith(_ParseReceiptData value, $Res Function(_ParseReceiptData) _then) = __$ParseReceiptDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'draft') ReceiptDraftData? draft
});


@override $ReceiptDraftDataCopyWith<$Res>? get draft;

}
/// @nodoc
class __$ParseReceiptDataCopyWithImpl<$Res>
    implements _$ParseReceiptDataCopyWith<$Res> {
  __$ParseReceiptDataCopyWithImpl(this._self, this._then);

  final _ParseReceiptData _self;
  final $Res Function(_ParseReceiptData) _then;

/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = freezed,}) {
  return _then(_ParseReceiptData(
draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraftData?,
  ));
}

/// Create a copy of ParseReceiptData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftDataCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ReceiptDraftDataCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// @nodoc
mixin _$ReceiptDraftData {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'amount') int? get amount;@JsonKey(name: 'wallet_id') String? get walletId;@JsonKey(name: 'category_id') String? get categoryId;/// `yyyy-MM-dd`.
@JsonKey(name: 'date') String? get date;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'merchant') String? get merchant;@JsonKey(name: 'confidence') DraftConfidenceData? get confidence;@JsonKey(name: 'items') List<ReceiptItemData>? get items;
/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDraftDataCopyWith<ReceiptDraftData> get copyWith => _$ReceiptDraftDataCopyWithImpl<ReceiptDraftData>(this as ReceiptDraftData, _$identity);

  /// Serializes this ReceiptDraftData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptDraftData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptDraftData&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptDraftData;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.walletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.confidence,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ReceiptDraftData;
  return 'ReceiptDraftData(type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, confidence: ${_this.confidence}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ReceiptDraftDataCopyWith<$Res>  {
  factory $ReceiptDraftDataCopyWith(ReceiptDraftData value, $Res Function(ReceiptDraftData) _then) = _$ReceiptDraftDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'confidence') DraftConfidenceData? confidence,@JsonKey(name: 'items') List<ReceiptItemData>? items
});


$DraftConfidenceDataCopyWith<$Res>? get confidence;

}
/// @nodoc
class _$ReceiptDraftDataCopyWithImpl<$Res>
    implements $ReceiptDraftDataCopyWith<$Res> {
  _$ReceiptDraftDataCopyWithImpl(this._self, this._then);

  final ReceiptDraftData _self;
  final $Res Function(ReceiptDraftData) _then;

/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = freezed,Object? items = freezed,}) {
  return _then(ReceiptDraftData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidenceData?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItemData>?,
  ));
}
/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceDataCopyWith<$Res>? get confidence {
    if (_self.confidence == null) {
    return null;
  }

  return $DraftConfidenceDataCopyWith<$Res>(_self.confidence!, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptDraftData].
extension ReceiptDraftDataPatterns on ReceiptDraftData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptDraftData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptDraftData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptDraftData value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptDraftData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptDraftData value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptDraftData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence, @JsonKey(name: 'items')  List<ReceiptItemData>? items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptDraftData() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence, @JsonKey(name: 'items')  List<ReceiptItemData>? items)  $default,) {final _that = this;
switch (_that) {
case _ReceiptDraftData():
return $default(_that.type,_that.amount,_that.walletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence, @JsonKey(name: 'items')  List<ReceiptItemData>? items)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptDraftData() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptDraftData implements ReceiptDraftData {
  const _ReceiptDraftData({@JsonKey(name: 'type') this.type, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'wallet_id') this.walletId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'date') this.date, @JsonKey(name: 'note') this.note, @JsonKey(name: 'merchant') this.merchant, @JsonKey(name: 'confidence') this.confidence, @JsonKey(name: 'items')  List<ReceiptItemData>? items}): _items = items;
  factory _ReceiptDraftData.fromJson(Map<String, dynamic> json) => _$ReceiptDraftDataFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'amount') final  int? amount;
@override@JsonKey(name: 'wallet_id') final  String? walletId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
/// `yyyy-MM-dd`.
@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'merchant') final  String? merchant;
@override@JsonKey(name: 'confidence') final  DraftConfidenceData? confidence;
 final  List<ReceiptItemData>? _items;
@override@JsonKey(name: 'items') List<ReceiptItemData>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDraftDataCopyWith<_ReceiptDraftData> get copyWith => __$ReceiptDraftDataCopyWithImpl<_ReceiptDraftData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptDraftDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptDraftData&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,walletId,categoryId,date,note,merchant,confidence,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ReceiptDraftData(type: $type, amount: $amount, walletId: $walletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, confidence: $confidence, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDraftDataCopyWith<$Res> implements $ReceiptDraftDataCopyWith<$Res> {
  factory _$ReceiptDraftDataCopyWith(_ReceiptDraftData value, $Res Function(_ReceiptDraftData) _then) = __$ReceiptDraftDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'confidence') DraftConfidenceData? confidence,@JsonKey(name: 'items') List<ReceiptItemData>? items
});


@override $DraftConfidenceDataCopyWith<$Res>? get confidence;

}
/// @nodoc
class __$ReceiptDraftDataCopyWithImpl<$Res>
    implements _$ReceiptDraftDataCopyWith<$Res> {
  __$ReceiptDraftDataCopyWithImpl(this._self, this._then);

  final _ReceiptDraftData _self;
  final $Res Function(_ReceiptDraftData) _then;

/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = freezed,Object? items = freezed,}) {
  return _then(_ReceiptDraftData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidenceData?,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItemData>?,
  ));
}

/// Create a copy of ReceiptDraftData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceDataCopyWith<$Res>? get confidence {
    if (_self.confidence == null) {
    return null;
  }

  return $DraftConfidenceDataCopyWith<$Res>(_self.confidence!, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// @nodoc
mixin _$DraftConfidenceData {

@JsonKey(name: 'type') double? get type;@JsonKey(name: 'amount') double? get amount;@JsonKey(name: 'wallet') double? get wallet;@JsonKey(name: 'category') double? get category;@JsonKey(name: 'date') double? get date;
/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftConfidenceDataCopyWith<DraftConfidenceData> get copyWith => _$DraftConfidenceDataCopyWithImpl<DraftConfidenceData>(this as DraftConfidenceData, _$identity);

  /// Serializes this DraftConfidenceData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DraftConfidenceData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftConfidenceData&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.wallet, _this.wallet) || other.wallet == _this.wallet)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.date, _this.date) || other.date == _this.date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DraftConfidenceData;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.wallet,_this.category,_this.date);
}

@override
String toString() {
  final _this = this as DraftConfidenceData;
  return 'DraftConfidenceData(type: ${_this.type}, amount: ${_this.amount}, wallet: ${_this.wallet}, category: ${_this.category}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $DraftConfidenceDataCopyWith<$Res>  {
  factory $DraftConfidenceDataCopyWith(DraftConfidenceData value, $Res Function(DraftConfidenceData) _then) = _$DraftConfidenceDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') double? type,@JsonKey(name: 'amount') double? amount,@JsonKey(name: 'wallet') double? wallet,@JsonKey(name: 'category') double? category,@JsonKey(name: 'date') double? date
});




}
/// @nodoc
class _$DraftConfidenceDataCopyWithImpl<$Res>
    implements $DraftConfidenceDataCopyWith<$Res> {
  _$DraftConfidenceDataCopyWithImpl(this._self, this._then);

  final DraftConfidenceData _self;
  final $Res Function(DraftConfidenceData) _then;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? wallet = freezed,Object? category = freezed,Object? date = freezed,}) {
  return _then(DraftConfidenceData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftConfidenceData].
extension DraftConfidenceDataPatterns on DraftConfidenceData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftConfidenceData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftConfidenceData value)  $default,){
final _that = this;
switch (_that) {
case _DraftConfidenceData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftConfidenceData value)?  $default,){
final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)  $default,) {final _that = this;
switch (_that) {
case _DraftConfidenceData():
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)?  $default,) {final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DraftConfidenceData implements DraftConfidenceData {
  const _DraftConfidenceData({@JsonKey(name: 'type') this.type, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'wallet') this.wallet, @JsonKey(name: 'category') this.category, @JsonKey(name: 'date') this.date});
  factory _DraftConfidenceData.fromJson(Map<String, dynamic> json) => _$DraftConfidenceDataFromJson(json);

@override@JsonKey(name: 'type') final  double? type;
@override@JsonKey(name: 'amount') final  double? amount;
@override@JsonKey(name: 'wallet') final  double? wallet;
@override@JsonKey(name: 'category') final  double? category;
@override@JsonKey(name: 'date') final  double? date;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftConfidenceDataCopyWith<_DraftConfidenceData> get copyWith => __$DraftConfidenceDataCopyWithImpl<_DraftConfidenceData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DraftConfidenceDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftConfidenceData&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,wallet,category,date);
}

@override
String toString() {
    return 'DraftConfidenceData(type: $type, amount: $amount, wallet: $wallet, category: $category, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DraftConfidenceDataCopyWith<$Res> implements $DraftConfidenceDataCopyWith<$Res> {
  factory _$DraftConfidenceDataCopyWith(_DraftConfidenceData value, $Res Function(_DraftConfidenceData) _then) = __$DraftConfidenceDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') double? type,@JsonKey(name: 'amount') double? amount,@JsonKey(name: 'wallet') double? wallet,@JsonKey(name: 'category') double? category,@JsonKey(name: 'date') double? date
});




}
/// @nodoc
class __$DraftConfidenceDataCopyWithImpl<$Res>
    implements _$DraftConfidenceDataCopyWith<$Res> {
  __$DraftConfidenceDataCopyWithImpl(this._self, this._then);

  final _DraftConfidenceData _self;
  final $Res Function(_DraftConfidenceData) _then;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? wallet = freezed,Object? category = freezed,Object? date = freezed,}) {
  return _then(_DraftConfidenceData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$ReceiptItemData {

@JsonKey(name: 'name') String? get name;@JsonKey(name: 'quantity') double? get quantity;@JsonKey(name: 'amount') int? get amount;
/// Create a copy of ReceiptItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemDataCopyWith<ReceiptItemData> get copyWith => _$ReceiptItemDataCopyWithImpl<ReceiptItemData>(this as ReceiptItemData, _$identity);

  /// Serializes this ReceiptItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptItemData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItemData&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptItemData;
  return Object.hash(runtimeType,_this.name,_this.quantity,_this.amount);
}

@override
String toString() {
  final _this = this as ReceiptItemData;
  return 'ReceiptItemData(name: ${_this.name}, quantity: ${_this.quantity}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $ReceiptItemDataCopyWith<$Res>  {
  factory $ReceiptItemDataCopyWith(ReceiptItemData value, $Res Function(ReceiptItemData) _then) = _$ReceiptItemDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'quantity') double? quantity,@JsonKey(name: 'amount') int? amount
});




}
/// @nodoc
class _$ReceiptItemDataCopyWithImpl<$Res>
    implements $ReceiptItemDataCopyWith<$Res> {
  _$ReceiptItemDataCopyWithImpl(this._self, this._then);

  final ReceiptItemData _self;
  final $Res Function(ReceiptItemData) _then;

/// Create a copy of ReceiptItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? quantity = freezed,Object? amount = freezed,}) {
  return _then(ReceiptItemData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItemData].
extension ReceiptItemDataPatterns on ReceiptItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItemData value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItemData value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'quantity')  double? quantity, @JsonKey(name: 'amount')  int? amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItemData() when $default != null:
return $default(_that.name,_that.quantity,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'quantity')  double? quantity, @JsonKey(name: 'amount')  int? amount)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItemData():
return $default(_that.name,_that.quantity,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'quantity')  double? quantity, @JsonKey(name: 'amount')  int? amount)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItemData() when $default != null:
return $default(_that.name,_that.quantity,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItemData implements ReceiptItemData {
  const _ReceiptItemData({@JsonKey(name: 'name') this.name, @JsonKey(name: 'quantity') this.quantity, @JsonKey(name: 'amount') this.amount});
  factory _ReceiptItemData.fromJson(Map<String, dynamic> json) => _$ReceiptItemDataFromJson(json);

@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'quantity') final  double? quantity;
@override@JsonKey(name: 'amount') final  int? amount;

/// Create a copy of ReceiptItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemDataCopyWith<_ReceiptItemData> get copyWith => __$ReceiptItemDataCopyWithImpl<_ReceiptItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItemData&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,quantity,amount);
}

@override
String toString() {
    return 'ReceiptItemData(name: $name, quantity: $quantity, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemDataCopyWith<$Res> implements $ReceiptItemDataCopyWith<$Res> {
  factory _$ReceiptItemDataCopyWith(_ReceiptItemData value, $Res Function(_ReceiptItemData) _then) = __$ReceiptItemDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'quantity') double? quantity,@JsonKey(name: 'amount') int? amount
});




}
/// @nodoc
class __$ReceiptItemDataCopyWithImpl<$Res>
    implements _$ReceiptItemDataCopyWith<$Res> {
  __$ReceiptItemDataCopyWithImpl(this._self, this._then);

  final _ReceiptItemData _self;
  final $Res Function(_ReceiptItemData) _then;

/// Create a copy of ReceiptItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? quantity = freezed,Object? amount = freezed,}) {
  return _then(_ReceiptItemData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
