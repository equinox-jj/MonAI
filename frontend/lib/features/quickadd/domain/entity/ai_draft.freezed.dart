// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiDraft {

 TransactionType? get type; int? get amount; String? get walletId; String? get toWalletId; String? get categoryId;/// Local midnight.
 DateTime? get date; String? get note; String? get merchant; DraftConfidence get confidence;
/// Create a copy of AiDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDraftCopyWith<AiDraft> get copyWith => _$AiDraftCopyWithImpl<AiDraft>(this as AiDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDraft&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.toWalletId, _this.toWalletId) || other.toWalletId == _this.toWalletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence));
}


@override
int get hashCode {
  final _this = this as AiDraft;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.walletId,_this.toWalletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.confidence);
}

@override
String toString() {
  final _this = this as AiDraft;
  return 'AiDraft(type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, toWalletId: ${_this.toWalletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, confidence: ${_this.confidence})';
}


}

/// @nodoc
abstract mixin class $AiDraftCopyWith<$Res>  {
  factory $AiDraftCopyWith(AiDraft value, $Res Function(AiDraft) _then) = _$AiDraftCopyWithImpl;
@useResult
$Res call({
 TransactionType? type, int? amount, String? walletId, String? toWalletId, String? categoryId, DateTime? date, String? note, String? merchant, DraftConfidence confidence
});


$DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class _$AiDraftCopyWithImpl<$Res>
    implements $AiDraftCopyWith<$Res> {
  _$AiDraftCopyWithImpl(this._self, this._then);

  final AiDraft _self;
  final $Res Function(AiDraft) _then;

/// Create a copy of AiDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,}) {
  return _then(AiDraft(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,
  ));
}
/// Create a copy of AiDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<$Res> get confidence {
  
  return $DraftConfidenceCopyWith<$Res>(_self.confidence, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiDraft].
extension AiDraftPatterns on AiDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDraft value)  $default,){
final _that = this;
switch (_that) {
case _AiDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AiDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType? type,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDraft() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType? type,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence)  $default,) {final _that = this;
switch (_that) {
case _AiDraft():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType? type,  int? amount,  String? walletId,  String? toWalletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence)?  $default,) {final _that = this;
switch (_that) {
case _AiDraft() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.toWalletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _AiDraft implements AiDraft {
  const _AiDraft({this.type, this.amount, this.walletId, this.toWalletId, this.categoryId, this.date, this.note, this.merchant, this.confidence = const DraftConfidence()});
  

@override final  TransactionType? type;
@override final  int? amount;
@override final  String? walletId;
@override final  String? toWalletId;
@override final  String? categoryId;
/// Local midnight.
@override final  DateTime? date;
@override final  String? note;
@override final  String? merchant;
@override@JsonKey() final  DraftConfidence confidence;

/// Create a copy of AiDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDraftCopyWith<_AiDraft> get copyWith => __$AiDraftCopyWithImpl<_AiDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDraft&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,walletId,toWalletId,categoryId,date,note,merchant,confidence);
}

@override
String toString() {
    return 'AiDraft(type: $type, amount: $amount, walletId: $walletId, toWalletId: $toWalletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$AiDraftCopyWith<$Res> implements $AiDraftCopyWith<$Res> {
  factory _$AiDraftCopyWith(_AiDraft value, $Res Function(_AiDraft) _then) = __$AiDraftCopyWithImpl;
@override @useResult
$Res call({
 TransactionType? type, int? amount, String? walletId, String? toWalletId, String? categoryId, DateTime? date, String? note, String? merchant, DraftConfidence confidence
});


@override $DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class __$AiDraftCopyWithImpl<$Res>
    implements _$AiDraftCopyWith<$Res> {
  __$AiDraftCopyWithImpl(this._self, this._then);

  final _AiDraft _self;
  final $Res Function(_AiDraft) _then;

/// Create a copy of AiDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? toWalletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,}) {
  return _then(_AiDraft(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,toWalletId: freezed == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,
  ));
}

/// Create a copy of AiDraft
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
