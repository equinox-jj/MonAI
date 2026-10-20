// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'undo_delete_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UndoDeleteState {

/// The transaction that can still be restored; null hides the undo.
 Transaction? get deleted;/// Names for [deleted]'s title.
 TransactionLookups get lookups; bool get isRestoring;/// Why the last restore failed; shown once.
 TransactionFailure? get restoreFailure;
/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UndoDeleteStateCopyWith<UndoDeleteState> get copyWith => _$UndoDeleteStateCopyWithImpl<UndoDeleteState>(this as UndoDeleteState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UndoDeleteState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UndoDeleteState&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted)&&(identical(other.lookups, _this.lookups) || other.lookups == _this.lookups)&&(identical(other.isRestoring, _this.isRestoring) || other.isRestoring == _this.isRestoring)&&(identical(other.restoreFailure, _this.restoreFailure) || other.restoreFailure == _this.restoreFailure));
}


@override
int get hashCode {
  final _this = this as UndoDeleteState;
  return Object.hash(runtimeType,_this.deleted,_this.lookups,_this.isRestoring,_this.restoreFailure);
}

@override
String toString() {
  final _this = this as UndoDeleteState;
  return 'UndoDeleteState(deleted: ${_this.deleted}, lookups: ${_this.lookups}, isRestoring: ${_this.isRestoring}, restoreFailure: ${_this.restoreFailure})';
}


}

/// @nodoc
abstract mixin class $UndoDeleteStateCopyWith<$Res>  {
  factory $UndoDeleteStateCopyWith(UndoDeleteState value, $Res Function(UndoDeleteState) _then) = _$UndoDeleteStateCopyWithImpl;
@useResult
$Res call({
 Transaction? deleted, TransactionLookups lookups, bool isRestoring, TransactionFailure? restoreFailure
});


$TransactionCopyWith<$Res>? get deleted;$TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class _$UndoDeleteStateCopyWithImpl<$Res>
    implements $UndoDeleteStateCopyWith<$Res> {
  _$UndoDeleteStateCopyWithImpl(this._self, this._then);

  final UndoDeleteState _self;
  final $Res Function(UndoDeleteState) _then;

/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deleted = freezed,Object? lookups = null,Object? isRestoring = null,Object? restoreFailure = freezed,}) {
  return _then(UndoDeleteState(
deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,isRestoring: null == isRestoring ? _self.isRestoring : isRestoring // ignore: cast_nullable_to_non_nullable
as bool,restoreFailure: freezed == restoreFailure ? _self.restoreFailure : restoreFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}
/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get deleted {
    if (_self.deleted == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.deleted!, (value) {
    return _then(_self.copyWith(deleted: value));
  });
}/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}


/// Adds pattern-matching-related methods to [UndoDeleteState].
extension UndoDeleteStatePatterns on UndoDeleteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UndoDeleteState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UndoDeleteState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UndoDeleteState value)  $default,){
final _that = this;
switch (_that) {
case _UndoDeleteState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UndoDeleteState value)?  $default,){
final _that = this;
switch (_that) {
case _UndoDeleteState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Transaction? deleted,  TransactionLookups lookups,  bool isRestoring,  TransactionFailure? restoreFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UndoDeleteState() when $default != null:
return $default(_that.deleted,_that.lookups,_that.isRestoring,_that.restoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Transaction? deleted,  TransactionLookups lookups,  bool isRestoring,  TransactionFailure? restoreFailure)  $default,) {final _that = this;
switch (_that) {
case _UndoDeleteState():
return $default(_that.deleted,_that.lookups,_that.isRestoring,_that.restoreFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Transaction? deleted,  TransactionLookups lookups,  bool isRestoring,  TransactionFailure? restoreFailure)?  $default,) {final _that = this;
switch (_that) {
case _UndoDeleteState() when $default != null:
return $default(_that.deleted,_that.lookups,_that.isRestoring,_that.restoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class _UndoDeleteState implements UndoDeleteState {
  const _UndoDeleteState({this.deleted, this.lookups = const TransactionLookups(), this.isRestoring = false, this.restoreFailure});
  

/// The transaction that can still be restored; null hides the undo.
@override final  Transaction? deleted;
/// Names for [deleted]'s title.
@override@JsonKey() final  TransactionLookups lookups;
@override@JsonKey() final  bool isRestoring;
/// Why the last restore failed; shown once.
@override final  TransactionFailure? restoreFailure;

/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UndoDeleteStateCopyWith<_UndoDeleteState> get copyWith => __$UndoDeleteStateCopyWithImpl<_UndoDeleteState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UndoDeleteState&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.lookups, lookups) || other.lookups == lookups)&&(identical(other.isRestoring, isRestoring) || other.isRestoring == isRestoring)&&(identical(other.restoreFailure, restoreFailure) || other.restoreFailure == restoreFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deleted,lookups,isRestoring,restoreFailure);
}

@override
String toString() {
    return 'UndoDeleteState(deleted: $deleted, lookups: $lookups, isRestoring: $isRestoring, restoreFailure: $restoreFailure)';
}


}

/// @nodoc
abstract mixin class _$UndoDeleteStateCopyWith<$Res> implements $UndoDeleteStateCopyWith<$Res> {
  factory _$UndoDeleteStateCopyWith(_UndoDeleteState value, $Res Function(_UndoDeleteState) _then) = __$UndoDeleteStateCopyWithImpl;
@override @useResult
$Res call({
 Transaction? deleted, TransactionLookups lookups, bool isRestoring, TransactionFailure? restoreFailure
});


@override $TransactionCopyWith<$Res>? get deleted;@override $TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class __$UndoDeleteStateCopyWithImpl<$Res>
    implements _$UndoDeleteStateCopyWith<$Res> {
  __$UndoDeleteStateCopyWithImpl(this._self, this._then);

  final _UndoDeleteState _self;
  final $Res Function(_UndoDeleteState) _then;

/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deleted = freezed,Object? lookups = null,Object? isRestoring = null,Object? restoreFailure = freezed,}) {
  return _then(_UndoDeleteState(
deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as Transaction?,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,isRestoring: null == isRestoring ? _self.isRestoring : isRestoring // ignore: cast_nullable_to_non_nullable
as bool,restoreFailure: freezed == restoreFailure ? _self.restoreFailure : restoreFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}

/// Create a copy of UndoDeleteState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get deleted {
    if (_self.deleted == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.deleted!, (value) {
    return _then(_self.copyWith(deleted: value));
  });
}/// Create a copy of UndoDeleteState
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
