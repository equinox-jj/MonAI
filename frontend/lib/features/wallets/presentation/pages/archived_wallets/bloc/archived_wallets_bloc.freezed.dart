// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archived_wallets_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArchivedWalletsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchivedWalletsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ArchivedWalletsEvent()';
}


}

/// @nodoc
class $ArchivedWalletsEventCopyWith<$Res>  {
$ArchivedWalletsEventCopyWith(ArchivedWalletsEvent _, $Res Function(ArchivedWalletsEvent) __);
}


/// Adds pattern-matching-related methods to [ArchivedWalletsEvent].
extension ArchivedWalletsEventPatterns on ArchivedWalletsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _UnarchiveRequested value)?  unarchiveRequested,TResult Function( _WalletsChanged value)?  walletsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UnarchiveRequested() when unarchiveRequested != null:
return unarchiveRequested(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _UnarchiveRequested value)  unarchiveRequested,required TResult Function( _WalletsChanged value)  walletsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _UnarchiveRequested():
return unarchiveRequested(_that);case _WalletsChanged():
return walletsChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _UnarchiveRequested value)?  unarchiveRequested,TResult? Function( _WalletsChanged value)?  walletsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UnarchiveRequested() when unarchiveRequested != null:
return unarchiveRequested(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String id)?  unarchiveRequested,TResult Function( List<Wallet> wallets)?  walletsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UnarchiveRequested() when unarchiveRequested != null:
return unarchiveRequested(_that.id);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String id)  unarchiveRequested,required TResult Function( List<Wallet> wallets)  walletsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _UnarchiveRequested():
return unarchiveRequested(_that.id);case _WalletsChanged():
return walletsChanged(_that.wallets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String id)?  unarchiveRequested,TResult? Function( List<Wallet> wallets)?  walletsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UnarchiveRequested() when unarchiveRequested != null:
return unarchiveRequested(_that.id);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ArchivedWalletsEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ArchivedWalletsEvent.started()';
}


}




/// @nodoc


class _UnarchiveRequested implements ArchivedWalletsEvent {
  const _UnarchiveRequested(this.id);
  

 final  String id;

/// Create a copy of ArchivedWalletsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnarchiveRequestedCopyWith<_UnarchiveRequested> get copyWith => __$UnarchiveRequestedCopyWithImpl<_UnarchiveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnarchiveRequested&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'ArchivedWalletsEvent.unarchiveRequested(id: $id)';
}


}

/// @nodoc
abstract mixin class _$UnarchiveRequestedCopyWith<$Res> implements $ArchivedWalletsEventCopyWith<$Res> {
  factory _$UnarchiveRequestedCopyWith(_UnarchiveRequested value, $Res Function(_UnarchiveRequested) _then) = __$UnarchiveRequestedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$UnarchiveRequestedCopyWithImpl<$Res>
    implements _$UnarchiveRequestedCopyWith<$Res> {
  __$UnarchiveRequestedCopyWithImpl(this._self, this._then);

  final _UnarchiveRequested _self;
  final $Res Function(_UnarchiveRequested) _then;

/// Create a copy of ArchivedWalletsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_UnarchiveRequested(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletsChanged implements ArchivedWalletsEvent {
  const _WalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of ArchivedWalletsEvent
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
    return 'ArchivedWalletsEvent.walletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletsChangedCopyWith<$Res> implements $ArchivedWalletsEventCopyWith<$Res> {
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

/// Create a copy of ArchivedWalletsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_WalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc
mixin _$ArchivedWalletsState {

 UiStatus get status; List<Wallet> get wallets; Set<String> get restoringIds; Wallet? get restored; WalletFailure? get actionFailure;
/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchivedWalletsStateCopyWith<ArchivedWalletsState> get copyWith => _$ArchivedWalletsStateCopyWithImpl<ArchivedWalletsState>(this as ArchivedWalletsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ArchivedWalletsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchivedWalletsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&const DeepCollectionEquality().equals(other.restoringIds, _this.restoringIds)&&(identical(other.restored, _this.restored) || other.restored == _this.restored)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as ArchivedWalletsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.wallets),const DeepCollectionEquality().hash(_this.restoringIds),_this.restored,_this.actionFailure);
}

@override
String toString() {
  final _this = this as ArchivedWalletsState;
  return 'ArchivedWalletsState(status: ${_this.status}, wallets: ${_this.wallets}, restoringIds: ${_this.restoringIds}, restored: ${_this.restored}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $ArchivedWalletsStateCopyWith<$Res>  {
  factory $ArchivedWalletsStateCopyWith(ArchivedWalletsState value, $Res Function(ArchivedWalletsState) _then) = _$ArchivedWalletsStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, List<Wallet> wallets, Set<String> restoringIds, Wallet? restored, WalletFailure? actionFailure
});


