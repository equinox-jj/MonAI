// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_providers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManageProvidersEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ManageProvidersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ManageProvidersEvent()';
}


}

/// @nodoc
class $ManageProvidersEventCopyWith<$Res>  {
$ManageProvidersEventCopyWith(ManageProvidersEvent _, $Res Function(ManageProvidersEvent) __);
}


/// Adds pattern-matching-related methods to [ManageProvidersEvent].
extension ManageProvidersEventPatterns on ManageProvidersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _UserChanged value)?  userChanged,TResult Function( _QueryChanged value)?  queryChanged,TResult Function( _Refreshed value)?  refreshed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UserChanged() when userChanged != null:
return userChanged(_that);case _QueryChanged() when queryChanged != null:
return queryChanged(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _UserChanged value)  userChanged,required TResult Function( _QueryChanged value)  queryChanged,required TResult Function( _Refreshed value)  refreshed,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _UserChanged():
return userChanged(_that);case _QueryChanged():
return queryChanged(_that);case _Refreshed():
return refreshed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _UserChanged value)?  userChanged,TResult? Function( _QueryChanged value)?  queryChanged,TResult? Function( _Refreshed value)?  refreshed,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UserChanged() when userChanged != null:
return userChanged(_that);case _QueryChanged() when queryChanged != null:
return queryChanged(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( User? user)?  userChanged,TResult Function( String query)?  queryChanged,TResult Function( bool quiet)?  refreshed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UserChanged() when userChanged != null:
return userChanged(_that.user);case _QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _Refreshed() when refreshed != null:
return refreshed(_that.quiet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( User? user)  userChanged,required TResult Function( String query)  queryChanged,required TResult Function( bool quiet)  refreshed,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _UserChanged():
return userChanged(_that.user);case _QueryChanged():
return queryChanged(_that.query);case _Refreshed():
return refreshed(_that.quiet);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( User? user)?  userChanged,TResult? Function( String query)?  queryChanged,TResult? Function( bool quiet)?  refreshed,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UserChanged() when userChanged != null:
return userChanged(_that.user);case _QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _Refreshed() when refreshed != null:
return refreshed(_that.quiet);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ManageProvidersEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ManageProvidersEvent.started()';
}


}




/// @nodoc


class _UserChanged implements ManageProvidersEvent {
  const _UserChanged(this.user);
  

 final  User? user;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserChangedCopyWith<_UserChanged> get copyWith => __$UserChangedCopyWithImpl<_UserChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserChanged&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString() {
    return 'ManageProvidersEvent.userChanged(user: $user)';
}


}

