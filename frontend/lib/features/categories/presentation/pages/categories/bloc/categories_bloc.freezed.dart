// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoriesEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoriesEvent()';
}


}

/// @nodoc
class $CategoriesEventCopyWith<$Res>  {
$CategoriesEventCopyWith(CategoriesEvent _, $Res Function(CategoriesEvent) __);
}


/// Adds pattern-matching-related methods to [CategoriesEvent].
extension CategoriesEventPatterns on CategoriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TypeSelected value)?  typeSelected,TResult Function( _Retried value)?  retried,TResult Function( _HiddenToggled value)?  hiddenToggled,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _CategoriesChanged value)?  categoriesChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _Retried() when retried != null:
return retried(_that);case _HiddenToggled() when hiddenToggled != null:
return hiddenToggled(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TypeSelected value)  typeSelected,required TResult Function( _Retried value)  retried,required TResult Function( _HiddenToggled value)  hiddenToggled,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _CategoriesChanged value)  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TypeSelected():
return typeSelected(_that);case _Retried():
return retried(_that);case _HiddenToggled():
return hiddenToggled(_that);case _DeleteRequested():
return deleteRequested(_that);case _CategoriesChanged():
return categoriesChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TypeSelected value)?  typeSelected,TResult? Function( _Retried value)?  retried,TResult? Function( _HiddenToggled value)?  hiddenToggled,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _CategoriesChanged value)?  categoriesChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TypeSelected() when typeSelected != null:
return typeSelected(_that);case _Retried() when retried != null:
return retried(_that);case _HiddenToggled() when hiddenToggled != null:
return hiddenToggled(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( CategoryType type)?  typeSelected,TResult Function()?  retried,TResult Function( String id)?  hiddenToggled,TResult Function( String id,  String? moveTo)?  deleteRequested,TResult Function( List<Category> categories)?  categoriesChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _Retried() when retried != null:
return retried();case _HiddenToggled() when hiddenToggled != null:
return hiddenToggled(_that.id);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.id,_that.moveTo);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( CategoryType type)  typeSelected,required TResult Function()  retried,required TResult Function( String id)  hiddenToggled,required TResult Function( String id,  String? moveTo)  deleteRequested,required TResult Function( List<Category> categories)  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _TypeSelected():
return typeSelected(_that.type);case _Retried():
return retried();case _HiddenToggled():
return hiddenToggled(_that.id);case _DeleteRequested():
return deleteRequested(_that.id,_that.moveTo);case _CategoriesChanged():
return categoriesChanged(_that.categories);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( CategoryType type)?  typeSelected,TResult? Function()?  retried,TResult? Function( String id)?  hiddenToggled,TResult? Function( String id,  String? moveTo)?  deleteRequested,TResult? Function( List<Category> categories)?  categoriesChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TypeSelected() when typeSelected != null:
return typeSelected(_that.type);case _Retried() when retried != null:
return retried();case _HiddenToggled() when hiddenToggled != null:
return hiddenToggled(_that.id);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.id,_that.moveTo);case _CategoriesChanged() when categoriesChanged != null:
return categoriesChanged(_that.categories);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements CategoriesEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoriesEvent.started()';
}


}




/// @nodoc


class _TypeSelected implements CategoriesEvent {
  const _TypeSelected(this.type);
  

 final  CategoryType type;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeSelectedCopyWith<_TypeSelected> get copyWith => __$TypeSelectedCopyWithImpl<_TypeSelected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeSelected&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'CategoriesEvent.typeSelected(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypeSelectedCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$TypeSelectedCopyWith(_TypeSelected value, $Res Function(_TypeSelected) _then) = __$TypeSelectedCopyWithImpl;
@useResult
$Res call({
 CategoryType type
});




}
/// @nodoc
class __$TypeSelectedCopyWithImpl<$Res>
    implements _$TypeSelectedCopyWith<$Res> {
  __$TypeSelectedCopyWithImpl(this._self, this._then);

  final _TypeSelected _self;
  final $Res Function(_TypeSelected) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_TypeSelected(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,
  ));
}


}

/// @nodoc


class _Retried implements CategoriesEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CategoriesEvent.retried()';
}


}




/// @nodoc


class _HiddenToggled implements CategoriesEvent {
  const _HiddenToggled(this.id);
  

 final  String id;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiddenToggledCopyWith<_HiddenToggled> get copyWith => __$HiddenToggledCopyWithImpl<_HiddenToggled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HiddenToggled&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'CategoriesEvent.hiddenToggled(id: $id)';
}


}

