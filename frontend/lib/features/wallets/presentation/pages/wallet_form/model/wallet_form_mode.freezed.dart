// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_form_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletFormMode {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletFormMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormMode()';
}


}

/// @nodoc
class $WalletFormModeCopyWith<$Res>  {
$WalletFormModeCopyWith(WalletFormMode _, $Res Function(WalletFormMode) __);
}


/// Adds pattern-matching-related methods to [WalletFormMode].
extension WalletFormModePatterns on WalletFormMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddWalletMode value)?  add,TResult Function( EditWalletMode value)?  edit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddWalletMode() when add != null:
return add(_that);case EditWalletMode() when edit != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddWalletMode value)  add,required TResult Function( EditWalletMode value)  edit,}){
final _that = this;
switch (_that) {
case AddWalletMode():
return add(_that);case EditWalletMode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddWalletMode value)?  add,TResult? Function( EditWalletMode value)?  edit,}){
final _that = this;
switch (_that) {
case AddWalletMode() when add != null:
return add(_that);case EditWalletMode() when edit != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  add,TResult Function( String id)?  edit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddWalletMode() when add != null:
return add();case EditWalletMode() when edit != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  add,required TResult Function( String id)  edit,}) {final _that = this;
switch (_that) {
case AddWalletMode():
return add();case EditWalletMode():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  add,TResult? Function( String id)?  edit,}) {final _that = this;
switch (_that) {
case AddWalletMode() when add != null:
return add();case EditWalletMode() when edit != null:
return edit(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class AddWalletMode implements WalletFormMode {
  const AddWalletMode();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddWalletMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormMode.add()';
}


}




/// @nodoc


class EditWalletMode implements WalletFormMode {
  const EditWalletMode(this.id);
  

 final  String id;

/// Create a copy of WalletFormMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditWalletModeCopyWith<EditWalletMode> get copyWith => _$EditWalletModeCopyWithImpl<EditWalletMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditWalletMode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'WalletFormMode.edit(id: $id)';
}


}

/// @nodoc
abstract mixin class $EditWalletModeCopyWith<$Res> implements $WalletFormModeCopyWith<$Res> {
  factory $EditWalletModeCopyWith(EditWalletMode value, $Res Function(EditWalletMode) _then) = _$EditWalletModeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$EditWalletModeCopyWithImpl<$Res>
    implements $EditWalletModeCopyWith<$Res> {
  _$EditWalletModeCopyWithImpl(this._self, this._then);

  final EditWalletMode _self;
  final $Res Function(EditWalletMode) _then;

/// Create a copy of WalletFormMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(EditWalletMode(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WalletFormOutcome {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletFormOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WalletFormOutcome()';
}


}

/// @nodoc
class $WalletFormOutcomeCopyWith<$Res>  {
$WalletFormOutcomeCopyWith(WalletFormOutcome _, $Res Function(WalletFormOutcome) __);
}


/// Adds pattern-matching-related methods to [WalletFormOutcome].
extension WalletFormOutcomePatterns on WalletFormOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SavedWalletOutcome value)?  saved,TResult Function( ArchivedWalletOutcome value)?  archived,TResult Function( DeletedWalletOutcome value)?  deleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SavedWalletOutcome() when saved != null:
return saved(_that);case ArchivedWalletOutcome() when archived != null:
return archived(_that);case DeletedWalletOutcome() when deleted != null:
return deleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SavedWalletOutcome value)  saved,required TResult Function( ArchivedWalletOutcome value)  archived,required TResult Function( DeletedWalletOutcome value)  deleted,}){
final _that = this;
switch (_that) {
case SavedWalletOutcome():
return saved(_that);case ArchivedWalletOutcome():
return archived(_that);case DeletedWalletOutcome():
return deleted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SavedWalletOutcome value)?  saved,TResult? Function( ArchivedWalletOutcome value)?  archived,TResult? Function( DeletedWalletOutcome value)?  deleted,}){
final _that = this;
switch (_that) {
case SavedWalletOutcome() when saved != null:
return saved(_that);case ArchivedWalletOutcome() when archived != null:
return archived(_that);case DeletedWalletOutcome() when deleted != null:
return deleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id)?  saved,TResult Function( String name)?  archived,TResult Function( String name)?  deleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SavedWalletOutcome() when saved != null:
return saved(_that.id);case ArchivedWalletOutcome() when archived != null:
return archived(_that.name);case DeletedWalletOutcome() when deleted != null:
return deleted(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id)  saved,required TResult Function( String name)  archived,required TResult Function( String name)  deleted,}) {final _that = this;
switch (_that) {
case SavedWalletOutcome():
return saved(_that.id);case ArchivedWalletOutcome():
return archived(_that.name);case DeletedWalletOutcome():
return deleted(_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id)?  saved,TResult? Function( String name)?  archived,TResult? Function( String name)?  deleted,}) {final _that = this;
switch (_that) {
case SavedWalletOutcome() when saved != null:
return saved(_that.id);case ArchivedWalletOutcome() when archived != null:
return archived(_that.name);case DeletedWalletOutcome() when deleted != null:
return deleted(_that.name);case _:
  return null;

}
}

}

