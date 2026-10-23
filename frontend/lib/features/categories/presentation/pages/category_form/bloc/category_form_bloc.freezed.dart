// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryFormEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryFormEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoryFormEvent()';
}


}

/// @nodoc
class $CategoryFormEventCopyWith<$Res>  {
$CategoryFormEventCopyWith(CategoryFormEvent _, $Res Function(CategoryFormEvent) __);
}


/// Adds pattern-matching-related methods to [CategoryFormEvent].
extension CategoryFormEventPatterns on CategoryFormEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _NameEdited value)?  nameEdited,TResult Function( _IconPicked value)?  iconPicked,TResult Function( _ColorPicked value)?  colorPicked,TResult Function( _SaveRequested value)?  saveRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _IconPicked() when iconPicked != null:
return iconPicked(_that);case _ColorPicked() when colorPicked != null:
return colorPicked(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _NameEdited value)  nameEdited,required TResult Function( _IconPicked value)  iconPicked,required TResult Function( _ColorPicked value)  colorPicked,required TResult Function( _SaveRequested value)  saveRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _NameEdited():
return nameEdited(_that);case _IconPicked():
return iconPicked(_that);case _ColorPicked():
return colorPicked(_that);case _SaveRequested():
return saveRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _NameEdited value)?  nameEdited,TResult? Function( _IconPicked value)?  iconPicked,TResult? Function( _ColorPicked value)?  colorPicked,TResult? Function( _SaveRequested value)?  saveRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _IconPicked() when iconPicked != null:
return iconPicked(_that);case _ColorPicked() when colorPicked != null:
return colorPicked(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String name)?  nameEdited,TResult Function( String icon)?  iconPicked,TResult Function( String color)?  colorPicked,TResult Function( String name)?  saveRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _NameEdited() when nameEdited != null:
return nameEdited(_that.name);case _IconPicked() when iconPicked != null:
return iconPicked(_that.icon);case _ColorPicked() when colorPicked != null:
return colorPicked(_that.color);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String name)  nameEdited,required TResult Function( String icon)  iconPicked,required TResult Function( String color)  colorPicked,required TResult Function( String name)  saveRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _NameEdited():
return nameEdited(_that.name);case _IconPicked():
return iconPicked(_that.icon);case _ColorPicked():
return colorPicked(_that.color);case _SaveRequested():
return saveRequested(_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String name)?  nameEdited,TResult? Function( String icon)?  iconPicked,TResult? Function( String color)?  colorPicked,TResult? Function( String name)?  saveRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _NameEdited() when nameEdited != null:
return nameEdited(_that.name);case _IconPicked() when iconPicked != null:
return iconPicked(_that.icon);case _ColorPicked() when colorPicked != null:
return colorPicked(_that.color);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements CategoryFormEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoryFormEvent.started()';
}


}




/// @nodoc


class _NameEdited implements CategoryFormEvent {
  const _NameEdited(this.name);
  

 final  String name;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameEditedCopyWith<_NameEdited> get copyWith => __$NameEditedCopyWithImpl<_NameEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameEdited&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'CategoryFormEvent.nameEdited(name: $name)';
}


}

