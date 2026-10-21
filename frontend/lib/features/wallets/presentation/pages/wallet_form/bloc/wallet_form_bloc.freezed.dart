// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletFormEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletFormEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormEvent()';
}


}

/// @nodoc
class $WalletFormEventCopyWith<$Res>  {
$WalletFormEventCopyWith(WalletFormEvent _, $Res Function(WalletFormEvent) __);
}


/// Adds pattern-matching-related methods to [WalletFormEvent].
extension WalletFormEventPatterns on WalletFormEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Retried value)?  retried,TResult Function( _ProviderPicked value)?  providerPicked,TResult Function( _TypePicked value)?  typePicked,TResult Function( _ColorPicked value)?  colorPicked,TResult Function( _DefaultToggled value)?  defaultToggled,TResult Function( _NameEdited value)?  nameEdited,TResult Function( _BalanceEdited value)?  balanceEdited,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _ArchiveRequested value)?  archiveRequested,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _ProvidersChanged value)?  providersChanged,TResult Function( _WalletsChanged value)?  walletsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _ProviderPicked() when providerPicked != null:
return providerPicked(_that);case _TypePicked() when typePicked != null:
return typePicked(_that);case _ColorPicked() when colorPicked != null:
return colorPicked(_that);case _DefaultToggled() when defaultToggled != null:
return defaultToggled(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _BalanceEdited() when balanceEdited != null:
return balanceEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _ProvidersChanged() when providersChanged != null:
return providersChanged(_that);case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Retried value)  retried,required TResult Function( _ProviderPicked value)  providerPicked,required TResult Function( _TypePicked value)  typePicked,required TResult Function( _ColorPicked value)  colorPicked,required TResult Function( _DefaultToggled value)  defaultToggled,required TResult Function( _NameEdited value)  nameEdited,required TResult Function( _BalanceEdited value)  balanceEdited,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _ArchiveRequested value)  archiveRequested,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _ProvidersChanged value)  providersChanged,required TResult Function( _WalletsChanged value)  walletsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Retried():
return retried(_that);case _ProviderPicked():
return providerPicked(_that);case _TypePicked():
return typePicked(_that);case _ColorPicked():
return colorPicked(_that);case _DefaultToggled():
return defaultToggled(_that);case _NameEdited():
return nameEdited(_that);case _BalanceEdited():
return balanceEdited(_that);case _SaveRequested():
return saveRequested(_that);case _ArchiveRequested():
return archiveRequested(_that);case _DeleteRequested():
return deleteRequested(_that);case _ProvidersChanged():
return providersChanged(_that);case _WalletsChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Retried value)?  retried,TResult? Function( _ProviderPicked value)?  providerPicked,TResult? Function( _TypePicked value)?  typePicked,TResult? Function( _ColorPicked value)?  colorPicked,TResult? Function( _DefaultToggled value)?  defaultToggled,TResult? Function( _NameEdited value)?  nameEdited,TResult? Function( _BalanceEdited value)?  balanceEdited,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _ArchiveRequested value)?  archiveRequested,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _ProvidersChanged value)?  providersChanged,TResult? Function( _WalletsChanged value)?  walletsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Retried() when retried != null:
return retried(_that);case _ProviderPicked() when providerPicked != null:
return providerPicked(_that);case _TypePicked() when typePicked != null:
return typePicked(_that);case _ColorPicked() when colorPicked != null:
return colorPicked(_that);case _DefaultToggled() when defaultToggled != null:
return defaultToggled(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _BalanceEdited() when balanceEdited != null:
return balanceEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _ProvidersChanged() when providersChanged != null:
return providersChanged(_that);case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  retried,TResult Function( String? slug)?  providerPicked,TResult Function( WalletType type)?  typePicked,TResult Function( String hex)?  colorPicked,TResult Function( bool isDefault)?  defaultToggled,TResult Function( String name)?  nameEdited,TResult Function( String balance)?  balanceEdited,TResult Function( String name,  String balance)?  saveRequested,TResult Function()?  archiveRequested,TResult Function()?  deleteRequested,TResult Function( List<PaymentProvider> providers)?  providersChanged,TResult Function( List<Wallet> wallets)?  walletsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _ProviderPicked() when providerPicked != null:
return providerPicked(_that.slug);case _TypePicked() when typePicked != null:
return typePicked(_that.type);case _ColorPicked() when colorPicked != null:
return colorPicked(_that.hex);case _DefaultToggled() when defaultToggled != null:
return defaultToggled(_that.isDefault);case _NameEdited() when nameEdited != null:
return nameEdited(_that.name);case _BalanceEdited() when balanceEdited != null:
return balanceEdited(_that.balance);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name,_that.balance);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _ProvidersChanged() when providersChanged != null:
return providersChanged(_that.providers);case _WalletsChanged() when walletsChanged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  retried,required TResult Function( String? slug)  providerPicked,required TResult Function( WalletType type)  typePicked,required TResult Function( String hex)  colorPicked,required TResult Function( bool isDefault)  defaultToggled,required TResult Function( String name)  nameEdited,required TResult Function( String balance)  balanceEdited,required TResult Function( String name,  String balance)  saveRequested,required TResult Function()  archiveRequested,required TResult Function()  deleteRequested,required TResult Function( List<PaymentProvider> providers)  providersChanged,required TResult Function( List<Wallet> wallets)  walletsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Retried():
return retried();case _ProviderPicked():
return providerPicked(_that.slug);case _TypePicked():
return typePicked(_that.type);case _ColorPicked():
return colorPicked(_that.hex);case _DefaultToggled():
return defaultToggled(_that.isDefault);case _NameEdited():
return nameEdited(_that.name);case _BalanceEdited():
return balanceEdited(_that.balance);case _SaveRequested():
return saveRequested(_that.name,_that.balance);case _ArchiveRequested():
return archiveRequested();case _DeleteRequested():
return deleteRequested();case _ProvidersChanged():
return providersChanged(_that.providers);case _WalletsChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  retried,TResult? Function( String? slug)?  providerPicked,TResult? Function( WalletType type)?  typePicked,TResult? Function( String hex)?  colorPicked,TResult? Function( bool isDefault)?  defaultToggled,TResult? Function( String name)?  nameEdited,TResult? Function( String balance)?  balanceEdited,TResult? Function( String name,  String balance)?  saveRequested,TResult? Function()?  archiveRequested,TResult? Function()?  deleteRequested,TResult? Function( List<PaymentProvider> providers)?  providersChanged,TResult? Function( List<Wallet> wallets)?  walletsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Retried() when retried != null:
return retried();case _ProviderPicked() when providerPicked != null:
return providerPicked(_that.slug);case _TypePicked() when typePicked != null:
return typePicked(_that.type);case _ColorPicked() when colorPicked != null:
return colorPicked(_that.hex);case _DefaultToggled() when defaultToggled != null:
return defaultToggled(_that.isDefault);case _NameEdited() when nameEdited != null:
return nameEdited(_that.name);case _BalanceEdited() when balanceEdited != null:
return balanceEdited(_that.balance);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name,_that.balance);case _ArchiveRequested() when archiveRequested != null:
return archiveRequested();case _DeleteRequested() when deleteRequested != null:
return deleteRequested();case _ProvidersChanged() when providersChanged != null:
return providersChanged(_that.providers);case _WalletsChanged() when walletsChanged != null:
return walletsChanged(_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements WalletFormEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormEvent.started()';
}


}




