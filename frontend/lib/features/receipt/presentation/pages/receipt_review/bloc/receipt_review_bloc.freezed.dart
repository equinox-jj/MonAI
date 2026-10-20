// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_review_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptReviewEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptReviewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReceiptReviewEvent()';
}


}

/// @nodoc
class $ReceiptReviewEventCopyWith<$Res>  {
$ReceiptReviewEventCopyWith(ReceiptReviewEvent _, $Res Function(ReceiptReviewEvent) __);
}


/// Adds pattern-matching-related methods to [ReceiptReviewEvent].
extension ReceiptReviewEventPatterns on ReceiptReviewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TypeSelected value)?  typeSelected,TResult Function( _CategoryPicked value)?  categoryPicked,TResult Function( _WalletPicked value)?  walletPicked,TResult Function( _DatePicked value)?  datePicked,TResult Function( _AmountEdited value)?  amountEdited,TResult Function( _MerchantEdited value)?  merchantEdited,TResult Function( _NoteEdited value)?  noteEdited,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _RetryRequested value)?  retryRequested,TResult Function( _WalletsChanged value)?  walletsChanged,TResult Function( _CategoriesChanged value)?  categoriesChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _AmountEdited() when amountEdited != null:
return amountEdited(_that);case _MerchantEdited() when merchantEdited != null:
return merchantEdited(_that);case _NoteEdited() when noteEdited != null:
return noteEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _RetryRequested() when retryRequested != null:
return retryRequested(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TypeSelected value)  typeSelected,required TResult Function( _CategoryPicked value)  categoryPicked,required TResult Function( _WalletPicked value)  walletPicked,required TResult Function( _DatePicked value)  datePicked,required TResult Function( _AmountEdited value)  amountEdited,required TResult Function( _MerchantEdited value)  merchantEdited,required TResult Function( _NoteEdited value)  noteEdited,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _RetryRequested value)  retryRequested,required TResult Function( _WalletsChanged value)  walletsChanged,required TResult Function( _CategoriesChanged value)  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TypeSelected():
return typeSelected(_that);case _CategoryPicked():
return categoryPicked(_that);case _WalletPicked():
return walletPicked(_that);case _DatePicked():
return datePicked(_that);case _AmountEdited():
return amountEdited(_that);case _MerchantEdited():
return merchantEdited(_that);case _NoteEdited():
return noteEdited(_that);case _SaveRequested():
return saveRequested(_that);case _RetryRequested():
return retryRequested(_that);case _WalletsChanged():
return walletsChanged(_that);case _CategoriesChanged():
return categoriesChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TypeSelected value)?  typeSelected,TResult? Function( _CategoryPicked value)?  categoryPicked,TResult? Function( _WalletPicked value)?  walletPicked,TResult? Function( _DatePicked value)?  datePicked,TResult? Function( _AmountEdited value)?  amountEdited,TResult? Function( _MerchantEdited value)?  merchantEdited,TResult? Function( _NoteEdited value)?  noteEdited,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _RetryRequested value)?  retryRequested,TResult? Function( _WalletsChanged value)?  walletsChanged,TResult? Function( _CategoriesChanged value)?  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _AmountEdited() when amountEdited != null:
return amountEdited(_that);case _MerchantEdited() when merchantEdited != null:
return merchantEdited(_that);case _NoteEdited() when noteEdited != null:
return noteEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _RetryRequested() when retryRequested != null:
return retryRequested(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( TransactionType type)?  typeSelected,TResult Function( String categoryId)?  categoryPicked,TResult Function( String walletId)?  walletPicked,TResult Function( DateTime date)?  datePicked,TResult Function( String text)?  amountEdited,TResult Function( String text)?  merchantEdited,TResult Function( String text)?  noteEdited,TResult Function( String amount,  String merchant,  String note)?  saveRequested,TResult Function()?  retryRequested,TResult Function( List<Wallet> wallets)?  walletsChanged,TResult Function( List<Category> categories)?  categoriesChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _AmountEdited() when amountEdited != null:
return amountEdited(_that.text);case _MerchantEdited() when merchantEdited != null:
return merchantEdited(_that.text);case _NoteEdited() when noteEdited != null:
return noteEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.amount,_that.merchant,_that.note);case _RetryRequested() when retryRequested != null:
return retryRequested();case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( TransactionType type)  typeSelected,required TResult Function( String categoryId)  categoryPicked,required TResult Function( String walletId)  walletPicked,required TResult Function( DateTime date)  datePicked,required TResult Function( String text)  amountEdited,required TResult Function( String text)  merchantEdited,required TResult Function( String text)  noteEdited,required TResult Function( String amount,  String merchant,  String note)  saveRequested,required TResult Function()  retryRequested,required TResult Function( List<Wallet> wallets)  walletsChanged,required TResult Function( List<Category> categories)  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _TypeSelected():
return typeSelected(_that.type);case _CategoryPicked():
return categoryPicked(_that.categoryId);case _WalletPicked():
return walletPicked(_that.walletId);case _DatePicked():
return datePicked(_that.date);case _AmountEdited():
return amountEdited(_that.text);case _MerchantEdited():
return merchantEdited(_that.text);case _NoteEdited():
return noteEdited(_that.text);case _SaveRequested():
return saveRequested(_that.amount,_that.merchant,_that.note);case _RetryRequested():
return retryRequested();case _WalletsChanged():
return walletsChanged(_that.wallets);case _CategoriesChanged():
return categoriesChanged(_that.categories);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( TransactionType type)?  typeSelected,TResult? Function( String categoryId)?  categoryPicked,TResult? Function( String walletId)?  walletPicked,TResult? Function( DateTime date)?  datePicked,TResult? Function( String text)?  amountEdited,TResult? Function( String text)?  merchantEdited,TResult? Function( String text)?  noteEdited,TResult? Function( String amount,  String merchant,  String note)?  saveRequested,TResult? Function()?  retryRequested,TResult? Function( List<Wallet> wallets)?  walletsChanged,TResult? Function( List<Category> categories)?  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _AmountEdited() when amountEdited != null:
return amountEdited(_that.text);case _MerchantEdited() when merchantEdited != null:
return merchantEdited(_that.text);case _NoteEdited() when noteEdited != null:
return noteEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.amount,_that.merchant,_that.note);case _RetryRequested() when retryRequested != null:
return retryRequested();case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ReceiptReviewEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReceiptReviewEvent.started()';
}


}




