// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddDraft {

 TransactionType get type;/// Local midnight.
 DateTime get date; int? get amount; String? get walletId;/// Transfers only.
 String? get toWalletId;/// Expense and income only.
 String? get categoryId; String? get note; String? get merchant; DraftConfidence get confidence;
/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<QuickAddDraft> get copyWith => _$QuickAddDraftCopyWithImpl<QuickAddDraft>(this as QuickAddDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuickAddDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddDraft&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence));
}


@override
int get hashCode {
  final _this = this as QuickAddDraft;
  return Object.hash(runtimeType,_this.type,_this.date,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId,_this.note,_this.merchant,_this.confidence);
}

@override
String toString() {
  final _this = this as QuickAddDraft;
  return 'QuickAddDraft(type: ${_this.type}, date: ${_this.date}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, note: ${_this.note}, merchant: ${_this.merchant}, confidence: ${_this.confidence})';
}


}

/// @nodoc
abstract mixin class $QuickAddDraftCopyWith<$Res>  {
  factory $QuickAddDraftCopyWith(QuickAddDraft value, $Res Function(QuickAddDraft) _then) = _$QuickAddDraftCopyWithImpl;
@useResult
$Res call({
 TransactionType type, DateTime date, int? amount, String? walletId, String? toWalletId, String? categoryId, String? note, String? merchant, DraftConfidence confidence
});


$DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class _$QuickAddDraftCopyWithImpl<$Res>
    implements $QuickAddDraftCopyWith<$Res> {
  _$QuickAddDraftCopyWithImpl(this._self, this._then);

  final QuickAddDraft _self;
  final $Res Function(QuickAddDraft) _then;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? date = null,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,}) {
  return _then(QuickAddDraft(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,
  ));
}
/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<$Res> get confidence {
  
  return $DraftConfidenceCopyWith<$Res>(_self.confidence, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuickAddDraft].
extension QuickAddDraftPatterns on QuickAddDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddDraft value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddDraft value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  DateTime date,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  DraftConfidence confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  DateTime date,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  DraftConfidence confidence)  $default,) {final _that = this;
switch (_that) {
case _QuickAddDraft():
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  DateTime date,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  String? note,  String? merchant,  DraftConfidence confidence)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddDraft() when $default != null:
return $default(_that.type,_that.date,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.note,_that.merchant,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddDraft implements QuickAddDraft {
  const _QuickAddDraft({required this.type, required this.date, this.amount, this.walletId, this.toWalletId, this.categoryId, this.note, this.merchant, this.confidence = const DraftConfidence()});
  

@override final  TransactionType type;
/// Local midnight.
@override final  DateTime date;
@override final  int? amount;
@override final  String? walletId;
/// Transfers only.
@override final  String? toWalletId;
/// Expense and income only.
@override final  String? categoryId;
@override final  String? note;
@override final  String? merchant;
@override@JsonKey() final  DraftConfidence confidence;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddDraftCopyWith<_QuickAddDraft> get copyWith => __$QuickAddDraftCopyWithImpl<_QuickAddDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddDraft&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,date,amount,walletId,toWalletId,categoryId,note,merchant,confidence);
}

@override
String toString() {
    return 'QuickAddDraft(type: $type, date: $date, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, note: $note, merchant: $merchant, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$QuickAddDraftCopyWith<$Res> implements $QuickAddDraftCopyWith<$Res> {
  factory _$QuickAddDraftCopyWith(_QuickAddDraft value, $Res Function(_QuickAddDraft) _then) = __$QuickAddDraftCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, DateTime date, int? amount, String? walletId, String? toWalletId, String? categoryId, String? note, String? merchant, DraftConfidence confidence
});


@override $DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class __$QuickAddDraftCopyWithImpl<$Res>
    implements _$QuickAddDraftCopyWith<$Res> {
  __$QuickAddDraftCopyWithImpl(this._self, this._then);

  final _QuickAddDraft _self;
  final $Res Function(_QuickAddDraft) _then;

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? date = null,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,}) {
  return _then(_QuickAddDraft(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,
  ));
}

/// Create a copy of QuickAddDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<$Res> get confidence {
  
  return $DraftConfidenceCopyWith<$Res>(_self.confidence, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}

// dart format on
