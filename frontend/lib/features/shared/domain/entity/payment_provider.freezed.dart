// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentProvider {

 String get id; String get slug; String get name; WalletType get type;/// Other names the provider is known by, for quick add.
 List<String> get aliases; int get sortOrder; String? get logoUrl;/// From the catalog bundled with the app, not yet replaced by the
/// server's: its [id] isn't one the server knows.
 bool get isBundled;
/// Create a copy of PaymentProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentProviderCopyWith<PaymentProvider> get copyWith => _$PaymentProviderCopyWithImpl<PaymentProvider>(this as PaymentProvider, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentProvider;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentProvider&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.isBundled, _this.isBundled) || other.isBundled == _this.isBundled));
}


@override
int get hashCode {
  final _this = this as PaymentProvider;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.type,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder,_this.logoUrl,_this.isBundled);
}

@override
String toString() {
  final _this = this as PaymentProvider;
  return 'PaymentProvider(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, type: ${_this.type}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder}, logoUrl: ${_this.logoUrl}, isBundled: ${_this.isBundled})';
}


}

/// @nodoc
abstract mixin class $PaymentProviderCopyWith<$Res>  {
  factory $PaymentProviderCopyWith(PaymentProvider value, $Res Function(PaymentProvider) _then) = _$PaymentProviderCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, WalletType type, List<String> aliases, int sortOrder, String? logoUrl, bool isBundled
});




}
/// @nodoc
class _$PaymentProviderCopyWithImpl<$Res>
    implements $PaymentProviderCopyWith<$Res> {
  _$PaymentProviderCopyWithImpl(this._self, this._then);

  final PaymentProvider _self;
  final $Res Function(PaymentProvider) _then;

/// Create a copy of PaymentProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? logoUrl = freezed,Object? isBundled = null,}) {
  return _then(PaymentProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,isBundled: null == isBundled ? _self.isBundled : isBundled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentProvider].
extension PaymentProviderPatterns on PaymentProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentProvider value)  $default,){
final _that = this;
switch (_that) {
case _PaymentProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentProvider value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  String? logoUrl,  bool isBundled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentProvider() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.logoUrl,_that.isBundled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  String? logoUrl,  bool isBundled)  $default,) {final _that = this;
switch (_that) {
case _PaymentProvider():
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.logoUrl,_that.isBundled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  WalletType type,  List<String> aliases,  int sortOrder,  String? logoUrl,  bool isBundled)?  $default,) {final _that = this;
switch (_that) {
case _PaymentProvider() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.aliases,_that.sortOrder,_that.logoUrl,_that.isBundled);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentProvider implements PaymentProvider {
  const _PaymentProvider({required this.id, required this.slug, required this.name, required this.type, required  List<String> aliases, required this.sortOrder, this.logoUrl, this.isBundled = false}): _aliases = aliases;
  

@override final  String id;
@override final  String slug;
@override final  String name;
@override final  WalletType type;
/// Other names the provider is known by, for quick add.
 final  List<String> _aliases;
/// Other names the provider is known by, for quick add.
@override List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  int sortOrder;
@override final  String? logoUrl;
/// From the catalog bundled with the app, not yet replaced by the
/// server's: its [id] isn't one the server knows.
@override@JsonKey() final  bool isBundled;

/// Create a copy of PaymentProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentProviderCopyWith<_PaymentProvider> get copyWith => __$PaymentProviderCopyWithImpl<_PaymentProvider>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.isBundled, isBundled) || other.isBundled == isBundled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,type,const DeepCollectionEquality().hash(_aliases),sortOrder,logoUrl,isBundled);
}

@override
String toString() {
    return 'PaymentProvider(id: $id, slug: $slug, name: $name, type: $type, aliases: $aliases, sortOrder: $sortOrder, logoUrl: $logoUrl, isBundled: $isBundled)';
}


}

/// @nodoc
abstract mixin class _$PaymentProviderCopyWith<$Res> implements $PaymentProviderCopyWith<$Res> {
  factory _$PaymentProviderCopyWith(_PaymentProvider value, $Res Function(_PaymentProvider) _then) = __$PaymentProviderCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, WalletType type, List<String> aliases, int sortOrder, String? logoUrl, bool isBundled
});




}
/// @nodoc
class __$PaymentProviderCopyWithImpl<$Res>
    implements _$PaymentProviderCopyWith<$Res> {
  __$PaymentProviderCopyWithImpl(this._self, this._then);

  final _PaymentProvider _self;
  final $Res Function(_PaymentProvider) _then;

/// Create a copy of PaymentProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? type = null,Object? aliases = null,Object? sortOrder = null,Object? logoUrl = freezed,Object? isBundled = null,}) {
  return _then(_PaymentProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletType,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,isBundled: null == isBundled ? _self.isBundled : isBundled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