/// @nodoc


class _TypeSelected implements ReceiptReviewEvent {
  const _TypeSelected(this.type);
  

 final  TransactionType type;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeSelectedCopyWith<_TypeSelected> get copyWith => __$TypeSelectedCopyWithImpl<_TypeSelected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeSelected&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'ReceiptReviewEvent.typeSelected(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypeSelectedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$TypeSelectedCopyWith(_TypeSelected value, $Res Function(_TypeSelected) _then) = __$TypeSelectedCopyWithImpl;
@useResult
$Res call({
 TransactionType type
});




}
/// @nodoc
class __$TypeSelectedCopyWithImpl<$Res>
    implements _$TypeSelectedCopyWith<$Res> {
  __$TypeSelectedCopyWithImpl(this._self, this._then);

  final _TypeSelected _self;
  final $Res Function(_TypeSelected) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_TypeSelected(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,
  ));
}


}

/// @nodoc


class _CategoryPicked implements ReceiptReviewEvent {
  const _CategoryPicked(this.categoryId);
  

 final  String categoryId;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryPickedCopyWith<_CategoryPicked> get copyWith => __$CategoryPickedCopyWithImpl<_CategoryPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryPicked&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoryId);
}

@override
String toString() {
    return 'ReceiptReviewEvent.categoryPicked(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryPickedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$CategoryPickedCopyWith(_CategoryPicked value, $Res Function(_CategoryPicked) _then) = __$CategoryPickedCopyWithImpl;
@useResult
$Res call({
 String categoryId
});




}
/// @nodoc
class __$CategoryPickedCopyWithImpl<$Res>
    implements _$CategoryPickedCopyWith<$Res> {
  __$CategoryPickedCopyWithImpl(this._self, this._then);

  final _CategoryPicked _self;
  final $Res Function(_CategoryPicked) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_CategoryPicked(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletPicked implements ReceiptReviewEvent {
  const _WalletPicked(this.walletId);
  

 final  String walletId;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletPickedCopyWith<_WalletPicked> get copyWith => __$WalletPickedCopyWithImpl<_WalletPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletPicked&&(identical(other.walletId, walletId) || other.walletId == walletId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,walletId);
}

@override
String toString() {
    return 'ReceiptReviewEvent.walletPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$WalletPickedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$WalletPickedCopyWith(_WalletPicked value, $Res Function(_WalletPicked) _then) = __$WalletPickedCopyWithImpl;
@useResult
$Res call({
 String walletId
});




}
/// @nodoc
class __$WalletPickedCopyWithImpl<$Res>
    implements _$WalletPickedCopyWith<$Res> {
  __$WalletPickedCopyWithImpl(this._self, this._then);

  final _WalletPicked _self;
  final $Res Function(_WalletPicked) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = null,}) {
  return _then(_WalletPicked(
null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DatePicked implements ReceiptReviewEvent {
  const _DatePicked(this.date);
  

 final  DateTime date;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatePickedCopyWith<_DatePicked> get copyWith => __$DatePickedCopyWithImpl<_DatePicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatePicked&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString() {
    return 'ReceiptReviewEvent.datePicked(date: $date)';
}


}

/// @nodoc
abstract mixin class _$DatePickedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$DatePickedCopyWith(_DatePicked value, $Res Function(_DatePicked) _then) = __$DatePickedCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class __$DatePickedCopyWithImpl<$Res>
    implements _$DatePickedCopyWith<$Res> {
  __$DatePickedCopyWithImpl(this._self, this._then);

  final _DatePicked _self;
  final $Res Function(_DatePicked) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_DatePicked(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _AmountEdited implements ReceiptReviewEvent {
  const _AmountEdited(this.text);
  

 final  String text;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmountEditedCopyWith<_AmountEdited> get copyWith => __$AmountEditedCopyWithImpl<_AmountEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmountEdited&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'ReceiptReviewEvent.amountEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$AmountEditedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$AmountEditedCopyWith(_AmountEdited value, $Res Function(_AmountEdited) _then) = __$AmountEditedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$AmountEditedCopyWithImpl<$Res>
    implements _$AmountEditedCopyWith<$Res> {
  __$AmountEditedCopyWithImpl(this._self, this._then);

  final _AmountEdited _self;
  final $Res Function(_AmountEdited) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_AmountEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MerchantEdited implements ReceiptReviewEvent {
  const _MerchantEdited(this.text);
  

 final  String text;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantEditedCopyWith<_MerchantEdited> get copyWith => __$MerchantEditedCopyWithImpl<_MerchantEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantEdited&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'ReceiptReviewEvent.merchantEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$MerchantEditedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$MerchantEditedCopyWith(_MerchantEdited value, $Res Function(_MerchantEdited) _then) = __$MerchantEditedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$MerchantEditedCopyWithImpl<$Res>
    implements _$MerchantEditedCopyWith<$Res> {
  __$MerchantEditedCopyWithImpl(this._self, this._then);

  final _MerchantEdited _self;
  final $Res Function(_MerchantEdited) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_MerchantEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NoteEdited implements ReceiptReviewEvent {
  const _NoteEdited(this.text);
  

 final  String text;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteEditedCopyWith<_NoteEdited> get copyWith => __$NoteEditedCopyWithImpl<_NoteEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteEdited&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'ReceiptReviewEvent.noteEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$NoteEditedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$NoteEditedCopyWith(_NoteEdited value, $Res Function(_NoteEdited) _then) = __$NoteEditedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$NoteEditedCopyWithImpl<$Res>
    implements _$NoteEditedCopyWith<$Res> {
  __$NoteEditedCopyWithImpl(this._self, this._then);

  final _NoteEdited _self;
  final $Res Function(_NoteEdited) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_NoteEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested implements ReceiptReviewEvent {
  const _SaveRequested({required this.amount, required this.merchant, required this.note});
  

 final  String amount;
 final  String merchant;
 final  String note;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,amount,merchant,note);
}

@override
String toString() {
    return 'ReceiptReviewEvent.saveRequested(amount: $amount, merchant: $merchant, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String amount, String merchant, String note
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? merchant = null,Object? note = null,}) {
  return _then(_SaveRequested(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RetryRequested implements ReceiptReviewEvent {
  const _RetryRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ReceiptReviewEvent.retryRequested()';
}


}




/// @nodoc


class _WalletsChanged implements ReceiptReviewEvent {
  const _WalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletsChangedCopyWith<_WalletsChanged> get copyWith => __$WalletsChangedCopyWithImpl<_WalletsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletsChanged&&const DeepCollectionEquality().equals(other.wallets, _wallets));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_wallets));
}

@override
String toString() {
    return 'ReceiptReviewEvent.walletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletsChangedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$WalletsChangedCopyWith(_WalletsChanged value, $Res Function(_WalletsChanged) _then) = __$WalletsChangedCopyWithImpl;
@useResult
$Res call({
 List<Wallet> wallets
});




}
/// @nodoc
class __$WalletsChangedCopyWithImpl<$Res>
    implements _$WalletsChangedCopyWith<$Res> {
  __$WalletsChangedCopyWithImpl(this._self, this._then);

  final _WalletsChanged _self;
  final $Res Function(_WalletsChanged) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_WalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc


class _CategoriesChanged implements ReceiptReviewEvent {
  const _CategoriesChanged( List<Category> categories): _categories = categories;
  

 final  List<Category> _categories;
 List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesChangedCopyWith<_CategoriesChanged> get copyWith => __$CategoriesChangedCopyWithImpl<_CategoriesChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesChanged&&const DeepCollectionEquality().equals(other.categories, _categories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'ReceiptReviewEvent.categoriesChanged(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoriesChangedCopyWith<$Res> implements $ReceiptReviewEventCopyWith<$Res> {
  factory _$CategoriesChangedCopyWith(_CategoriesChanged value, $Res Function(_CategoriesChanged) _then) = __$CategoriesChangedCopyWithImpl;
@useResult
$Res call({
 List<Category> categories
});




}
/// @nodoc
class __$CategoriesChangedCopyWithImpl<$Res>
    implements _$CategoriesChangedCopyWith<$Res> {
  __$CategoriesChangedCopyWithImpl(this._self, this._then);

  final _CategoriesChanged _self;
  final $Res Function(_CategoriesChanged) _then;

/// Create a copy of ReceiptReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoriesChanged(
null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,
  ));
}


}

/// @nodoc
mixin _$ReceiptReviewState {

/// The photo and what the scanner read.
 ReceiptReviewArgs get args;/// The user's current date; later dates can't be picked.
 DateTime get today;/// What the AI read; replaced when "Try again" succeeds.
 ReceiptDraft get draft;/// Expense or income.
 TransactionType get type;/// Local midnight.
 DateTime get date; String? get walletId; String? get categoryId;/// Why the AI gave no draft; null once it read the receipt.
 ReceiptAiFailure? get aiFailure;/// "Try again" is waiting for the AI.
 bool get isRetrying;/// Bumped when "Try again" brings a new [draft], so the screen refills
/// its text fields.
 int get draftVersion;/// Why "Try again" failed; shown once as a snackbar.
 ReceiptAiFailure? get retryFailure;/// The fields still as the AI filled them.
 Map<ReceiptField, FieldMark> get marks;/// Active wallets, to pick from.
 List<Wallet> get wallets;/// Every cached category; see [ReceiptReviewStateX.categories].
 List<Category> get allCategories;/// One error per invalid field, keyed by the API's field name.
 Map<String, FieldError> get errors;/// A save failed on the input, so errors update as the user edits.
 bool get autovalidate; bool get isSaving;/// Set once saved, as the new transaction's id; the screen leaves.
 String? get savedId;/// Why a save failed; shown once as a snackbar.
 ReceiptFailure? get actionFailure;
/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptReviewStateCopyWith<ReceiptReviewState> get copyWith => _$ReceiptReviewStateCopyWithImpl<ReceiptReviewState>(this as ReceiptReviewState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptReviewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptReviewState&&(identical(other.args, _this.args) || other.args == _this.args)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.walletId, _this.walletId) || other.walletId == _this.walletId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.aiFailure, _this.aiFailure) || other.aiFailure == _this.aiFailure)&&(identical(other.isRetrying, _this.isRetrying) || other.isRetrying == _this.isRetrying)&&(identical(other.draftVersion, _this.draftVersion) || other.draftVersion == _this.draftVersion)&&(identical(other.retryFailure, _this.retryFailure) || other.retryFailure == _this.retryFailure)&&const DeepCollectionEquality().equals(other.marks, _this.marks)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&const DeepCollectionEquality().equals(other.allCategories, _this.allCategories)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.savedId, _this.savedId) || other.savedId == _this.savedId)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as ReceiptReviewState;
  return Object.hashAll([runtimeType,_this.args,_this.today,_this.draft,_this.type,_this.date,_this.walletId,_this.categoryId,_this.aiFailure,_this.isRetrying,_this.draftVersion,_this.retryFailure,const DeepCollectionEquality().hash(_this.marks),const DeepCollectionEquality().hash(_this.wallets),const DeepCollectionEquality().hash(_this.allCategories),const DeepCollectionEquality().hash(_this.errors),_this.autovalidate,_this.isSaving,_this.savedId,_this.actionFailure]);
}

@override
String toString() {
  final _this = this as ReceiptReviewState;
  return 'ReceiptReviewState(args: ${_this.args}, today: ${_this.today}, draft: ${_this.draft}, type: ${_this.type}, date: ${_this.date}, walletId: ${_this.walletId}, categoryId: ${_this.categoryId}, aiFailure: ${_this.aiFailure}, isRetrying: ${_this.isRetrying}, draftVersion: ${_this.draftVersion}, retryFailure: ${_this.retryFailure}, marks: ${_this.marks}, wallets: ${_this.wallets}, allCategories: ${_this.allCategories}, errors: ${_this.errors}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, savedId: ${_this.savedId}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $ReceiptReviewStateCopyWith<$Res>  {
  factory $ReceiptReviewStateCopyWith(ReceiptReviewState value, $Res Function(ReceiptReviewState) _then) = _$ReceiptReviewStateCopyWithImpl;
@useResult
$Res call({
 ReceiptReviewArgs args, DateTime today, ReceiptDraft draft, TransactionType type, DateTime date, String? walletId, String? categoryId, ReceiptAiFailure? aiFailure, bool isRetrying, int draftVersion, ReceiptAiFailure? retryFailure, Map<ReceiptField, FieldMark> marks, List<Wallet> wallets, List<Category> allCategories, Map<String, FieldError> errors, bool autovalidate, bool isSaving, String? savedId, ReceiptFailure? actionFailure
});


$ReceiptReviewArgsCopyWith<$Res> get args;$ReceiptDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ReceiptReviewStateCopyWithImpl<$Res>
    implements $ReceiptReviewStateCopyWith<$Res> {
  _$ReceiptReviewStateCopyWithImpl(this._self, this._then);

  final ReceiptReviewState _self;
  final $Res Function(ReceiptReviewState) _then;

/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? args = null,Object? today = null,Object? draft = null,Object? type = null,Object? date = null,Object? walletId = freezed,Object? categoryId = freezed,Object? aiFailure = freezed,Object? isRetrying = null,Object? draftVersion = null,Object? retryFailure = freezed,Object? marks = null,Object? wallets = null,Object? allCategories = null,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? savedId = freezed,Object? actionFailure = freezed,}) {
  return _then(ReceiptReviewState(
args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as ReceiptReviewArgs,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraft,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,draftVersion: null == draftVersion ? _self.draftVersion : draftVersion // ignore: cast_nullable_to_non_nullable
as int,retryFailure: freezed == retryFailure ? _self.retryFailure : retryFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as Map<ReceiptField, FieldMark>,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,allCategories: null == allCategories ? _self.allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as ReceiptFailure?,
  ));
}
/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptReviewArgsCopyWith<$Res> get args {
  
  return $ReceiptReviewArgsCopyWith<$Res>(_self.args, (value) {
    return _then(_self.copyWith(args: value));
  });
}/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftCopyWith<$Res> get draft {
  
  return $ReceiptDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptReviewState].
extension ReceiptReviewStatePatterns on ReceiptReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptReviewState value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReceiptReviewArgs args,  DateTime today,  ReceiptDraft draft,  TransactionType type,  DateTime date,  String? walletId,  String? categoryId,  ReceiptAiFailure? aiFailure,  bool isRetrying,  int draftVersion,  ReceiptAiFailure? retryFailure,  Map<ReceiptField, FieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  String? savedId,  ReceiptFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptReviewState() when $default != null:
return $default(_that.args,_that.today,_that.draft,_that.type,_that.date,_that.walletId,_that.categoryId,_that.aiFailure,_that.isRetrying,_that.draftVersion,_that.retryFailure,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.savedId,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReceiptReviewArgs args,  DateTime today,  ReceiptDraft draft,  TransactionType type,  DateTime date,  String? walletId,  String? categoryId,  ReceiptAiFailure? aiFailure,  bool isRetrying,  int draftVersion,  ReceiptAiFailure? retryFailure,  Map<ReceiptField, FieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  String? savedId,  ReceiptFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _ReceiptReviewState():
return $default(_that.args,_that.today,_that.draft,_that.type,_that.date,_that.walletId,_that.categoryId,_that.aiFailure,_that.isRetrying,_that.draftVersion,_that.retryFailure,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.savedId,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReceiptReviewArgs args,  DateTime today,  ReceiptDraft draft,  TransactionType type,  DateTime date,  String? walletId,  String? categoryId,  ReceiptAiFailure? aiFailure,  bool isRetrying,  int draftVersion,  ReceiptAiFailure? retryFailure,  Map<ReceiptField, FieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  String? savedId,  ReceiptFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptReviewState() when $default != null:
return $default(_that.args,_that.today,_that.draft,_that.type,_that.date,_that.walletId,_that.categoryId,_that.aiFailure,_that.isRetrying,_that.draftVersion,_that.retryFailure,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.savedId,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptReviewState implements ReceiptReviewState {
  const _ReceiptReviewState({required this.args, required this.today, required this.draft, required this.type, required this.date, this.walletId, this.categoryId, this.aiFailure, this.isRetrying = false, this.draftVersion = 0, this.retryFailure,  Map<ReceiptField, FieldMark> marks = const {},  List<Wallet> wallets = const [],  List<Category> allCategories = const [],  Map<String, FieldError> errors = const {}, this.autovalidate = false, this.isSaving = false, this.savedId, this.actionFailure}): _marks = marks,_wallets = wallets,_allCategories = allCategories,_errors = errors;
  

/// The photo and what the scanner read.
@override final  ReceiptReviewArgs args;
/// The user's current date; later dates can't be picked.
@override final  DateTime today;
/// What the AI read; replaced when "Try again" succeeds.
@override final  ReceiptDraft draft;
/// Expense or income.
@override final  TransactionType type;
/// Local midnight.
@override final  DateTime date;
@override final  String? walletId;
@override final  String? categoryId;
/// Why the AI gave no draft; null once it read the receipt.
@override final  ReceiptAiFailure? aiFailure;
/// "Try again" is waiting for the AI.
@override@JsonKey() final  bool isRetrying;
/// Bumped when "Try again" brings a new [draft], so the screen refills
/// its text fields.
@override@JsonKey() final  int draftVersion;
/// Why "Try again" failed; shown once as a snackbar.
@override final  ReceiptAiFailure? retryFailure;
/// The fields still as the AI filled them.
 final  Map<ReceiptField, FieldMark> _marks;
/// The fields still as the AI filled them.
@override@JsonKey() Map<ReceiptField, FieldMark> get marks {
  if (_marks is EqualUnmodifiableMapView) return _marks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_marks);
}

/// Active wallets, to pick from.
 final  List<Wallet> _wallets;
/// Active wallets, to pick from.
@override@JsonKey() List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

/// Every cached category; see [ReceiptReviewStateX.categories].
 final  List<Category> _allCategories;
/// Every cached category; see [ReceiptReviewStateX.categories].
@override@JsonKey() List<Category> get allCategories {
  if (_allCategories is EqualUnmodifiableListView) return _allCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allCategories);
}

/// One error per invalid field, keyed by the API's field name.
 final  Map<String, FieldError> _errors;
/// One error per invalid field, keyed by the API's field name.
@override@JsonKey() Map<String, FieldError> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// A save failed on the input, so errors update as the user edits.
@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
/// Set once saved, as the new transaction's id; the screen leaves.
@override final  String? savedId;
/// Why a save failed; shown once as a snackbar.
@override final  ReceiptFailure? actionFailure;

/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptReviewStateCopyWith<_ReceiptReviewState> get copyWith => __$ReceiptReviewStateCopyWithImpl<_ReceiptReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptReviewState&&(identical(other.args, args) || other.args == args)&&(identical(other.today, today) || other.today == today)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.aiFailure, aiFailure) || other.aiFailure == aiFailure)&&(identical(other.isRetrying, isRetrying) || other.isRetrying == isRetrying)&&(identical(other.draftVersion, draftVersion) || other.draftVersion == draftVersion)&&(identical(other.retryFailure, retryFailure) || other.retryFailure == retryFailure)&&const DeepCollectionEquality().equals(other.marks, _marks)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&const DeepCollectionEquality().equals(other.allCategories, _allCategories)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.savedId, savedId) || other.savedId == savedId)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,args,today,draft,type,date,walletId,categoryId,aiFailure,isRetrying,draftVersion,retryFailure,const DeepCollectionEquality().hash(_marks),const DeepCollectionEquality().hash(_wallets),const DeepCollectionEquality().hash(_allCategories),const DeepCollectionEquality().hash(_errors),autovalidate,isSaving,savedId,actionFailure]);
}

