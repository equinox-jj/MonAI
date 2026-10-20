// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_category_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateCategoryRequest {

@JsonKey(name: 'name', includeIfNull: false) String? get name;@JsonKey(name: 'icon', includeIfNull: false) String? get icon;@JsonKey(name: 'color', includeIfNull: false) String? get color;@JsonKey(name: 'is_hidden', includeIfNull: false) bool? get isHidden;
/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCategoryRequestCopyWith<UpdateCategoryRequest> get copyWith => _$UpdateCategoryRequestCopyWithImpl<UpdateCategoryRequest>(this as UpdateCategoryRequest, _$identity);

  /// Serializes this UpdateCategoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateCategoryRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCategoryRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isHidden, _this.isHidden) || other.isHidden == _this.isHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateCategoryRequest;
  return Object.hash(runtimeType,_this.name,_this.icon,_this.color,_this.isHidden);
}

@override
String toString() {
  final _this = this as UpdateCategoryRequest;
  return 'UpdateCategoryRequest(name: ${_this.name}, icon: ${_this.icon}, color: ${_this.color}, isHidden: ${_this.isHidden})';
}


}

/// @nodoc
abstract mixin class $UpdateCategoryRequestCopyWith<$Res>  {
  factory $UpdateCategoryRequestCopyWith(UpdateCategoryRequest value, $Res Function(UpdateCategoryRequest) _then) = _$UpdateCategoryRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'icon', includeIfNull: false) String? icon,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_hidden', includeIfNull: false) bool? isHidden
});




}
/// @nodoc
class _$UpdateCategoryRequestCopyWithImpl<$Res>
    implements $UpdateCategoryRequestCopyWith<$Res> {
  _$UpdateCategoryRequestCopyWithImpl(this._self, this._then);

  final UpdateCategoryRequest _self;
  final $Res Function(UpdateCategoryRequest) _then;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? isHidden = freezed,}) {
  return _then(UpdateCategoryRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCategoryRequest].
extension UpdateCategoryRequestPatterns on UpdateCategoryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateCategoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateCategoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateCategoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'icon', includeIfNull: false)  String? icon, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_hidden', includeIfNull: false)  bool? isHidden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
return $default(_that.name,_that.icon,_that.color,_that.isHidden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'icon', includeIfNull: false)  String? icon, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_hidden', includeIfNull: false)  bool? isHidden)  $default,) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest():
return $default(_that.name,_that.icon,_that.color,_that.isHidden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name', includeIfNull: false)  String? name, @JsonKey(name: 'icon', includeIfNull: false)  String? icon, @JsonKey(name: 'color', includeIfNull: false)  String? color, @JsonKey(name: 'is_hidden', includeIfNull: false)  bool? isHidden)?  $default,) {final _that = this;
switch (_that) {
case _UpdateCategoryRequest() when $default != null:
return $default(_that.name,_that.icon,_that.color,_that.isHidden);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateCategoryRequest implements UpdateCategoryRequest {
  const _UpdateCategoryRequest({@JsonKey(name: 'name', includeIfNull: false) this.name, @JsonKey(name: 'icon', includeIfNull: false) this.icon, @JsonKey(name: 'color', includeIfNull: false) this.color, @JsonKey(name: 'is_hidden', includeIfNull: false) this.isHidden});
  factory _UpdateCategoryRequest.fromJson(Map<String, dynamic> json) => _$UpdateCategoryRequestFromJson(json);

@override@JsonKey(name: 'name', includeIfNull: false) final  String? name;
@override@JsonKey(name: 'icon', includeIfNull: false) final  String? icon;
@override@JsonKey(name: 'color', includeIfNull: false) final  String? color;
@override@JsonKey(name: 'is_hidden', includeIfNull: false) final  bool? isHidden;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCategoryRequestCopyWith<_UpdateCategoryRequest> get copyWith => __$UpdateCategoryRequestCopyWithImpl<_UpdateCategoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateCategoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCategoryRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,icon,color,isHidden);
}

@override
String toString() {
    return 'UpdateCategoryRequest(name: $name, icon: $icon, color: $color, isHidden: $isHidden)';
}


}

/// @nodoc
abstract mixin class _$UpdateCategoryRequestCopyWith<$Res> implements $UpdateCategoryRequestCopyWith<$Res> {
  factory _$UpdateCategoryRequestCopyWith(_UpdateCategoryRequest value, $Res Function(_UpdateCategoryRequest) _then) = __$UpdateCategoryRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name', includeIfNull: false) String? name,@JsonKey(name: 'icon', includeIfNull: false) String? icon,@JsonKey(name: 'color', includeIfNull: false) String? color,@JsonKey(name: 'is_hidden', includeIfNull: false) bool? isHidden
});




}
/// @nodoc
class __$UpdateCategoryRequestCopyWithImpl<$Res>
    implements _$UpdateCategoryRequestCopyWith<$Res> {
  __$UpdateCategoryRequestCopyWithImpl(this._self, this._then);

  final _UpdateCategoryRequest _self;
  final $Res Function(_UpdateCategoryRequest) _then;

/// Create a copy of UpdateCategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? isHidden = freezed,}) {
  return _then(_UpdateCategoryRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