/// @nodoc
abstract mixin class _$HiddenToggledCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$HiddenToggledCopyWith(_HiddenToggled value, $Res Function(_HiddenToggled) _then) = __$HiddenToggledCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$HiddenToggledCopyWithImpl<$Res>
    implements _$HiddenToggledCopyWith<$Res> {
  __$HiddenToggledCopyWithImpl(this._self, this._then);

  final _HiddenToggled _self;
  final $Res Function(_HiddenToggled) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_HiddenToggled(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteRequested implements CategoriesEvent {
  const _DeleteRequested(this.id, {this.moveTo});
  

 final  String id;
 final  String? moveTo;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteRequestedCopyWith<_DeleteRequested> get copyWith => __$DeleteRequestedCopyWithImpl<_DeleteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested&&(identical(other.id, id) || other.id == id)&&(identical(other.moveTo, moveTo) || other.moveTo == moveTo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,moveTo);
}

@override
String toString() {
    return 'CategoriesEvent.deleteRequested(id: $id, moveTo: $moveTo)';
}


}

/// @nodoc
abstract mixin class _$DeleteRequestedCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$DeleteRequestedCopyWith(_DeleteRequested value, $Res Function(_DeleteRequested) _then) = __$DeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String id, String? moveTo
});




}
/// @nodoc
class __$DeleteRequestedCopyWithImpl<$Res>
    implements _$DeleteRequestedCopyWith<$Res> {
  __$DeleteRequestedCopyWithImpl(this._self, this._then);

  final _DeleteRequested _self;
  final $Res Function(_DeleteRequested) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moveTo = freezed,}) {
  return _then(_DeleteRequested(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moveTo: freezed == moveTo ? _self.moveTo : moveTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CategoriesChanged implements CategoriesEvent {
  const _CategoriesChanged( List<Category> categories): _categories = categories;
  

 final  List<Category> _categories;
 List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesChangedCopyWith<_CategoriesChanged> get copyWith => __$CategoriesChangedCopyWithImpl<_CategoriesChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesChanged&&const DeepCollectionEquality().equals(other.categories, _categories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'CategoriesEvent.categoriesChanged(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoriesChangedCopyWith<$Res> implements $CategoriesEventCopyWith<$Res> {
  factory _$CategoriesChangedCopyWith(_CategoriesChanged value, $Res Function(_CategoriesChanged) _then) = __$CategoriesChangedCopyWithImpl;
@useResult
$Res call({
 List<Category> categories
});




}
/// @nodoc
class __$CategoriesChangedCopyWithImpl<$Res>
    implements _$CategoriesChangedCopyWith<$Res> {
  __$CategoriesChangedCopyWithImpl(this._self, this._then);

  final _CategoriesChanged _self;
  final $Res Function(_CategoriesChanged) _then;

/// Create a copy of CategoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_CategoriesChanged(
null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,
  ));
}


}

/// @nodoc
mixin _$CategoriesState {

 CategoryType get type; UiStatus get status; List<Category> get categories; Set<String> get busyIds; CategoryFailure? get loadFailure; Category? get moveFrom; Category? get deleted; CategoryFailure? get actionFailure;
/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesStateCopyWith<CategoriesState> get copyWith => _$CategoriesStateCopyWithImpl<CategoriesState>(this as CategoriesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoriesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesState&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.busyIds, _this.busyIds)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.moveFrom, _this.moveFrom) || other.moveFrom == _this.moveFrom)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as CategoriesState;
  return Object.hash(runtimeType,_this.type,_this.status,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.busyIds),_this.loadFailure,_this.moveFrom,_this.deleted,_this.actionFailure);
}

