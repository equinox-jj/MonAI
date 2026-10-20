// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionDetailEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionDetailEvent()';
}


}

/// @nodoc
class $TransactionDetailEventCopyWith<$Res>  {
$TransactionDetailEventCopyWith(TransactionDetailEvent _, $Res Function(TransactionDetailEvent) __);
}


/// Adds pattern-matching-related methods to [TransactionDetailEvent].
extension TransactionDetailEventPatterns on TransactionDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Retried value)?  retried,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _TransactionChanged value)?  transactionChanged,TResult Function( _LookupsChanged value)?  lookupsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _TransactionChanged() when transactionChanged != null:
return transactionChanged(_that);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Retried value)  retried,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _TransactionChanged value)  transactionChanged,required TResult Function( _LookupsChanged value)  lookupsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Retried():
return retried(_that);case _DeleteRequested():
return deleteRequested(_that);case _TransactionChanged():
return transactionChanged(_that);case _LookupsChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Retried value)?  retried,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _TransactionChanged value)?  transactionChanged,TResult? Function( _LookupsChanged value)?  lookupsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _TransactionChanged() when transactionChanged != null:
return transactionChanged(_that);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  retried,TResult Function()?  deleteRequested,TResult Function( Transaction? transaction)?  transactionChanged,TResult Function( TransactionLookups lookups)?  lookupsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _TransactionChanged() when transactionChanged != null:
return transactionChanged(_that.transaction);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  retried,required TResult Function()  deleteRequested,required TResult Function( Transaction? transaction)  transactionChanged,required TResult Function( TransactionLookups lookups)  lookupsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Retried():
return retried();case _DeleteRequested():
return deleteRequested();case _TransactionChanged():
return transactionChanged(_that.transaction);case _LookupsChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  retried,TResult? Function()?  deleteRequested,TResult? Function( Transaction? transaction)?  transactionChanged,TResult? Function( TransactionLookups lookups)?  lookupsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _TransactionChanged() when transactionChanged != null:
return transactionChanged(_that.transaction);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TransactionDetailEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionDetailEvent.started()';
}


}




/// @nodoc


class _Retried implements TransactionDetailEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionDetailEvent.retried()';
}


}




/// @nodoc


class _DeleteRequested implements TransactionDetailEvent {
  const _DeleteRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionDetailEvent.deleteRequested()';
}


}




/// @nodoc


class _TransactionChanged implements TransactionDetailEvent {
  const _TransactionChanged(this.transaction);
  

 final  Transaction? transaction;

/// Create a copy of TransactionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionChangedCopyWith<_TransactionChanged> get copyWith => __$TransactionChangedCopyWithImpl<_TransactionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionChanged&&(identical(other.transaction, transaction) || other.transaction == transaction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transaction);
}

@override
String toString() {
    return 'TransactionDetailEvent.transactionChanged(transaction: $transaction)';
}


}

/// @nodoc
abstract mixin class _$TransactionChangedCopyWith<$Res> implements $TransactionDetailEventCopyWith<$Res> {
  factory _$TransactionChangedCopyWith(_TransactionChanged value, $Res Function(_TransactionChanged) _then) = __$TransactionChangedCopyWithImpl;
@useResult
$Res call({
 Transaction? transaction
});


$TransactionCopyWith<$Res>? get transaction;

}
/// @nodoc
class __$TransactionChangedCopyWithImpl<$Res>
    implements _$TransactionChangedCopyWith<$Res> {
  __$TransactionChangedCopyWithImpl(this._self, this._then);

  final _TransactionChanged _self;
  final $Res Function(_TransactionChanged) _then;

/// Create a copy of TransactionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = freezed,}) {
  return _then(_TransactionChanged(
freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction?,
  ));
}

/// Create a copy of TransactionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

/// @nodoc


class _LookupsChanged implements TransactionDetailEvent {
  const _LookupsChanged(this.lookups);
  

 final  TransactionLookups lookups;

/// Create a copy of TransactionDetailEvent
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
    return 'TransactionDetailEvent.lookupsChanged(lookups: $lookups)';
}


}

/// @nodoc
abstract mixin class _$LookupsChangedCopyWith<$Res> implements $TransactionDetailEventCopyWith<$Res> {
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

/// Create a copy of TransactionDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lookups = null,}) {
  return _then(_LookupsChanged(
null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,
  ));
}

/// Create a copy of TransactionDetailEvent
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
mixin _$TransactionDetailState {

/// [UiStatus.loading] until the transaction is cached,
/// [UiStatus.failure] when it couldn't be fetched or no longer exists,
/// otherwise [UiStatus.success].
 UiStatus get status; Transaction? get transaction; TransactionLookups get lookups; bool get isRefreshing; bool get isDeleting;/// The transaction was deleted, here or elsewhere: the screen closes.
 bool get isClosed;/// Why the transaction couldn't be shown.
 TransactionFailure? get loadFailure;/// Why a delete failed; shown once as a snackbar.
 TransactionFailure? get actionFailure;
/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDetailStateCopyWith<TransactionDetailState> get copyWith => _$TransactionDetailStateCopyWithImpl<TransactionDetailState>(this as TransactionDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDetailState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.transaction, _this.transaction) || other.transaction == _this.transaction)&&(identical(other.lookups, _this.lookups) || other.lookups == _this.lookups)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.isClosed, _this.isClosed) || other.isClosed == _this.isClosed)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as TransactionDetailState;
  return Object.hash(runtimeType,_this.status,_this.transaction,_this.lookups,_this.isRefreshing,_this.isDeleting,_this.isClosed,_this.loadFailure,_this.actionFailure);
}

