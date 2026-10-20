// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _SignOutConfirmed value)?  signOutConfirmed,TResult Function( _OverviewChanged value)?  overviewChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _SignOutConfirmed() when signOutConfirmed != null:
return signOutConfirmed(_that);case _OverviewChanged() when overviewChanged != null:
return overviewChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _SignOutConfirmed value)  signOutConfirmed,required TResult Function( _OverviewChanged value)  overviewChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _SignOutConfirmed():
return signOutConfirmed(_that);case _OverviewChanged():
return overviewChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _SignOutConfirmed value)?  signOutConfirmed,TResult? Function( _OverviewChanged value)?  overviewChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _SignOutConfirmed() when signOutConfirmed != null:
return signOutConfirmed(_that);case _OverviewChanged() when overviewChanged != null:
return overviewChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( bool allDevices)?  signOutConfirmed,TResult Function( SettingsOverview overview)?  overviewChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _SignOutConfirmed() when signOutConfirmed != null:
return signOutConfirmed(_that.allDevices);case _OverviewChanged() when overviewChanged != null:
return overviewChanged(_that.overview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( bool allDevices)  signOutConfirmed,required TResult Function( SettingsOverview overview)  overviewChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _SignOutConfirmed():
return signOutConfirmed(_that.allDevices);case _OverviewChanged():
return overviewChanged(_that.overview);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( bool allDevices)?  signOutConfirmed,TResult? Function( SettingsOverview overview)?  overviewChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _SignOutConfirmed() when signOutConfirmed != null:
return signOutConfirmed(_that.allDevices);case _OverviewChanged() when overviewChanged != null:
return overviewChanged(_that.overview);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements SettingsEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsEvent.started()';
}


}




/// @nodoc


class _SignOutConfirmed implements SettingsEvent {
  const _SignOutConfirmed({required this.allDevices});
  

 final  bool allDevices;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignOutConfirmedCopyWith<_SignOutConfirmed> get copyWith => __$SignOutConfirmedCopyWithImpl<_SignOutConfirmed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignOutConfirmed&&(identical(other.allDevices, allDevices) || other.allDevices == allDevices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,allDevices);
}

@override
String toString() {
    return 'SettingsEvent.signOutConfirmed(allDevices: $allDevices)';
}


}

/// @nodoc
abstract mixin class _$SignOutConfirmedCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$SignOutConfirmedCopyWith(_SignOutConfirmed value, $Res Function(_SignOutConfirmed) _then) = __$SignOutConfirmedCopyWithImpl;
@useResult
$Res call({
 bool allDevices
});




}
/// @nodoc
class __$SignOutConfirmedCopyWithImpl<$Res>
    implements _$SignOutConfirmedCopyWith<$Res> {
  __$SignOutConfirmedCopyWithImpl(this._self, this._then);

  final _SignOutConfirmed _self;
  final $Res Function(_SignOutConfirmed) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allDevices = null,}) {
  return _then(_SignOutConfirmed(
allDevices: null == allDevices ? _self.allDevices : allDevices // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _OverviewChanged implements SettingsEvent {
  const _OverviewChanged(this.overview);
  

 final  SettingsOverview overview;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewChangedCopyWith<_OverviewChanged> get copyWith => __$OverviewChangedCopyWithImpl<_OverviewChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverviewChanged&&(identical(other.overview, overview) || other.overview == overview));
}


@override
int get hashCode {
    return Object.hash(runtimeType,overview);
}

@override
String toString() {
    return 'SettingsEvent.overviewChanged(overview: $overview)';
}


}

/// @nodoc
abstract mixin class _$OverviewChangedCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$OverviewChangedCopyWith(_OverviewChanged value, $Res Function(_OverviewChanged) _then) = __$OverviewChangedCopyWithImpl;
@useResult
$Res call({
 SettingsOverview overview
});


$SettingsOverviewCopyWith<$Res> get overview;

}
/// @nodoc
class __$OverviewChangedCopyWithImpl<$Res>
    implements _$OverviewChangedCopyWith<$Res> {
  __$OverviewChangedCopyWithImpl(this._self, this._then);

  final _OverviewChanged _self;
  final $Res Function(_OverviewChanged) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? overview = null,}) {
  return _then(_OverviewChanged(
null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as SettingsOverview,
  ));
}

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsOverviewCopyWith<$Res> get overview {
  
  return $SettingsOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}
}

