// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryInput {

 String get name; CategoryType get type;/// A Material Symbols name, e.g. `local_cafe`.
 String? get icon;/// `#RRGGBB`.
 String? get color;
/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryInputCopyWith<CategoryInput> get copyWith => _$CategoryInputCopyWithImpl<CategoryInput>(this as CategoryInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color));
}


@override
int get hashCode {
  final _this = this as CategoryInput;
  return Object.hash(runtimeType,_this.name,_this.type,_this.icon,_this.color);
}

@override
String toString() {
  final _this = this as CategoryInput;
  return 'CategoryInput(name: ${_this.name}, type: ${_this.type}, icon: ${_this.icon}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $CategoryInputCopyWith<$Res>  {
  factory $CategoryInputCopyWith(CategoryInput value, $Res Function(CategoryInput) _then) = _$CategoryInputCopyWithImpl;
@useResult
$Res call({
 String name, CategoryType type, String? icon, String? color
});




}
/// @nodoc
class _$CategoryInputCopyWithImpl<$Res>
    implements $CategoryInputCopyWith<$Res> {
  _$CategoryInputCopyWithImpl(this._self, this._then);

  final CategoryInput _self;
  final $Res Function(CategoryInput) _then;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? icon = freezed,Object? color = freezed,}) {
  return _then(CategoryInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryInput].
extension CategoryInputPatterns on CategoryInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryInput value)  $default,){
final _that = this;
switch (_that) {
case _CategoryInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryInput value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  CategoryType type,  String? icon,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that.name,_that.type,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  CategoryType type,  String? icon,  String? color)  $default,) {final _that = this;
switch (_that) {
case _CategoryInput():
return $default(_that.name,_that.type,_that.icon,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  CategoryType type,  String? icon,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _CategoryInput() when $default != null:
return $default(_that.name,_that.type,_that.icon,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryInput extends CategoryInput {
  const _CategoryInput({required this.name, required this.type, this.icon, this.color}): super._();
  

@override final  String name;
@override final  CategoryType type;
/// A Material Symbols name, e.g. `local_cafe`.
@override final  String? icon;
/// `#RRGGBB`.
@override final  String? color;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryInputCopyWith<_CategoryInput> get copyWith => __$CategoryInputCopyWithImpl<_CategoryInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryInput&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,type,icon,color);
}

@override
String toString() {
    return 'CategoryInput(name: $name, type: $type, icon: $icon, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CategoryInputCopyWith<$Res> implements $CategoryInputCopyWith<$Res> {
  factory _$CategoryInputCopyWith(_CategoryInput value, $Res Function(_CategoryInput) _then) = __$CategoryInputCopyWithImpl;
@override @useResult
$Res call({
 String name, CategoryType type, String? icon, String? color
});




}
/// @nodoc
class __$CategoryInputCopyWithImpl<$Res>
    implements _$CategoryInputCopyWith<$Res> {
  __$CategoryInputCopyWithImpl(this._self, this._then);

  final _CategoryInput _self;
  final $Res Function(_CategoryInput) _then;

/// Create a copy of CategoryInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? icon = freezed,Object? color = freezed,}) {
  return _then(_CategoryInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