/// @nodoc


class _Retried implements WalletFormEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormEvent.retried()';
}


}




/// @nodoc


class _ProviderPicked implements WalletFormEvent {
  const _ProviderPicked(this.slug);
  

 final  String? slug;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderPickedCopyWith<_ProviderPicked> get copyWith => __$ProviderPickedCopyWithImpl<_ProviderPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderPicked&&(identical(other.slug, slug) || other.slug == slug));
}


@override
int get hashCode {
    return Object.hash(runtimeType,slug);
}

@override
String toString() {
    return 'WalletFormEvent.providerPicked(slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$ProviderPickedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$ProviderPickedCopyWith(_ProviderPicked value, $Res Function(_ProviderPicked) _then) = __$ProviderPickedCopyWithImpl;
@useResult
$Res call({
 String? slug
});




}
/// @nodoc
class __$ProviderPickedCopyWithImpl<$Res>
    implements _$ProviderPickedCopyWith<$Res> {
  __$ProviderPickedCopyWithImpl(this._self, this._then);

  final _ProviderPicked _self;
  final $Res Function(_ProviderPicked) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? slug = freezed,}) {
  return _then(_ProviderPicked(
freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TypePicked implements WalletFormEvent {
  const _TypePicked(this.type);
  

 final  WalletType type;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypePickedCopyWith<_TypePicked> get copyWith => __$TypePickedCopyWithImpl<_TypePicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypePicked&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'WalletFormEvent.typePicked(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypePickedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$TypePickedCopyWith(_TypePicked value, $Res Function(_TypePicked) _then) = __$TypePickedCopyWithImpl;
@useResult
$Res call({
 WalletType type
});




}
/// @nodoc
class __$TypePickedCopyWithImpl<$Res>
    implements _$TypePickedCopyWith<$Res> {
  __$TypePickedCopyWithImpl(this._self, this._then);

  final _TypePicked _self;
  final $Res Function(_TypePicked) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_TypePicked(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,
  ));
}


}

/// @nodoc


class _ColorPicked implements WalletFormEvent {
  const _ColorPicked(this.hex);
  

 final  String hex;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorPickedCopyWith<_ColorPicked> get copyWith => __$ColorPickedCopyWithImpl<_ColorPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorPicked&&(identical(other.hex, hex) || other.hex == hex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hex);
}

@override
String toString() {
    return 'WalletFormEvent.colorPicked(hex: $hex)';
}


}