/// @nodoc


class SavedWalletOutcome implements WalletFormOutcome {
  const SavedWalletOutcome(this.id);
  

 final  String id;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedWalletOutcomeCopyWith<SavedWalletOutcome> get copyWith => _$SavedWalletOutcomeCopyWithImpl<SavedWalletOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedWalletOutcome&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'WalletFormOutcome.saved(id: $id)';
}


}

/// @nodoc
abstract mixin class $SavedWalletOutcomeCopyWith<$Res> implements $WalletFormOutcomeCopyWith<$Res> {
  factory $SavedWalletOutcomeCopyWith(SavedWalletOutcome value, $Res Function(SavedWalletOutcome) _then) = _$SavedWalletOutcomeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SavedWalletOutcomeCopyWithImpl<$Res>
    implements $SavedWalletOutcomeCopyWith<$Res> {
  _$SavedWalletOutcomeCopyWithImpl(this._self, this._then);

  final SavedWalletOutcome _self;
  final $Res Function(SavedWalletOutcome) _then;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SavedWalletOutcome(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ArchivedWalletOutcome implements WalletFormOutcome {
  const ArchivedWalletOutcome(this.name);
  

 final  String name;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchivedWalletOutcomeCopyWith<ArchivedWalletOutcome> get copyWith => _$ArchivedWalletOutcomeCopyWithImpl<ArchivedWalletOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchivedWalletOutcome&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'WalletFormOutcome.archived(name: $name)';
}


}

/// @nodoc
abstract mixin class $ArchivedWalletOutcomeCopyWith<$Res> implements $WalletFormOutcomeCopyWith<$Res> {
  factory $ArchivedWalletOutcomeCopyWith(ArchivedWalletOutcome value, $Res Function(ArchivedWalletOutcome) _then) = _$ArchivedWalletOutcomeCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$ArchivedWalletOutcomeCopyWithImpl<$Res>
    implements $ArchivedWalletOutcomeCopyWith<$Res> {
  _$ArchivedWalletOutcomeCopyWithImpl(this._self, this._then);

  final ArchivedWalletOutcome _self;
  final $Res Function(ArchivedWalletOutcome) _then;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(ArchivedWalletOutcome(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeletedWalletOutcome implements WalletFormOutcome {
  const DeletedWalletOutcome(this.name);
  

 final  String name;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedWalletOutcomeCopyWith<DeletedWalletOutcome> get copyWith => _$DeletedWalletOutcomeCopyWithImpl<DeletedWalletOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedWalletOutcome&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString() {
    return 'WalletFormOutcome.deleted(name: $name)';
}


}

/// @nodoc
abstract mixin class $DeletedWalletOutcomeCopyWith<$Res> implements $WalletFormOutcomeCopyWith<$Res> {
  factory $DeletedWalletOutcomeCopyWith(DeletedWalletOutcome value, $Res Function(DeletedWalletOutcome) _then) = _$DeletedWalletOutcomeCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$DeletedWalletOutcomeCopyWithImpl<$Res>
    implements $DeletedWalletOutcomeCopyWith<$Res> {
  _$DeletedWalletOutcomeCopyWithImpl(this._self, this._then);

  final DeletedWalletOutcome _self;
  final $Res Function(DeletedWalletOutcome) _then;

/// Create a copy of WalletFormOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(DeletedWalletOutcome(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
