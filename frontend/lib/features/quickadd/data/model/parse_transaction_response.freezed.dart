// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_transaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParseTransactionResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') ParseTransactionData? get data;
/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseTransactionResponseCopyWith<ParseTransactionResponse> get copyWith => _$ParseTransactionResponseCopyWithImpl<ParseTransactionResponse>(this as ParseTransactionResponse, _$identity);

  /// Serializes this ParseTransactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseTransactionResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseTransactionResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseTransactionResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ParseTransactionResponse;
  return 'ParseTransactionResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ParseTransactionResponseCopyWith<$Res>  {
  factory $ParseTransactionResponseCopyWith(ParseTransactionResponse value, $Res Function(ParseTransactionResponse) _then) = _$ParseTransactionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ParseTransactionData? data
});


$ParseTransactionDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$ParseTransactionResponseCopyWithImpl<$Res>
    implements $ParseTransactionResponseCopyWith<$Res> {
  _$ParseTransactionResponseCopyWithImpl(this._self, this._then);

  final ParseTransactionResponse _self;
  final $Res Function(ParseTransactionResponse) _then;

/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(ParseTransactionResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ParseTransactionData?,
  ));
}
/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParseTransactionDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ParseTransactionDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ParseTransactionResponse].
extension ParseTransactionResponsePatterns on ParseTransactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseTransactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseTransactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseTransactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseTransactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseTransactionData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseTransactionResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseTransactionData? data)  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  ParseTransactionData? data)?  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseTransactionResponse implements ParseTransactionResponse {
  const _ParseTransactionResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _ParseTransactionResponse.fromJson(Map<String, dynamic> json) => _$ParseTransactionResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  ParseTransactionData? data;

/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseTransactionResponseCopyWith<_ParseTransactionResponse> get copyWith => __$ParseTransactionResponseCopyWithImpl<_ParseTransactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseTransactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseTransactionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'ParseTransactionResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ParseTransactionResponseCopyWith<$Res> implements $ParseTransactionResponseCopyWith<$Res> {
  factory _$ParseTransactionResponseCopyWith(_ParseTransactionResponse value, $Res Function(_ParseTransactionResponse) _then) = __$ParseTransactionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') ParseTransactionData? data
});


@override $ParseTransactionDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$ParseTransactionResponseCopyWithImpl<$Res>
    implements _$ParseTransactionResponseCopyWith<$Res> {
  __$ParseTransactionResponseCopyWithImpl(this._self, this._then);

  final _ParseTransactionResponse _self;
  final $Res Function(_ParseTransactionResponse) _then;

/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_ParseTransactionResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ParseTransactionData?,
  ));
}

/// Create a copy of ParseTransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParseTransactionDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $ParseTransactionDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ParseTransactionData {

@JsonKey(name: 'drafts') List<TransactionDraftData>? get drafts;
/// Create a copy of ParseTransactionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseTransactionDataCopyWith<ParseTransactionData> get copyWith => _$ParseTransactionDataCopyWithImpl<ParseTransactionData>(this as ParseTransactionData, _$identity);

  /// Serializes this ParseTransactionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParseTransactionData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseTransactionData&&const DeepCollectionEquality().equals(other.drafts, _this.drafts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParseTransactionData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.drafts));
}

@override
String toString() {
  final _this = this as ParseTransactionData;
  return 'ParseTransactionData(drafts: ${_this.drafts})';
}


}

/// @nodoc
abstract mixin class $ParseTransactionDataCopyWith<$Res>  {
  factory $ParseTransactionDataCopyWith(ParseTransactionData value, $Res Function(ParseTransactionData) _then) = _$ParseTransactionDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'drafts') List<TransactionDraftData>? drafts
});




}
/// @nodoc
class _$ParseTransactionDataCopyWithImpl<$Res>
    implements $ParseTransactionDataCopyWith<$Res> {
  _$ParseTransactionDataCopyWithImpl(this._self, this._then);

  final ParseTransactionData _self;
  final $Res Function(ParseTransactionData) _then;

/// Create a copy of ParseTransactionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drafts = freezed,}) {
  return _then(ParseTransactionData(
drafts: freezed == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<TransactionDraftData>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseTransactionData].
extension ParseTransactionDataPatterns on ParseTransactionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseTransactionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseTransactionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseTransactionData value)  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseTransactionData value)?  $default,){
final _that = this;
switch (_that) {
case _ParseTransactionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'drafts')  List<TransactionDraftData>? drafts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseTransactionData() when $default != null:
return $default(_that.drafts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'drafts')  List<TransactionDraftData>? drafts)  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionData():
return $default(_that.drafts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'drafts')  List<TransactionDraftData>? drafts)?  $default,) {final _that = this;
switch (_that) {
case _ParseTransactionData() when $default != null:
return $default(_that.drafts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParseTransactionData implements ParseTransactionData {
  const _ParseTransactionData({@JsonKey(name: 'drafts')  List<TransactionDraftData>? drafts}): _drafts = drafts;
  factory _ParseTransactionData.fromJson(Map<String, dynamic> json) => _$ParseTransactionDataFromJson(json);

 final  List<TransactionDraftData>? _drafts;
@override@JsonKey(name: 'drafts') List<TransactionDraftData>? get drafts {
  final value = _drafts;
  if (value == null) return null;
  if (_drafts is EqualUnmodifiableListView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ParseTransactionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseTransactionDataCopyWith<_ParseTransactionData> get copyWith => __$ParseTransactionDataCopyWithImpl<_ParseTransactionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParseTransactionDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseTransactionData&&const DeepCollectionEquality().equals(other.drafts, _drafts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_drafts));
}

@override
String toString() {
    return 'ParseTransactionData(drafts: $drafts)';
}


}

/// @nodoc
abstract mixin class _$ParseTransactionDataCopyWith<$Res> implements $ParseTransactionDataCopyWith<$Res> {
  factory _$ParseTransactionDataCopyWith(_ParseTransactionData value, $Res Function(_ParseTransactionData) _then) = __$ParseTransactionDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'drafts') List<TransactionDraftData>? drafts
});




}
/// @nodoc
class __$ParseTransactionDataCopyWithImpl<$Res>
    implements _$ParseTransactionDataCopyWith<$Res> {
  __$ParseTransactionDataCopyWithImpl(this._self, this._then);

  final _ParseTransactionData _self;
  final $Res Function(_ParseTransactionData) _then;

/// Create a copy of ParseTransactionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drafts = freezed,}) {
  return _then(_ParseTransactionData(
drafts: freezed == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<TransactionDraftData>?,
  ));
}


}