/// @nodoc
abstract mixin class _$ColorPickedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$ColorPickedCopyWith(_ColorPicked value, $Res Function(_ColorPicked) _then) = __$ColorPickedCopyWithImpl;
@useResult
$Res call({
 String hex
});




}
/// @nodoc
class __$ColorPickedCopyWithImpl<$Res>
    implements _$ColorPickedCopyWith<$Res> {
  __$ColorPickedCopyWithImpl(this._self, this._then);

  final _ColorPicked _self;
  final $Res Function(_ColorPicked) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hex = null,}) {
  return _then(_ColorPicked(
null == hex ? _self.hex : hex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DefaultToggled implements WalletFormEvent {
  const _DefaultToggled({required this.isDefault});
  

 final  bool isDefault;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultToggledCopyWith<_DefaultToggled> get copyWith => __$DefaultToggledCopyWithImpl<_DefaultToggled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultToggled&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isDefault);
}

@override
String toString() {
    return 'WalletFormEvent.defaultToggled(isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$DefaultToggledCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$DefaultToggledCopyWith(_DefaultToggled value, $Res Function(_DefaultToggled) _then) = __$DefaultToggledCopyWithImpl;
@useResult
$Res call({
 bool isDefault
});




}
/// @nodoc
class __$DefaultToggledCopyWithImpl<$Res>
    implements _$DefaultToggledCopyWith<$Res> {
  __$DefaultToggledCopyWithImpl(this._self, this._then);

  final _DefaultToggled _self;
  final $Res Function(_DefaultToggled) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isDefault = null,}) {
  return _then(_DefaultToggled(
isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _NameEdited implements WalletFormEvent {
  const _NameEdited(this.name);
  

 final  String name;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameEditedCopyWith<_NameEdited> get copyWith => __$NameEditedCopyWithImpl<_NameEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameEdited&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'WalletFormEvent.nameEdited(name: $name)';
}


}

/// @nodoc
abstract mixin class _$NameEditedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$NameEditedCopyWith(_NameEdited value, $Res Function(_NameEdited) _then) = __$NameEditedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$NameEditedCopyWithImpl<$Res>
    implements _$NameEditedCopyWith<$Res> {
  __$NameEditedCopyWithImpl(this._self, this._then);

  final _NameEdited _self;
  final $Res Function(_NameEdited) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_NameEdited(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _BalanceEdited implements WalletFormEvent {
  const _BalanceEdited(this.balance);
  

 final  String balance;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceEditedCopyWith<_BalanceEdited> get copyWith => __$BalanceEditedCopyWithImpl<_BalanceEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceEdited&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,balance);
}

@override
String toString() {
    return 'WalletFormEvent.balanceEdited(balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$BalanceEditedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$BalanceEditedCopyWith(_BalanceEdited value, $Res Function(_BalanceEdited) _then) = __$BalanceEditedCopyWithImpl;
@useResult
$Res call({
 String balance
});




}
/// @nodoc
class __$BalanceEditedCopyWithImpl<$Res>
    implements _$BalanceEditedCopyWith<$Res> {
  __$BalanceEditedCopyWithImpl(this._self, this._then);

  final _BalanceEdited _self;
  final $Res Function(_BalanceEdited) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? balance = null,}) {
  return _then(_BalanceEdited(
null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested implements WalletFormEvent {
  const _SaveRequested({required this.name, required this.balance});
  

 final  String name;
 final  String balance;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,balance);
}

@override
String toString() {
    return 'WalletFormEvent.saveRequested(name: $name, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String name, String balance
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? balance = null,}) {
  return _then(_SaveRequested(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ArchiveRequested implements WalletFormEvent {
  const _ArchiveRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormEvent.archiveRequested()';
}


}




/// @nodoc


class _DeleteRequested implements WalletFormEvent {
  const _DeleteRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormEvent.deleteRequested()';
}


}




/// @nodoc


class _ProvidersChanged implements WalletFormEvent {
  const _ProvidersChanged( List<PaymentProvider> providers): _providers = providers;
  

 final  List<PaymentProvider> _providers;
 List<PaymentProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}


/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvidersChangedCopyWith<_ProvidersChanged> get copyWith => __$ProvidersChangedCopyWithImpl<_ProvidersChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvidersChanged&&const DeepCollectionEquality().equals(other.providers, _providers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_providers));
}

@override
String toString() {
    return 'WalletFormEvent.providersChanged(providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$ProvidersChangedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
  factory _$ProvidersChangedCopyWith(_ProvidersChanged value, $Res Function(_ProvidersChanged) _then) = __$ProvidersChangedCopyWithImpl;
@useResult
$Res call({
 List<PaymentProvider> providers
});




}
/// @nodoc
class __$ProvidersChangedCopyWithImpl<$Res>
    implements _$ProvidersChangedCopyWith<$Res> {
  __$ProvidersChangedCopyWithImpl(this._self, this._then);

  final _ProvidersChanged _self;
  final $Res Function(_ProvidersChanged) _then;

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? providers = null,}) {
  return _then(_ProvidersChanged(
null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<PaymentProvider>,
  ));
}


}

/// @nodoc


class _WalletsChanged implements WalletFormEvent {
  const _WalletsChanged( List<Wallet> wallets): _wallets = wallets;
  

 final  List<Wallet> _wallets;
 List<Wallet> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of WalletFormEvent
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
    return 'WalletFormEvent.walletsChanged(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletsChangedCopyWith<$Res> implements $WalletFormEventCopyWith<$Res> {
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

/// Create a copy of WalletFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_WalletsChanged(
null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>,
  ));
}


}

