// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallets_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletsEvent()';
}


}

/// @nodoc
class $WalletsEventCopyWith<$Res>  {
$WalletsEventCopyWith(WalletsEvent _, $Res Function(WalletsEvent) __);
}


/// Adds pattern-matching-related methods to [WalletsEvent].
extension WalletsEventPatterns on WalletsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Refreshed value)?  refreshed,TResult Function( _Selected value)?  selected,TResult Function( _WalletsChanged value)?  walletsChanged,TResult Function( _AllWalletsChanged value)?  allWalletsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _Selected() when selected != null:
return selected(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Refreshed value)  refreshed,required TResult Function( _Selected value)  selected,required TResult Function( _WalletsChanged value)  walletsChanged,required TResult Function( _AllWalletsChanged value)  allWalletsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Refreshed():
return refreshed(_that);case _Selected():
return selected(_that);case _WalletsChanged():
return walletsChanged(_that);case _AllWalletsChanged():
return allWalletsChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Refreshed value)?  refreshed,TResult? Function( _Selected value)?  selected,TResult? Function( _WalletsChanged value)?  walletsChanged,TResult? Function( _AllWalletsChanged value)?  allWalletsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _Selected() when selected != null:
return selected(_that);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshed,TResult Function( String id)?  selected,TResult Function( List<Wallet> wallets)?  walletsChanged,TResult Function( List<Wallet> wallets)?  allWalletsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _Selected() when selected != null:
return selected(_that.id);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshed,required TResult Function( String id)  selected,required TResult Function( List<Wallet> wallets)  walletsChanged,required TResult Function( List<Wallet> wallets)  allWalletsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Refreshed():
return refreshed();case _Selected():
return selected(_that.id);case _WalletsChanged():
return walletsChanged(_that.wallets);case _AllWalletsChanged():
return allWalletsChanged(_that.wallets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshed,TResult? Function( String id)?  selected,TResult? Function( List<Wallet> wallets)?  walletsChanged,TResult? Function( List<Wallet> wallets)?  allWalletsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _Selected() when selected != null:
return selected(_that.id);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _AllWalletsChanged() when allWalletsChanged != null:
return allWalletsChanged(_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements WalletsEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletsEvent.started()';
}


}




/// @nodoc


class _Refreshed implements WalletsEvent {
  const _Refreshed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletsEvent.refreshed()';
}


}




/// @nodoc


class _Selected implements WalletsEvent {
  const _Selected(this.id);
  

 final  String id;

/// Create a copy of WalletsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedCopyWith<_Selected> get copyWith => __$SelectedCopyWithImpl<_Selected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Selected&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'WalletsEvent.selected(id: $id)';
}


}

/// @nodoc
abstract mixin class _$SelectedCopyWith<$Res> implements $WalletsEventCopyWith<$Res> {
  factory _$SelectedCopyWith(_Selected value, $Res Function(_Selected) _then) = __$SelectedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$SelectedCopyWithImpl<$Res>
    implements _$SelectedCopyWith<$Res> {
  __$SelectedCopyWithImpl(this._self, this._then);

  final _Selected _self;
  final $Res Function(_Selected) _then;

/// Create a copy of WalletsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_Selected(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WalletsChanged implements WalletsEvent {
  const _WalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of WalletsEvent
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
    return 'WalletsEvent.walletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletsChangedCopyWith<$Res> implements $WalletsEventCopyWith<$Res> {
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

/// Create a copy of WalletsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_WalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc


class _AllWalletsChanged implements WalletsEvent {
  const _AllWalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of WalletsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllWalletsChangedCopyWith<_AllWalletsChanged> get copyWith => __$AllWalletsChangedCopyWithImpl<_AllWalletsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllWalletsChanged&&const DeepCollectionEquality().equals(other.wallets, _wallets));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_wallets));
}