/// @nodoc
abstract mixin class _$UserChangedCopyWith<$Res> implements $ManageProvidersEventCopyWith<$Res> {
  factory _$UserChangedCopyWith(_UserChanged value, $Res Function(_UserChanged) _then) = __$UserChangedCopyWithImpl;
@useResult
$Res call({
 User? user
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$UserChangedCopyWithImpl<$Res>
    implements _$UserChangedCopyWith<$Res> {
  __$UserChangedCopyWithImpl(this._self, this._then);

  final _UserChanged _self;
  final $Res Function(_UserChanged) _then;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(_UserChanged(
freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _QueryChanged implements ManageProvidersEvent {
  const _QueryChanged(this.query);
  

 final  String query;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueryChangedCopyWith<_QueryChanged> get copyWith => __$QueryChangedCopyWithImpl<_QueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'ManageProvidersEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class _$QueryChangedCopyWith<$Res> implements $ManageProvidersEventCopyWith<$Res> {
  factory _$QueryChangedCopyWith(_QueryChanged value, $Res Function(_QueryChanged) _then) = __$QueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$QueryChangedCopyWithImpl<$Res>
    implements _$QueryChangedCopyWith<$Res> {
  __$QueryChangedCopyWithImpl(this._self, this._then);

  final _QueryChanged _self;
  final $Res Function(_QueryChanged) _then;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_QueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Refreshed implements ManageProvidersEvent {
  const _Refreshed({this.quiet = false});
  

@JsonKey() final  bool quiet;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshedCopyWith<_Refreshed> get copyWith => __$RefreshedCopyWithImpl<_Refreshed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshed&&(identical(other.quiet, quiet) || other.quiet == quiet));
}


@override
int get hashCode {
    return Object.hash(runtimeType,quiet);
}

@override
String toString() {
    return 'ManageProvidersEvent.refreshed(quiet: $quiet)';
}


}

/// @nodoc
abstract mixin class _$RefreshedCopyWith<$Res> implements $ManageProvidersEventCopyWith<$Res> {
  factory _$RefreshedCopyWith(_Refreshed value, $Res Function(_Refreshed) _then) = __$RefreshedCopyWithImpl;
@useResult
$Res call({
 bool quiet
});




}
/// @nodoc
class __$RefreshedCopyWithImpl<$Res>
    implements _$RefreshedCopyWith<$Res> {
  __$RefreshedCopyWithImpl(this._self, this._then);

  final _Refreshed _self;
  final $Res Function(_Refreshed) _then;

/// Create a copy of ManageProvidersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? quiet = null,}) {
  return _then(_Refreshed(
quiet: null == quiet ? _self.quiet : quiet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ManageProvidersState {

 UiStatus get status; List<AdminPaymentProvider> get providers; String get query; bool get isRefreshing; ProviderFailure? get loadFailure; ProviderFailure? get refreshFailure; bool get canCreate; bool get canEdit;
/// Create a copy of ManageProvidersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManageProvidersStateCopyWith<ManageProvidersState> get copyWith => _$ManageProvidersStateCopyWithImpl<ManageProvidersState>(this as ManageProvidersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ManageProvidersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManageProvidersState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.providers, _this.providers)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.refreshFailure, _this.refreshFailure) || other.refreshFailure == _this.refreshFailure)&&(identical(other.canCreate, _this.canCreate) || other.canCreate == _this.canCreate)&&(identical(other.canEdit, _this.canEdit) || other.canEdit == _this.canEdit));
}


@override
int get hashCode {
  final _this = this as ManageProvidersState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.providers),_this.query,_this.isRefreshing,_this.loadFailure,_this.refreshFailure,_this.canCreate,_this.canEdit);
}

@override
String toString() {
  final _this = this as ManageProvidersState;
  return 'ManageProvidersState(status: ${_this.status}, providers: ${_this.providers}, query: ${_this.query}, isRefreshing: ${_this.isRefreshing}, loadFailure: ${_this.loadFailure}, refreshFailure: ${_this.refreshFailure}, canCreate: ${_this.canCreate}, canEdit: ${_this.canEdit})';
}


}

/// @nodoc
abstract mixin class $ManageProvidersStateCopyWith<$Res>  {
  factory $ManageProvidersStateCopyWith(ManageProvidersState value, $Res Function(ManageProvidersState) _then) = _$ManageProvidersStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, List<AdminPaymentProvider> providers, String query, bool isRefreshing, ProviderFailure? loadFailure, ProviderFailure? refreshFailure, bool canCreate, bool canEdit
});




}
/// @nodoc
class _$ManageProvidersStateCopyWithImpl<$Res>
    implements $ManageProvidersStateCopyWith<$Res> {
  _$ManageProvidersStateCopyWithImpl(this._self, this._then);

  final ManageProvidersState _self;
  final $Res Function(ManageProvidersState) _then;

/// Create a copy of ManageProvidersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? providers = null,Object? query = null,Object? isRefreshing = null,Object? loadFailure = freezed,Object? refreshFailure = freezed,Object? canCreate = null,Object? canEdit = null,}) {
  return _then(ManageProvidersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<AdminPaymentProvider>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as ProviderFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as ProviderFailure?,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ManageProvidersState].
extension ManageProvidersStatePatterns on ManageProvidersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManageProvidersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManageProvidersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManageProvidersState value)  $default,){
final _that = this;
switch (_that) {
case _ManageProvidersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManageProvidersState value)?  $default,){
final _that = this;
switch (_that) {
case _ManageProvidersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  List<AdminPaymentProvider> providers,  String query,  bool isRefreshing,  ProviderFailure? loadFailure,  ProviderFailure? refreshFailure,  bool canCreate,  bool canEdit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManageProvidersState() when $default != null:
return $default(_that.status,_that.providers,_that.query,_that.isRefreshing,_that.loadFailure,_that.refreshFailure,_that.canCreate,_that.canEdit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  List<AdminPaymentProvider> providers,  String query,  bool isRefreshing,  ProviderFailure? loadFailure,  ProviderFailure? refreshFailure,  bool canCreate,  bool canEdit)  $default,) {final _that = this;
switch (_that) {
case _ManageProvidersState():
return $default(_that.status,_that.providers,_that.query,_that.isRefreshing,_that.loadFailure,_that.refreshFailure,_that.canCreate,_that.canEdit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  List<AdminPaymentProvider> providers,  String query,  bool isRefreshing,  ProviderFailure? loadFailure,  ProviderFailure? refreshFailure,  bool canCreate,  bool canEdit)?  $default,) {final _that = this;
switch (_that) {
case _ManageProvidersState() when $default != null:
return $default(_that.status,_that.providers,_that.query,_that.isRefreshing,_that.loadFailure,_that.refreshFailure,_that.canCreate,_that.canEdit);case _:
  return null;

}
}

}

/// @nodoc


class _ManageProvidersState implements ManageProvidersState {
  const _ManageProvidersState({this.status = UiStatus.initial,  List<AdminPaymentProvider> providers = const [], this.query = '', this.isRefreshing = false, this.loadFailure, this.refreshFailure, this.canCreate = false, this.canEdit = false}): _providers = providers;
  

@override@JsonKey() final  UiStatus status;
 final  List<AdminPaymentProvider> _providers;
@override@JsonKey() List<AdminPaymentProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isRefreshing;
@override final  ProviderFailure? loadFailure;
@override final  ProviderFailure? refreshFailure;
@override@JsonKey() final  bool canCreate;
@override@JsonKey() final  bool canEdit;

/// Create a copy of ManageProvidersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManageProvidersStateCopyWith<_ManageProvidersState> get copyWith => __$ManageProvidersStateCopyWithImpl<_ManageProvidersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManageProvidersState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.providers, _providers)&&(identical(other.query, query) || other.query == query)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.refreshFailure, refreshFailure) || other.refreshFailure == refreshFailure)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_providers),query,isRefreshing,loadFailure,refreshFailure,canCreate,canEdit);
}

@override
String toString() {
    return 'ManageProvidersState(status: $status, providers: $providers, query: $query, isRefreshing: $isRefreshing, loadFailure: $loadFailure, refreshFailure: $refreshFailure, canCreate: $canCreate, canEdit: $canEdit)';
}


}

/// @nodoc
abstract mixin class _$ManageProvidersStateCopyWith<$Res> implements $ManageProvidersStateCopyWith<$Res> {
  factory _$ManageProvidersStateCopyWith(_ManageProvidersState value, $Res Function(_ManageProvidersState) _then) = __$ManageProvidersStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, List<AdminPaymentProvider> providers, String query, bool isRefreshing, ProviderFailure? loadFailure, ProviderFailure? refreshFailure, bool canCreate, bool canEdit
});




}
/// @nodoc
class __$ManageProvidersStateCopyWithImpl<$Res>
    implements _$ManageProvidersStateCopyWith<$Res> {
  __$ManageProvidersStateCopyWithImpl(this._self, this._then);

  final _ManageProvidersState _self;
  final $Res Function(_ManageProvidersState) _then;

/// Create a copy of ManageProvidersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? providers = null,Object? query = null,Object? isRefreshing = null,Object? loadFailure = freezed,Object? refreshFailure = freezed,Object? canCreate = null,Object? canEdit = null,}) {
  return _then(_ManageProvidersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<AdminPaymentProvider>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as ProviderFailure?,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as ProviderFailure?,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
