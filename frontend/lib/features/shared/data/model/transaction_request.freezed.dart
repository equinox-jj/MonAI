// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionRequest {

@JsonKey(name: 'type') String get type;@JsonKey(name: 'amount') int get amount;@JsonKey(name: 'wallet_id') String get walletId;@JsonKey(name: 'to_wallet_id') String? get toWalletId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'date') String get date;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'merchant') String? get merchant;@JsonKey(name: 'source', includeIfNull: false) String? get source;@JsonKey(name: 'receipt_key', includeIfNull: false) String? get receiptKey;
/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<TransactionRequest> get copyWith => _$TransactionRequestCopyWithImpl<TransactionRequest>(this as TransactionRequest, _$identity);

  /// Serializes this TransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRequest&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.receiptKey, _this.receiptKey) || other.receiptKey == _this.receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionRequest;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.source,_this.receiptKey);
}

@override
String toString() {
  final _this = this as TransactionRequest;
  return 'TransactionRequest(type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, source: ${_this.source}, receiptKey: ${_this.receiptKey})';
}


}

/// @nodoc
abstract mixin class $TransactionRequestCopyWith<$Res>  {
  factory $TransactionRequestCopyWith(TransactionRequest value, $Res Function(TransactionRequest) _then) = _$TransactionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') String type,@JsonKey(name: 'amount') int amount,@JsonKey(name: 'wallet_id') String walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'source', includeIfNull: false) String? source,@JsonKey(name: 'receipt_key', includeIfNull: false) String? receiptKey
});




}
/// @nodoc
class _$TransactionRequestCopyWithImpl<$Res>
    implements $TransactionRequestCopyWith<$Res> {
  _$TransactionRequestCopyWithImpl(this._self, this._then);

  final TransactionRequest _self;
  final $Res Function(TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? amount = null,Object? walletId = null,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = null,Object? note = freezed,Object? merchant = freezed,Object? source = freezed,Object? receiptKey = freezed,}) {
  return _then(TransactionRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionRequest].
extension TransactionRequestPatterns on TransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'amount')  int amount, @JsonKey(name: 'wallet_id')  String walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'source', includeIfNull: false)  String? source, @JsonKey(name: 'receipt_key', includeIfNull: false)  String? receiptKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'amount')  int amount, @JsonKey(name: 'wallet_id')  String walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'source', includeIfNull: false)  String? source, @JsonKey(name: 'receipt_key', includeIfNull: false)  String? receiptKey)  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest():
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  String type, @JsonKey(name: 'amount')  int amount, @JsonKey(name: 'wallet_id')  String walletId, @JsonKey(name: 'to_wallet_id')  String? toWalletId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'date')  String date, @JsonKey(name: 'note')  String? note, @JsonKey(name: 'merchant')  String? merchant, @JsonKey(name: 'source', includeIfNull: false)  String? source, @JsonKey(name: 'receipt_key', includeIfNull: false)  String? receiptKey)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRequest() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionRequest implements TransactionRequest {
  const _TransactionRequest({@JsonKey(name: 'type') required this.type, @JsonKey(name: 'amount') required this.amount, @JsonKey(name: 'wallet_id') required this.walletId, @JsonKey(name: 'to_wallet_id') this.toWalletId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'date') required this.date, @JsonKey(name: 'note') this.note, @JsonKey(name: 'merchant') this.merchant, @JsonKey(name: 'source', includeIfNull: false) this.source, @JsonKey(name: 'receipt_key', includeIfNull: false) this.receiptKey});
  factory _TransactionRequest.fromJson(Map<String, dynamic> json) => _$TransactionRequestFromJson(json);

@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'amount') final  int amount;
@override@JsonKey(name: 'wallet_id') final  String walletId;
@override@JsonKey(name: 'to_wallet_id') final  String? toWalletId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'date') final  String date;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'merchant') final  String? merchant;
@override@JsonKey(name: 'source', includeIfNull: false) final  String? source;
@override@JsonKey(name: 'receipt_key', includeIfNull: false) final  String? receiptKey;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRequestCopyWith<_TransactionRequest> get copyWith => __$TransactionRequestCopyWithImpl<_TransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.source, source) || other.source == source)&&(identical(other.receiptKey, receiptKey) || other.receiptKey == receiptKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,walletId,toWalletId,categoryId,date,note,merchant,source,receiptKey);
}

@override
String toString() {
    return 'TransactionRequest(type: $type, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, source: $source, receiptKey: $receiptKey)';
}


}

/// @nodoc
abstract mixin class _$TransactionRequestCopyWith<$Res> implements $TransactionRequestCopyWith<$Res> {
  factory _$TransactionRequestCopyWith(_TransactionRequest value, $Res Function(_TransactionRequest) _then) = __$TransactionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') String type,@JsonKey(name: 'amount') int amount,@JsonKey(name: 'wallet_id') String walletId,@JsonKey(name: 'to_wallet_id') String? toWalletId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'date') String date,@JsonKey(name: 'note') String? note,@JsonKey(name: 'merchant') String? merchant,@JsonKey(name: 'source', includeIfNull: false) String? source,@JsonKey(name: 'receipt_key', includeIfNull: false) String? receiptKey
});




}
/// @nodoc
class __$TransactionRequestCopyWithImpl<$Res>
    implements _$TransactionRequestCopyWith<$Res> {
  __$TransactionRequestCopyWithImpl(this._self, this._then);

  final _TransactionRequest _self;
  final $Res Function(_TransactionRequest) _then;

/// Create a copy of TransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? walletId = null,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = null,Object? note = freezed,Object? merchant = freezed,Object? source = freezed,Object? receiptKey = freezed,}) {
  return _then(_TransactionRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
