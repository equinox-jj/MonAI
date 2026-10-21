// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_review_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddReviewEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReviewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddReviewEvent()';
}


}

/// @nodoc
class $QuickAddReviewEventCopyWith<$Res>  {
$QuickAddReviewEventCopyWith(QuickAddReviewEvent _, $Res Function(QuickAddReviewEvent) __);
}


/// Adds pattern-matching-related methods to [QuickAddReviewEvent].
extension QuickAddReviewEventPatterns on QuickAddReviewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _CategoryPicked value)?  categoryPicked,TResult Function( _WalletPicked value)?  walletPicked,TResult Function( _ToWalletPicked value)?  toWalletPicked,TResult Function( _DatePicked value)?  datePicked,TResult Function( _AmountEdited value)?  amountEdited,TResult Function( _NoteEdited value)?  noteEdited,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _SkipRequested value)?  skipRequested,TResult Function( _WalletsChanged value)?  walletsChanged,TResult Function( _CategoriesChanged value)?  categoriesChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _AmountEdited() when amountEdited != null:
return amountEdited(_that);case _NoteEdited() when noteEdited != null:
return noteEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _SkipRequested() when skipRequested != null:
return skipRequested(_that);case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _CategoryPicked value)  categoryPicked,required TResult Function( _WalletPicked value)  walletPicked,required TResult Function( _ToWalletPicked value)  toWalletPicked,required TResult Function( _DatePicked value)  datePicked,required TResult Function( _AmountEdited value)  amountEdited,required TResult Function( _NoteEdited value)  noteEdited,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _SkipRequested value)  skipRequested,required TResult Function( _WalletsChanged value)  walletsChanged,required TResult Function( _CategoriesChanged value)  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _CategoryPicked():
return categoryPicked(_that);case _WalletPicked():
return walletPicked(_that);case _ToWalletPicked():
return toWalletPicked(_that);case _DatePicked():
return datePicked(_that);case _AmountEdited():
return amountEdited(_that);case _NoteEdited():
return noteEdited(_that);case _SaveRequested():
return saveRequested(_that);case _SkipRequested():
return skipRequested(_that);case _WalletsChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _CategoryPicked value)?  categoryPicked,TResult? Function( _WalletPicked value)?  walletPicked,TResult? Function( _ToWalletPicked value)?  toWalletPicked,TResult? Function( _DatePicked value)?  datePicked,TResult? Function( _AmountEdited value)?  amountEdited,TResult? Function( _NoteEdited value)?  noteEdited,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _SkipRequested value)?  skipRequested,TResult? Function( _WalletsChanged value)?  walletsChanged,TResult? Function( _CategoriesChanged value)?  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _AmountEdited() when amountEdited != null:
return amountEdited(_that);case _NoteEdited() when noteEdited != null:
return noteEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _SkipRequested() when skipRequested != null:
return skipRequested(_that);case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String categoryId)?  categoryPicked,TResult Function( String walletId)?  walletPicked,TResult Function( String walletId)?  toWalletPicked,TResult Function( DateTime date)?  datePicked,TResult Function( String text)?  amountEdited,TResult Function( String text)?  noteEdited,TResult Function( String amount,  String note)?  saveRequested,TResult Function()?  skipRequested,TResult Function( List<Wallet> wallets)?  walletsChanged,TResult Function( List<Category> categories)?  categoriesChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _AmountEdited() when amountEdited != null:
return amountEdited(_that.text);case _NoteEdited() when noteEdited != null:
return noteEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.amount,_that.note);case _SkipRequested() when skipRequested != null:
return skipRequested();case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String categoryId)  categoryPicked,required TResult Function( String walletId)  walletPicked,required TResult Function( String walletId)  toWalletPicked,required TResult Function( DateTime date)  datePicked,required TResult Function( String text)  amountEdited,required TResult Function( String text)  noteEdited,required TResult Function( String amount,  String note)  saveRequested,required TResult Function()  skipRequested,required TResult Function( List<Wallet> wallets)  walletsChanged,required TResult Function( List<Category> categories)  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _CategoryPicked():
return categoryPicked(_that.categoryId);case _WalletPicked():
return walletPicked(_that.walletId);case _ToWalletPicked():
return toWalletPicked(_that.walletId);case _DatePicked():
return datePicked(_that.date);case _AmountEdited():
return amountEdited(_that.text);case _NoteEdited():
return noteEdited(_that.text);case _SaveRequested():
return saveRequested(_that.amount,_that.note);case _SkipRequested():
return skipRequested();case _WalletsChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String categoryId)?  categoryPicked,TResult? Function( String walletId)?  walletPicked,TResult? Function( String walletId)?  toWalletPicked,TResult? Function( DateTime date)?  datePicked,TResult? Function( String text)?  amountEdited,TResult? Function( String text)?  noteEdited,TResult? Function( String amount,  String note)?  saveRequested,TResult? Function()?  skipRequested,TResult? Function( List<Wallet> wallets)?  walletsChanged,TResult? Function( List<Category> categories)?  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _AmountEdited() when amountEdited != null:
return amountEdited(_that.text);case _NoteEdited() when noteEdited != null:
return noteEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.amount,_that.note);case _SkipRequested() when skipRequested != null:
return skipRequested();case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements QuickAddReviewEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddReviewEvent.started()';
}


}




