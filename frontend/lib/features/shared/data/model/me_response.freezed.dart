// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') MeData? get data;
/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeResponseCopyWith<MeResponse> get copyWith => _$MeResponseCopyWithImpl<MeResponse>(this as MeResponse, _$identity);

  /// Serializes this MeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as MeResponse;
  return 'MeResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $MeResponseCopyWith<$Res>  {
  factory $MeResponseCopyWith(MeResponse value, $Res Function(MeResponse) _then) = _$MeResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') MeData? data
});


$MeDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$MeResponseCopyWithImpl<$Res>
    implements $MeResponseCopyWith<$Res> {
  _$MeResponseCopyWithImpl(this._self, this._then);

  final MeResponse _self;
  final $Res Function(MeResponse) _then;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(MeResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MeData?,
  ));
}
/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MeDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeResponse].
extension MeResponsePatterns on MeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeResponse value)  $default,){
final _that = this;
switch (_that) {
case _MeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MeData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MeData? data)  $default,) {final _that = this;
switch (_that) {
case _MeResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MeData? data)?  $default,) {final _that = this;
switch (_that) {
case _MeResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeResponse implements MeResponse {
  const _MeResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _MeResponse.fromJson(Map<String, dynamic> json) => _$MeResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  MeData? data;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeResponseCopyWith<_MeResponse> get copyWith => __$MeResponseCopyWithImpl<_MeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'MeResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MeResponseCopyWith<$Res> implements $MeResponseCopyWith<$Res> {
  factory _$MeResponseCopyWith(_MeResponse value, $Res Function(_MeResponse) _then) = __$MeResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') MeData? data
});


@override $MeDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$MeResponseCopyWithImpl<$Res>
    implements _$MeResponseCopyWith<$Res> {
  __$MeResponseCopyWithImpl(this._self, this._then);

  final _MeResponse _self;
  final $Res Function(_MeResponse) _then;

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_MeResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MeData?,
  ));
}

/// Create a copy of MeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MeDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MeData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'email') String? get email;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'role') MeRole? get role;@JsonKey(name: 'permissions') List<String>? get permissions;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeDataCopyWith<MeData> get copyWith => _$MeDataCopyWithImpl<MeData>(this as MeData, _$identity);

  /// Serializes this MeData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.role, _this.role) || other.role == _this.role)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeData;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.avatarUrl,_this.timezone,_this.role,const DeepCollectionEquality().hash(_this.permissions),_this.createdAt);
}

@override
String toString() {
  final _this = this as MeData;
  return 'MeData(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, avatarUrl: ${_this.avatarUrl}, timezone: ${_this.timezone}, role: ${_this.role}, permissions: ${_this.permissions}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MeDataCopyWith<$Res>  {
  factory $MeDataCopyWith(MeData value, $Res Function(MeData) _then) = _$MeDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'email') String? email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'role') MeRole? role,@JsonKey(name: 'permissions') List<String>? permissions,@JsonKey(name: 'created_at') DateTime? createdAt
});


$MeRoleCopyWith<$Res>? get role;

}
/// @nodoc
class _$MeDataCopyWithImpl<$Res>
    implements $MeDataCopyWith<$Res> {
  _$MeDataCopyWithImpl(this._self, this._then);

  final MeData _self;
  final $Res Function(MeData) _then;

/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? avatarUrl = freezed,Object? timezone = freezed,Object? role = freezed,Object? permissions = freezed,Object? createdAt = freezed,}) {
  return _then(MeData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MeRole?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeRoleCopyWith<$Res>? get role {
    if (_self.role == null) {
    return null;
  }

  return $MeRoleCopyWith<$Res>(_self.role!, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeData].
extension MeDataPatterns on MeData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeData value)  $default,){
final _that = this;
switch (_that) {
case _MeData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeData value)?  $default,){
final _that = this;
switch (_that) {
case _MeData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'role')  MeRole? role, @JsonKey(name: 'permissions')  List<String>? permissions, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeData() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.timezone,_that.role,_that.permissions,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'role')  MeRole? role, @JsonKey(name: 'permissions')  List<String>? permissions, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MeData():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.timezone,_that.role,_that.permissions,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'role')  MeRole? role, @JsonKey(name: 'permissions')  List<String>? permissions, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MeData() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.timezone,_that.role,_that.permissions,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeData implements MeData {
  const _MeData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'email') this.email, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'role') this.role, @JsonKey(name: 'permissions')  List<String>? permissions, @JsonKey(name: 'created_at') this.createdAt}): _permissions = permissions;
  factory _MeData.fromJson(Map<String, dynamic> json) => _$MeDataFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'email') final  String? email;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'role') final  MeRole? role;
 final  List<String>? _permissions;
