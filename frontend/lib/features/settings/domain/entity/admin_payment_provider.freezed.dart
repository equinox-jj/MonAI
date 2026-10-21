// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminPaymentProvider {

 String get id; String get slug; String get name; WalletType get type;/// Lowercase words quick add matches, e.g. `gpay` for GoPay.
 List<String> get aliases;/// Lower appears first.
 int get sortOrder;/// Inactive providers are hidden from users adding a wallet.
 bool get isActive;/// Cash and the like: can't be deactivated, deleted or renamed to
/// another slug.
 bool get isSystem; DateTime get updatedAt; String? get logoUrl;
/// Create a copy of AdminPaymentProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminPaymentProviderCopyWith<AdminPaymentProvider> get copyWith => _$AdminPaymentProviderCopyWithImpl<AdminPaymentProvider>(this as AdminPaymentProvider, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminPaymentProvider;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminPaymentProvider&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl));
}


@override
int get hashCode {
  final _this = this as AdminPaymentProvider;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder,_this.isActive,_this.isSystem,_this.updatedAt,_this.logoUrl);
}

@override
String toString() {
  final _this = this as AdminPaymentProvider;
  return 'AdminPaymentProvider(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive}, isSystem: ${_this.isSystem}, updatedAt: ${_this.updatedAt}, logoUrl: ${_this.logoUrl})';
}


}

