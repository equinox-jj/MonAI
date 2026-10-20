// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_form_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionFormMode {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormMode()';
}


}

/// @nodoc
class $TransactionFormModeCopyWith<$Res>  {
$TransactionFormModeCopyWith(TransactionFormMode _, $Res Function(TransactionFormMode) __);
}


/// Adds pattern-matching-related methods to [TransactionFormMode].
extension TransactionFormModePatterns on TransactionFormMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddTransactionMode value)?  add,TResult Function( PrefillTransactionMode value)?  prefill,TResult Function( EditTransactionMode value)?  edit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddTransactionMode() when add != null:
return add(_that);case PrefillTransactionMode() when prefill != null:
return prefill(_that);case EditTransactionMode() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddTransactionMode value)  add,required TResult Function( PrefillTransactionMode value)  prefill,required TResult Function( EditTransactionMode value)  edit,}){
final _that = this;
switch (_that) {
case AddTransactionMode():
return add(_that);case PrefillTransactionMode():
return prefill(_that);case EditTransactionMode():
return edit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddTransactionMode value)?  add,TResult? Function( PrefillTransactionMode value)?  prefill,TResult? Function( EditTransactionMode value)?  edit,}){
final _that = this;
switch (_that) {
case AddTransactionMode() when add != null:
return add(_that);case PrefillTransactionMode() when prefill != null:
return prefill(_that);case EditTransactionMode() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TransactionType type,  String? walletId)?  add,TResult Function( QuickAddDraft draft)?  prefill,TResult Function( String id)?  edit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddTransactionMode() when add != null:
return add(_that.type,_that.walletId);case PrefillTransactionMode() when prefill != null:
return prefill(_that.draft);case EditTransactionMode() when edit != null:
return edit(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TransactionType type,  String? walletId)  add,required TResult Function( QuickAddDraft draft)  prefill,required TResult Function( String id)  edit,}) {final _that = this;
switch (_that) {
case AddTransactionMode():
return add(_that.type,_that.walletId);case PrefillTransactionMode():
return prefill(_that.draft);case EditTransactionMode():
return edit(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TransactionType type,  String? walletId)?  add,TResult? Function( QuickAddDraft draft)?  prefill,TResult? Function( String id)?  edit,}) {final _that = this;
switch (_that) {
case AddTransactionMode() when add != null:
return add(_that.type,_that.walletId);case PrefillTransactionMode() when prefill != null:
return prefill(_that.draft);case EditTransactionMode() when edit != null:
return edit(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class AddTransactionMode implements TransactionFormMode {
  const AddTransactionMode({this.type = TransactionType.expense, this.walletId});
  

@JsonKey() final  TransactionType type;
 final  String? walletId;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTransactionModeCopyWith<AddTransactionMode> get copyWith => _$AddTransactionModeCopyWithImpl<AddTransactionMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTransactionMode&&(identical(other.type, type) || other.type == type)&&(identical(other.walletId, walletId) || other.walletId == walletId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,walletId);
}

@override
String toString() {
    return 'TransactionFormMode.add(type: $type, walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class $AddTransactionModeCopyWith<$Res> implements $TransactionFormModeCopyWith<$Res> {
  factory $AddTransactionModeCopyWith(AddTransactionMode value, $Res Function(AddTransactionMode) _then) = _$AddTransactionModeCopyWithImpl;
@useResult
$Res call({
 TransactionType type, String? walletId
});




}
/// @nodoc
class _$AddTransactionModeCopyWithImpl<$Res>
    implements $AddTransactionModeCopyWith<$Res> {
  _$AddTransactionModeCopyWithImpl(this._self, this._then);

  final AddTransactionMode _self;
  final $Res Function(AddTransactionMode) _then;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? walletId = freezed,}) {
  return _then(AddTransactionMode(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,walletId: freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PrefillTransactionMode implements TransactionFormMode {
  const PrefillTransactionMode(this.draft);
  

 final  QuickAddDraft draft;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrefillTransactionModeCopyWith<PrefillTransactionMode> get copyWith => _$PrefillTransactionModeCopyWithImpl<PrefillTransactionMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrefillTransactionMode&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,draft);
}

@override
String toString() {
    return 'TransactionFormMode.prefill(draft: $draft)';
}


}

/// @nodoc
abstract mixin class $PrefillTransactionModeCopyWith<$Res> implements $TransactionFormModeCopyWith<$Res> {
  factory $PrefillTransactionModeCopyWith(PrefillTransactionMode value, $Res Function(PrefillTransactionMode) _then) = _$PrefillTransactionModeCopyWithImpl;
@useResult
$Res call({
 QuickAddDraft draft
});


$QuickAddDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$PrefillTransactionModeCopyWithImpl<$Res>
    implements $PrefillTransactionModeCopyWith<$Res> {
  _$PrefillTransactionModeCopyWithImpl(this._self, this._then);

  final PrefillTransactionMode _self;
  final $Res Function(PrefillTransactionMode) _then;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(PrefillTransactionMode(
null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as QuickAddDraft,
  ));
}

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res> get draft {
  
  return $QuickAddDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class EditTransactionMode implements TransactionFormMode {
  const EditTransactionMode(this.id);
  

 final  String id;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditTransactionModeCopyWith<EditTransactionMode> get copyWith => _$EditTransactionModeCopyWithImpl<EditTransactionMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditTransactionMode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TransactionFormMode.edit(id: $id)';
}


}

/// @nodoc
abstract mixin class $EditTransactionModeCopyWith<$Res> implements $TransactionFormModeCopyWith<$Res> {
  factory $EditTransactionModeCopyWith(EditTransactionMode value, $Res Function(EditTransactionMode) _then) = _$EditTransactionModeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$EditTransactionModeCopyWithImpl<$Res>
    implements $EditTransactionModeCopyWith<$Res> {
  _$EditTransactionModeCopyWithImpl(this._self, this._then);

  final EditTransactionMode _self;
  final $Res Function(EditTransactionMode) _then;

/// Create a copy of TransactionFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(EditTransactionMode(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TransactionFormOutcome {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormOutcome()';
}


}

/// @nodoc
class $TransactionFormOutcomeCopyWith<$Res>  {
$TransactionFormOutcomeCopyWith(TransactionFormOutcome _, $Res Function(TransactionFormOutcome) __);
}


/// Adds pattern-matching-related methods to [TransactionFormOutcome].
extension TransactionFormOutcomePatterns on TransactionFormOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ClosedFormOutcome value)?  closed,TResult Function( SavedFormOutcome value)?  saved,TResult Function( DeletedFormOutcome value)?  deleted,TResult Function( ScanReceiptFormOutcome value)?  scanReceipt,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ClosedFormOutcome() when closed != null:
return closed(_that);case SavedFormOutcome() when saved != null:
return saved(_that);case DeletedFormOutcome() when deleted != null:
return deleted(_that);case ScanReceiptFormOutcome() when scanReceipt != null:
return scanReceipt(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ClosedFormOutcome value)  closed,required TResult Function( SavedFormOutcome value)  saved,required TResult Function( DeletedFormOutcome value)  deleted,required TResult Function( ScanReceiptFormOutcome value)  scanReceipt,}){
final _that = this;
switch (_that) {
case ClosedFormOutcome():
return closed(_that);case SavedFormOutcome():
return saved(_that);case DeletedFormOutcome():
return deleted(_that);case ScanReceiptFormOutcome():
return scanReceipt(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ClosedFormOutcome value)?  closed,TResult? Function( SavedFormOutcome value)?  saved,TResult? Function( DeletedFormOutcome value)?  deleted,TResult? Function( ScanReceiptFormOutcome value)?  scanReceipt,}){
final _that = this;
switch (_that) {
case ClosedFormOutcome() when closed != null:
return closed(_that);case SavedFormOutcome() when saved != null:
return saved(_that);case DeletedFormOutcome() when deleted != null:
return deleted(_that);case ScanReceiptFormOutcome() when scanReceipt != null:
return scanReceipt(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  closed,TResult Function( String id)?  saved,TResult Function( String id)?  deleted,TResult Function()?  scanReceipt,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ClosedFormOutcome() when closed != null:
return closed();case SavedFormOutcome() when saved != null:
return saved(_that.id);case DeletedFormOutcome() when deleted != null:
return deleted(_that.id);case ScanReceiptFormOutcome() when scanReceipt != null:
return scanReceipt();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  closed,required TResult Function( String id)  saved,required TResult Function( String id)  deleted,required TResult Function()  scanReceipt,}) {final _that = this;
switch (_that) {
case ClosedFormOutcome():
return closed();case SavedFormOutcome():
return saved(_that.id);case DeletedFormOutcome():
return deleted(_that.id);case ScanReceiptFormOutcome():
return scanReceipt();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  closed,TResult? Function( String id)?  saved,TResult? Function( String id)?  deleted,TResult? Function()?  scanReceipt,}) {final _that = this;
switch (_that) {
case ClosedFormOutcome() when closed != null:
return closed();case SavedFormOutcome() when saved != null:
return saved(_that.id);case DeletedFormOutcome() when deleted != null:
return deleted(_that.id);case ScanReceiptFormOutcome() when scanReceipt != null:
return scanReceipt();case _:
  return null;

}
}

}

/// @nodoc


class ClosedFormOutcome implements TransactionFormOutcome {
  const ClosedFormOutcome();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ClosedFormOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormOutcome.closed()';
}


}