@override
String toString() {
  final _this = this as TransactionDetailState;
  return 'TransactionDetailState(status: ${_this.status}, transaction: ${_this.transaction}, lookups: ${_this.lookups}, isRefreshing: ${_this.isRefreshing}, isDeleting: ${_this.isDeleting}, isClosed: ${_this.isClosed}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $TransactionDetailStateCopyWith<$Res>  {
  factory $TransactionDetailStateCopyWith(TransactionDetailState value, $Res Function(TransactionDetailState) _then) = _$TransactionDetailStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, Transaction? transaction, TransactionLookups lookups, bool isRefreshing, bool isDeleting, bool isClosed, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


$TransactionCopyWith<$Res>? get transaction;$TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class _$TransactionDetailStateCopyWithImpl<$Res>
    implements $TransactionDetailStateCopyWith<$Res> {
  _$TransactionDetailStateCopyWithImpl(this._self, this._then);

  final TransactionDetailState _self;
  final $Res Function(TransactionDetailState) _then;

/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? transaction = freezed,Object? lookups = null,Object? isRefreshing = null,Object? isDeleting = null,Object? isClosed = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(TransactionDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}
/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionDetailState].
extension TransactionDetailStatePatterns on TransactionDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDetailState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  Transaction? transaction,  TransactionLookups lookups,  bool isRefreshing,  bool isDeleting,  bool isClosed,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionDetailState() when $default != null:
return $default(_that.status,_that.transaction,_that.lookups,_that.isRefreshing,_that.isDeleting,_that.isClosed,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  Transaction? transaction,  TransactionLookups lookups,  bool isRefreshing,  bool isDeleting,  bool isClosed,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _TransactionDetailState():
return $default(_that.status,_that.transaction,_that.lookups,_that.isRefreshing,_that.isDeleting,_that.isClosed,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  Transaction? transaction,  TransactionLookups lookups,  bool isRefreshing,  bool isDeleting,  bool isClosed,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _TransactionDetailState() when $default != null:
return $default(_that.status,_that.transaction,_that.lookups,_that.isRefreshing,_that.isDeleting,_that.isClosed,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionDetailState implements TransactionDetailState {
  const _TransactionDetailState({this.status = UiStatus.initial, this.transaction, this.lookups = const TransactionLookups(), this.isRefreshing = false, this.isDeleting = false, this.isClosed = false, this.loadFailure, this.actionFailure});
  

/// [UiStatus.loading] until the transaction is cached,
/// [UiStatus.failure] when it couldn't be fetched or no longer exists,
/// otherwise [UiStatus.success].
@override@JsonKey() final  UiStatus status;
@override final  Transaction? transaction;
@override@JsonKey() final  TransactionLookups lookups;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool isDeleting;
/// The transaction was deleted, here or elsewhere: the screen closes.
@override@JsonKey() final  bool isClosed;
/// Why the transaction couldn't be shown.
@override final  TransactionFailure? loadFailure;
/// Why a delete failed; shown once as a snackbar.
@override final  TransactionFailure? actionFailure;

/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDetailStateCopyWith<_TransactionDetailState> get copyWith => __$TransactionDetailStateCopyWithImpl<_TransactionDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.lookups, lookups) || other.lookups == lookups)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,transaction,lookups,isRefreshing,isDeleting,isClosed,loadFailure,actionFailure);
}

@override
String toString() {
    return 'TransactionDetailState(status: $status, transaction: $transaction, lookups: $lookups, isRefreshing: $isRefreshing, isDeleting: $isDeleting, isClosed: $isClosed, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$TransactionDetailStateCopyWith<$Res> implements $TransactionDetailStateCopyWith<$Res> {
  factory _$TransactionDetailStateCopyWith(_TransactionDetailState value, $Res Function(_TransactionDetailState) _then) = __$TransactionDetailStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, Transaction? transaction, TransactionLookups lookups, bool isRefreshing, bool isDeleting, bool isClosed, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


@override $TransactionCopyWith<$Res>? get transaction;@override $TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class __$TransactionDetailStateCopyWithImpl<$Res>
    implements _$TransactionDetailStateCopyWith<$Res> {
  __$TransactionDetailStateCopyWithImpl(this._self, this._then);

  final _TransactionDetailState _self;
  final $Res Function(_TransactionDetailState) _then;

/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? transaction = freezed,Object? lookups = null,Object? isRefreshing = null,Object? isDeleting = null,Object? isClosed = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_TransactionDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}

/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of TransactionDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}

// dart format on
