// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_provider_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminProviderResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') AdminProviderData? get data;
/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProviderResponseCopyWith<AdminProviderResponse> get copyWith => _$AdminProviderResponseCopyWithImpl<AdminProviderResponse>(this as AdminProviderResponse, _$identity);

  /// Serializes this AdminProviderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProviderResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProviderResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProviderResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as AdminProviderResponse;
  return 'AdminProviderResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $AdminProviderResponseCopyWith<$Res>  {
  factory $AdminProviderResponseCopyWith(AdminProviderResponse value, $Res Function(AdminProviderResponse) _then) = _$AdminProviderResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') AdminProviderData? data
});


$AdminProviderDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$AdminProviderResponseCopyWithImpl<$Res>
    implements $AdminProviderResponseCopyWith<$Res> {
  _$AdminProviderResponseCopyWithImpl(this._self, this._then);

  final AdminProviderResponse _self;
  final $Res Function(AdminProviderResponse) _then;

/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(AdminProviderResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdminProviderData?,
  ));
}
/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProviderDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdminProviderDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminProviderResponse].
extension AdminProviderResponsePatterns on AdminProviderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProviderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProviderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProviderResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminProviderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProviderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProviderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  AdminProviderData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProviderResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  AdminProviderData? data)  $default,) {final _that = this;
switch (_that) {
case _AdminProviderResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  AdminProviderData? data)?  $default,) {final _that = this;
switch (_that) {
case _AdminProviderResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProviderResponse implements AdminProviderResponse {
  const _AdminProviderResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _AdminProviderResponse.fromJson(Map<String, dynamic> json) => _$AdminProviderResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  AdminProviderData? data;

/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProviderResponseCopyWith<_AdminProviderResponse> get copyWith => __$AdminProviderResponseCopyWithImpl<_AdminProviderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProviderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProviderResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'AdminProviderResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AdminProviderResponseCopyWith<$Res> implements $AdminProviderResponseCopyWith<$Res> {
  factory _$AdminProviderResponseCopyWith(_AdminProviderResponse value, $Res Function(_AdminProviderResponse) _then) = __$AdminProviderResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') AdminProviderData? data
});


@override $AdminProviderDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$AdminProviderResponseCopyWithImpl<$Res>
    implements _$AdminProviderResponseCopyWith<$Res> {
  __$AdminProviderResponseCopyWithImpl(this._self, this._then);

  final _AdminProviderResponse _self;
  final $Res Function(_AdminProviderResponse) _then;

/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_AdminProviderResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdminProviderData?,
  ));
}

/// Create a copy of AdminProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProviderDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdminProviderDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AdminProviderData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'slug') String? get slug;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'aliases') List<String>? get aliases;@JsonKey(name: 'sort_order') int? get sortOrder;@JsonKey(name: 'is_active') bool? get isActive;@JsonKey(name: 'is_system') bool? get isSystem;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of AdminProviderData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProviderDataCopyWith<AdminProviderData> get copyWith => _$AdminProviderDataCopyWithImpl<AdminProviderData>(this as AdminProviderData, _$identity);

  /// Serializes this AdminProviderData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminProviderData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProviderData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminProviderData;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.type,_this.logoUrl,const DeepCollectionEquality().hash(_this.aliases),_this.sortOrder,_this.isActive,_this.isSystem,_this.updatedAt);
}

@override
String toString() {
  final _this = this as AdminProviderData;
  return 'AdminProviderData(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, type: ${_this.type}, logoUrl: ${_this.logoUrl}, aliases: ${_this.aliases}, sortOrder: ${_this.sortOrder}, isActive: ${_this.isActive}, isSystem: ${_this.isSystem}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $AdminProviderDataCopyWith<$Res>  {
  factory $AdminProviderDataCopyWith(AdminProviderData value, $Res Function(AdminProviderData) _then) = _$AdminProviderDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'aliases') List<String>? aliases,@JsonKey(name: 'sort_order') int? sortOrder,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'is_system') bool? isSystem,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$AdminProviderDataCopyWithImpl<$Res>
    implements $AdminProviderDataCopyWith<$Res> {
  _$AdminProviderDataCopyWithImpl(this._self, this._then);

  final AdminProviderData _self;
  final $Res Function(AdminProviderData) _then;

/// Create a copy of AdminProviderData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? slug = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? aliases = freezed,Object? sortOrder = freezed,Object? isActive = freezed,Object? isSystem = freezed,Object? updatedAt = freezed,}) {
  return _then(AdminProviderData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProviderData].
extension AdminProviderDataPatterns on AdminProviderData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProviderData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProviderData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProviderData value)  $default,){
final _that = this;
switch (_that) {
case _AdminProviderData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProviderData value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProviderData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProviderData() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AdminProviderData():
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order')  int? sortOrder, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminProviderData() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.type,_that.logoUrl,_that.aliases,_that.sortOrder,_that.isActive,_that.isSystem,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProviderData implements AdminProviderData {
  const _AdminProviderData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'slug') this.slug, @JsonKey(name: 'name') this.name, @JsonKey(name: 'type') this.type, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'aliases')  List<String>? aliases, @JsonKey(name: 'sort_order') this.sortOrder, @JsonKey(name: 'is_active') this.isActive, @JsonKey(name: 'is_system') this.isSystem, @JsonKey(name: 'updated_at') this.updatedAt}): _aliases = aliases;
  factory _AdminProviderData.fromJson(Map<String, dynamic> json) => _$AdminProviderDataFromJson(json);

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
@override@JsonKey(name: 'is_active') final  bool? isActive;
@override@JsonKey(name: 'is_system') final  bool? isSystem;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of AdminProviderData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProviderDataCopyWith<_AdminProviderData> get copyWith => __$AdminProviderDataCopyWithImpl<_AdminProviderData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProviderDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProviderData&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,type,logoUrl,const DeepCollectionEquality().hash(_aliases),sortOrder,isActive,isSystem,updatedAt);
}

@override
String toString() {
    return 'AdminProviderData(id: $id, slug: $slug, name: $name, type: $type, logoUrl: $logoUrl, aliases: $aliases, sortOrder: $sortOrder, isActive: $isActive, isSystem: $isSystem, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AdminProviderDataCopyWith<$Res> implements $AdminProviderDataCopyWith<$Res> {
  factory _$AdminProviderDataCopyWith(_AdminProviderData value, $Res Function(_AdminProviderData) _then) = __$AdminProviderDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'aliases') List<String>? aliases,@JsonKey(name: 'sort_order') int? sortOrder,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'is_system') bool? isSystem,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$AdminProviderDataCopyWithImpl<$Res>
    implements _$AdminProviderDataCopyWith<$Res> {
  __$AdminProviderDataCopyWithImpl(this._self, this._then);

  final _AdminProviderData _self;
  final $Res Function(_AdminProviderData) _then;

/// Create a copy of AdminProviderData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? slug = freezed,Object? name = freezed,Object? type = freezed,Object? logoUrl = freezed,Object? aliases = freezed,Object? sortOrder = freezed,Object? isActive = freezed,Object? isSystem = freezed,Object? updatedAt = freezed,}) {
  return _then(_AdminProviderData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