/// @nodoc
mixin _$WalletFormState {

 WalletFormMode get mode; UiStatus get status; List<PaymentProvider> get providers;/// Null for a custom wallet. A slug, not an id, so the pick survives the
/// bundled catalog being replaced.
 String? get providerSlug; WalletType? get type; String? get color; bool get isDefault; int get initialBalance; Wallet? get original; String? get defaultWalletName; Map<String, FieldError> get errors; bool get autovalidate; bool get isSaving; bool get isArchiving; bool get isDeleting; String? get nameFill; bool get offerArchive; WalletFormOutcome? get outcome; WalletFailure? get loadFailure; WalletFailure? get actionFailure;
/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletFormStateCopyWith<WalletFormState> get copyWith => _$WalletFormStateCopyWithImpl<WalletFormState>(this as WalletFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WalletFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.providers, _this.providers)&&(identical(other.providerSlug, _this.providerSlug) || other.providerSlug == _this.providerSlug)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.original, _this.original) || other.original == _this.original)&&(identical(other.defaultWalletName, _this.defaultWalletName) || other.defaultWalletName == _this.defaultWalletName)&&const DeepCollectionEquality().equals(other.errors, _this.errors)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isArchiving, _this.isArchiving) || other.isArchiving == _this.isArchiving)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.nameFill, _this.nameFill) || other.nameFill == _this.nameFill)&&(identical(other.offerArchive, _this.offerArchive) || other.offerArchive == _this.offerArchive)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as WalletFormState;
  return Object.hashAll([runtimeType,_this.mode,_this.status,const DeepCollectionEquality().hash(_this.providers),_this.providerSlug,_this.type,_this.color,_this.isDefault,_this.initialBalance,_this.original,_this.defaultWalletName,const DeepCollectionEquality().hash(_this.errors),_this.autovalidate,_this.isSaving,_this.isArchiving,_this.isDeleting,_this.nameFill,_this.offerArchive,_this.outcome,_this.loadFailure,_this.actionFailure]);
}