/// @nodoc


class _CategoryPicked implements QuickAddReviewEvent {
  const _CategoryPicked(this.categoryId);
  

 final  String categoryId;

/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.categoryPicked(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryPickedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_CategoryPicked(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletPicked implements QuickAddReviewEvent {
  const _WalletPicked(this.walletId);
  

 final  String walletId;

/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.walletPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$WalletPickedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = null,}) {
  return _then(_WalletPicked(
null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToWalletPicked implements QuickAddReviewEvent {
  const _ToWalletPicked(this.walletId);
  

 final  String walletId;

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToWalletPickedCopyWith<_ToWalletPicked> get copyWith => __$ToWalletPickedCopyWithImpl<_ToWalletPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToWalletPicked&&(identical(other.walletId, walletId) || other.walletId == walletId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,walletId);
}

@override
String toString() {
    return 'QuickAddReviewEvent.toWalletPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$ToWalletPickedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
  factory _$ToWalletPickedCopyWith(_ToWalletPicked value, $Res Function(_ToWalletPicked) _then) = __$ToWalletPickedCopyWithImpl;
@useResult
$Res call({
 String walletId
});




}
/// @nodoc
class __$ToWalletPickedCopyWithImpl<$Res>
    implements _$ToWalletPickedCopyWith<$Res> {
  __$ToWalletPickedCopyWithImpl(this._self, this._then);

  final _ToWalletPicked _self;
  final $Res Function(_ToWalletPicked) _then;

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = null,}) {
  return _then(_ToWalletPicked(
null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DatePicked implements QuickAddReviewEvent {
  const _DatePicked(this.date);
  

 final  DateTime date;

/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.datePicked(date: $date)';
}


}

/// @nodoc
abstract mixin class _$DatePickedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_DatePicked(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _AmountEdited implements QuickAddReviewEvent {
  const _AmountEdited(this.text);
  

 final  String text;

/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.amountEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$AmountEditedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_AmountEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NoteEdited implements QuickAddReviewEvent {
  const _NoteEdited(this.text);
  

 final  String text;

/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.noteEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$NoteEditedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_NoteEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested implements QuickAddReviewEvent {
  const _SaveRequested({required this.amount, required this.note});
  

 final  String amount;
 final  String note;

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,amount,note);
}

@override
String toString() {
    return 'QuickAddReviewEvent.saveRequested(amount: $amount, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String amount, String note
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? note = null,}) {
  return _then(_SaveRequested(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SkipRequested implements QuickAddReviewEvent {
  const _SkipRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkipRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddReviewEvent.skipRequested()';
}


}




/// @nodoc


class _WalletsChanged implements QuickAddReviewEvent {
  const _WalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.walletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletsChangedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_WalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc


class _CategoriesChanged implements QuickAddReviewEvent {
  const _CategoriesChanged( List<Category> categories): _categories = categories;
  

 final  List<Category> _categories;
 List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of QuickAddReviewEvent
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
    return 'QuickAddReviewEvent.categoriesChanged(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoriesChangedCopyWith<$Res> implements $QuickAddReviewEventCopyWith<$Res> {
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

/// Create a copy of QuickAddReviewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoriesChanged(
null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,
  ));
}


}

/// @nodoc
mixin _$QuickAddReviewState {

 QuickAddReviewArgs get args; DateTime get today; int get index; QuickAddDraft get current; List<QuickAddReviewResult> get results; Map<QuickAddField, MonAIFieldMark> get marks; List<Wallet> get wallets; List<Category> get allCategories; Map<String, FieldError> get errors; bool get autovalidate; bool get isSaving; QuickAddSaveFailure? get actionFailure;
/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddReviewStateCopyWith<QuickAddReviewState> get copyWith => _$QuickAddReviewStateCopyWithImpl<QuickAddReviewState>(this as QuickAddReviewState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuickAddReviewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReviewState&&(identical(other.args, _this.args) || other.args == _this.args)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.current, _this.current) || other.current == _this.current)&&const DeepCollectionEquality().equals(other.results, _this.results)&&const DeepCollectionEquality().equals(other.marks, _this.marks)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&const DeepCollectionEquality().equals(other.allCategories, _this.allCategories)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as QuickAddReviewState;
  return Object.hash(runtimeType,_this.args,_this.today,_this.index,_this.current,const DeepCollectionEquality().hash(_this.results),const DeepCollectionEquality().hash(_this.marks),const DeepCollectionEquality().hash(_this.wallets),const DeepCollectionEquality().hash(_this.allCategories),const DeepCollectionEquality().hash(_this.errors),_this.autovalidate,_this.isSaving,_this.actionFailure);
}

@override
String toString() {
  final _this = this as QuickAddReviewState;
  return 'QuickAddReviewState(args: ${_this.args}, today: ${_this.today}, index: ${_this.index}, current: ${_this.current}, results: ${_this.results}, marks: ${_this.marks}, wallets: ${_this.wallets}, allCategories: ${_this.allCategories}, errors: ${_this.errors}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $QuickAddReviewStateCopyWith<$Res>  {
  factory $QuickAddReviewStateCopyWith(QuickAddReviewState value, $Res Function(QuickAddReviewState) _then) = _$QuickAddReviewStateCopyWithImpl;
@useResult
$Res call({
 QuickAddReviewArgs args, DateTime today, int index, QuickAddDraft current, List<QuickAddReviewResult> results, Map<QuickAddField, MonAIFieldMark> marks, List<Wallet> wallets, List<Category> allCategories, Map<String, FieldError> errors, bool autovalidate, bool isSaving, QuickAddSaveFailure? actionFailure
});


$QuickAddReviewArgsCopyWith<$Res> get args;$QuickAddDraftCopyWith<$Res> get current;

}
/// @nodoc
class _$QuickAddReviewStateCopyWithImpl<$Res>
    implements $QuickAddReviewStateCopyWith<$Res> {
  _$QuickAddReviewStateCopyWithImpl(this._self, this._then);

  final QuickAddReviewState _self;
  final $Res Function(QuickAddReviewState) _then;

/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? args = null,Object? today = null,Object? index = null,Object? current = null,Object? results = null,Object? marks = null,Object? wallets = null,Object? allCategories = null,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? actionFailure = freezed,}) {
  return _then(QuickAddReviewState(
args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as QuickAddReviewArgs,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as QuickAddDraft,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<QuickAddReviewResult>,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as Map<QuickAddField, MonAIFieldMark>,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,allCategories: null == allCategories ? _self.allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as QuickAddSaveFailure?,
  ));
}
/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddReviewArgsCopyWith<$Res> get args {
  
  return $QuickAddReviewArgsCopyWith<$Res>(_self.args, (value) {
    return _then(_self.copyWith(args: value));
  });
}/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res> get current {
  
  return $QuickAddDraftCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuickAddReviewState].
extension QuickAddReviewStatePatterns on QuickAddReviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddReviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddReviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddReviewState value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddReviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddReviewState value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddReviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuickAddReviewArgs args,  DateTime today,  int index,  QuickAddDraft current,  List<QuickAddReviewResult> results,  Map<QuickAddField, MonAIFieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  QuickAddSaveFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddReviewState() when $default != null:
return $default(_that.args,_that.today,_that.index,_that.current,_that.results,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuickAddReviewArgs args,  DateTime today,  int index,  QuickAddDraft current,  List<QuickAddReviewResult> results,  Map<QuickAddField, MonAIFieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  QuickAddSaveFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _QuickAddReviewState():
return $default(_that.args,_that.today,_that.index,_that.current,_that.results,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuickAddReviewArgs args,  DateTime today,  int index,  QuickAddDraft current,  List<QuickAddReviewResult> results,  Map<QuickAddField, MonAIFieldMark> marks,  List<Wallet> wallets,  List<Category> allCategories,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  QuickAddSaveFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddReviewState() when $default != null:
return $default(_that.args,_that.today,_that.index,_that.current,_that.results,_that.marks,_that.wallets,_that.allCategories,_that.errors,_that.autovalidate,_that.isSaving,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddReviewState implements QuickAddReviewState {
  const _QuickAddReviewState({required this.args, required this.today, this.index = 0, required this.current,  List<QuickAddReviewResult> results = const [],  Map<QuickAddField, MonAIFieldMark> marks = const {},  List<Wallet> wallets = const [],  List<Category> allCategories = const [],  Map<String, FieldError> errors = const {}, this.autovalidate = false, this.isSaving = false, this.actionFailure}): _results = results,_marks = marks,_wallets = wallets,_allCategories = allCategories,_errors = errors;
  

@override final  QuickAddReviewArgs args;
@override final  DateTime today;
@override@JsonKey() final  int index;
@override final  QuickAddDraft current;
 final  List<QuickAddReviewResult> _results;
@override@JsonKey() List<QuickAddReviewResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  Map<QuickAddField, MonAIFieldMark> _marks;
@override@JsonKey() Map<QuickAddField, MonAIFieldMark> get marks {
  if (_marks is EqualUnmodifiableMapView) return _marks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_marks);
}

 final  List<Wallet> _wallets;
@override@JsonKey() List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

 final  List<Category> _allCategories;
@override@JsonKey() List<Category> get allCategories {
  if (_allCategories is EqualUnmodifiableListView) return _allCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allCategories);
}

 final  Map<String, FieldError> _errors;
@override@JsonKey() Map<String, FieldError> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
@override final  QuickAddSaveFailure? actionFailure;

/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddReviewStateCopyWith<_QuickAddReviewState> get copyWith => __$QuickAddReviewStateCopyWithImpl<_QuickAddReviewState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddReviewState&&(identical(other.args, args) || other.args == args)&&(identical(other.today, today) || other.today == today)&&(identical(other.index, index) || other.index == index)&&(identical(other.current, current) || other.current == current)&&const DeepCollectionEquality().equals(other.results, _results)&&const DeepCollectionEquality().equals(other.marks, _marks)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&const DeepCollectionEquality().equals(other.allCategories, _allCategories)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,args,today,index,current,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_marks),const DeepCollectionEquality().hash(_wallets),const DeepCollectionEquality().hash(_allCategories),const DeepCollectionEquality().hash(_errors),autovalidate,isSaving,actionFailure);
}

@override
String toString() {
    return 'QuickAddReviewState(args: $args, today: $today, index: $index, current: $current, results: $results, marks: $marks, wallets: $wallets, allCategories: $allCategories, errors: $errors, autovalidate: $autovalidate, isSaving: $isSaving, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$QuickAddReviewStateCopyWith<$Res> implements $QuickAddReviewStateCopyWith<$Res> {
  factory _$QuickAddReviewStateCopyWith(_QuickAddReviewState value, $Res Function(_QuickAddReviewState) _then) = __$QuickAddReviewStateCopyWithImpl;
@override @useResult
$Res call({
 QuickAddReviewArgs args, DateTime today, int index, QuickAddDraft current, List<QuickAddReviewResult> results, Map<QuickAddField, MonAIFieldMark> marks, List<Wallet> wallets, List<Category> allCategories, Map<String, FieldError> errors, bool autovalidate, bool isSaving, QuickAddSaveFailure? actionFailure
});


@override $QuickAddReviewArgsCopyWith<$Res> get args;@override $QuickAddDraftCopyWith<$Res> get current;

}
/// @nodoc
class __$QuickAddReviewStateCopyWithImpl<$Res>
    implements _$QuickAddReviewStateCopyWith<$Res> {
  __$QuickAddReviewStateCopyWithImpl(this._self, this._then);

  final _QuickAddReviewState _self;
  final $Res Function(_QuickAddReviewState) _then;

/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? args = null,Object? today = null,Object? index = null,Object? current = null,Object? results = null,Object? marks = null,Object? wallets = null,Object? allCategories = null,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? actionFailure = freezed,}) {
  return _then(_QuickAddReviewState(
args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as QuickAddReviewArgs,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as QuickAddDraft,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<QuickAddReviewResult>,marks: null == marks ? _self._marks : marks // ignore: cast_nullable_to_non_nullable
as Map<QuickAddField, MonAIFieldMark>,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,allCategories: null == allCategories ? _self._allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as QuickAddSaveFailure?,
  ));
}

/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddReviewArgsCopyWith<$Res> get args {
  
  return $QuickAddReviewArgsCopyWith<$Res>(_self.args, (value) {
    return _then(_self.copyWith(args: value));
  });
}/// Create a copy of QuickAddReviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res> get current {
  
  return $QuickAddDraftCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}

/// @nodoc
mixin _$QuickAddReviewResult {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReviewResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddReviewResult()';
}


}

/// @nodoc
class $QuickAddReviewResultCopyWith<$Res>  {
$QuickAddReviewResultCopyWith(QuickAddReviewResult _, $Res Function(QuickAddReviewResult) __);
}


/// Adds pattern-matching-related methods to [QuickAddReviewResult].
extension QuickAddReviewResultPatterns on QuickAddReviewResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SavedQuickAddResult value)?  saved,TResult Function( SkippedQuickAddResult value)?  skipped,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SavedQuickAddResult() when saved != null:
return saved(_that);case SkippedQuickAddResult() when skipped != null:
return skipped(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SavedQuickAddResult value)  saved,required TResult Function( SkippedQuickAddResult value)  skipped,}){
final _that = this;
switch (_that) {
case SavedQuickAddResult():
return saved(_that);case SkippedQuickAddResult():
return skipped(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SavedQuickAddResult value)?  saved,TResult? Function( SkippedQuickAddResult value)?  skipped,}){
final _that = this;
switch (_that) {
case SavedQuickAddResult() when saved != null:
return saved(_that);case SkippedQuickAddResult() when skipped != null:
return skipped(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Transaction transaction)?  saved,TResult Function()?  skipped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SavedQuickAddResult() when saved != null:
return saved(_that.transaction);case SkippedQuickAddResult() when skipped != null:
return skipped();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Transaction transaction)  saved,required TResult Function()  skipped,}) {final _that = this;
switch (_that) {
case SavedQuickAddResult():
return saved(_that.transaction);case SkippedQuickAddResult():
return skipped();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Transaction transaction)?  saved,TResult? Function()?  skipped,}) {final _that = this;
switch (_that) {
case SavedQuickAddResult() when saved != null:
return saved(_that.transaction);case SkippedQuickAddResult() when skipped != null:
return skipped();case _:
  return null;

}
}

}