/// @nodoc


class SavedFormOutcome implements TransactionFormOutcome {
  const SavedFormOutcome(this.id);
  

 final  String id;

/// Create a copy of TransactionFormOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedFormOutcomeCopyWith<SavedFormOutcome> get copyWith => _$SavedFormOutcomeCopyWithImpl<SavedFormOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedFormOutcome&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TransactionFormOutcome.saved(id: $id)';
}


}

/// @nodoc
abstract mixin class $SavedFormOutcomeCopyWith<$Res> implements $TransactionFormOutcomeCopyWith<$Res> {
  factory $SavedFormOutcomeCopyWith(SavedFormOutcome value, $Res Function(SavedFormOutcome) _then) = _$SavedFormOutcomeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SavedFormOutcomeCopyWithImpl<$Res>
    implements $SavedFormOutcomeCopyWith<$Res> {
  _$SavedFormOutcomeCopyWithImpl(this._self, this._then);

  final SavedFormOutcome _self;
  final $Res Function(SavedFormOutcome) _then;

/// Create a copy of TransactionFormOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SavedFormOutcome(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeletedFormOutcome implements TransactionFormOutcome {
  const DeletedFormOutcome(this.id);
  

 final  String id;

/// Create a copy of TransactionFormOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedFormOutcomeCopyWith<DeletedFormOutcome> get copyWith => _$DeletedFormOutcomeCopyWithImpl<DeletedFormOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedFormOutcome&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TransactionFormOutcome.deleted(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeletedFormOutcomeCopyWith<$Res> implements $TransactionFormOutcomeCopyWith<$Res> {
  factory $DeletedFormOutcomeCopyWith(DeletedFormOutcome value, $Res Function(DeletedFormOutcome) _then) = _$DeletedFormOutcomeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DeletedFormOutcomeCopyWithImpl<$Res>
    implements $DeletedFormOutcomeCopyWith<$Res> {
  _$DeletedFormOutcomeCopyWithImpl(this._self, this._then);

  final DeletedFormOutcome _self;
  final $Res Function(DeletedFormOutcome) _then;

/// Create a copy of TransactionFormOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeletedFormOutcome(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ScanReceiptFormOutcome implements TransactionFormOutcome {
  const ScanReceiptFormOutcome();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanReceiptFormOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionFormOutcome.scanReceipt()';
}


}




// dart format on