/// @nodoc
mixin _$SettingsState {

/// What the cache holds; empty values until its first read.
 SettingsOverview get overview;/// The installed version; empty until read, or when it can't be.
 String get appVersion;/// A sign-out is running: its row shows progress and taps are ignored.
 bool get isSigningOut;/// Why the last sign-out failed; shown once as a snackbar.
 SettingsSignOutFailure? get signOutFailure;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.overview, _this.overview) || other.overview == _this.overview)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.isSigningOut, _this.isSigningOut) || other.isSigningOut == _this.isSigningOut)&&(identical(other.signOutFailure, _this.signOutFailure) || other.signOutFailure == _this.signOutFailure));
}


@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.overview,_this.appVersion,_this.isSigningOut,_this.signOutFailure);
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(overview: ${_this.overview}, appVersion: ${_this.appVersion}, isSigningOut: ${_this.isSigningOut}, signOutFailure: ${_this.signOutFailure})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 SettingsOverview overview, String appVersion, bool isSigningOut, SettingsSignOutFailure? signOutFailure
});


$SettingsOverviewCopyWith<$Res> get overview;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? overview = null,Object? appVersion = null,Object? isSigningOut = null,Object? signOutFailure = freezed,}) {
  return _then(SettingsState(
overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as SettingsOverview,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,isSigningOut: null == isSigningOut ? _self.isSigningOut : isSigningOut // ignore: cast_nullable_to_non_nullable
as bool,signOutFailure: freezed == signOutFailure ? _self.signOutFailure : signOutFailure // ignore: cast_nullable_to_non_nullable
as SettingsSignOutFailure?,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsOverviewCopyWith<$Res> get overview {
  
  return $SettingsOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SettingsOverview overview,  String appVersion,  bool isSigningOut,  SettingsSignOutFailure? signOutFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.overview,_that.appVersion,_that.isSigningOut,_that.signOutFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SettingsOverview overview,  String appVersion,  bool isSigningOut,  SettingsSignOutFailure? signOutFailure)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.overview,_that.appVersion,_that.isSigningOut,_that.signOutFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SettingsOverview overview,  String appVersion,  bool isSigningOut,  SettingsSignOutFailure? signOutFailure)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.overview,_that.appVersion,_that.isSigningOut,_that.signOutFailure);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.overview = const SettingsOverview(), this.appVersion = '', this.isSigningOut = false, this.signOutFailure});
  

/// What the cache holds; empty values until its first read.
@override@JsonKey() final  SettingsOverview overview;
/// The installed version; empty until read, or when it can't be.
@override@JsonKey() final  String appVersion;
/// A sign-out is running: its row shows progress and taps are ignored.
@override@JsonKey() final  bool isSigningOut;
/// Why the last sign-out failed; shown once as a snackbar.
@override final  SettingsSignOutFailure? signOutFailure;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.isSigningOut, isSigningOut) || other.isSigningOut == isSigningOut)&&(identical(other.signOutFailure, signOutFailure) || other.signOutFailure == signOutFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,overview,appVersion,isSigningOut,signOutFailure);
}

@override
String toString() {
    return 'SettingsState(overview: $overview, appVersion: $appVersion, isSigningOut: $isSigningOut, signOutFailure: $signOutFailure)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 SettingsOverview overview, String appVersion, bool isSigningOut, SettingsSignOutFailure? signOutFailure
});


@override $SettingsOverviewCopyWith<$Res> get overview;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? overview = null,Object? appVersion = null,Object? isSigningOut = null,Object? signOutFailure = freezed,}) {
  return _then(_SettingsState(
overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as SettingsOverview,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,isSigningOut: null == isSigningOut ? _self.isSigningOut : isSigningOut // ignore: cast_nullable_to_non_nullable
as bool,signOutFailure: freezed == signOutFailure ? _self.signOutFailure : signOutFailure // ignore: cast_nullable_to_non_nullable
as SettingsSignOutFailure?,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsOverviewCopyWith<$Res> get overview {
  
  return $SettingsOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}
}

// dart format on