@override
String toString() {
  final _this = this as CategoriesState;
  return 'CategoriesState(type: ${_this.type}, status: ${_this.status}, categories: ${_this.categories}, busyIds: ${_this.busyIds}, loadFailure: ${_this.loadFailure}, moveFrom: ${_this.moveFrom}, deleted: ${_this.deleted}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $CategoriesStateCopyWith<$Res>  {
  factory $CategoriesStateCopyWith(CategoriesState value, $Res Function(CategoriesState) _then) = _$CategoriesStateCopyWithImpl;
@useResult
$Res call({
 CategoryType type, UiStatus status, List<Category> categories, Set<String> busyIds, CategoryFailure? loadFailure, Category? moveFrom, Category? deleted, CategoryFailure? actionFailure
});


$CategoryCopyWith<$Res>? get moveFrom;$CategoryCopyWith<$Res>? get deleted;

}
/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._self, this._then);

  final CategoriesState _self;
  final $Res Function(CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = null,Object? categories = null,Object? busyIds = null,Object? loadFailure = freezed,Object? moveFrom = freezed,Object? deleted = freezed,Object? actionFailure = freezed,}) {
  return _then(CategoriesState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,busyIds: null == busyIds ? _self.busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,moveFrom: freezed == moveFrom ? _self.moveFrom : moveFrom // ignore: cast_nullable_to_non_nullable
as Category?,deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as Category?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,
  ));
}
/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get moveFrom {
    if (_self.moveFrom == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.moveFrom!, (value) {
    return _then(_self.copyWith(moveFrom: value));
  });
}/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get deleted {
    if (_self.deleted == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.deleted!, (value) {
    return _then(_self.copyWith(deleted: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoriesState].
extension CategoriesStatePatterns on CategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoriesState value)  $default,){
final _that = this;
switch (_that) {
case _CategoriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoriesState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoryType type,  UiStatus status,  List<Category> categories,  Set<String> busyIds,  CategoryFailure? loadFailure,  Category? moveFrom,  Category? deleted,  CategoryFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.type,_that.status,_that.categories,_that.busyIds,_that.loadFailure,_that.moveFrom,_that.deleted,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoryType type,  UiStatus status,  List<Category> categories,  Set<String> busyIds,  CategoryFailure? loadFailure,  Category? moveFrom,  Category? deleted,  CategoryFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _CategoriesState():
return $default(_that.type,_that.status,_that.categories,_that.busyIds,_that.loadFailure,_that.moveFrom,_that.deleted,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoryType type,  UiStatus status,  List<Category> categories,  Set<String> busyIds,  CategoryFailure? loadFailure,  Category? moveFrom,  Category? deleted,  CategoryFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.type,_that.status,_that.categories,_that.busyIds,_that.loadFailure,_that.moveFrom,_that.deleted,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _CategoriesState implements CategoriesState {
  const _CategoriesState({this.type = CategoryType.expense, this.status = UiStatus.initial,  List<Category> categories = const [],  Set<String> busyIds = const {}, this.loadFailure, this.moveFrom, this.deleted, this.actionFailure}): _categories = categories,_busyIds = busyIds;
  

@override@JsonKey() final  CategoryType type;
@override@JsonKey() final  UiStatus status;
 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  Set<String> _busyIds;
@override@JsonKey() Set<String> get busyIds {
  if (_busyIds is EqualUnmodifiableSetView) return _busyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busyIds);
}

@override final  CategoryFailure? loadFailure;
@override final  Category? moveFrom;
@override final  Category? deleted;
@override final  CategoryFailure? actionFailure;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesStateCopyWith<_CategoriesState> get copyWith => __$CategoriesStateCopyWithImpl<_CategoriesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesState&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.busyIds, _busyIds)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.moveFrom, moveFrom) || other.moveFrom == moveFrom)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,status,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_busyIds),loadFailure,moveFrom,deleted,actionFailure);
}

@override
String toString() {
    return 'CategoriesState(type: $type, status: $status, categories: $categories, busyIds: $busyIds, loadFailure: $loadFailure, moveFrom: $moveFrom, deleted: $deleted, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$CategoriesStateCopyWith<$Res> implements $CategoriesStateCopyWith<$Res> {
  factory _$CategoriesStateCopyWith(_CategoriesState value, $Res Function(_CategoriesState) _then) = __$CategoriesStateCopyWithImpl;
@override @useResult
$Res call({
 CategoryType type, UiStatus status, List<Category> categories, Set<String> busyIds, CategoryFailure? loadFailure, Category? moveFrom, Category? deleted, CategoryFailure? actionFailure
});


@override $CategoryCopyWith<$Res>? get moveFrom;@override $CategoryCopyWith<$Res>? get deleted;

}
/// @nodoc
class __$CategoriesStateCopyWithImpl<$Res>
    implements _$CategoriesStateCopyWith<$Res> {
  __$CategoriesStateCopyWithImpl(this._self, this._then);

  final _CategoriesState _self;
  final $Res Function(_CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = null,Object? categories = null,Object? busyIds = null,Object? loadFailure = freezed,Object? moveFrom = freezed,Object? deleted = freezed,Object? actionFailure = freezed,}) {
  return _then(_CategoriesState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,busyIds: null == busyIds ? _self._busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,moveFrom: freezed == moveFrom ? _self.moveFrom : moveFrom // ignore: cast_nullable_to_non_nullable
as Category?,deleted: freezed == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as Category?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as CategoryFailure?,
  ));
}

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get moveFrom {
    if (_self.moveFrom == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.moveFrom!, (value) {
    return _then(_self.copyWith(moveFrom: value));
  });
}/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get deleted {
    if (_self.deleted == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.deleted!, (value) {
    return _then(_self.copyWith(deleted: value));
  });
}
}

// dart format on