@override
String toString() {
    return 'ReceiptReviewState(args: $args, today: $today, draft: $draft, type: $type, date: $date, walletId: $walletId, categoryId: $categoryId, aiFailure: $aiFailure, isRetrying: $isRetrying, draftVersion: $draftVersion, retryFailure: $retryFailure, marks: $marks, wallets: $wallets, allCategories: $allCategories, errors: $errors, autovalidate: $autovalidate, isSaving: $isSaving, savedId: $savedId, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$ReceiptReviewStateCopyWith<$Res> implements $ReceiptReviewStateCopyWith<$Res> {
  factory _$ReceiptReviewStateCopyWith(_ReceiptReviewState value, $Res Function(_ReceiptReviewState) _then) = __$ReceiptReviewStateCopyWithImpl;
@override @useResult
$Res call({
 ReceiptReviewArgs args, DateTime today, ReceiptDraft draft, TransactionType type, DateTime date, String? walletId, String? categoryId, ReceiptAiFailure? aiFailure, bool isRetrying, int draftVersion, ReceiptAiFailure? retryFailure, Map<ReceiptField, FieldMark> marks, List<Wallet> wallets, List<Category> allCategories, Map<String, FieldError> errors, bool autovalidate, bool isSaving, String? savedId, ReceiptFailure? actionFailure
});


@override $ReceiptReviewArgsCopyWith<$Res> get args;@override $ReceiptDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$ReceiptReviewStateCopyWithImpl<$Res>
    implements _$ReceiptReviewStateCopyWith<$Res> {
  __$ReceiptReviewStateCopyWithImpl(this._self, this._then);

  final _ReceiptReviewState _self;
  final $Res Function(_ReceiptReviewState) _then;

/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? args = null,Object? today = null,Object? draft = null,Object? type = null,Object? date = null,Object? walletId = freezed,Object? categoryId = freezed,Object? aiFailure = freezed,Object? isRetrying = null,Object? draftVersion = null,Object? retryFailure = freezed,Object? marks = null,Object? wallets = null,Object? allCategories = null,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? savedId = freezed,Object? actionFailure = freezed,}) {
  return _then(_ReceiptReviewState(
args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as ReceiptReviewArgs,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraft,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,draftVersion: null == draftVersion ? _self.draftVersion : draftVersion // ignore: cast_nullable_to_non_nullable
as int,retryFailure: freezed == retryFailure ? _self.retryFailure : retryFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,marks: null == marks ? _self._marks : marks // ignore: cast_nullable_to_non_nullable
as Map<ReceiptField, FieldMark>,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,allCategories: null == allCategories ? _self._allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as ReceiptFailure?,
  ));
}

/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptReviewArgsCopyWith<$Res> get args {
  
  return $ReceiptReviewArgsCopyWith<$Res>(_self.args, (value) {
    return _then(_self.copyWith(args: value));
  });
}/// Create a copy of ReceiptReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftCopyWith<$Res> get draft {
  
  return $ReceiptDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
