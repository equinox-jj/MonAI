// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_form_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryFormMode {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryFormMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoryFormMode()';
}


}

/// @nodoc
class $CategoryFormModeCopyWith<$Res>  {
$CategoryFormModeCopyWith(CategoryFormMode _, $Res Function(CategoryFormMode) __);
}


/// Adds pattern-matching-related methods to [CategoryFormMode].
extension CategoryFormModePatterns on CategoryFormMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreateCategoryMode value)?  create,TResult Function( EditCategoryMode value)?  edit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreateCategoryMode() when create != null:
return create(_that);case EditCategoryMode() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreateCategoryMode value)  create,required TResult Function( EditCategoryMode value)  edit,}){
final _that = this;
switch (_that) {
case CreateCategoryMode():
return create(_that);case EditCategoryMode():
return edit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreateCategoryMode value)?  create,TResult? Function( EditCategoryMode value)?  edit,}){
final _that = this;
switch (_that) {
case CreateCategoryMode() when create != null:
return create(_that);case EditCategoryMode() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CategoryType type)?  create,TResult Function( String id)?  edit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreateCategoryMode() when create != null:
return create(_that.type);case EditCategoryMode() when edit != null:
return edit(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CategoryType type)  create,required TResult Function( String id)  edit,}) {final _that = this;
switch (_that) {
case CreateCategoryMode():
return create(_that.type);case EditCategoryMode():
return edit(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CategoryType type)?  create,TResult? Function( String id)?  edit,}) {final _that = this;
switch (_that) {
case CreateCategoryMode() when create != null:
return create(_that.type);case EditCategoryMode() when edit != null:
return edit(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class CreateCategoryMode implements CategoryFormMode {
  const CreateCategoryMode(this.type);
  

 final  CategoryType type;

/// Create a copy of CategoryFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCategoryModeCopyWith<CreateCategoryMode> get copyWith => _$CreateCategoryModeCopyWithImpl<CreateCategoryMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCategoryMode&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'CategoryFormMode.create(type: $type)';
}


}

/// @nodoc
abstract mixin class $CreateCategoryModeCopyWith<$Res> implements $CategoryFormModeCopyWith<$Res> {
  factory $CreateCategoryModeCopyWith(CreateCategoryMode value, $Res Function(CreateCategoryMode) _then) = _$CreateCategoryModeCopyWithImpl;
@useResult
$Res call({
 CategoryType type
});




}
/// @nodoc
class _$CreateCategoryModeCopyWithImpl<$Res>
    implements $CreateCategoryModeCopyWith<$Res> {
  _$CreateCategoryModeCopyWithImpl(this._self, this._then);

  final CreateCategoryMode _self;
  final $Res Function(CreateCategoryMode) _then;

/// Create a copy of CategoryFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(CreateCategoryMode(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,
  ));
}


}

/// @nodoc


class EditCategoryMode implements CategoryFormMode {
  const EditCategoryMode(this.id);
  

 final  String id;

/// Create a copy of CategoryFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditCategoryModeCopyWith<EditCategoryMode> get copyWith => _$EditCategoryModeCopyWithImpl<EditCategoryMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditCategoryMode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'CategoryFormMode.edit(id: $id)';
}


}

/// @nodoc
abstract mixin class $EditCategoryModeCopyWith<$Res> implements $CategoryFormModeCopyWith<$Res> {
  factory $EditCategoryModeCopyWith(EditCategoryMode value, $Res Function(EditCategoryMode) _then) = _$EditCategoryModeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$EditCategoryModeCopyWithImpl<$Res>
    implements $EditCategoryModeCopyWith<$Res> {
  _$EditCategoryModeCopyWithImpl(this._self, this._then);

  final EditCategoryMode _self;
  final $Res Function(EditCategoryMode) _then;

/// Create a copy of CategoryFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(EditCategoryMode(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
