// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionInput {

 TransactionType get type; int get amount; DateTime get date; String? get walletId; String? get toWalletId; String? get categoryId; String? get note; String? get merchant; TransactionSource get source;/// From an uploaded receipt photo; creates only.
 String? get receiptKey;
/// Create a copy of TransactionInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionInputCopyWith<TransactionInput> get copyWith => _$TransactionInputCopyWithImpl<TransactionInput>(this as TransactionInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionInput&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.receiptKey, _this.receiptKey) || other.receiptKey == _this.receiptKey));
}


@override
int get hashCode {
  final _this = this as TransactionInput;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.date,_this.walletId,_this.toWalletId,_this.categoryId,_this.note,_this.merchant,_this.source,_this.receiptKey);
}

@override
String toString() {
  final _this = this as TransactionInput;
  return 'TransactionInput(type: ${_this.type}, amount: ${_this.amount}, date: ${_this.date}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, note: ${_this.note}, merchant: ${_this.merchant}, source: ${_this.source}, receiptKey: ${_this.receiptKey})';
}


}

/// @nodoc
abstract mixin class $TransactionInputCopyWith<$Res>  {
  factory $TransactionInputCopyWith(TransactionInput value, $Res Function(TransactionInput) _then) = _$TransactionInputCopyWithImpl;
@useResult
$Res call({
 TransactionType type, int amount, DateTime date, String? walletId, String? toWalletId, String? categoryId, String? note, String? merchant, TransactionSource source, String? receiptKey
});




}
/// @nodoc
class _$TransactionInputCopyWithImpl<$Res>
    implements $TransactionInputCopyWith<$Res> {
  _$TransactionInputCopyWithImpl(this._self, this._then);

  final TransactionInput _self;
  final $Res Function(TransactionInput) _then;

/// Create a copy of TransactionInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? amount = null,Object? date = null,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? source = null,Object? receiptKey = freezed,}) {
  return _then(TransactionInput(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionInput].
extension TransactionInputPatterns on TransactionInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionInput value)  $default,){
final _that = this;
switch (_that) {
case _TransactionInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionInput value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  DateTime date,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  TransactionSource source,  String? receiptKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionInput() when $default != null:
return $default(_that.type,_that.amount,_that.date,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  DateTime date,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  TransactionSource source,  String? receiptKey)  $default,) {final _that = this;
switch (_that) {
case _TransactionInput():
return $default(_that.type,_that.amount,_that.date,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  int amount,  DateTime date,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  TransactionSource source,  String? receiptKey)?  $default,) {final _that = this;
switch (_that) {
case _TransactionInput() when $default != null:
return $default(_that.type,_that.amount,_that.date,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.source,_that.receiptKey);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionInput implements TransactionInput {
  const _TransactionInput({required this.type, required this.amount, required this.date, this.walletId, this.toWalletId, this.categoryId, this.note, this.merchant, this.source = TransactionSource.manual, this.receiptKey});
  

@override final  TransactionType type;
@override final  int amount;
@override final  DateTime date;
@override final  String? walletId;
@override final  String? toWalletId;
@override final  String? categoryId;
@override final  String? note;
@override final  String? merchant;
@override@JsonKey() final  TransactionSource source;
/// From an uploaded receipt photo; creates only.
@override final  String? receiptKey;

/// Create a copy of TransactionInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionInputCopyWith<_TransactionInput> get copyWith => __$TransactionInputCopyWithImpl<_TransactionInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionInput&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.source, source) || other.source == source)&&(identical(other.receiptKey, receiptKey) || other.receiptKey == receiptKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,date,walletId,toWalletId,categoryId,note,merchant,source,receiptKey);
}

@override
String toString() {
    return 'TransactionInput(type: $type, amount: $amount, date: $date, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, note: $note, merchant: $merchant, source: $source, receiptKey: $receiptKey)';
}


}

/// @nodoc
abstract mixin class _$TransactionInputCopyWith<$Res> implements $TransactionInputCopyWith<$Res> {
  factory _$TransactionInputCopyWith(_TransactionInput value, $Res Function(_TransactionInput) _then) = __$TransactionInputCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, int amount, DateTime date, String? walletId, String? toWalletId, String? categoryId, String? note, String? merchant, TransactionSource source, String? receiptKey
});




}
/// @nodoc
class __$TransactionInputCopyWithImpl<$Res>
    implements _$TransactionInputCopyWith<$Res> {
  __$TransactionInputCopyWithImpl(this._self, this._then);

  final _TransactionInput _self;
  final $Res Function(_TransactionInput) _then;

/// Create a copy of TransactionInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? date = null,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? source = null,Object? receiptKey = freezed,}) {
  return _then(_TransactionInput(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,receiptKey: freezed == receiptKey ? _self.receiptKey : receiptKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