/// @nodoc
abstract mixin class $AdminPaymentProviderCopyWith<$Res>  {
  factory $AdminPaymentProviderCopyWith(AdminPaymentProvider value, $Res Function(AdminPaymentProvider) _then) = _$AdminPaymentProviderCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, WalletType type, List<String> aliases, int sortOrder, bool isActive, bool isSystem, DateTime updatedAt, String? logoUrl
});




}
/// @nodoc
class _$AdminPaymentProviderCopyWithImpl<$Res>
    implements $AdminPaymentProviderCopyWith<$Res> {
  _$AdminPaymentProviderCopyWithImpl(this._self, this._then);

  final AdminPaymentProvider _self;
  final $Res Function(AdminPaymentProvider) _then;

/// Create a copy of AdminPaymentProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? isActive = null,Object? isSystem = null,Object? updatedAt = null,Object? logoUrl = freezed,}) {
  return _then(AdminPaymentProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminPaymentProvider].
extension AdminPaymentProviderPatterns on AdminPaymentProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminPaymentProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminPaymentProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminPaymentProvider value)  $default,){
final _that = this;
switch (_that) {
case _AdminPaymentProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminPaymentProvider value)?  $default,){
final _that = this;
switch (_that) {
case _AdminPaymentProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive,  bool isSystem,  DateTime updatedAt,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminPaymentProvider() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive,  bool isSystem,  DateTime updatedAt,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminPaymentProvider():
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive,  bool isSystem,  DateTime updatedAt,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminPaymentProvider() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminPaymentProvider implements AdminPaymentProvider {
  const _AdminPaymentProvider({required this.id, required this.slug, required this.name, required this.type, required  List<String> aliases, required this.sortOrder, required this.isActive, required this.isSystem, required this.updatedAt, this.logoUrl}): _aliases = aliases;
  

@override final  String id;
@override final  String slug;
@override final  String name;
@override final  WalletType type;
/// Lowercase words quick add matches, e.g. `gpay` for GoPay.
 final  List<String> _aliases;
/// Lowercase words quick add matches, e.g. `gpay` for GoPay.
@override List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

/// Lower appears first.
@override final  int sortOrder;
/// Inactive providers are hidden from users adding a wallet.
@override final  bool isActive;
/// Cash and the like: can't be deactivated, deleted or renamed to
/// another slug.
@override final  bool isSystem;
@override final  DateTime updatedAt;
@override final  String? logoUrl;

/// Create a copy of AdminPaymentProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminPaymentProviderCopyWith<_AdminPaymentProvider> get copyWith => __$AdminPaymentProviderCopyWithImpl<_AdminPaymentProvider>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminPaymentProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder,isActive,isSystem,updatedAt,logoUrl);
}

@override
String toString() {
    return 'AdminPaymentProvider(id: $id, slug: $slug, name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder, isActive: $isActive, isSystem: $isSystem, updatedAt: $updatedAt, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminPaymentProviderCopyWith<$Res> implements $AdminPaymentProviderCopyWith<$Res> {
  factory _$AdminPaymentProviderCopyWith(_AdminPaymentProvider value, $Res Function(_AdminPaymentProvider) _then) = __$AdminPaymentProviderCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, WalletType type, List<String> aliases, int sortOrder, bool isActive, bool isSystem, DateTime updatedAt, String? logoUrl
});




}
/// @nodoc
class __$AdminPaymentProviderCopyWithImpl<$Res>
    implements _$AdminPaymentProviderCopyWith<$Res> {
  __$AdminPaymentProviderCopyWithImpl(this._self, this._then);

  final _AdminPaymentProvider _self;
  final $Res Function(_AdminPaymentProvider) _then;

/// Create a copy of AdminPaymentProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? isActive = null,Object? isSystem = null,Object? updatedAt = null,Object? logoUrl = freezed,}) {
  return _then(_AdminPaymentProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ProviderInput {

 String get name; WalletType get type; List<String> get aliases; int get sortOrder; bool get isActive;
/// Create a copy of ProviderInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderInputCopyWith<ProviderInput> get copyWith => _$ProviderInputCopyWithImpl<ProviderInput>(this as ProviderInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProviderInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}


@override
int get hashCode {
  final _this = this as ProviderInput;
  return Object.hash(runtimeType,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder,_this.isActive);
}

@override
String toString() {
  final _this = this as ProviderInput;
  return 'ProviderInput(name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $ProviderInputCopyWith<$Res>  {
  factory $ProviderInputCopyWith(ProviderInput value, $Res Function(ProviderInput) _then) = _$ProviderInputCopyWithImpl;
@useResult
$Res call({
 String name, WalletType type, List<String> aliases, int sortOrder, bool isActive
});




}
/// @nodoc
class _$ProviderInputCopyWithImpl<$Res>
    implements $ProviderInputCopyWith<$Res> {
  _$ProviderInputCopyWithImpl(this._self, this._then);

  final ProviderInput _self;
  final $Res Function(ProviderInput) _then;

/// Create a copy of ProviderInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(ProviderInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderInput].
extension ProviderInputPatterns on ProviderInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderInput value)  $default,){
final _that = this;
switch (_that) {
case _ProviderInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderInput value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderInput() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProviderInput():
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WalletType type,  List<String> aliases,  int sortOrder,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProviderInput() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _ProviderInput implements ProviderInput {
  const _ProviderInput({required this.name, required this.type, required  List<String> aliases, required this.sortOrder, required this.isActive}): _aliases = aliases;
  

@override final  String name;
@override final  WalletType type;
 final  List<String> _aliases;
@override List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  int sortOrder;
@override final  bool isActive;

/// Create a copy of ProviderInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderInputCopyWith<_ProviderInput> get copyWith => __$ProviderInputCopyWithImpl<_ProviderInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderInput&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder,isActive);
}

@override
String toString() {
    return 'ProviderInput(name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProviderInputCopyWith<$Res> implements $ProviderInputCopyWith<$Res> {
  factory _$ProviderInputCopyWith(_ProviderInput value, $Res Function(_ProviderInput) _then) = __$ProviderInputCopyWithImpl;
@override @useResult
$Res call({
 String name, WalletType type, List<String> aliases, int sortOrder, bool isActive
});




}
/// @nodoc
class __$ProviderInputCopyWithImpl<$Res>
    implements _$ProviderInputCopyWith<$Res> {
  __$ProviderInputCopyWithImpl(this._self, this._then);

  final _ProviderInput _self;
  final $Res Function(_ProviderInput) _then;

/// Create a copy of ProviderInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? isActive = null,}) {
  return _then(_ProviderInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ProviderChanges {

 String? get name; WalletType? get type; List<String>? get aliases; int? get sortOrder;
/// Create a copy of ProviderChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderChangesCopyWith<ProviderChanges> get copyWith => _$ProviderChangesCopyWithImpl<ProviderChanges>(this as ProviderChanges, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProviderChanges;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderChanges&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}


@override
int get hashCode {
  final _this = this as ProviderChanges;
  return Object.hash(runtimeType,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder);
}

@override
String toString() {
  final _this = this as ProviderChanges;
  return 'ProviderChanges(name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $ProviderChangesCopyWith<$Res>  {
  factory $ProviderChangesCopyWith(ProviderChanges value, $Res Function(ProviderChanges) _then) = _$ProviderChangesCopyWithImpl;
@useResult
$Res call({
 String? name, WalletType? type, List<String>? aliases, int? sortOrder
});




}
/// @nodoc
class _$ProviderChangesCopyWithImpl<$Res>
    implements $ProviderChangesCopyWith<$Res> {
  _$ProviderChangesCopyWithImpl(this._self, this._then);

  final ProviderChanges _self;
  final $Res Function(ProviderChanges) _then;

/// Create a copy of ProviderChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? type = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(ProviderChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderChanges].
extension ProviderChangesPatterns on ProviderChanges {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderChanges() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderChanges value)  $default,){
final _that = this;
switch (_that) {
case _ProviderChanges():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderChanges value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderChanges() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  WalletType? type,  List<String>? aliases,  int? sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderChanges() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  WalletType? type,  List<String>? aliases,  int? sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ProviderChanges():
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  WalletType? type,  List<String>? aliases,  int? sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ProviderChanges() when $default != null:
return $default(_that.name,_that.type,_that.aliases,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ProviderChanges extends ProviderChanges {
  const _ProviderChanges({this.name, this.type,  List<String>? aliases, this.sortOrder}): _aliases = aliases,super._();
  

@override final  String? name;
@override final  WalletType? type;
 final  List<String>? _aliases;
@override List<String>? get aliases {
  final value = _aliases;
  if (value == null) return null;
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? sortOrder;

/// Create a copy of ProviderChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderChangesCopyWith<_ProviderChanges> get copyWith => __$ProviderChangesCopyWithImpl<_ProviderChanges>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderChanges&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder);
}

@override
String toString() {
    return 'ProviderChanges(name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ProviderChangesCopyWith<$Res> implements $ProviderChangesCopyWith<$Res> {
  factory _$ProviderChangesCopyWith(_ProviderChanges value, $Res Function(_ProviderChanges) _then) = __$ProviderChangesCopyWithImpl;
@override @useResult
$Res call({
 String? name, WalletType? type, List<String>? aliases, int? sortOrder
});




}
/// @nodoc
class __$ProviderChangesCopyWithImpl<$Res>
    implements _$ProviderChangesCopyWith<$Res> {
  __$ProviderChangesCopyWithImpl(this._self, this._then);

  final _ProviderChanges _self;
  final $Res Function(_ProviderChanges) _then;

/// Create a copy of ProviderChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? type = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(_ProviderChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType?,aliases: freezed == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SavedProvider {

 AdminPaymentProvider get provider; Failure? get logoFailure;
/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedProviderCopyWith<SavedProvider> get copyWith => _$SavedProviderCopyWithImpl<SavedProvider>(this as SavedProvider, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedProvider;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedProvider&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.logoFailure, _this.logoFailure) || other.logoFailure == _this.logoFailure));
}


@override
int get hashCode {
  final _this = this as SavedProvider;
  return Object.hash(runtimeType,_this.provider,_this.logoFailure);
}

@override
String toString() {
  final _this = this as SavedProvider;
  return 'SavedProvider(provider: ${_this.provider}, logoFailure: ${_this.logoFailure})';
}


}

/// @nodoc
abstract mixin class $SavedProviderCopyWith<$Res>  {
  factory $SavedProviderCopyWith(SavedProvider value, $Res Function(SavedProvider) _then) = _$SavedProviderCopyWithImpl;
@useResult
$Res call({
 AdminPaymentProvider provider, Failure? logoFailure
});


$AdminPaymentProviderCopyWith<$Res> get provider;$FailureCopyWith<$Res>? get logoFailure;

}
/// @nodoc
class _$SavedProviderCopyWithImpl<$Res>
    implements $SavedProviderCopyWith<$Res> {
  _$SavedProviderCopyWithImpl(this._self, this._then);

  final SavedProvider _self;
  final $Res Function(SavedProvider) _then;

/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? logoFailure = freezed,}) {
  return _then(SavedProvider(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AdminPaymentProvider,logoFailure: freezed == logoFailure ? _self.logoFailure : logoFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPaymentProviderCopyWith<$Res> get provider {
  
  return $AdminPaymentProviderCopyWith<$Res>(_self.provider, (value) {
    return _then(_self.copyWith(provider: value));
  });
}/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get logoFailure {
    if (_self.logoFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.logoFailure!, (value) {
    return _then(_self.copyWith(logoFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedProvider].
extension SavedProviderPatterns on SavedProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedProvider value)  $default,){
final _that = this;
switch (_that) {
case _SavedProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedProvider value)?  $default,){
final _that = this;
switch (_that) {
case _SavedProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdminPaymentProvider provider,  Failure? logoFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedProvider() when $default != null:
return $default(_that.provider,_that.logoFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdminPaymentProvider provider,  Failure? logoFailure)  $default,) {final _that = this;
switch (_that) {
case _SavedProvider():
return $default(_that.provider,_that.logoFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdminPaymentProvider provider,  Failure? logoFailure)?  $default,) {final _that = this;
switch (_that) {
case _SavedProvider() when $default != null:
return $default(_that.provider,_that.logoFailure);case _:
  return null;

}
}

}

/// @nodoc


class _SavedProvider implements SavedProvider {
  const _SavedProvider({required this.provider, this.logoFailure});
  

@override final  AdminPaymentProvider provider;
@override final  Failure? logoFailure;

/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedProviderCopyWith<_SavedProvider> get copyWith => __$SavedProviderCopyWithImpl<_SavedProvider>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedProvider&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.logoFailure, logoFailure) || other.logoFailure == logoFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,provider,logoFailure);
}

@override
String toString() {
    return 'SavedProvider(provider: $provider, logoFailure: $logoFailure)';
}


}

/// @nodoc
abstract mixin class _$SavedProviderCopyWith<$Res> implements $SavedProviderCopyWith<$Res> {
  factory _$SavedProviderCopyWith(_SavedProvider value, $Res Function(_SavedProvider) _then) = __$SavedProviderCopyWithImpl;
@override @useResult
$Res call({
 AdminPaymentProvider provider, Failure? logoFailure
});


@override $AdminPaymentProviderCopyWith<$Res> get provider;@override $FailureCopyWith<$Res>? get logoFailure;

}
/// @nodoc
class __$SavedProviderCopyWithImpl<$Res>
    implements _$SavedProviderCopyWith<$Res> {
  __$SavedProviderCopyWithImpl(this._self, this._then);

  final _SavedProvider _self;
  final $Res Function(_SavedProvider) _then;

/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? logoFailure = freezed,}) {
  return _then(_SavedProvider(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AdminPaymentProvider,logoFailure: freezed == logoFailure ? _self.logoFailure : logoFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPaymentProviderCopyWith<$Res> get provider {
  
  return $AdminPaymentProviderCopyWith<$Res>(_self.provider, (value) {
    return _then(_self.copyWith(provider: value));
  });
}/// Create a copy of SavedProvider
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get logoFailure {
    if (_self.logoFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.logoFailure!, (value) {
    return _then(_self.copyWith(logoFailure: value));
  });
}
}

// dart format on
