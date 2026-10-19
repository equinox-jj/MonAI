// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') TransactionData? get data;
/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<TransactionResponse> get copyWith => _$TransactionResponseCopyWithImpl<TransactionResponse>(this as TransactionResponse, _$identity);

  /// Serializes this TransactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as TransactionResponse;
  return 'TransactionResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $TransactionResponseCopyWith<$Res>  {
  factory $TransactionResponseCopyWith(TransactionResponse value, $Res Function(TransactionResponse) _then) = _$TransactionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') TransactionData? data
});


$TransactionDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$TransactionResponseCopyWithImpl<$Res>
    implements $TransactionResponseCopyWith<$Res> {
  _$TransactionResponseCopyWithImpl(this._self, this._then);

  final TransactionResponse _self;
  final $Res Function(TransactionResponse) _then;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(TransactionResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TransactionData?,
  ));
}
/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TransactionDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionResponse].
extension TransactionResponsePatterns on TransactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _TransactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  TransactionData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  TransactionData? data)  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  TransactionData? data)?  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionResponse implements TransactionResponse {
  const _TransactionResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  TransactionData? data;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionResponseCopyWith<_TransactionResponse> get copyWith => __$TransactionResponseCopyWithImpl<_TransactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'TransactionResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TransactionResponseCopyWith<$Res> implements $TransactionResponseCopyWith<$Res> {
  factory _$TransactionResponseCopyWith(_TransactionResponse value, $Res Function(_TransactionResponse) _then) = __$TransactionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') TransactionData? data
});


@override $TransactionDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$TransactionResponseCopyWithImpl<$Res>
    implements _$TransactionResponseCopyWith<$Res> {
  __$TransactionResponseCopyWithImpl(this._self, this._then);

  final _TransactionResponse _self;
  final $Res Function(_TransactionResponse) _then;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_TransactionResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TransactionData?,
  ));
}

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $TransactionDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TransactionData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'amount') int? get amount;@JsonKey(name: 'wallet_id') String? get walletId;@JsonKey(name: 'to_wallet_id') String? get toWalletId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'date') String? get date;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'merchant') String? get merchant;@JsonKey(name: 'receipt_url') String? get receiptUrl;@JsonKey(name: 'source') String? get source;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of TransactionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDataCopyWith<TransactionData> get copyWith => _$TransactionDataCopyWithImpl<TransactionData>(this as TransactionData, _$identity);

  /// Serializes this TransactionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionData;
  return Object.hash(runtimeType,_this.id,_this.type,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.receiptUrl,_this.source,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as TransactionData;
  return 'TransactionData(id: ${_this.id}, type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, receiptUrl: ${_this.receiptUrl}, source: ${_this.source}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $TransactionDataCopyWith<$Res>  {
  factory $TransactionDataCopyWith(TransactionData value, $Res Function(TransactionData) _then) = _$TransactionDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'source') String? source,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$TransactionDataCopyWithImpl<$Res>
    implements $TransactionDataCopyWith<$Res> {
  _$TransactionDataCopyWithImpl(this._self, this._then);

  final TransactionData _self;
  final $Res Function(TransactionData) _then;

/// Create a copy of TransactionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? receiptUrl = freezed,Object? source = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(TransactionData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionData].
extension TransactionDataPatterns on TransactionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionData value)  $default,){
final _that = this;
switch (_that) {
case _TransactionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionData value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionData() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.receiptUrl,_that.source,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionData():
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.receiptUrl,_that.source,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'wallet_id')  String? walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String? date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionData() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.receiptUrl,_that.source,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionData implements TransactionData {
  const _TransactionData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'type') this.type, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'wallet_id') this.walletId, @JsonKey(name: 'to_wallet_id') this.toWalletId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'date') this.date, @JsonKey(name: 'note') this.note, @JsonKey(name: 'merchant') this.merchant, @JsonKey(name: 'receipt_url') this.receiptUrl, @JsonKey(name: 'source') this.source, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _TransactionData.fromJson(Map<String, dynamic> json) => _$TransactionDataFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'amount') final  int? amount;
@override@JsonKey(name: 'wallet_id') final  String? walletId;
@override@JsonKey(name: 'to_wallet_id') final  String? toWalletId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'date') final  String? date;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'merchant') final  String? merchant;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;
@override@JsonKey(name: 'source') final  String? source;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of TransactionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDataCopyWith<_TransactionData> get copyWith => __$TransactionDataCopyWithImpl<_TransactionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionData&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,amount,walletId,toWalletId,categoryId,date,note,merchant,receiptUrl,source,createdAt,updatedAt);
}

@override
String toString() {
    return 'TransactionData(id: $id, type: $type, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, receiptUrl: $receiptUrl, source: $source, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionDataCopyWith<$Res> implements $TransactionDataCopyWith<$Res> {
  factory _$TransactionDataCopyWith(_TransactionData value, $Res Function(_TransactionData) _then) = __$TransactionDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'type') String? type,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'wallet_id') String? walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String? date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'source') String? source,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$TransactionDataCopyWithImpl<$Res>
    implements _$TransactionDataCopyWith<$Res> {
  __$TransactionDataCopyWithImpl(this._self, this._then);

  final _TransactionData _self;
  final $Res Function(_TransactionData) _then;

/// Create a copy of TransactionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? receiptUrl = freezed,Object? source = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TransactionData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
