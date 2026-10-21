// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptDraft {

 TransactionType? get type; int? get amount; String? get walletId; String? get categoryId;/// Local midnight.
 DateTime? get date; String? get note; String? get merchant; DraftConfidence get confidence; List<ReceiptItem> get items;
/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDraftCopyWith<ReceiptDraft> get copyWith => _$ReceiptDraftCopyWithImpl<ReceiptDraft>(this as ReceiptDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptDraft&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.merchant, _this.merchant) || other.merchant == _this.merchant)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as ReceiptDraft;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.walletId,_this.categoryId,_this.date,_this.note,_this.merchant,_this.confidence,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ReceiptDraft;
  return 'ReceiptDraft(type: ${_this.type}, amount: ${_this.amount}, walletId: ${_this.walletId}, categoryId: ${_this.categoryId}, date: ${_this.date}, note: ${_this.note}, merchant: ${_this.merchant}, confidence: ${_this.confidence}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ReceiptDraftCopyWith<$Res>  {
  factory $ReceiptDraftCopyWith(ReceiptDraft value, $Res Function(ReceiptDraft) _then) = _$ReceiptDraftCopyWithImpl;
@useResult
$Res call({
 TransactionType? type, int? amount, String? walletId, String? categoryId, DateTime? date, String? note, String? merchant, DraftConfidence confidence, List<ReceiptItem> items
});


$DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class _$ReceiptDraftCopyWithImpl<$Res>
    implements $ReceiptDraftCopyWith<$Res> {
  _$ReceiptDraftCopyWithImpl(this._self, this._then);

  final ReceiptDraft _self;
  final $Res Function(ReceiptDraft) _then;

/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,Object? items = null,}) {
  return _then(ReceiptDraft(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}
/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<$Res> get confidence {
  
  return $DraftConfidenceCopyWith<$Res>(_self.confidence, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptDraft].
extension ReceiptDraftPatterns on ReceiptDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType? type,  int? amount,  String? walletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence,  List<ReceiptItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptDraft() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType? type,  int? amount,  String? walletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence,  List<ReceiptItem> items)  $default,) {final _that = this;
switch (_that) {
case _ReceiptDraft():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType? type,  int? amount,  String? walletId,  String? categoryId,  DateTime? date,  String? note,  String? merchant,  DraftConfidence confidence,  List<ReceiptItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptDraft() when $default != null:
return $default(_that.type,_that.amount,_that.walletId,_that.categoryId,_that.date,_that.note,_that.merchant,_that.confidence,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptDraft implements ReceiptDraft {
  const _ReceiptDraft({this.type, this.amount, this.walletId, this.categoryId, this.date, this.note, this.merchant, this.confidence = const DraftConfidence(),  List<ReceiptItem> items = const []}): _items = items;
  

@override final  TransactionType? type;
@override final  int? amount;
@override final  String? walletId;
@override final  String? categoryId;
/// Local midnight.
@override final  DateTime? date;
@override final  String? note;
@override final  String? merchant;
@override@JsonKey() final  DraftConfidence confidence;
 final  List<ReceiptItem> _items;
@override@JsonKey() List<ReceiptItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDraftCopyWith<_ReceiptDraft> get copyWith => __$ReceiptDraftCopyWithImpl<_ReceiptDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptDraft&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,walletId,categoryId,date,note,merchant,confidence,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ReceiptDraft(type: $type, amount: $amount, walletId: $walletId, categoryId: $categoryId, date: $date, note: $note, merchant: $merchant, confidence: $confidence, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDraftCopyWith<$Res> implements $ReceiptDraftCopyWith<$Res> {
  factory _$ReceiptDraftCopyWith(_ReceiptDraft value, $Res Function(_ReceiptDraft) _then) = __$ReceiptDraftCopyWithImpl;
@override @useResult
$Res call({
 TransactionType? type, int? amount, String? walletId, String? categoryId, DateTime? date, String? note, String? merchant, DraftConfidence confidence, List<ReceiptItem> items
});


@override $DraftConfidenceCopyWith<$Res> get confidence;

}
/// @nodoc
class __$ReceiptDraftCopyWithImpl<$Res>
    implements _$ReceiptDraftCopyWith<$Res> {
  __$ReceiptDraftCopyWithImpl(this._self, this._then);

  final _ReceiptDraft _self;
  final $Res Function(_ReceiptDraft) _then;

/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? walletId = freezed,Object? categoryId = freezed,Object? date = freezed,Object? note = freezed,Object? merchant = freezed,Object? confidence = null,Object? items = null,}) {
  return _then(_ReceiptDraft(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as DraftConfidence,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItem>,
  ));
}

/// Create a copy of ReceiptDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<$Res> get confidence {
  
  return $DraftConfidenceCopyWith<$Res>(_self.confidence, (value) {
    return _then(_self.copyWith(confidence: value));
  });
}
}

/// @nodoc
mixin _$ReceiptItem {

 String get name; double? get quantity; int? get amount;
/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemCopyWith<ReceiptItem> get copyWith => _$ReceiptItemCopyWithImpl<ReceiptItem>(this as ReceiptItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItem&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}


@override
int get hashCode {
  final _this = this as ReceiptItem;
  return Object.hash(runtimeType,_this.name,_this.quantity,_this.amount);
}

@override
String toString() {
  final _this = this as ReceiptItem;
  return 'ReceiptItem(name: ${_this.name}, quantity: ${_this.quantity}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $ReceiptItemCopyWith<$Res>  {
  factory $ReceiptItemCopyWith(ReceiptItem value, $Res Function(ReceiptItem) _then) = _$ReceiptItemCopyWithImpl;
@useResult
$Res call({
 String name, double? quantity, int? amount
});




}
/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._self, this._then);

  final ReceiptItem _self;
  final $Res Function(ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = freezed,Object? amount = freezed,}) {
  return _then(ReceiptItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItem].
extension ReceiptItemPatterns on ReceiptItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double? quantity,  int? amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double? quantity,  int? amount)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double? quantity,  int? amount)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.name,_that.quantity,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptItem implements ReceiptItem {
  const _ReceiptItem({required this.name, this.quantity, this.amount});
  

@override final  String name;
@override final  double? quantity;
@override final  int? amount;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemCopyWith<_ReceiptItem> get copyWith => __$ReceiptItemCopyWithImpl<_ReceiptItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItem&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,quantity,amount);
}

@override
String toString() {
    return 'ReceiptItem(name: $name, quantity: $quantity, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemCopyWith<$Res> implements $ReceiptItemCopyWith<$Res> {
  factory _$ReceiptItemCopyWith(_ReceiptItem value, $Res Function(_ReceiptItem) _then) = __$ReceiptItemCopyWithImpl;
@override @useResult
$Res call({
 String name, double? quantity, int? amount
});




}
/// @nodoc
class __$ReceiptItemCopyWithImpl<$Res>
    implements _$ReceiptItemCopyWith<$Res> {
  __$ReceiptItemCopyWithImpl(this._self, this._then);

  final _ReceiptItem _self;
  final $Res Function(_ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = freezed,Object? amount = freezed,}) {
  return _then(_ReceiptItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
