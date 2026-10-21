// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionDraft {

 TransactionType get type; DateTime get date; int get amount; String? get walletId; String? get toWalletId; String? get categoryId;
/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<TransactionDraft> get copyWith => _$TransactionDraftCopyWithImpl<TransactionDraft>(this as TransactionDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDraft&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId));
}


@override
int get hashCode {
  final _this = this as TransactionDraft;
  return Object.hash(runtimeType,_this.type,_this.date,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId);
}

@override
String toString() {
  final _this = this as TransactionDraft;
  return 'TransactionDraft(type: ${_this.type}, date: ${_this.date}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId})';
}


}

/// @nodoc
abstract mixin class $TransactionDraftCopyWith<$Res>  {
  factory $TransactionDraftCopyWith(TransactionDraft value, $Res Function(TransactionDraft) _then) = _$TransactionDraftCopyWithImpl;
@useResult
$Res call({
 TransactionType type, DateTime date, int amount, String? walletId, String? toWalletId, String? categoryId
});




}
/// @nodoc
class _$TransactionDraftCopyWithImpl<$Res>
    implements $TransactionDraftCopyWith<$Res> {
  _$TransactionDraftCopyWithImpl(this._self, this._then);

  final TransactionDraft _self;
  final $Res Function(TransactionDraft) _then;

/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? date = null,Object? amount = null,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,}) {
  return _then(TransactionDraft(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionDraft].
extension TransactionDraftPatterns on TransactionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDraft value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  DateTime date,  int amount,  String? walletId,  String? toWalletId,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  DateTime date,  int amount,  String? walletId,  String? toWalletId,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _TransactionDraft():
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  DateTime date,  int amount,  String? walletId,  String? toWalletId,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionDraft() when $default != null:
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionDraft implements TransactionDraft {
  const _TransactionDraft({required this.type, required this.date, this.amount = 0, this.walletId, this.toWalletId, this.categoryId});
  

@override final  TransactionType type;
@override final  DateTime date;
@override@JsonKey() final  int amount;
@override final  String? walletId;
@override final  String? toWalletId;
@override final  String? categoryId;

/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDraftCopyWith<_TransactionDraft> get copyWith => __$TransactionDraftCopyWithImpl<_TransactionDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDraft&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,date,amount,walletId,toWalletId,categoryId);
}

@override
String toString() {
    return 'TransactionDraft(type: $type, date: $date, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$TransactionDraftCopyWith<$Res> implements $TransactionDraftCopyWith<$Res> {
  factory _$TransactionDraftCopyWith(_TransactionDraft value, $Res Function(_TransactionDraft) _then) = __$TransactionDraftCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, DateTime date, int amount, String? walletId, String? toWalletId, String? categoryId
});




}
/// @nodoc
class __$TransactionDraftCopyWithImpl<$Res>
    implements _$TransactionDraftCopyWith<$Res> {
  __$TransactionDraftCopyWithImpl(this._self, this._then);

  final _TransactionDraft _self;
  final $Res Function(_TransactionDraft) _then;

/// Create a copy of TransactionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? date = null,Object? amount = null,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,}) {
  return _then(_TransactionDraft(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
