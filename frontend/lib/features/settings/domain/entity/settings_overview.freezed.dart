// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsOverview {

/// Null until the user has been cached since sign-in.
 SettingsProfile? get profile;/// This month's limit in rupiah; null when none is set.
 int? get budgetLimit;/// Every category, hidden ones included.
 int get categoryCount;/// Wallets that aren't archived.
 int get walletCount;/// The user may add, edit or remove payment providers.
 bool get canManageProviders;
/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsOverviewCopyWith<SettingsOverview> get copyWith => _$SettingsOverviewCopyWithImpl<SettingsOverview>(this as SettingsOverview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsOverview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsOverview&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.budgetLimit, _this.budgetLimit) || other.budgetLimit == _this.budgetLimit)&&(identical(other.categoryCount, _this.categoryCount) || other.categoryCount == _this.categoryCount)&&(identical(other.walletCount, _this.walletCount) || other.walletCount == _this.walletCount)&&(identical(other.canManageProviders, _this.canManageProviders) || other.canManageProviders == _this.canManageProviders));
}


@override
int get hashCode {
  final _this = this as SettingsOverview;
  return Object.hash(runtimeType,_this.profile,_this.budgetLimit,_this.categoryCount,_this.walletCount,_this.canManageProviders);
}

@override
String toString() {
  final _this = this as SettingsOverview;
  return 'SettingsOverview(profile: ${_this.profile}, budgetLimit: ${_this.budgetLimit}, categoryCount: ${_this.categoryCount}, walletCount: ${_this.walletCount}, canManageProviders: ${_this.canManageProviders})';
}


}

/// @nodoc
abstract mixin class $SettingsOverviewCopyWith<$Res>  {
  factory $SettingsOverviewCopyWith(SettingsOverview value, $Res Function(SettingsOverview) _then) = _$SettingsOverviewCopyWithImpl;
@useResult
$Res call({
 SettingsProfile? profile, int? budgetLimit, int categoryCount, int walletCount, bool canManageProviders
});


$SettingsProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$SettingsOverviewCopyWithImpl<$Res>
    implements $SettingsOverviewCopyWith<$Res> {
  _$SettingsOverviewCopyWithImpl(this._self, this._then);

  final SettingsOverview _self;
  final $Res Function(SettingsOverview) _then;

/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? budgetLimit = freezed,Object? categoryCount = null,Object? walletCount = null,Object? canManageProviders = null,}) {
  return _then(SettingsOverview(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SettingsProfile?,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as int?,categoryCount: null == categoryCount ? _self.categoryCount : categoryCount // ignore: cast_nullable_to_non_nullable
as int,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,canManageProviders: null == canManageProviders ? _self.canManageProviders : canManageProviders // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $SettingsProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsOverview].
extension SettingsOverviewPatterns on SettingsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsOverview value)  $default,){
final _that = this;
switch (_that) {
case _SettingsOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SettingsProfile? profile,  int? budgetLimit,  int categoryCount,  int walletCount,  bool canManageProviders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsOverview() when $default != null:
return $default(_that.profile,_that.budgetLimit,_that.categoryCount,_that.walletCount,_that.canManageProviders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SettingsProfile? profile,  int? budgetLimit,  int categoryCount,  int walletCount,  bool canManageProviders)  $default,) {final _that = this;
switch (_that) {
case _SettingsOverview():
return $default(_that.profile,_that.budgetLimit,_that.categoryCount,_that.walletCount,_that.canManageProviders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SettingsProfile? profile,  int? budgetLimit,  int categoryCount,  int walletCount,  bool canManageProviders)?  $default,) {final _that = this;
switch (_that) {
case _SettingsOverview() when $default != null:
return $default(_that.profile,_that.budgetLimit,_that.categoryCount,_that.walletCount,_that.canManageProviders);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsOverview implements SettingsOverview {
  const _SettingsOverview({this.profile, this.budgetLimit, this.categoryCount = 0, this.walletCount = 0, this.canManageProviders = false});
  

/// Null until the user has been cached since sign-in.
@override final  SettingsProfile? profile;
/// This month's limit in rupiah; null when none is set.
@override final  int? budgetLimit;
/// Every category, hidden ones included.
@override@JsonKey() final  int categoryCount;
/// Wallets that aren't archived.
@override@JsonKey() final  int walletCount;
/// The user may add, edit or remove payment providers.
@override@JsonKey() final  bool canManageProviders;

/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsOverviewCopyWith<_SettingsOverview> get copyWith => __$SettingsOverviewCopyWithImpl<_SettingsOverview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsOverview&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.budgetLimit, budgetLimit) || other.budgetLimit == budgetLimit)&&(identical(other.categoryCount, categoryCount) || other.categoryCount == categoryCount)&&(identical(other.walletCount, walletCount) || other.walletCount == walletCount)&&(identical(other.canManageProviders, canManageProviders) || other.canManageProviders == canManageProviders));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile,budgetLimit,categoryCount,walletCount,canManageProviders);
}

@override
String toString() {
    return 'SettingsOverview(profile: $profile, budgetLimit: $budgetLimit, categoryCount: $categoryCount, walletCount: $walletCount, canManageProviders: $canManageProviders)';
}


}

