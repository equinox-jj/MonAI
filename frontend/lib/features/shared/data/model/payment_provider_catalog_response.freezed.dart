// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider_catalog_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentProviderCatalogResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') PaymentProviderCatalogData? get data;
/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentProviderCatalogResponseCopyWith<PaymentProviderCatalogResponse> get copyWith => _$PaymentProviderCatalogResponseCopyWithImpl<PaymentProviderCatalogResponse>(this as PaymentProviderCatalogResponse, _$identity);

  /// Serializes this PaymentProviderCatalogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentProviderCatalogResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentProviderCatalogResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentProviderCatalogResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as PaymentProviderCatalogResponse;
  return 'PaymentProviderCatalogResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $PaymentProviderCatalogResponseCopyWith<$Res>  {
  factory $PaymentProviderCatalogResponseCopyWith(PaymentProviderCatalogResponse value, $Res Function(PaymentProviderCatalogResponse) _then) = _$PaymentProviderCatalogResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') PaymentProviderCatalogData? data
});


$PaymentProviderCatalogDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$PaymentProviderCatalogResponseCopyWithImpl<$Res>
    implements $PaymentProviderCatalogResponseCopyWith<$Res> {
  _$PaymentProviderCatalogResponseCopyWithImpl(this._self, this._then);

  final PaymentProviderCatalogResponse _self;
  final $Res Function(PaymentProviderCatalogResponse) _then;

/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(PaymentProviderCatalogResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PaymentProviderCatalogData?,
  ));
}
/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentProviderCatalogDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PaymentProviderCatalogDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentProviderCatalogResponse].
extension PaymentProviderCatalogResponsePatterns on PaymentProviderCatalogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentProviderCatalogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentProviderCatalogResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentProviderCatalogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  PaymentProviderCatalogData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  PaymentProviderCatalogData? data)  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  PaymentProviderCatalogData? data)?  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentProviderCatalogResponse implements PaymentProviderCatalogResponse {
  const _PaymentProviderCatalogResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _PaymentProviderCatalogResponse.fromJson(Map<String, dynamic> json) => _$PaymentProviderCatalogResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  PaymentProviderCatalogData? data;

/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentProviderCatalogResponseCopyWith<_PaymentProviderCatalogResponse> get copyWith => __$PaymentProviderCatalogResponseCopyWithImpl<_PaymentProviderCatalogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentProviderCatalogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentProviderCatalogResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'PaymentProviderCatalogResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PaymentProviderCatalogResponseCopyWith<$Res> implements $PaymentProviderCatalogResponseCopyWith<$Res> {
  factory _$PaymentProviderCatalogResponseCopyWith(_PaymentProviderCatalogResponse value, $Res Function(_PaymentProviderCatalogResponse) _then) = __$PaymentProviderCatalogResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') PaymentProviderCatalogData? data
});


@override $PaymentProviderCatalogDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$PaymentProviderCatalogResponseCopyWithImpl<$Res>
    implements _$PaymentProviderCatalogResponseCopyWith<$Res> {
  __$PaymentProviderCatalogResponseCopyWithImpl(this._self, this._then);

  final _PaymentProviderCatalogResponse _self;
  final $Res Function(_PaymentProviderCatalogResponse) _then;

/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_PaymentProviderCatalogResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PaymentProviderCatalogData?,
  ));
}

/// Create a copy of PaymentProviderCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentProviderCatalogDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PaymentProviderCatalogDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PaymentProviderCatalogData {

@JsonKey(name: 'version') int? get version;@JsonKey(name: 'providers') List<PaymentProviderData>? get providers;
/// Create a copy of PaymentProviderCatalogData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentProviderCatalogDataCopyWith<PaymentProviderCatalogData> get copyWith => _$PaymentProviderCatalogDataCopyWithImpl<PaymentProviderCatalogData>(this as PaymentProviderCatalogData, _$identity);

  /// Serializes this PaymentProviderCatalogData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentProviderCatalogData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentProviderCatalogData&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.providers, _this.providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentProviderCatalogData;
  return Object.hash(runtimeType,_this.version,const DeepCollectionEquality().hash(_this.providers));
}

@override
String toString() {
  final _this = this as PaymentProviderCatalogData;
  return 'PaymentProviderCatalogData(version: ${_this.version}, providers: ${_this.providers})';
}


}

/// @nodoc
abstract mixin class $PaymentProviderCatalogDataCopyWith<$Res>  {
  factory $PaymentProviderCatalogDataCopyWith(PaymentProviderCatalogData value, $Res Function(PaymentProviderCatalogData) _then) = _$PaymentProviderCatalogDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'providers') List<PaymentProviderData>? providers
});




}
/// @nodoc
class _$PaymentProviderCatalogDataCopyWithImpl<$Res>
    implements $PaymentProviderCatalogDataCopyWith<$Res> {
  _$PaymentProviderCatalogDataCopyWithImpl(this._self, this._then);

  final PaymentProviderCatalogData _self;
  final $Res Function(PaymentProviderCatalogData) _then;

/// Create a copy of PaymentProviderCatalogData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? providers = freezed,}) {
  return _then(PaymentProviderCatalogData(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,providers: freezed == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<PaymentProviderData>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentProviderCatalogData].
extension PaymentProviderCatalogDataPatterns on PaymentProviderCatalogData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentProviderCatalogData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentProviderCatalogData value)  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentProviderCatalogData value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderCatalogData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'version')  int? version, @JsonKey(name: 'providers')  List<PaymentProviderData>? providers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogData() when $default != null:
return $default(_that.version,_that.providers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'version')  int? version, @JsonKey(name: 'providers')  List<PaymentProviderData>? providers)  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogData():
return $default(_that.version,_that.providers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'version')  int? version, @JsonKey(name: 'providers')  List<PaymentProviderData>? providers)?  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderCatalogData() when $default != null:
return $default(_that.version,_that.providers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentProviderCatalogData implements PaymentProviderCatalogData {
  const _PaymentProviderCatalogData({@JsonKey(name: 'version') this.version, @JsonKey(name: 'providers')  List<PaymentProviderData>? providers}): _providers = providers;
  factory _PaymentProviderCatalogData.fromJson(Map<String, dynamic> json) => _$PaymentProviderCatalogDataFromJson(json);

@override@JsonKey(name: 'version') final  int? version;
 final  List<PaymentProviderData>? _providers;
@override@JsonKey(name: 'providers') List<PaymentProviderData>? get providers {
  final value = _providers;
  if (value == null) return null;
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PaymentProviderCatalogData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentProviderCatalogDataCopyWith<_PaymentProviderCatalogData> get copyWith => __$PaymentProviderCatalogDataCopyWithImpl<_PaymentProviderCatalogData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentProviderCatalogDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentProviderCatalogData&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.providers, _providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_providers));
}