/// @nodoc


class SavedQuickAddResult implements QuickAddReviewResult {
  const SavedQuickAddResult(this.transaction);
  

 final  Transaction transaction;

/// Create a copy of QuickAddReviewResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedQuickAddResultCopyWith<SavedQuickAddResult> get copyWith => _$SavedQuickAddResultCopyWithImpl<SavedQuickAddResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedQuickAddResult&&(identical(other.transaction, transaction) || other.transaction == transaction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transaction);
}

@override
String toString() {
    return 'QuickAddReviewResult.saved(transaction: $transaction)';
}


}

/// @nodoc
abstract mixin class $SavedQuickAddResultCopyWith<$Res> implements $QuickAddReviewResultCopyWith<$Res> {
  factory $SavedQuickAddResultCopyWith(SavedQuickAddResult value, $Res Function(SavedQuickAddResult) _then) = _$SavedQuickAddResultCopyWithImpl;
@useResult
$Res call({
 Transaction transaction
});


$TransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class _$SavedQuickAddResultCopyWithImpl<$Res>
    implements $SavedQuickAddResultCopyWith<$Res> {
  _$SavedQuickAddResultCopyWithImpl(this._self, this._then);

  final SavedQuickAddResult _self;
  final $Res Function(SavedQuickAddResult) _then;

/// Create a copy of QuickAddReviewResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = null,}) {
  return _then(SavedQuickAddResult(
null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction,
  ));
}

/// Create a copy of QuickAddReviewResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res> get transaction {
  
  return $TransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

/// @nodoc


class SkippedQuickAddResult implements QuickAddReviewResult {
  const SkippedQuickAddResult();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SkippedQuickAddResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddReviewResult.skipped()';
}


}




// dart format on