/// @nodoc
abstract mixin class _$SettingsOverviewCopyWith<$Res> implements $SettingsOverviewCopyWith<$Res> {
  factory _$SettingsOverviewCopyWith(_SettingsOverview value, $Res Function(_SettingsOverview) _then) = __$SettingsOverviewCopyWithImpl;
@override @useResult
$Res call({
 SettingsProfile? profile, int? budgetLimit, int categoryCount, int walletCount, bool canManageProviders
});


@override $SettingsProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$SettingsOverviewCopyWithImpl<$Res>
    implements _$SettingsOverviewCopyWith<$Res> {
  __$SettingsOverviewCopyWithImpl(this._self, this._then);

  final _SettingsOverview _self;
  final $Res Function(_SettingsOverview) _then;

/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? budgetLimit = freezed,Object? categoryCount = null,Object? walletCount = null,Object? canManageProviders = null,}) {
  return _then(_SettingsOverview(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as SettingsProfile?,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as int?,categoryCount: null == categoryCount ? _self.categoryCount : categoryCount // ignore: cast_nullable_to_non_nullable
as int,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,canManageProviders: null == canManageProviders ? _self.canManageProviders : canManageProviders // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingsOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $SettingsProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
mixin _$SettingsProfile {

 String get name; String get email;/// `JP` for "Joshua Pardede".
 String get initials;/// Presigned and short-lived.
 String? get avatarUrl;/// The role's name for anyone above a regular user, e.g. "Admin".
 String? get roleBadge;
/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsProfileCopyWith<SettingsProfile> get copyWith => _$SettingsProfileCopyWithImpl<SettingsProfile>(this as SettingsProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsProfile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.initials, _this.initials) || other.initials == _this.initials)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.roleBadge, _this.roleBadge) || other.roleBadge == _this.roleBadge));
}


@override
int get hashCode {
  final _this = this as SettingsProfile;
  return Object.hash(runtimeType,_this.name,_this.email,_this.initials,_this.avatarUrl,_this.roleBadge);
}

@override
String toString() {
  final _this = this as SettingsProfile;
  return 'SettingsProfile(name: ${_this.name}, email: ${_this.email}, initials: ${_this.initials}, avatarUrl: ${_this.avatarUrl}, roleBadge: ${_this.roleBadge})';
}


}

/// @nodoc
abstract mixin class $SettingsProfileCopyWith<$Res>  {
  factory $SettingsProfileCopyWith(SettingsProfile value, $Res Function(SettingsProfile) _then) = _$SettingsProfileCopyWithImpl;
@useResult
$Res call({
 String name, String email, String initials, String? avatarUrl, String? roleBadge
});




}
/// @nodoc
class _$SettingsProfileCopyWithImpl<$Res>
    implements $SettingsProfileCopyWith<$Res> {
  _$SettingsProfileCopyWithImpl(this._self, this._then);

  final SettingsProfile _self;
  final $Res Function(SettingsProfile) _then;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? initials = null,Object? avatarUrl = freezed,Object? roleBadge = freezed,}) {
  return _then(SettingsProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,roleBadge: freezed == roleBadge ? _self.roleBadge : roleBadge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsProfile].
extension SettingsProfilePatterns on SettingsProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsProfile value)  $default,){
final _that = this;
switch (_that) {
case _SettingsProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String initials,  String? avatarUrl,  String? roleBadge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
return $default(_that.name,_that.email,_that.initials,_that.avatarUrl,_that.roleBadge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String initials,  String? avatarUrl,  String? roleBadge)  $default,) {final _that = this;
switch (_that) {
case _SettingsProfile():
return $default(_that.name,_that.email,_that.initials,_that.avatarUrl,_that.roleBadge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String initials,  String? avatarUrl,  String? roleBadge)?  $default,) {final _that = this;
switch (_that) {
case _SettingsProfile() when $default != null:
return $default(_that.name,_that.email,_that.initials,_that.avatarUrl,_that.roleBadge);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsProfile implements SettingsProfile {
  const _SettingsProfile({required this.name, required this.email, required this.initials, this.avatarUrl, this.roleBadge});
  

@override final  String name;
@override final  String email;
/// `JP` for "Joshua Pardede".
@override final  String initials;
/// Presigned and short-lived.
@override final  String? avatarUrl;
/// The role's name for anyone above a regular user, e.g. "Admin".
@override final  String? roleBadge;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsProfileCopyWith<_SettingsProfile> get copyWith => __$SettingsProfileCopyWithImpl<_SettingsProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.roleBadge, roleBadge) || other.roleBadge == roleBadge));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,initials,avatarUrl,roleBadge);
}

@override
String toString() {
    return 'SettingsProfile(name: $name, email: $email, initials: $initials, avatarUrl: $avatarUrl, roleBadge: $roleBadge)';
}


}

/// @nodoc
abstract mixin class _$SettingsProfileCopyWith<$Res> implements $SettingsProfileCopyWith<$Res> {
  factory _$SettingsProfileCopyWith(_SettingsProfile value, $Res Function(_SettingsProfile) _then) = __$SettingsProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String initials, String? avatarUrl, String? roleBadge
});




}
/// @nodoc
class __$SettingsProfileCopyWithImpl<$Res>
    implements _$SettingsProfileCopyWith<$Res> {
  __$SettingsProfileCopyWithImpl(this._self, this._then);

  final _SettingsProfile _self;
  final $Res Function(_SettingsProfile) _then;

/// Create a copy of SettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? initials = null,Object? avatarUrl = freezed,Object? roleBadge = freezed,}) {
  return _then(_SettingsProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,roleBadge: freezed == roleBadge ? _self.roleBadge : roleBadge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
