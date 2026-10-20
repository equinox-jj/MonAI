// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionFormEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent()';
}


}

/// @nodoc
class $TransactionFormEventCopyWith<$Res>  {
$TransactionFormEventCopyWith(TransactionFormEvent _, $Res Function(TransactionFormEvent) __);
}


/// Adds pattern-matching-related methods to [TransactionFormEvent].
extension TransactionFormEventPatterns on TransactionFormEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Retried value)?  retried,TResult Function( _TypeSelected value)?  typeSelected,TResult Function( _DigitPressed value)?  digitPressed,TResult Function( _TripleZeroPressed value)?  tripleZeroPressed,TResult Function( _BackspacePressed value)?  backspacePressed,TResult Function( _CategoryPicked value)?  categoryPicked,TResult Function( _WalletPicked value)?  walletPicked,TResult Function( _ToWalletPicked value)?  toWalletPicked,TResult Function( _DatePicked value)?  datePicked,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _CloseRequested value)?  closeRequested,TResult Function( _ScanRequested value)?  scanRequested,TResult Function( _DiscardConfirmed value)?  discardConfirmed,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _LookupsChanged value)?  lookupsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _DigitPressed() when digitPressed != null:
return digitPressed(_that);case _TripleZeroPressed() when tripleZeroPressed != null:
return tripleZeroPressed(_that);case _BackspacePressed() when backspacePressed != null:
return backspacePressed(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _CloseRequested() when closeRequested != null:
return closeRequested(_that);case _ScanRequested() when scanRequested != null:
return scanRequested(_that);case _DiscardConfirmed() when discardConfirmed != null:
return discardConfirmed(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Retried value)  retried,required TResult Function( _TypeSelected value)  typeSelected,required TResult Function( _DigitPressed value)  digitPressed,required TResult Function( _TripleZeroPressed value)  tripleZeroPressed,required TResult Function( _BackspacePressed value)  backspacePressed,required TResult Function( _CategoryPicked value)  categoryPicked,required TResult Function( _WalletPicked value)  walletPicked,required TResult Function( _ToWalletPicked value)  toWalletPicked,required TResult Function( _DatePicked value)  datePicked,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _CloseRequested value)  closeRequested,required TResult Function( _ScanRequested value)  scanRequested,required TResult Function( _DiscardConfirmed value)  discardConfirmed,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _LookupsChanged value)  lookupsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Retried():
return retried(_that);case _TypeSelected():
return typeSelected(_that);case _DigitPressed():
return digitPressed(_that);case _TripleZeroPressed():
return tripleZeroPressed(_that);case _BackspacePressed():
return backspacePressed(_that);case _CategoryPicked():
return categoryPicked(_that);case _WalletPicked():
return walletPicked(_that);case _ToWalletPicked():
return toWalletPicked(_that);case _DatePicked():
return datePicked(_that);case _SaveRequested():
return saveRequested(_that);case _CloseRequested():
return closeRequested(_that);case _ScanRequested():
return scanRequested(_that);case _DiscardConfirmed():
return discardConfirmed(_that);case _DeleteRequested():
return deleteRequested(_that);case _LookupsChanged():
return lookupsChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Retried value)?  retried,TResult? Function( _TypeSelected value)?  typeSelected,TResult? Function( _DigitPressed value)?  digitPressed,TResult? Function( _TripleZeroPressed value)?  tripleZeroPressed,TResult? Function( _BackspacePressed value)?  backspacePressed,TResult? Function( _CategoryPicked value)?  categoryPicked,TResult? Function( _WalletPicked value)?  walletPicked,TResult? Function( _ToWalletPicked value)?  toWalletPicked,TResult? Function( _DatePicked value)?  datePicked,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _CloseRequested value)?  closeRequested,TResult? Function( _ScanRequested value)?  scanRequested,TResult? Function( _DiscardConfirmed value)?  discardConfirmed,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _LookupsChanged value)?  lookupsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _DigitPressed() when digitPressed != null:
return digitPressed(_that);case _TripleZeroPressed() when tripleZeroPressed != null:
return tripleZeroPressed(_that);case _BackspacePressed() when backspacePressed != null:
return backspacePressed(_that);case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that);case _WalletPicked() when walletPicked != null:
return walletPicked(_that);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that);case _DatePicked() when datePicked != null:
return datePicked(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _CloseRequested() when closeRequested != null:
return closeRequested(_that);case _ScanRequested() when scanRequested != null:
return scanRequested(_that);case _DiscardConfirmed() when discardConfirmed != null:
return discardConfirmed(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  retried,TResult Function( TransactionType type)?  typeSelected,TResult Function( int digit)?  digitPressed,TResult Function()?  tripleZeroPressed,TResult Function()?  backspacePressed,TResult Function( String categoryId)?  categoryPicked,TResult Function( String walletId)?  walletPicked,TResult Function( String walletId)?  toWalletPicked,TResult Function( DateTime date)?  datePicked,TResult Function( String note)?  saveRequested,TResult Function( String note)?  closeRequested,TResult Function( String note)?  scanRequested,TResult Function()?  discardConfirmed,TResult Function()?  deleteRequested,TResult Function( TransactionLookups lookups)?  lookupsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _DigitPressed() when digitPressed != null:
return digitPressed(_that.digit);case _TripleZeroPressed() when tripleZeroPressed != null:
return tripleZeroPressed();case _BackspacePressed() when backspacePressed != null:
return backspacePressed();case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.note);case _CloseRequested() when closeRequested != null:
return closeRequested(_that.note);case _ScanRequested() when scanRequested != null:
return scanRequested(_that.note);case _DiscardConfirmed() when discardConfirmed != null:
return discardConfirmed();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  retried,required TResult Function( TransactionType type)  typeSelected,required TResult Function( int digit)  digitPressed,required TResult Function()  tripleZeroPressed,required TResult Function()  backspacePressed,required TResult Function( String categoryId)  categoryPicked,required TResult Function( String walletId)  walletPicked,required TResult Function( String walletId)  toWalletPicked,required TResult Function( DateTime date)  datePicked,required TResult Function( String note)  saveRequested,required TResult Function( String note)  closeRequested,required TResult Function( String note)  scanRequested,required TResult Function()  discardConfirmed,required TResult Function()  deleteRequested,required TResult Function( TransactionLookups lookups)  lookupsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Retried():
return retried();case _TypeSelected():
return typeSelected(_that.type);case _DigitPressed():
return digitPressed(_that.digit);case _TripleZeroPressed():
return tripleZeroPressed();case _BackspacePressed():
return backspacePressed();case _CategoryPicked():
return categoryPicked(_that.categoryId);case _WalletPicked():
return walletPicked(_that.walletId);case _ToWalletPicked():
return toWalletPicked(_that.walletId);case _DatePicked():
return datePicked(_that.date);case _SaveRequested():
return saveRequested(_that.note);case _CloseRequested():
return closeRequested(_that.note);case _ScanRequested():
return scanRequested(_that.note);case _DiscardConfirmed():
return discardConfirmed();case _DeleteRequested():
return deleteRequested();case _LookupsChanged():
return lookupsChanged(_that.lookups);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  retried,TResult? Function( TransactionType type)?  typeSelected,TResult? Function( int digit)?  digitPressed,TResult? Function()?  tripleZeroPressed,TResult? Function()?  backspacePressed,TResult? Function( String categoryId)?  categoryPicked,TResult? Function( String walletId)?  walletPicked,TResult? Function( String walletId)?  toWalletPicked,TResult? Function( DateTime date)?  datePicked,TResult? Function( String note)?  saveRequested,TResult? Function( String note)?  closeRequested,TResult? Function( String note)?  scanRequested,TResult? Function()?  discardConfirmed,TResult? Function()?  deleteRequested,TResult? Function( TransactionLookups lookups)?  lookupsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _DigitPressed() when digitPressed != null:
return digitPressed(_that.digit);case _TripleZeroPressed() when tripleZeroPressed != null:
return tripleZeroPressed();case _BackspacePressed() when backspacePressed != null:
return backspacePressed();case _CategoryPicked() when categoryPicked != null:
return categoryPicked(_that.categoryId);case _WalletPicked() when walletPicked != null:
return walletPicked(_that.walletId);case _ToWalletPicked() when toWalletPicked != null:
return toWalletPicked(_that.walletId);case _DatePicked() when datePicked != null:
return datePicked(_that.date);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.note);case _CloseRequested() when closeRequested != null:
return closeRequested(_that.note);case _ScanRequested() when scanRequested != null:
return scanRequested(_that.note);case _DiscardConfirmed() when discardConfirmed != null:
return discardConfirmed();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TransactionFormEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.started()';
}


}




