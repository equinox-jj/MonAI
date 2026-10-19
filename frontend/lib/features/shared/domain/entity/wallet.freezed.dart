// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Wallet {

 String get id; String get name; WalletType get type; int get initialBalance; int get currentBalance; bool get isDefault; bool get isArchived; DateTime get createdAt; DateTime get updatedAt;/// The linked payment provider; null for a custom wallet.
 String? get providerId; String? get logoUrl; String? get icon;/// `#RRGGBB`.
 String? get color;
/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletCopyWith<Wallet> get copyWith => _$WalletCopyWithImpl<Wallet>(this as Wallet, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Wallet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wallet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.initialBalance, _this.initialBalance) || other.initialBalance == _this.initialBalance)&&(identical(other.currentBalance, _this.currentBalance) || other.currentBalance == _this.currentBalance)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.providerId, _this.providerId) || other.providerId == _this.providerId)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color));
}


@override
int get hashCode {
  final _this = this as Wallet;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.initialBalance,_this.currentBalance,_this.isDefault,_this.isArchived,_this.createdAt,_this.updatedAt,_this.providerId,_this.logoUrl,_this.icon,_this.color);
}

@override
String toString() {
  final _this = this as Wallet;
  return 'Wallet(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, initialBalance: ${_this.initialBalance}, currentBalance: ${_this.currentBalance}, isDefault: ${_this.isDefault}, isArchived: ${_this.isArchived}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, providerId: ${_this.providerId}, logoUrl: ${_this.logoUrl}, icon: ${_this.icon}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $WalletCopyWith<$Res>  {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) _then) = _$WalletCopyWithImpl;
@useResult
$Res call({
 String id, String name, WalletType type, int initialBalance, int currentBalance, bool isDefault, bool isArchived, DateTime createdAt, DateTime updatedAt, String? providerId, String? logoUrl, String? icon, String? color
});




}
/// @nodoc
class _$WalletCopyWithImpl<$Res>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._self, this._then);

  final Wallet _self;
  final $Res Function(Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? initialBalance = null,Object? currentBalance = null,Object? isDefault = null,Object? isArchived = null,Object? createdAt = null,Object? updatedAt = null,Object? providerId = freezed,Object? logoUrl = freezed,Object? icon = freezed,Object? color = freezed,}) {
  return _then(Wallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wallet].
extension WalletPatterns on Wallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wallet value)  $default,){
final _that = this;
switch (_that) {
case _Wallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wallet value)?  $default,){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  WalletType type,  int initialBalance,  int currentBalance,  bool isDefault,  bool isArchived,  DateTime createdAt,  DateTime updatedAt,  String? providerId,  String? logoUrl,  String? icon,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.initialBalance,_that.currentBalance,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt,_that.providerId,_that.logoUrl,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  WalletType type,  int initialBalance,  int currentBalance,  bool isDefault,  bool isArchived,  DateTime createdAt,  DateTime updatedAt,  String? providerId,  String? logoUrl,  String? icon,  String? color)  $default,) {final _that = this;
switch (_that) {
case _Wallet():
return $default(_that.id,_that.name,_that.type,_that.initialBalance,_that.currentBalance,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt,_that.providerId,_that.logoUrl,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  WalletType type,  int initialBalance,  int currentBalance,  bool isDefault,  bool isArchived,  DateTime createdAt,  DateTime updatedAt,  String? providerId,  String? logoUrl,  String? icon,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.initialBalance,_that.currentBalance,_that.isDefault,_that.isArchived,_that.createdAt,_that.updatedAt,_that.providerId,_that.logoUrl,_that.icon,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _Wallet implements Wallet {
  const _Wallet({required this.id, required this.name, required this.type, required this.initialBalance, required this.currentBalance, required this.isDefault, required this.isArchived, required this.createdAt, required this.updatedAt, this.providerId, this.logoUrl, this.icon, this.color});
  

@override final  String id;
@override final  String name;
@override final  WalletType type;
@override final  int initialBalance;
@override final  int currentBalance;
@override final  bool isDefault;
@override final  bool isArchived;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// The linked payment provider; null for a custom wallet.
@override final  String? providerId;
@override final  String? logoUrl;
@override final  String? icon;
/// `#RRGGBB`.
@override final  String? color;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletCopyWith<_Wallet> get copyWith => __$WalletCopyWithImpl<_Wallet>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wallet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,initialBalance,currentBalance,isDefault,isArchived,createdAt,updatedAt,providerId,logoUrl,icon,color);
}

@override
String toString() {
    return 'Wallet(id: $id, name: $name, type: $type, initialBalance: $initialBalance, currentBalance: $currentBalance, isDefault: $isDefault, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt, providerId: $providerId, logoUrl: $logoUrl, icon: $icon, color: $color)';
}


}

/// @nodoc
abstract mixin class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) _then) = __$WalletCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, WalletType type, int initialBalance, int currentBalance, bool isDefault, bool isArchived, DateTime createdAt, DateTime updatedAt, String? providerId, String? logoUrl, String? icon, String? color
});




}
/// @nodoc
class __$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(this._self, this._then);

  final _Wallet _self;
  final $Res Function(_Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? initialBalance = null,Object? currentBalance = null,Object? isDefault = null,Object? isArchived = null,Object? createdAt = null,Object? updatedAt = null,Object? providerId = freezed,Object? logoUrl = freezed,Object? icon = freezed,Object? color = freezed,}) {
  return _then(_Wallet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as int,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