/// @nodoc
mixin _$TransactionDraftData {

@JsonKey(name: 'type') String? get type;@JsonKey(name: 'amount') int? get amount;@JsonKey(name: 'wallet_id') String? get walletId;@JsonKey(name: 'to_wallet_id') String? get toWalletId;@JsonKey(name: 'category_id') String? get categoryId;/// `yyyy-MM-dd`.
@JsonKey(name: 'date') String? get date;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'merchant') String? get merchant;@JsonKey(name: 'confidence') DraftConfidenceData? get confidence;
/// Create a copy of TransactionDraftData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDraftDataCopyWith<TransactionDraftData> get copyWith => _$TransactionDraftDataCopyWithImpl<TransactionDraftData>(this as TransactionDraftData, _$identity);

  /// Serializes this TransactionDraftData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionDraftData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDraftData&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionDraftData;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.confidence);
}

@override
String toString() {
  final _this = this as TransactionDraftData;
  return 'TransactionDraftData(type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, confidence: ${_this.confidence})';
}


}

/// @nodoc
abstract mixin class $TransactionDraftDataCopyWith<$Res>  {
  factory $TransactionDraftDataCopyWith(TransactionDraftData value, $Res Function(TransactionDraftData) _then) = _$TransactionDraftDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'confidence') DraftConfidenceData? confidence
});


$DraftConfidenceDataCopyWith<$Res>? get confidence;

}
/// @nodoc
class _$TransactionDraftDataCopyWithImpl<$Res>
    implements $TransactionDraftDataCopyWith<$Res> {
  _$TransactionDraftDataCopyWithImpl(this._self, this._then);

  final TransactionDraftData _self;
  final $Res Function(TransactionDraftData) _then;

/// Create a copy of TransactionDraftData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = freezed,}) {
  return _then(TransactionDraftData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidenceData?,
  ));
}
/// Create a copy of TransactionDraftData
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


/// Adds pattern-matching-related methods to [TransactionDraftData].
extension TransactionDraftDataPatterns on TransactionDraftData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDraftData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDraftData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDraftData value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDraftData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDraftData value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDraftData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionDraftData() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence)  $default,) {final _that = this;
switch (_that) {
case _TransactionDraftData():
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'confidence')  DraftConfidenceData? confidence)?  $default,) {final _that = this;
switch (_that) {
case _TransactionDraftData() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionDraftData implements TransactionDraftData {
  const _TransactionDraftData({@JsonKey(name: 'type') this.type, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'wallet_id') this.walletId, @JsonKey(name: 'to_wallet_id') this.toWalletId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'date') this.date, @JsonKey(name: 'note') this.note, @JsonKey(name: 'merchant') this.merchant, @JsonKey(name: 'confidence') this.confidence});
  factory _TransactionDraftData.fromJson(Map<String, dynamic> json) => _$TransactionDraftDataFromJson(json);

@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'amount') final  int? amount;
@override@JsonKey(name: 'wallet_id') final  String? walletId;
@override@JsonKey(name: 'to_wallet_id') final  String? toWalletId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
/// `yyyy-MM-dd`.
@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'merchant') final  String? merchant;
@override@JsonKey(name: 'confidence') final  DraftConfidenceData? confidence;

/// Create a copy of TransactionDraftData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDraftDataCopyWith<_TransactionDraftData> get copyWith => __$TransactionDraftDataCopyWithImpl<_TransactionDraftData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionDraftDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDraftData&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,walletId,toWalletId,categoryId,date,note,merchant,confidence);
}

@override
String toString() {
    return 'TransactionDraftData(type: $type, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TransactionDraftDataCopyWith<$Res> implements $TransactionDraftDataCopyWith<$Res> {
  factory _$TransactionDraftDataCopyWith(_TransactionDraftData value, $Res Function(_TransactionDraftData) _then) = __$TransactionDraftDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'confidence') DraftConfidenceData? confidence
});


@override $DraftConfidenceDataCopyWith<$Res>? get confidence;

}
/// @nodoc
class __$TransactionDraftDataCopyWithImpl<$Res>
    implements _$TransactionDraftDataCopyWith<$Res> {
  __$TransactionDraftDataCopyWithImpl(this._self, this._then);

  final _TransactionDraftData _self;
  final $Res Function(_TransactionDraftData) _then;

/// Create a copy of TransactionDraftData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = freezed,}) {
  return _then(_TransactionDraftData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidenceData?,
  ));
}

/// Create a copy of TransactionDraftData
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

// dart format on