/// @nodoc


class _Retried implements TransactionFormEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.retried()';
}


}




/// @nodoc


class _TypeSelected implements TransactionFormEvent {
  const _TypeSelected(this.type);
  

 final  TransactionType type;

/// Create a copy of TransactionFormEvent
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
    return 'TransactionFormEvent.typeSelected(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypeSelectedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
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

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_TypeSelected(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,
  ));
}


}

/// @nodoc


class _DigitPressed implements TransactionFormEvent {
  const _DigitPressed(this.digit);
  

 final  int digit;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DigitPressedCopyWith<_DigitPressed> get copyWith => __$DigitPressedCopyWithImpl<_DigitPressed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DigitPressed&&(identical(other.digit, digit) || other.digit == digit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,digit);
}

@override
String toString() {
    return 'TransactionFormEvent.digitPressed(digit: $digit)';
}


}

/// @nodoc
abstract mixin class _$DigitPressedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
  factory _$DigitPressedCopyWith(_DigitPressed value, $Res Function(_DigitPressed) _then) = __$DigitPressedCopyWithImpl;
@useResult
$Res call({
 int digit
});




}
/// @nodoc
class __$DigitPressedCopyWithImpl<$Res>
    implements _$DigitPressedCopyWith<$Res> {
  __$DigitPressedCopyWithImpl(this._self, this._then);

  final _DigitPressed _self;
  final $Res Function(_DigitPressed) _then;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? digit = null,}) {
  return _then(_DigitPressed(
null == digit ? _self.digit : digit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _TripleZeroPressed implements TransactionFormEvent {
  const _TripleZeroPressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripleZeroPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.tripleZeroPressed()';
}


}




/// @nodoc


class _BackspacePressed implements TransactionFormEvent {
  const _BackspacePressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackspacePressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.backspacePressed()';
}


}




/// @nodoc


class _CategoryPicked implements TransactionFormEvent {
  const _CategoryPicked(this.categoryId);
  

 final  String categoryId;

/// Create a copy of TransactionFormEvent
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
    return 'TransactionFormEvent.categoryPicked(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryPickedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
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

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,}) {
  return _then(_CategoryPicked(
null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletPicked implements TransactionFormEvent {
  const _WalletPicked(this.walletId);
  

 final  String walletId;

/// Create a copy of TransactionFormEvent
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
    return 'TransactionFormEvent.walletPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$WalletPickedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
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

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = null,}) {
  return _then(_WalletPicked(
null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToWalletPicked implements TransactionFormEvent {
  const _ToWalletPicked(this.walletId);
  

 final  String walletId;

/// Create a copy of TransactionFormEvent
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
    return 'TransactionFormEvent.toWalletPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$ToWalletPickedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
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

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = null,}) {
  return _then(_ToWalletPicked(
null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DatePicked implements TransactionFormEvent {
  const _DatePicked(this.date);
  

 final  DateTime date;

/// Create a copy of TransactionFormEvent
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
    return 'TransactionFormEvent.datePicked(date: $date)';
}


}

/// @nodoc
abstract mixin class _$DatePickedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
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

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_DatePicked(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _SaveRequested implements TransactionFormEvent {
  const _SaveRequested({required this.note});
  

 final  String note;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,note);
}

@override
String toString() {
    return 'TransactionFormEvent.saveRequested(note: $note)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String note
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? note = null,}) {
  return _then(_SaveRequested(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CloseRequested implements TransactionFormEvent {
  const _CloseRequested({required this.note});
  

 final  String note;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloseRequestedCopyWith<_CloseRequested> get copyWith => __$CloseRequestedCopyWithImpl<_CloseRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloseRequested&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,note);
}

@override
String toString() {
    return 'TransactionFormEvent.closeRequested(note: $note)';
}


}

/// @nodoc
abstract mixin class _$CloseRequestedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
  factory _$CloseRequestedCopyWith(_CloseRequested value, $Res Function(_CloseRequested) _then) = __$CloseRequestedCopyWithImpl;
@useResult
$Res call({
 String note
});




}
/// @nodoc
class __$CloseRequestedCopyWithImpl<$Res>
    implements _$CloseRequestedCopyWith<$Res> {
  __$CloseRequestedCopyWithImpl(this._self, this._then);

  final _CloseRequested _self;
  final $Res Function(_CloseRequested) _then;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? note = null,}) {
  return _then(_CloseRequested(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ScanRequested implements TransactionFormEvent {
  const _ScanRequested({required this.note});
  

 final  String note;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanRequestedCopyWith<_ScanRequested> get copyWith => __$ScanRequestedCopyWithImpl<_ScanRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanRequested&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,note);
}

@override
String toString() {
    return 'TransactionFormEvent.scanRequested(note: $note)';
}


}

/// @nodoc
abstract mixin class _$ScanRequestedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
  factory _$ScanRequestedCopyWith(_ScanRequested value, $Res Function(_ScanRequested) _then) = __$ScanRequestedCopyWithImpl;
@useResult
$Res call({
 String note
});




}
/// @nodoc
class __$ScanRequestedCopyWithImpl<$Res>
    implements _$ScanRequestedCopyWith<$Res> {
  __$ScanRequestedCopyWithImpl(this._self, this._then);

  final _ScanRequested _self;
  final $Res Function(_ScanRequested) _then;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? note = null,}) {
  return _then(_ScanRequested(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DiscardConfirmed implements TransactionFormEvent {
  const _DiscardConfirmed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscardConfirmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.discardConfirmed()';
}


}




/// @nodoc


class _DeleteRequested implements TransactionFormEvent {
  const _DeleteRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormEvent.deleteRequested()';
}


}




/// @nodoc


class _LookupsChanged implements TransactionFormEvent {
  const _LookupsChanged(this.lookups);
  

 final  TransactionLookups lookups;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LookupsChangedCopyWith<_LookupsChanged> get copyWith => __$LookupsChangedCopyWithImpl<_LookupsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LookupsChanged&&(identical(other.lookups, lookups) || other.lookups == lookups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lookups);
}

@override
String toString() {
    return 'TransactionFormEvent.lookupsChanged(lookups: $lookups)';
}


}

/// @nodoc
abstract mixin class _$LookupsChangedCopyWith<$Res> implements $TransactionFormEventCopyWith<$Res> {
  factory _$LookupsChangedCopyWith(_LookupsChanged value, $Res Function(_LookupsChanged) _then) = __$LookupsChangedCopyWithImpl;
@useResult
$Res call({
 TransactionLookups lookups
});


$TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class __$LookupsChangedCopyWithImpl<$Res>
    implements _$LookupsChangedCopyWith<$Res> {
  __$LookupsChangedCopyWithImpl(this._self, this._then);

  final _LookupsChanged _self;
  final $Res Function(_LookupsChanged) _then;

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lookups = null,}) {
  return _then(_LookupsChanged(
null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,
  ));
}

/// Create a copy of TransactionFormEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}

/// @nodoc
mixin _$TransactionFormState {

 TransactionFormMode get mode;/// The user's current date; later dates can't be picked.
 DateTime get today;/// What is entered now.
 TransactionDraft get draft;/// What the form started with, to tell whether anything changed.
 TransactionDraft get baseline;/// [UiStatus.loading] while the edited transaction loads,
/// [UiStatus.failure] when it couldn't be, otherwise
/// [UiStatus.success].
 UiStatus get status;/// The transaction being edited.
 Transaction? get original; TransactionLookups get lookups;/// One error per invalid field, keyed by the API's field name.
 Map<String, FieldError> get errors;/// Fields a quick-add draft filled unsurely, keyed by the API's field
/// name; each is marked until the user changes it.
 Set<String> get unsure;/// A save failed on the input, so errors update as the user edits.
 bool get autovalidate; bool get isSaving; bool get isDeleting;/// Close was asked with unsaved changes: the discard dialog shows once.
 bool get askDiscard;/// Set once the form is done; the screen closes.
 TransactionFormOutcome? get outcome;/// Why the edited transaction couldn't be loaded.
 TransactionFailure? get loadFailure;/// Why a save or delete failed; shown once as a snackbar.
 TransactionFailure? get actionFailure;
/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionFormStateCopyWith<TransactionFormState> get copyWith => _$TransactionFormStateCopyWithImpl<TransactionFormState>(this as TransactionFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.baseline, _this.baseline) || other.baseline == _this.baseline)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.original, _this.original) || other.original == _this.original)&&(identical(other.lookups, _this.lookups) || other.lookups == _this.lookups)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&const DeepCollectionEquality().equals(other.unsure, _this.unsure)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.askDiscard, _this.askDiscard) || other.askDiscard == _this.askDiscard)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as TransactionFormState;
  return Object.hash(runtimeType,_this.mode,_this.today,_this.draft,_this.baseline,_this.status,_this.original,_this.lookups,const DeepCollectionEquality().hash(_this.errors),const DeepCollectionEquality().hash(_this.unsure),_this.autovalidate,_this.isSaving,_this.isDeleting,_this.askDiscard,_this.outcome,_this.loadFailure,_this.actionFailure);
}