/// @nodoc
abstract mixin class _$NameEditedCopyWith<$Res> implements $CategoryFormEventCopyWith<$Res> {
  factory _$NameEditedCopyWith(_NameEdited value, $Res Function(_NameEdited) _then) = __$NameEditedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$NameEditedCopyWithImpl<$Res>
    implements _$NameEditedCopyWith<$Res> {
  __$NameEditedCopyWithImpl(this._self, this._then);

  final _NameEdited _self;
  final $Res Function(_NameEdited) _then;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_NameEdited(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _IconPicked implements CategoryFormEvent {
  const _IconPicked(this.icon);
  

 final  String icon;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconPickedCopyWith<_IconPicked> get copyWith => __$IconPickedCopyWithImpl<_IconPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconPicked&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode {
    return Object.hash(runtimeType,icon);
}

@override
String toString() {
    return 'CategoryFormEvent.iconPicked(icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$IconPickedCopyWith<$Res> implements $CategoryFormEventCopyWith<$Res> {
  factory _$IconPickedCopyWith(_IconPicked value, $Res Function(_IconPicked) _then) = __$IconPickedCopyWithImpl;
@useResult
$Res call({
 String icon
});




}
/// @nodoc
class __$IconPickedCopyWithImpl<$Res>
    implements _$IconPickedCopyWith<$Res> {
  __$IconPickedCopyWithImpl(this._self, this._then);

  final _IconPicked _self;
  final $Res Function(_IconPicked) _then;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? icon = null,}) {
  return _then(_IconPicked(
null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ColorPicked implements CategoryFormEvent {
  const _ColorPicked(this.color);
  

 final  String color;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorPickedCopyWith<_ColorPicked> get copyWith => __$ColorPickedCopyWithImpl<_ColorPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorPicked&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,color);
}

@override
String toString() {
    return 'CategoryFormEvent.colorPicked(color: $color)';
}


}

/// @nodoc
abstract mixin class _$ColorPickedCopyWith<$Res> implements $CategoryFormEventCopyWith<$Res> {
  factory _$ColorPickedCopyWith(_ColorPicked value, $Res Function(_ColorPicked) _then) = __$ColorPickedCopyWithImpl;
@useResult
$Res call({
 String color
});




}
/// @nodoc
class __$ColorPickedCopyWithImpl<$Res>
    implements _$ColorPickedCopyWith<$Res> {
  __$ColorPickedCopyWithImpl(this._self, this._then);

  final _ColorPicked _self;
  final $Res Function(_ColorPicked) _then;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(_ColorPicked(
null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested implements CategoryFormEvent {
  const _SaveRequested(this.name);
  

 final  String name;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'CategoryFormEvent.saveRequested(name: $name)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $CategoryFormEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of CategoryFormEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_SaveRequested(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CategoryFormState {

 CategoryFormMode get mode; UiStatus get status; CategoryType get type; Category? get original; String get icon; String get color; FieldError? get nameError; bool get autovalidate; bool get isSaving; bool get done; String? get savedId; CategoryFailure? get actionFailure;
/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryFormStateCopyWith<CategoryFormState> get copyWith => _$CategoryFormStateCopyWithImpl<CategoryFormState>(this as CategoryFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.original, _this.original) || other.original == _this.original)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.savedId, _this.savedId) || other.savedId == _this.savedId)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as CategoryFormState;
  return Object.hash(runtimeType,_this.mode,_this.status,_this.type,_this.original,_this.icon,_this.color,_this.nameError,_this.autovalidate,_this.isSaving,_this.done,_this.savedId,_this.actionFailure);
}

@override
String toString() {
  final _this = this as CategoryFormState;
  return 'CategoryFormState(mode: ${_this.mode}, status: ${_this.status}, type: ${_this.type}, original: ${_this.original}, icon: ${_this.icon}, color: ${_this.color}, nameError: ${_this.nameError}, autovalidate: ${_this.autovalidate}, isSaving: ${_this.isSaving}, done: ${_this.done}, savedId: ${_this.savedId}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $CategoryFormStateCopyWith<$Res>  {
  factory $CategoryFormStateCopyWith(CategoryFormState value, $Res Function(CategoryFormState) _then) = _$CategoryFormStateCopyWithImpl;
@useResult
$Res call({
 CategoryFormMode mode, UiStatus status, CategoryType type, Category? original, String icon, String color, FieldError? nameError, bool autovalidate, bool isSaving, bool done, String? savedId, CategoryFailure? actionFailure
});


$CategoryFormModeCopyWith<$Res> get mode;$CategoryCopyWith<$Res>? get original;

}
/// @nodoc
class _$CategoryFormStateCopyWithImpl<$Res>
    implements $CategoryFormStateCopyWith<$Res> {
  _$CategoryFormStateCopyWithImpl(this._self, this._then);

  final CategoryFormState _self;
  final $Res Function(CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? status = null,Object? type = null,Object? original = freezed,Object? icon = null,Object? color = null,Object? nameError = freezed,Object? autovalidate = null,Object? isSaving = null,Object? done = null,Object? savedId = freezed,Object? actionFailure = freezed,}) {
  return _then(CategoryFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CategoryFormMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Category?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,
  ));
}
/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryFormModeCopyWith<$Res> get mode {
  
  return $CategoryFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryFormState].
extension CategoryFormStatePatterns on CategoryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryFormState value)  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoryFormMode mode,  UiStatus status,  CategoryType type,  Category? original,  String icon,  String color,  FieldError? nameError,  bool autovalidate,  bool isSaving,  bool done,  String? savedId,  CategoryFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.mode,_that.status,_that.type,_that.original,_that.icon,_that.color,_that.nameError,_that.autovalidate,_that.isSaving,_that.done,_that.savedId,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoryFormMode mode,  UiStatus status,  CategoryType type,  Category? original,  String icon,  String color,  FieldError? nameError,  bool autovalidate,  bool isSaving,  bool done,  String? savedId,  CategoryFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState():
return $default(_that.mode,_that.status,_that.type,_that.original,_that.icon,_that.color,_that.nameError,_that.autovalidate,_that.isSaving,_that.done,_that.savedId,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoryFormMode mode,  UiStatus status,  CategoryType type,  Category? original,  String icon,  String color,  FieldError? nameError,  bool autovalidate,  bool isSaving,  bool done,  String? savedId,  CategoryFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.mode,_that.status,_that.type,_that.original,_that.icon,_that.color,_that.nameError,_that.autovalidate,_that.isSaving,_that.done,_that.savedId,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryFormState implements CategoryFormState {
  const _CategoryFormState({required this.mode, this.status = UiStatus.initial, required this.type, this.original, this.icon = defaultCategoryIcon, this.color = defaultCategoryColor, this.nameError, this.autovalidate = false, this.isSaving = false, this.done = false, this.savedId, this.actionFailure});
  

@override final  CategoryFormMode mode;
@override@JsonKey() final  UiStatus status;
@override final  CategoryType type;
@override final  Category? original;
@override@JsonKey() final  String icon;
@override@JsonKey() final  String color;
@override final  FieldError? nameError;
@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool done;
@override final  String? savedId;
@override final  CategoryFailure? actionFailure;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryFormStateCopyWith<_CategoryFormState> get copyWith => __$CategoryFormStateCopyWithImpl<_CategoryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.original, original) || other.original == original)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.done, done) || other.done == done)&&(identical(other.savedId, savedId) || other.savedId == savedId)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,status,type,original,icon,color,nameError,autovalidate,isSaving,done,savedId,actionFailure);
}