@override
String toString() {
    return 'WalletsEvent.allWalletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$AllWalletsChangedCopyWith<$Res> implements $WalletsEventCopyWith<$Res> {
  factory _$AllWalletsChangedCopyWith(_AllWalletsChanged value, $Res Function(_AllWalletsChanged) _then) = __$AllWalletsChangedCopyWithImpl;
@useResult
$Res call({
 List<Wallet> wallets
});




}
/// @nodoc
class __$AllWalletsChangedCopyWithImpl<$Res>
    implements _$AllWalletsChangedCopyWith<$Res> {
  __$AllWalletsChangedCopyWithImpl(this._self, this._then);

  final _AllWalletsChanged _self;
  final $Res Function(_AllWalletsChanged) _then;

/// Create a copy of WalletsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_AllWalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc
mixin _$WalletsState {

/// [UiStatus.loading] while nothing is cached yet (the skeleton),
/// [UiStatus.failure] when that first load failed, [UiStatus.empty]
/// when the user has no wallet, otherwise [UiStatus.success].
 UiStatus get status;/// The wallets that aren't archived, default first, then by name.
 List<Wallet> get wallets; int get archivedCount;/// The server answered once, so no wallets means there are none.
 bool get loaded; bool get isRefreshing;/// The wallet beside the list on a wide screen.
 String? get selectedId;/// Why the first load failed, with nothing cached.
 WalletFailure? get loadFailure;/// Why a refresh failed; shown once as a snackbar.
 WalletFailure? get actionFailure;
/// Create a copy of WalletsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletsStateCopyWith<WalletsState> get copyWith => _$WalletsStateCopyWithImpl<WalletsState>(this as WalletsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WalletsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.wallets, _this.wallets)&&(identical(other.archivedCount, _this.archivedCount) || other.archivedCount == _this.archivedCount)&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.selectedId, _this.selectedId) || other.selectedId == _this.selectedId)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as WalletsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.wallets),_this.archivedCount,_this.loaded,_this.isRefreshing,_this.selectedId,_this.loadFailure,_this.actionFailure);
}

@override
String toString() {
  final _this = this as WalletsState;
  return 'WalletsState(status: ${_this.status}, wallets: ${_this.wallets}, archivedCount: ${_this.archivedCount}, loaded: ${_this.loaded}, isRefreshing: ${_this.isRefreshing}, selectedId: ${_this.selectedId}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $WalletsStateCopyWith<$Res>  {
  factory $WalletsStateCopyWith(WalletsState value, $Res Function(WalletsState) _then) = _$WalletsStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, List<Wallet> wallets, int archivedCount, bool loaded, bool isRefreshing, String? selectedId, WalletFailure? loadFailure, WalletFailure? actionFailure
});




}
/// @nodoc
class _$WalletsStateCopyWithImpl<$Res>
    implements $WalletsStateCopyWith<$Res> {
  _$WalletsStateCopyWithImpl(this._self, this._then);

  final WalletsState _self;
  final $Res Function(WalletsState) _then;

/// Create a copy of WalletsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? wallets = null,Object? archivedCount = null,Object? loaded = null,Object? isRefreshing = null,Object? selectedId = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(WalletsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,archivedCount: null == archivedCount ? _self.archivedCount : archivedCount // ignore: cast_nullable_to_non_nullable
as int,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletsState].
extension WalletsStatePatterns on WalletsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletsState value)  $default,){
final _that = this;
switch (_that) {
case _WalletsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletsState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  List<Wallet> wallets,  int archivedCount,  bool loaded,  bool isRefreshing,  String? selectedId,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletsState() when $default != null:
return $default(_that.status,_that.wallets,_that.archivedCount,_that.loaded,_that.isRefreshing,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  List<Wallet> wallets,  int archivedCount,  bool loaded,  bool isRefreshing,  String? selectedId,  WalletFailure? loadFailure,  WalletFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _WalletsState():
return $default(_that.status,_that.wallets,_that.archivedCount,_that.loaded,_that.isRefreshing,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  List<Wallet> wallets,  int archivedCount,  bool loaded,  bool isRefreshing,  String? selectedId,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _WalletsState() when $default != null:
return $default(_that.status,_that.wallets,_that.archivedCount,_that.loaded,_that.isRefreshing,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _WalletsState implements WalletsState {
  const _WalletsState({this.status = UiStatus.initial,  List<Wallet> wallets = const [], this.archivedCount = 0, this.loaded = false, this.isRefreshing = false, this.selectedId, this.loadFailure, this.actionFailure}): _wallets = wallets;
  

/// [UiStatus.loading] while nothing is cached yet (the skeleton),
/// [UiStatus.failure] when that first load failed, [UiStatus.empty]
/// when the user has no wallet, otherwise [UiStatus.success].
@override@JsonKey() final  UiStatus status;
/// The wallets that aren't archived, default first, then by name.
 final  List<Wallet> _wallets;
/// The wallets that aren't archived, default first, then by name.
@override@JsonKey() List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

@override@JsonKey() final  int archivedCount;
/// The server answered once, so no wallets means there are none.
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool isRefreshing;
/// The wallet beside the list on a wide screen.
@override final  String? selectedId;
/// Why the first load failed, with nothing cached.
@override final  WalletFailure? loadFailure;
/// Why a refresh failed; shown once as a snackbar.
@override final  WalletFailure? actionFailure;

/// Create a copy of WalletsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletsStateCopyWith<_WalletsState> get copyWith => __$WalletsStateCopyWithImpl<_WalletsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.wallets, _wallets)&&(identical(other.archivedCount, archivedCount) || other.archivedCount == archivedCount)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_wallets),archivedCount,loaded,isRefreshing,selectedId,loadFailure,actionFailure);
}

@override
String toString() {
    return 'WalletsState(status: $status, wallets: $wallets, archivedCount: $archivedCount, loaded: $loaded, isRefreshing: $isRefreshing, selectedId: $selectedId, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$WalletsStateCopyWith<$Res> implements $WalletsStateCopyWith<$Res> {
  factory _$WalletsStateCopyWith(_WalletsState value, $Res Function(_WalletsState) _then) = __$WalletsStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, List<Wallet> wallets, int archivedCount, bool loaded, bool isRefreshing, String? selectedId, WalletFailure? loadFailure, WalletFailure? actionFailure
});




}
/// @nodoc
class __$WalletsStateCopyWithImpl<$Res>
    implements _$WalletsStateCopyWith<$Res> {
  __$WalletsStateCopyWithImpl(this._self, this._then);

  final _WalletsState _self;
  final $Res Function(_WalletsState) _then;

/// Create a copy of WalletsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? wallets = null,Object? archivedCount = null,Object? loaded = null,Object? isRefreshing = null,Object? selectedId = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_WalletsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,archivedCount: null == archivedCount ? _self.archivedCount : archivedCount // ignore: cast_nullable_to_non_nullable
as int,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}


}

// dart format on
