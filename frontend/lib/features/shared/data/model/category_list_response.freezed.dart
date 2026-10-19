// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryListResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') List<CategoryData>? get data;
/// Create a copy of CategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryListResponseCopyWith<CategoryListResponse> get copyWith => _$CategoryListResponseCopyWithImpl<CategoryListResponse>(this as CategoryListResponse, _$identity);

  /// Serializes this CategoryListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.data, _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryListResponse;
  return Object.hash(runtimeType,_this.success,_this.message,const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as CategoryListResponse;
  return 'CategoryListResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CategoryListResponseCopyWith<$Res>  {
  factory $CategoryListResponseCopyWith(CategoryListResponse value, $Res Function(CategoryListResponse) _then) = _$CategoryListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<CategoryData>? data
});




}
/// @nodoc
class _$CategoryListResponseCopyWithImpl<$Res>
    implements $CategoryListResponseCopyWith<$Res> {
  _$CategoryListResponseCopyWithImpl(this._self, this._then);

  final CategoryListResponse _self;
  final $Res Function(CategoryListResponse) _then;

/// Create a copy of CategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(CategoryListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CategoryData>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryListResponse].
extension CategoryListResponsePatterns on CategoryListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryListResponse value)  $default,){
final _that = this;
switch (_that) {
case _CategoryListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<CategoryData>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<CategoryData>? data)  $default,) {final _that = this;
switch (_that) {
case _CategoryListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  List<CategoryData>? data)?  $default,) {final _that = this;
switch (_that) {
case _CategoryListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryListResponse implements CategoryListResponse {
  const _CategoryListResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data')  List<CategoryData>? data}): _data = data;
  factory _CategoryListResponse.fromJson(Map<String, dynamic> json) => _$CategoryListResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
 final  List<CategoryData>? _data;
@override@JsonKey(name: 'data') List<CategoryData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryListResponseCopyWith<_CategoryListResponse> get copyWith => __$CategoryListResponseCopyWithImpl<_CategoryListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'CategoryListResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CategoryListResponseCopyWith<$Res> implements $CategoryListResponseCopyWith<$Res> {
  factory _$CategoryListResponseCopyWith(_CategoryListResponse value, $Res Function(_CategoryListResponse) _then) = __$CategoryListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') List<CategoryData>? data
});




}
/// @nodoc
class __$CategoryListResponseCopyWithImpl<$Res>
    implements _$CategoryListResponseCopyWith<$Res> {
  __$CategoryListResponseCopyWithImpl(this._self, this._then);

  final _CategoryListResponse _self;
  final $Res Function(_CategoryListResponse) _then;

/// Create a copy of CategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_CategoryListResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CategoryData>?,
  ));
}


}


/// @nodoc
mixin _$CategoryData {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'color') String? get color;@JsonKey(name: 'is_default') bool? get isDefault;@JsonKey(name: 'is_system') bool? get isSystem;@JsonKey(name: 'is_hidden') bool? get isHidden;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDataCopyWith<CategoryData> get copyWith => _$CategoryDataCopyWithImpl<CategoryData>(this as CategoryData, _$identity);

  /// Serializes this CategoryData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&(identical(other.isHidden, _this.isHidden) || other.isHidden == _this.isHidden)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryData;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.icon,_this.color,_this.isDefault,_this.isSystem,_this.isHidden,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as CategoryData;
  return 'CategoryData(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, icon: ${_this.icon}, color: ${_this.color}, isDefault: ${_this.isDefault}, isSystem: ${_this.isSystem}, isHidden: ${_this.isHidden}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CategoryDataCopyWith<$Res>  {
  factory $CategoryDataCopyWith(CategoryData value, $Res Function(CategoryData) _then) = _$CategoryDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'is_default') bool? isDefault,@JsonKey(name: 'is_system') bool? isSystem,@JsonKey(name: 'is_hidden') bool? isHidden,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$CategoryDataCopyWithImpl<$Res>
    implements $CategoryDataCopyWith<$Res> {
  _$CategoryDataCopyWithImpl(this._self, this._then);

  final CategoryData _self;
  final $Res Function(CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? type = freezed,Object? icon = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isSystem = freezed,Object? isHidden = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(CategoryData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryData].
extension CategoryDataPatterns on CategoryData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryData value)  $default,){
final _that = this;
switch (_that) {
case _CategoryData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryData value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'is_hidden')  bool? isHidden, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.icon,_that.color,_that.isDefault,_that.isSystem,_that.isHidden,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'is_hidden')  bool? isHidden, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryData():
return $default(_that.id,_that.name,_that.type,_that.icon,_that.color,_that.isDefault,_that.isSystem,_that.isHidden,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'is_default')  bool? isDefault, @JsonKey(name: 'is_system')  bool? isSystem, @JsonKey(name: 'is_hidden')  bool? isHidden, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.icon,_that.color,_that.isDefault,_that.isSystem,_that.isHidden,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryData implements CategoryData {
  const _CategoryData({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'type') this.type, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'color') this.color, @JsonKey(name: 'is_default') this.isDefault, @JsonKey(name: 'is_system') this.isSystem, @JsonKey(name: 'is_hidden') this.isHidden, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'color') final  String? color;
@override@JsonKey(name: 'is_default') final  bool? isDefault;
@override@JsonKey(name: 'is_system') final  bool? isSystem;
@override@JsonKey(name: 'is_hidden') final  bool? isHidden;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDataCopyWith<_CategoryData> get copyWith => __$CategoryDataCopyWithImpl<_CategoryData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,icon,color,isDefault,isSystem,isHidden,createdAt,updatedAt);
}

@override
String toString() {
    return 'CategoryData(id: $id, name: $name, type: $type, icon: $icon, color: $color, isDefault: $isDefault, isSystem: $isSystem, isHidden: $isHidden, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryDataCopyWith<$Res> implements $CategoryDataCopyWith<$Res> {
  factory _$CategoryDataCopyWith(_CategoryData value, $Res Function(_CategoryData) _then) = __$CategoryDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'type') String? type,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'is_default') bool? isDefault,@JsonKey(name: 'is_system') bool? isSystem,@JsonKey(name: 'is_hidden') bool? isHidden,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$CategoryDataCopyWithImpl<$Res>
    implements _$CategoryDataCopyWith<$Res> {
  __$CategoryDataCopyWithImpl(this._self, this._then);

  final _CategoryData _self;
  final $Res Function(_CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? type = freezed,Object? icon = freezed,Object? color = freezed,Object? isDefault = freezed,Object? isSystem = freezed,Object? isHidden = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CategoryData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isDefault: freezed == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool?,isSystem: freezed == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