@override@JsonKey(name: 'permissions') List<String>? get permissions {
  final value = _permissions;
  if (value == null) return null;
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeDataCopyWith<_MeData> get copyWith => __$MeDataCopyWithImpl<_MeData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,avatarUrl,timezone,role,const DeepCollectionEquality().hash(_permissions),createdAt);
}

@override
String toString() {
    return 'MeData(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, timezone: $timezone, role: $role, permissions: $permissions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MeDataCopyWith<$Res> implements $MeDataCopyWith<$Res> {
  factory _$MeDataCopyWith(_MeData value, $Res Function(_MeData) _then) = __$MeDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'email') String? email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'role') MeRole? role,@JsonKey(name: 'permissions') List<String>? permissions,@JsonKey(name: 'created_at') DateTime? createdAt
});


@override $MeRoleCopyWith<$Res>? get role;

}
/// @nodoc
class __$MeDataCopyWithImpl<$Res>
    implements _$MeDataCopyWith<$Res> {
  __$MeDataCopyWithImpl(this._self, this._then);

  final _MeData _self;
  final $Res Function(_MeData) _then;

/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? avatarUrl = freezed,Object? timezone = freezed,Object? role = freezed,Object? permissions = freezed,Object? createdAt = freezed,}) {
  return _then(_MeData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MeRole?,permissions: freezed == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MeData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeRoleCopyWith<$Res>? get role {
    if (_self.role == null) {
    return null;
  }

  return $MeRoleCopyWith<$Res>(_self.role!, (value) {
    return _then(_self.copyWith(role: value));
  });
}
}


/// @nodoc
mixin _$MeRole {

@JsonKey(name: 'slug') String? get slug;@JsonKey(name: 'name') String? get name;
/// Create a copy of MeRole
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeRoleCopyWith<MeRole> get copyWith => _$MeRoleCopyWithImpl<MeRole>(this as MeRole, _$identity);

  /// Serializes this MeRole to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeRole;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeRole&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeRole;
  return Object.hash(runtimeType,_this.slug,_this.name);
}

@override
String toString() {
  final _this = this as MeRole;
  return 'MeRole(slug: ${_this.slug}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $MeRoleCopyWith<$Res>  {
  factory $MeRoleCopyWith(MeRole value, $Res Function(MeRole) _then) = _$MeRoleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name
});




}
/// @nodoc
class _$MeRoleCopyWithImpl<$Res>
    implements $MeRoleCopyWith<$Res> {
  _$MeRoleCopyWithImpl(this._self, this._then);

  final MeRole _self;
  final $Res Function(MeRole) _then;

/// Create a copy of MeRole
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = freezed,Object? name = freezed,}) {
  return _then(MeRole(
slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeRole].
extension MeRolePatterns on MeRole {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeRole value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeRole() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeRole value)  $default,){
final _that = this;
switch (_that) {
case _MeRole():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeRole value)?  $default,){
final _that = this;
switch (_that) {
case _MeRole() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeRole() when $default != null:
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name)  $default,) {final _that = this;
switch (_that) {
case _MeRole():
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'name')  String? name)?  $default,) {final _that = this;
switch (_that) {
case _MeRole() when $default != null:
return $default(_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeRole implements MeRole {
  const _MeRole({@JsonKey(name: 'slug') this.slug, @JsonKey(name: 'name') this.name});
  factory _MeRole.fromJson(Map<String, dynamic> json) => _$MeRoleFromJson(json);

@override@JsonKey(name: 'slug') final  String? slug;
@override@JsonKey(name: 'name') final  String? name;

/// Create a copy of MeRole
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeRoleCopyWith<_MeRole> get copyWith => __$MeRoleCopyWithImpl<_MeRole>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeRoleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeRole&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slug,name);
}

@override
String toString() {
    return 'MeRole(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MeRoleCopyWith<$Res> implements $MeRoleCopyWith<$Res> {
  factory _$MeRoleCopyWith(_MeRole value, $Res Function(_MeRole) _then) = __$MeRoleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'name') String? name
});




}
/// @nodoc
class __$MeRoleCopyWithImpl<$Res>
    implements _$MeRoleCopyWith<$Res> {
  __$MeRoleCopyWithImpl(this._self, this._then);

  final _MeRole _self;
  final $Res Function(_MeRole) _then;

/// Create a copy of MeRole
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = freezed,Object? name = freezed,}) {
  return _then(_MeRole(
slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