@override
String toString() {
    return 'CategoryFormState(mode: $mode, status: $status, type: $type, original: $original, icon: $icon, color: $color, nameError: $nameError, autovalidate: $autovalidate, isSaving: $isSaving, done: $done, savedId: $savedId, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$CategoryFormStateCopyWith<$Res> implements $CategoryFormStateCopyWith<$Res> {
  factory _$CategoryFormStateCopyWith(_CategoryFormState value, $Res Function(_CategoryFormState) _then) = __$CategoryFormStateCopyWithImpl;
@override @useResult
$Res call({
 CategoryFormMode mode, UiStatus status, CategoryType type, Category? original, String icon, String color, FieldError? nameError, bool autovalidate, bool isSaving, bool done, String? savedId, CategoryFailure? actionFailure
});


@override $CategoryFormModeCopyWith<$Res> get mode;@override $CategoryCopyWith<$Res>? get original;

}
/// @nodoc
class __$CategoryFormStateCopyWithImpl<$Res>
    implements _$CategoryFormStateCopyWith<$Res> {
  __$CategoryFormStateCopyWithImpl(this._self, this._then);

  final _CategoryFormState _self;
  final $Res Function(_CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? status = null,Object? type = null,Object? original = freezed,Object? icon = null,Object? color = null,Object? nameError = freezed,Object? autovalidate = null,Object? isSaving = null,Object? done = null,Object? savedId = freezed,Object? actionFailure = freezed,}) {
  return _then(_CategoryFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CategoryFormMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,original: freezed == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Category?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,
  ));
}

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryFormModeCopyWith<$Res> get mode {
  
  return $CategoryFormModeCopyWith<$Res>(_self.mode, (value) {
    return _then(_self.copyWith(mode: value));
  });
}/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get original {
    if (_self.original == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.original!, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}

// dart format on