@override
String toString() {
  final _this = this as TransactionFormState;
  return 'TransactionFormState(mode: ${_this.mode}, today: ${_this.today}, draft: ${_this.draft}, baseline: ${_this.baseline}, status: ${_this.status}, original: ${_this.original}, lookups: ${_this.lookups}, errors: ${_this.errors}, unsure: ${_this.unsure}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, isDeleting: ${_this.isDeleting}, askDiscard: ${_this.askDiscard}, outcome: ${_this.outcome}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $TransactionFormStateCopyWith<$Res>  {
  factory $TransactionFormStateCopyWith(TransactionFormState value, $Res Function(TransactionFormState) _then) = _$TransactionFormStateCopyWithImpl;
@useResult
$Res call({
 TransactionFormMode mode, DateTime today, TransactionDraft draft, TransactionDraft baseline, UiStatus status, Transaction? original, TransactionLookups lookups, Map<String, FieldError> errors, Set<String> unsure, bool autovalidate, bool isSaving, bool isDeleting, bool askDiscard, TransactionFormOutcome? outcome, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


$TransactionFormModeCopyWith<$Res> get mode;$TransactionDraftCopyWith<$Res> get draft;$TransactionDraftCopyWith<$Res> get baseline;$TransactionCopyWith<$Res>? get original;$TransactionLookupsCopyWith<$Res> get lookups;$TransactionFormOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class _$TransactionFormStateCopyWithImpl<$Res>
    implements $TransactionFormStateCopyWith<$Res> {
  _$TransactionFormStateCopyWithImpl(this._self, this._then);

  final TransactionFormState _self;
  final $Res Function(TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? today = null,Object? draft = null,Object? baseline = null,Object? status = null,Object? original = freezed,Object? lookups = null,Object? errors = null,Object? unsure = null,Object? autovalidate = null,Object? isSaving = null,Object? isDeleting = null,Object? askDiscard = null,Object? outcome = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(TransactionFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransactionFormMode,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TransactionDraft,baseline: null == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as TransactionDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,unsure: null == unsure ? _self.unsure : unsure // ignore: cast_nullable_to_non_nullable
as Set<String>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,askDiscard: null == askDiscard ? _self.askDiscard : askDiscard // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as TransactionFormOutcome?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}
/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFormModeCopyWith<$Res> get mode {
  
  return $TransactionFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<$Res> get draft {
  
  return $TransactionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<$Res> get baseline {
  
  return $TransactionDraftCopyWith<$Res>(_self.baseline, (value) {
    return _then(_self.copyWith(baseline: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFormOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $TransactionFormOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionFormState].
extension TransactionFormStatePatterns on TransactionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionFormState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionFormMode mode,  DateTime today,  TransactionDraft draft,  TransactionDraft baseline,  UiStatus status,  Transaction? original,  TransactionLookups lookups,  Map<String, FieldError> errors,  Set<String> unsure,  bool autovalidate,  bool isSaving,  bool isDeleting,  bool askDiscard,  TransactionFormOutcome? outcome,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.mode,_that.today,_that.draft,_that.baseline,_that.status,_that.original,_that.lookups,_that.errors,_that.unsure,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.askDiscard,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionFormMode mode,  DateTime today,  TransactionDraft draft,  TransactionDraft baseline,  UiStatus status,  Transaction? original,  TransactionLookups lookups,  Map<String, FieldError> errors,  Set<String> unsure,  bool autovalidate,  bool isSaving,  bool isDeleting,  bool askDiscard,  TransactionFormOutcome? outcome,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState():
return $default(_that.mode,_that.today,_that.draft,_that.baseline,_that.status,_that.original,_that.lookups,_that.errors,_that.unsure,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.askDiscard,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionFormMode mode,  DateTime today,  TransactionDraft draft,  TransactionDraft baseline,  UiStatus status,  Transaction? original,  TransactionLookups lookups,  Map<String, FieldError> errors,  Set<String> unsure,  bool autovalidate,  bool isSaving,  bool isDeleting,  bool askDiscard,  TransactionFormOutcome? outcome,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.mode,_that.today,_that.draft,_that.baseline,_that.status,_that.original,_that.lookups,_that.errors,_that.unsure,_that.autovalidate,_that.isSaving,_that.isDeleting,_that.askDiscard,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionFormState implements TransactionFormState {
  const _TransactionFormState({required this.mode, required this.today, required this.draft, required this.baseline, this.status = UiStatus.initial, this.original, this.lookups = const TransactionLookups(),  Map<String, FieldError> errors = const {},  Set<String> unsure = const {}, this.autovalidate = false, this.isSaving = false, this.isDeleting = false, this.askDiscard = false, this.outcome, this.loadFailure, this.actionFailure}): _errors = errors,_unsure = unsure;
  

@override final  TransactionFormMode mode;
/// The user's current date; later dates can't be picked.
@override final  DateTime today;
/// What is entered now.
@override final  TransactionDraft draft;
/// What the form started with, to tell whether anything changed.
@override final  TransactionDraft baseline;
/// [UiStatus.loading] while the edited transaction loads,
/// [UiStatus.failure] when it couldn't be, otherwise
/// [UiStatus.success].
@override@JsonKey() final  UiStatus status;
/// The transaction being edited.
@override final  Transaction? original;
@override@JsonKey() final  TransactionLookups lookups;
/// One error per invalid field, keyed by the API's field name.
 final  Map<String, FieldError> _errors;
/// One error per invalid field, keyed by the API's field name.
@override@JsonKey() Map<String, FieldError> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// Fields a quick-add draft filled unsurely, keyed by the API's field
/// name; each is marked until the user changes it.
 final  Set<String> _unsure;
/// Fields a quick-add draft filled unsurely, keyed by the API's field
/// name; each is marked until the user changes it.
@override@JsonKey() Set<String> get unsure {
  if (_unsure is EqualUnmodifiableSetView) return _unsure;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unsure);
}

/// A save failed on the input, so errors update as the user edits.
@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isDeleting;
/// Close was asked with unsaved changes: the discard dialog shows once.
@override@JsonKey() final  bool askDiscard;
/// Set once the form is done; the screen closes.
@override final  TransactionFormOutcome? outcome;
/// Why the edited transaction couldn't be loaded.
@override final  TransactionFailure? loadFailure;
/// Why a save or delete failed; shown once as a snackbar.
@override final  TransactionFailure? actionFailure;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionFormStateCopyWith<_TransactionFormState> get copyWith => __$TransactionFormStateCopyWithImpl<_TransactionFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.today, today) || other.today == today)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.baseline, baseline) || other.baseline == baseline)&&(identical(other.status, status) || other.status == status)&&(identical(other.original, original) || other.original == original)&&(identical(other.lookups, lookups) || other.lookups == lookups)&&const DeepCollectionEquality().equals(other.errors, _errors)&&const DeepCollectionEquality().equals(other.unsure, _unsure)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.askDiscard, askDiscard) || other.askDiscard == askDiscard)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,today,draft,baseline,status,original,lookups,const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_unsure),autovalidate,isSaving,isDeleting,askDiscard,outcome,loadFailure,actionFailure);
}

@override
String toString() {
    return 'TransactionFormState(mode: $mode, today: $today, draft: $draft, baseline: $baseline, status: $status, original: $original, lookups: $lookups, errors: $errors, unsure: $unsure, autovalidate: $autovalidate, isSaving: $isSaving, isDeleting: $isDeleting, askDiscard: $askDiscard, outcome: $outcome, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$TransactionFormStateCopyWith<$Res> implements $TransactionFormStateCopyWith<$Res> {
  factory _$TransactionFormStateCopyWith(_TransactionFormState value, $Res Function(_TransactionFormState) _then) = __$TransactionFormStateCopyWithImpl;
@override @useResult
$Res call({
 TransactionFormMode mode, DateTime today, TransactionDraft draft, TransactionDraft baseline, UiStatus status, Transaction? original, TransactionLookups lookups, Map<String, FieldError> errors, Set<String> unsure, bool autovalidate, bool isSaving, bool isDeleting, bool askDiscard, TransactionFormOutcome? outcome, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


@override $TransactionFormModeCopyWith<$Res> get mode;@override $TransactionDraftCopyWith<$Res> get draft;@override $TransactionDraftCopyWith<$Res> get baseline;@override $TransactionCopyWith<$Res>? get original;@override $TransactionLookupsCopyWith<$Res> get lookups;@override $TransactionFormOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class __$TransactionFormStateCopyWithImpl<$Res>
    implements _$TransactionFormStateCopyWith<$Res> {
  __$TransactionFormStateCopyWithImpl(this._self, this._then);

  final _TransactionFormState _self;
  final $Res Function(_TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? today = null,Object? draft = null,Object? baseline = null,Object? status = null,Object? original = freezed,Object? lookups = null,Object? errors = null,Object? unsure = null,Object? autovalidate = null,Object? isSaving = null,Object? isDeleting = null,Object? askDiscard = null,Object? outcome = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_TransactionFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransactionFormMode,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TransactionDraft,baseline: null == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as TransactionDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,unsure: null == unsure ? _self._unsure : unsure // ignore: cast_nullable_to_non_nullable
as Set<String>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,askDiscard: null == askDiscard ? _self.askDiscard : askDiscard // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as TransactionFormOutcome?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFormModeCopyWith<$Res> get mode {
  
  return $TransactionFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<$Res> get draft {
  
  return $TransactionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDraftCopyWith<$Res> get baseline {
  
  return $TransactionDraftCopyWith<$Res>(_self.baseline, (value) {
    return _then(_self.copyWith(baseline: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFormOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $TransactionFormOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}

// dart format on