@override
String toString() {
    return 'PaymentProviderCatalogData(version: $version, providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$PaymentProviderCatalogDataCopyWith<$Res> implements $PaymentProviderCatalogDataCopyWith<$Res> {
  factory _$PaymentProviderCatalogDataCopyWith(_PaymentProviderCatalogData value, $Res Function(_PaymentProviderCatalogData) _then) = __$PaymentProviderCatalogDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') int? version,@JsonKey(name: 'providers') List<PaymentProviderData>? providers
});




}
/// @nodoc
class __$PaymentProviderCatalogDataCopyWithImpl<$Res>
    implements _$PaymentProviderCatalogDataCopyWith<$Res> {
  __$PaymentProviderCatalogDataCopyWithImpl(this._self, this._then);

  final _PaymentProviderCatalogData _self;
  final $Res Function(_PaymentProviderCatalogData) _then;

/// Create a copy of PaymentProviderCatalogData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? providers = freezed,}) {
  return _then(_PaymentProviderCatalogData(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,providers: freezed == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<PaymentProviderData>?,
  ));
}


}


/// @nodoc
mixin _$PaymentProviderData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'slug') String? get slug;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'aliases') List<String>? get aliases;@JsonKey(name: 'sort_order') int? get sortOrder;
/// Create a copy of PaymentProviderData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentProviderDataCopyWith<PaymentProviderData> get copyWith => _$PaymentProviderDataCopyWithImpl<PaymentProviderData>(this as PaymentProviderData, _$identity);

  /// Serializes this PaymentProviderData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentProviderData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentProviderData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentProviderData;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.type,_this.logoUrl,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder);
}

@override
String toString() {
  final _this = this as PaymentProviderData;
  return 'PaymentProviderData(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, type: ${_this.type}, logoUrl: ${_this.logoUrl}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $PaymentProviderDataCopyWith<$Res>  {
  factory $PaymentProviderDataCopyWith(PaymentProviderData value, $Res Function(PaymentProviderData) _then) = _$PaymentProviderDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'aliases') List<String>? aliases,@JsonKey(name: 'sort_order') int? sortOrder
});




}
/// @nodoc
class _$PaymentProviderDataCopyWithImpl<$Res>
    implements $PaymentProviderDataCopyWith<$Res> {
  _$PaymentProviderDataCopyWithImpl(this._self, this._then);

  final PaymentProviderData _self;
  final $Res Function(PaymentProviderData) _then;

/// Create a copy of PaymentProviderData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? slug = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(PaymentProviderData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentProviderData].
extension PaymentProviderDataPatterns on PaymentProviderData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentProviderData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentProviderData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentProviderData value)  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentProviderData value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentProviderData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentProviderData() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder)  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderData():
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _PaymentProviderData() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentProviderData implements PaymentProviderData {
  const _PaymentProviderData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'slug') this.slug, @JsonKey(name: 'name') this.name, @JsonKey(name: 'type') this.type, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order') this.sortOrder}): _aliases = aliases;
  factory _PaymentProviderData.fromJson(Map<String, dynamic> json) => _$PaymentProviderDataFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'slug') final  String? slug;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
 final  List<String>? _aliases;
@override@JsonKey(name: 'aliases') List<String>? get aliases {
  final value = _aliases;
  if (value == null) return null;
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'sort_order') final  int? sortOrder;

/// Create a copy of PaymentProviderData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentProviderDataCopyWith<_PaymentProviderData> get copyWith => __$PaymentProviderDataCopyWithImpl<_PaymentProviderData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentProviderDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentProviderData&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,type,logoUrl,const DeepCollectionEquality().hash(_aliases),sortOrder);
}

@override
String toString() {
    return 'PaymentProviderData(id: $id, slug: $slug, name: $name, type: $type, logoUrl: $logoUrl, aliases: $aliases, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$PaymentProviderDataCopyWith<$Res> implements $PaymentProviderDataCopyWith<$Res> {
  factory _$PaymentProviderDataCopyWith(_PaymentProviderData value, $Res Function(_PaymentProviderData) _then) = __$PaymentProviderDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'aliases') List<String>? aliases,@JsonKey(name: 'sort_order') int? sortOrder
});




}
/// @nodoc
class __$PaymentProviderDataCopyWithImpl<$Res>
    implements _$PaymentProviderDataCopyWith<$Res> {
  __$PaymentProviderDataCopyWithImpl(this._self, this._then);

  final _PaymentProviderData _self;
  final $Res Function(_PaymentProviderData) _then;

/// Create a copy of PaymentProviderData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? slug = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? aliases = freezed,Object? sortOrder = freezed,}) {
  return _then(_PaymentProviderData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