$WalletCopyWith<$Res>? get restored;

}
/// @nodoc
class _$ArchivedWalletsStateCopyWithImpl<$Res>
    implements $ArchivedWalletsStateCopyWith<$Res> {
  _$ArchivedWalletsStateCopyWithImpl(this._self, this._then);

  final ArchivedWalletsState _self;
  final $Res Function(ArchivedWalletsState) _then;

/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? wallets = null,Object? restoringIds = null,Object? restored = freezed,Object? actionFailure = freezed,}) {
  return _then(ArchivedWalletsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,restoringIds: null == restoringIds ? _self.restoringIds : restoringIds // ignore: cast_nullable_to_non_nullable
as Set<String>,restored: freezed == restored ? _self.restored : restored // ignore: cast_nullable_to_non_nullable
as Wallet?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}
/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get restored {
    if (_self.restored == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.restored!, (value) {
    return _then(_self.copyWith(restored: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArchivedWalletsState].
extension ArchivedWalletsStatePatterns on ArchivedWalletsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchivedWalletsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchivedWalletsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchivedWalletsState value)  $default,){
final _that = this;
switch (_that) {
case _ArchivedWalletsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchivedWalletsState value)?  $default,){
final _that = this;
switch (_that) {
case _ArchivedWalletsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  List<Wallet> wallets,  Set<String> restoringIds,  Wallet? restored,  WalletFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchivedWalletsState() when $default != null:
return $default(_that.status,_that.wallets,_that.restoringIds,_that.restored,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  List<Wallet> wallets,  Set<String> restoringIds,  Wallet? restored,  WalletFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _ArchivedWalletsState():
return $default(_that.status,_that.wallets,_that.restoringIds,_that.restored,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  List<Wallet> wallets,  Set<String> restoringIds,  Wallet? restored,  WalletFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _ArchivedWalletsState() when $default != null:
return $default(_that.status,_that.wallets,_that.restoringIds,_that.restored,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ArchivedWalletsState implements ArchivedWalletsState {
  const _ArchivedWalletsState({this.status = UiStatus.initial,  List<Wallet> wallets = const [],  Set<String> restoringIds = const {}, this.restored, this.actionFailure}): _wallets = wallets,_restoringIds = restoringIds;
  

@override@JsonKey() final  UiStatus status;
 final  List<Wallet> _wallets;
@override@JsonKey() List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

 final  Set<String> _restoringIds;
@override@JsonKey() Set<String> get restoringIds {
  if (_restoringIds is EqualUnmodifiableSetView) return _restoringIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_restoringIds);
}

@override final  Wallet? restored;
@override final  WalletFailure? actionFailure;

/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchivedWalletsStateCopyWith<_ArchivedWalletsState> get copyWith => __$ArchivedWalletsStateCopyWithImpl<_ArchivedWalletsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchivedWalletsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&const DeepCollectionEquality().equals(other.restoringIds, _restoringIds)&&(identical(other.restored, restored) || other.restored == restored)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_wallets),const DeepCollectionEquality().hash(_restoringIds),restored,actionFailure);
}

@override
String toString() {
    return 'ArchivedWalletsState(status: $status, wallets: $wallets, restoringIds: $restoringIds, restored: $restored, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$ArchivedWalletsStateCopyWith<$Res> implements $ArchivedWalletsStateCopyWith<$Res> {
  factory _$ArchivedWalletsStateCopyWith(_ArchivedWalletsState value, $Res Function(_ArchivedWalletsState) _then) = __$ArchivedWalletsStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, List<Wallet> wallets, Set<String> restoringIds, Wallet? restored, WalletFailure? actionFailure
});


@override $WalletCopyWith<$Res>? get restored;

}
/// @nodoc
class __$ArchivedWalletsStateCopyWithImpl<$Res>
    implements _$ArchivedWalletsStateCopyWith<$Res> {
  __$ArchivedWalletsStateCopyWithImpl(this._self, this._then);

  final _ArchivedWalletsState _self;
  final $Res Function(_ArchivedWalletsState) _then;

/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? wallets = null,Object? restoringIds = null,Object? restored = freezed,Object? actionFailure = freezed,}) {
  return _then(_ArchivedWalletsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,restoringIds: null == restoringIds ? _self._restoringIds : restoringIds // ignore: cast_nullable_to_non_nullable
as Set<String>,restored: freezed == restored ? _self.restored : restored // ignore: cast_nullable_to_non_nullable
as Wallet?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}

/// Create a copy of ArchivedWalletsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get restored {
    if (_self.restored == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.restored!, (value) {
    return _then(_self.copyWith(restored: value));
  });
}
}

// dart format on