@override
String toString() {
  final _this = this as WalletFormState;
  return 'WalletFormState(mode: ${_this.mode}, status: ${_this.status}, providers: ${_this.providers}, providerSlug: ${_this.providerSlug}, type: ${_this.type}, color: ${_this.color}, isDefault: ${_this.isDefault}, initialBalance: ${_this.initialBalance}, original: ${_this.original}, defaultWalletName: ${_this.defaultWalletName}, errors: ${_this.errors}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, isArchiving: ${_this.isArchiving}, isDeleting: ${_this.isDeleting}, nameFill: ${_this.nameFill}, offerArchive: ${_this.offerArchive}, outcome: ${_this.outcome}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $WalletFormStateCopyWith<$Res>  {
  factory $WalletFormStateCopyWith(WalletFormState value, $Res Function(WalletFormState) _then) = _$WalletFormStateCopyWithImpl;
@useResult
$Res call({
 WalletFormMode mode, UiStatus status, List<PaymentProvider> providers, String? providerSlug, WalletType? type, String? color, bool isDefault, int initialBalance, Wallet? original, String? defaultWalletName, Map<String, FieldError> errors, bool autovalidate, bool isSaving, bool isArchiving, bool isDeleting, String? nameFill, bool offerArchive, WalletFormOutcome? outcome, WalletFailure? loadFailure, WalletFailure? actionFailure
});


$WalletFormModeCopyWith<$Res> get mode;$WalletCopyWith<$Res>? get original;$WalletFormOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class _$WalletFormStateCopyWithImpl<$Res>
    implements $WalletFormStateCopyWith<$Res> {
  _$WalletFormStateCopyWithImpl(this._self, this._then);

  final WalletFormState _self;
  final $Res Function(WalletFormState) _then;

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? status = null,Object? providers = null,Object? providerSlug = freezed,Object? type = freezed,Object? color = freezed,Object? isDefault = null,Object? initialBalance = null,Object? original = freezed,Object? defaultWalletName = freezed,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? isArchiving = null,Object? isDeleting = null,Object? nameFill = freezed,Object? offerArchive = null,Object? outcome = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(WalletFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as WalletFormMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<PaymentProvider>,providerSlug: freezed == providerSlug ? _self.providerSlug : providerSlug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Wallet?,defaultWalletName: freezed == defaultWalletName ? _self.defaultWalletName : defaultWalletName // ignore: cast_nullable_to_non_nullable
as String?,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isArchiving: null == isArchiving ? _self.isArchiving : isArchiving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,nameFill: freezed == nameFill ? _self.nameFill : nameFill // ignore: cast_nullable_to_non_nullable
as String?,offerArchive: null == offerArchive ? _self.offerArchive : offerArchive // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as WalletFormOutcome?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}
/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletFormModeCopyWith<$Res> get mode {
  
  return $WalletFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletFormOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $WalletFormOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletFormState].
extension WalletFormStatePatterns on WalletFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletFormState value)  $default,){
final _that = this;
switch (_that) {
case _WalletFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletFormState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WalletFormMode mode,  UiStatus status,  List<PaymentProvider> providers,  String? providerSlug,  WalletType? type,  String? color,  bool isDefault,  int initialBalance,  Wallet? original,  String? defaultWalletName,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  bool isArchiving,  bool isDeleting,  String? nameFill,  bool offerArchive,  WalletFormOutcome? outcome,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
return $default(_that.mode,_that.status,_that.providers,_that.providerSlug,_that.type,_that.color,_that.isDefault,_that.initialBalance,_that.original,_that.defaultWalletName,_that.errors,_that.autovalidate,_that.isSaving,_that.isArchiving,_that.isDeleting,_that.nameFill,_that.offerArchive,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WalletFormMode mode,  UiStatus status,  List<PaymentProvider> providers,  String? providerSlug,  WalletType? type,  String? color,  bool isDefault,  int initialBalance,  Wallet? original,  String? defaultWalletName,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  bool isArchiving,  bool isDeleting,  String? nameFill,  bool offerArchive,  WalletFormOutcome? outcome,  WalletFailure? loadFailure,  WalletFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _WalletFormState():
return $default(_that.mode,_that.status,_that.providers,_that.providerSlug,_that.type,_that.color,_that.isDefault,_that.initialBalance,_that.original,_that.defaultWalletName,_that.errors,_that.autovalidate,_that.isSaving,_that.isArchiving,_that.isDeleting,_that.nameFill,_that.offerArchive,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WalletFormMode mode,  UiStatus status,  List<PaymentProvider> providers,  String? providerSlug,  WalletType? type,  String? color,  bool isDefault,  int initialBalance,  Wallet? original,  String? defaultWalletName,  Map<String, FieldError> errors,  bool autovalidate,  bool isSaving,  bool isArchiving,  bool isDeleting,  String? nameFill,  bool offerArchive,  WalletFormOutcome? outcome,  WalletFailure? loadFailure,  WalletFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
return $default(_that.mode,_that.status,_that.providers,_that.providerSlug,_that.type,_that.color,_that.isDefault,_that.initialBalance,_that.original,_that.defaultWalletName,_that.errors,_that.autovalidate,_that.isSaving,_that.isArchiving,_that.isDeleting,_that.nameFill,_that.offerArchive,_that.outcome,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _WalletFormState implements WalletFormState {
  const _WalletFormState({required this.mode, this.status = UiStatus.initial,  List<PaymentProvider> providers = const [], this.providerSlug, this.type, this.color, this.isDefault = false, this.initialBalance = 0, this.original, this.defaultWalletName,  Map<String, FieldError> errors = const {}, this.autovalidate = false, this.isSaving = false, this.isArchiving = false, this.isDeleting = false, this.nameFill, this.offerArchive = false, this.outcome, this.loadFailure, this.actionFailure}): _providers = providers,_errors = errors;
  

@override final  WalletFormMode mode;
@override@JsonKey() final  UiStatus status;
 final  List<PaymentProvider> _providers;
@override@JsonKey() List<PaymentProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}

/// Null for a custom wallet. A slug, not an id, so the pick survives the
/// bundled catalog being replaced.
@override final  String? providerSlug;
@override final  WalletType? type;
@override final  String? color;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  int initialBalance;
@override final  Wallet? original;
@override final  String? defaultWalletName;
 final  Map<String, FieldError> _errors;
@override@JsonKey() Map<String, FieldError> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isArchiving;
@override@JsonKey() final  bool isDeleting;
@override final  String? nameFill;
@override@JsonKey() final  bool offerArchive;
@override final  WalletFormOutcome? outcome;
@override final  WalletFailure? loadFailure;
@override final  WalletFailure? actionFailure;

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletFormStateCopyWith<_WalletFormState> get copyWith => __$WalletFormStateCopyWithImpl<_WalletFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.providers, _providers)&&(identical(other.providerSlug, providerSlug) || other.providerSlug == providerSlug)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.original, original) || other.original == original)&&(identical(other.defaultWalletName, defaultWalletName) || other.defaultWalletName == defaultWalletName)&&const DeepCollectionEquality().equals(other.errors, _errors)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isArchiving, isArchiving) || other.isArchiving == isArchiving)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.nameFill, nameFill) || other.nameFill == nameFill)&&(identical(other.offerArchive, offerArchive) || other.offerArchive == offerArchive)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,mode,status,const DeepCollectionEquality().hash(_providers),providerSlug,type,color,isDefault,initialBalance,original,defaultWalletName,const DeepCollectionEquality().hash(_errors),autovalidate,isSaving,isArchiving,isDeleting,nameFill,offerArchive,outcome,loadFailure,actionFailure]);
}

