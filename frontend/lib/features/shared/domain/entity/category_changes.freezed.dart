// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_changes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryChanges {

 String? get name; String? get icon; String? get color; bool? get isHidden;
/// Create a copy of CategoryChanges
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryChangesCopyWith<CategoryChanges> get copyWith => _$CategoryChangesCopyWithImpl<CategoryChanges>(this as CategoryChanges, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryChanges;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryChanges&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.isHidden, _this.isHidden) || other.isHidden == _this.isHidden));
}


@override
int get hashCode {
  final _this = this as CategoryChanges;
  return Object.hash(runtimeType,_this.name,_this.icon,_this.color,_this.isHidden);
}

@override
String toString() {
  final _this = this as CategoryChanges;
  return 'CategoryChanges(name: ${_this.name}, icon: ${_this.icon}, color: ${_this.color}, isHidden: ${_this.isHidden})';
}


}

/// @nodoc
abstract mixin class $CategoryChangesCopyWith<$Res>  {
  factory $CategoryChangesCopyWith(CategoryChanges value, $Res Function(CategoryChanges) _then) = _$CategoryChangesCopyWithImpl;
@useResult
$Res call({
 String? name, String? icon, String? color, bool? isHidden
});




}
/// @nodoc
class _$CategoryChangesCopyWithImpl<$Res>
    implements $CategoryChangesCopyWith<$Res> {
  _$CategoryChangesCopyWithImpl(this._self, this._then);

  final CategoryChanges _self;
  final $Res Function(CategoryChanges) _then;

/// Create a copy of CategoryChanges
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? isHidden = freezed,}) {
  return _then(CategoryChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryChanges].
extension CategoryChangesPatterns on CategoryChanges {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryChanges value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryChanges() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryChanges value)  $default,){
final _that = this;
switch (_that) {
case _CategoryChanges():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryChanges value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryChanges() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? icon,  String? color,  bool? isHidden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryChanges() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? icon,  String? color,  bool? isHidden)  $default,) {final _that = this;
switch (_that) {
case _CategoryChanges():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? icon,  String? color,  bool? isHidden)?  $default,) {final _that = this;
switch (_that) {
case _CategoryChanges() when $default != null:
return $default(_that.name,_that.icon,_that.color,_that.isHidden);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryChanges extends CategoryChanges {
  const _CategoryChanges({this.name, this.icon, this.color, this.isHidden}): super._();
  

@override final  String? name;
@override final  String? icon;
@override final  String? color;
@override final  bool? isHidden;

/// Create a copy of CategoryChanges
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryChangesCopyWith<_CategoryChanges> get copyWith => __$CategoryChangesCopyWithImpl<_CategoryChanges>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryChanges&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,icon,color,isHidden);
}

@override
String toString() {
    return 'CategoryChanges(name: $name, icon: $icon, color: $color, isHidden: $isHidden)';
}


}

/// @nodoc
abstract mixin class _$CategoryChangesCopyWith<$Res> implements $CategoryChangesCopyWith<$Res> {
  factory _$CategoryChangesCopyWith(_CategoryChanges value, $Res Function(_CategoryChanges) _then) = __$CategoryChangesCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? icon, String? color, bool? isHidden
});




}
/// @nodoc
class __$CategoryChangesCopyWithImpl<$Res>
    implements _$CategoryChangesCopyWith<$Res> {
  __$CategoryChangesCopyWithImpl(this._self, this._then);

  final _CategoryChanges _self;
  final $Res Function(_CategoryChanges) _then;

/// Create a copy of CategoryChanges
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? isHidden = freezed,}) {
  return _then(_CategoryChanges(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
