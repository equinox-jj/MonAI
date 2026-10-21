// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 String get id; TransactionType get type; int get amount; String get walletId;/// Local midnight.
 DateTime get date; TransactionSource get source; DateTime get createdAt; DateTime get updatedAt;/// Transfers only.
 String? get toWalletId;/// Expenses and incomes only.
 String? get categoryId; String? get note; String? get merchant;/// Presigned and short-lived.
 String? get receiptUrl;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Transaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl));
}


@override
int get hashCode {
  final _this = this as Transaction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.amount,_this.walletId,_this.date,_this.source,_this.createdAt,_this.updatedAt,_this.toWalletId,_this.categoryId,_this.note,_this.merchant,_this.receiptUrl);
}

@override
String toString() {
  final _this = this as Transaction;
  return 'Transaction(id: ${_this.id}, type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, date: ${_this.date}, source: ${_this.source}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, note: ${_this.note}, merchant: ${_this.merchant}, receiptUrl: ${_this.receiptUrl})';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, int amount, String walletId, DateTime date, TransactionSource source, DateTime createdAt, DateTime updatedAt, String? toWalletId, String? categoryId, String? note, String? merchant, String? receiptUrl
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? walletId = null,Object? date = null,Object? source = null,Object? createdAt = null,Object? updatedAt = null,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? receiptUrl = freezed,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  String walletId,  DateTime date,  TransactionSource source,  DateTime createdAt,  DateTime updatedAt,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  String? receiptUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.date,_that.source,_that.createdAt,_that.updatedAt,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  int amount,  String walletId,  DateTime date,  TransactionSource source,  DateTime createdAt,  DateTime updatedAt,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  String? receiptUrl)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.date,_that.source,_that.createdAt,_that.updatedAt,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  int amount,  String walletId,  DateTime date,  TransactionSource source,  DateTime createdAt,  DateTime updatedAt,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  String? receiptUrl)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.walletId,_that.date,_that.source,_that.createdAt,_that.updatedAt,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.receiptUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.type, required this.amount, required this.walletId, required this.date, required this.source, required this.createdAt, required this.updatedAt, this.toWalletId, this.categoryId, this.note, this.merchant, this.receiptUrl});
  

@override final  String id;
@override final  TransactionType type;
@override final  int amount;
@override final  String walletId;
/// Local midnight.
@override final  DateTime date;
@override final  TransactionSource source;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Transfers only.
@override final  String? toWalletId;
/// Expenses and incomes only.
@override final  String? categoryId;
@override final  String? note;
@override final  String? merchant;
/// Presigned and short-lived.
@override final  String? receiptUrl;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.date, date) || other.date == date)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,amount,walletId,date,source,createdAt,updatedAt,toWalletId,categoryId,note,merchant,receiptUrl);
}

@override
String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, walletId: $walletId, date: $date, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, toWalletId: $toWalletId, categoryId: $categoryId, note: $note, merchant: $merchant, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, int amount, String walletId, DateTime date, TransactionSource source, DateTime createdAt, DateTime updatedAt, String? toWalletId, String? categoryId, String? note, String? merchant, String? receiptUrl
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? walletId = null,Object? date = null,Object? source = null,Object? createdAt = null,Object? updatedAt = null,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? receiptUrl = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