@override
String toString() {
    return 'WalletFormState(mode: $mode, status: $status, providers: $providers, providerSlug: $providerSlug, type: $type, color: $color, isDefault: $isDefault, initialBalance: $initialBalance, original: $original, defaultWalletName: $defaultWalletName, errors: $errors, autovalidate: $autovalidate, isSaving: $isSaving, isArchiving: $isArchiving, isDeleting: $isDeleting, nameFill: $nameFill, offerArchive: $offerArchive, outcome: $outcome, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$WalletFormStateCopyWith<$Res> implements $WalletFormStateCopyWith<$Res> {
  factory _$WalletFormStateCopyWith(_WalletFormState value, $Res Function(_WalletFormState) _then) = __$WalletFormStateCopyWithImpl;
@override @useResult
$Res call({
 WalletFormMode mode, UiStatus status, List<PaymentProvider> providers, String? providerSlug, WalletType? type, String? color, bool isDefault, int initialBalance, Wallet? original, String? defaultWalletName, Map<String, FieldError> errors, bool autovalidate, bool isSaving, bool isArchiving, bool isDeleting, String? nameFill, bool offerArchive, WalletFormOutcome? outcome, WalletFailure? loadFailure, WalletFailure? actionFailure
});


@override $WalletFormModeCopyWith<$Res> get mode;@override $WalletCopyWith<$Res>? get original;@override $WalletFormOutcomeCopyWith<$Res>? get outcome;

}
/// @nodoc
class __$WalletFormStateCopyWithImpl<$Res>
    implements _$WalletFormStateCopyWith<$Res> {
  __$WalletFormStateCopyWithImpl(this._self, this._then);

  final _WalletFormState _self;
  final $Res Function(_WalletFormState) _then;

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? status = null,Object? providers = null,Object? providerSlug = freezed,Object? type = freezed,Object? color = freezed,Object? isDefault = null,Object? initialBalance = null,Object? original = freezed,Object? defaultWalletName = freezed,Object? errors = null,Object? autovalidate = null,Object? isSaving = null,Object? isArchiving = null,Object? isDeleting = null,Object? nameFill = freezed,Object? offerArchive = null,Object? outcome = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_WalletFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as WalletFormMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<PaymentProvider>,providerSlug: freezed == providerSlug ? _self.providerSlug : providerSlug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Wallet?,defaultWalletName: freezed == defaultWalletName ? _self.defaultWalletName : defaultWalletName // ignore: cast_nullable_to_non_nullable
as String?,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, FieldError>,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isArchiving: null == isArchiving ? _self.isArchiving : isArchiving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,nameFill: freezed == nameFill ? _self.nameFill : nameFill // ignore: cast_nullable_to_non_nullable
as String?,offerArchive: null == offerArchive ? _self.offerArchive : offerArchive // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as WalletFormOutcome?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as WalletFailure?,
  ));
}

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletFormModeCopyWith<$Res> get mode {
  
  return $WalletFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletFormOutcomeCopyWith<$Res>? get outcome {
    if (_self.outcome == null) {
    return null;
  }

  return $WalletFormOutcomeCopyWith<$Res>(_self.outcome!, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}

// dart format on
