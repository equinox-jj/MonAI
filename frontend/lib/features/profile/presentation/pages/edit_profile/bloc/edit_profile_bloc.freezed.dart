// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent()';
}


}

/// @nodoc
class $EditProfileEventCopyWith<$Res>  {
$EditProfileEventCopyWith(EditProfileEvent _, $Res Function(EditProfileEvent) __);
}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _UserChanged value)?  userChanged,TResult Function( _NameEdited value)?  nameEdited,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _PhotoSourcePicked value)?  photoSourcePicked,TResult Function( _RemovePhotoRequested value)?  removePhotoRequested,TResult Function( _PasswordEdited value)?  passwordEdited,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _DeleteConfirmed value)?  deleteConfirmed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UserChanged() when userChanged != null:
return userChanged(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _PhotoSourcePicked() when photoSourcePicked != null:
return photoSourcePicked(_that);case _RemovePhotoRequested() when removePhotoRequested != null:
return removePhotoRequested(_that);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _DeleteConfirmed() when deleteConfirmed != null:
return deleteConfirmed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _UserChanged value)  userChanged,required TResult Function( _NameEdited value)  nameEdited,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _PhotoSourcePicked value)  photoSourcePicked,required TResult Function( _RemovePhotoRequested value)  removePhotoRequested,required TResult Function( _PasswordEdited value)  passwordEdited,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _DeleteConfirmed value)  deleteConfirmed,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _UserChanged():
return userChanged(_that);case _NameEdited():
return nameEdited(_that);case _SaveRequested():
return saveRequested(_that);case _PhotoSourcePicked():
return photoSourcePicked(_that);case _RemovePhotoRequested():
return removePhotoRequested(_that);case _PasswordEdited():
return passwordEdited(_that);case _DeleteRequested():
return deleteRequested(_that);case _DeleteConfirmed():
return deleteConfirmed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _UserChanged value)?  userChanged,TResult? Function( _NameEdited value)?  nameEdited,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _PhotoSourcePicked value)?  photoSourcePicked,TResult? Function( _RemovePhotoRequested value)?  removePhotoRequested,TResult? Function( _PasswordEdited value)?  passwordEdited,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _DeleteConfirmed value)?  deleteConfirmed,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _UserChanged() when userChanged != null:
return userChanged(_that);case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _PhotoSourcePicked() when photoSourcePicked != null:
return photoSourcePicked(_that);case _RemovePhotoRequested() when removePhotoRequested != null:
return removePhotoRequested(_that);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _DeleteConfirmed() when deleteConfirmed != null:
return deleteConfirmed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( User? user)?  userChanged,TResult Function( String text)?  nameEdited,TResult Function( String name)?  saveRequested,TResult Function( AvatarPhotoSource source,  AvatarCropLabels cropLabels)?  photoSourcePicked,TResult Function()?  removePhotoRequested,TResult Function()?  passwordEdited,TResult Function( String password)?  deleteRequested,TResult Function( String password)?  deleteConfirmed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UserChanged() when userChanged != null:
return userChanged(_that.user);case _NameEdited() when nameEdited != null:
return nameEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name);case _PhotoSourcePicked() when photoSourcePicked != null:
return photoSourcePicked(_that.source,_that.cropLabels);case _RemovePhotoRequested() when removePhotoRequested != null:
return removePhotoRequested();case _PasswordEdited() when passwordEdited != null:
return passwordEdited();case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.password);case _DeleteConfirmed() when deleteConfirmed != null:
return deleteConfirmed(_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( User? user)  userChanged,required TResult Function( String text)  nameEdited,required TResult Function( String name)  saveRequested,required TResult Function( AvatarPhotoSource source,  AvatarCropLabels cropLabels)  photoSourcePicked,required TResult Function()  removePhotoRequested,required TResult Function()  passwordEdited,required TResult Function( String password)  deleteRequested,required TResult Function( String password)  deleteConfirmed,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _UserChanged():
return userChanged(_that.user);case _NameEdited():
return nameEdited(_that.text);case _SaveRequested():
return saveRequested(_that.name);case _PhotoSourcePicked():
return photoSourcePicked(_that.source,_that.cropLabels);case _RemovePhotoRequested():
return removePhotoRequested();case _PasswordEdited():
return passwordEdited();case _DeleteRequested():
return deleteRequested(_that.password);case _DeleteConfirmed():
return deleteConfirmed(_that.password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( User? user)?  userChanged,TResult? Function( String text)?  nameEdited,TResult? Function( String name)?  saveRequested,TResult? Function( AvatarPhotoSource source,  AvatarCropLabels cropLabels)?  photoSourcePicked,TResult? Function()?  removePhotoRequested,TResult? Function()?  passwordEdited,TResult? Function( String password)?  deleteRequested,TResult? Function( String password)?  deleteConfirmed,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _UserChanged() when userChanged != null:
return userChanged(_that.user);case _NameEdited() when nameEdited != null:
return nameEdited(_that.text);case _SaveRequested() when saveRequested != null:
return saveRequested(_that.name);case _PhotoSourcePicked() when photoSourcePicked != null:
return photoSourcePicked(_that.source,_that.cropLabels);case _RemovePhotoRequested() when removePhotoRequested != null:
return removePhotoRequested();case _PasswordEdited() when passwordEdited != null:
return passwordEdited();case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.password);case _DeleteConfirmed() when deleteConfirmed != null:
return deleteConfirmed(_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _Started with DiagnosticableTreeMixin implements EditProfileEvent {
  const _Started();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.started'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.started()';
}


}




/// @nodoc


class _UserChanged with DiagnosticableTreeMixin implements EditProfileEvent {
  const _UserChanged(this.user);
  

 final  User? user;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserChangedCopyWith<_UserChanged> get copyWith => __$UserChangedCopyWithImpl<_UserChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.userChanged'))
    ..add(DiagnosticsProperty('user', user));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserChanged&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.userChanged(user: $user)';
}


}

/// @nodoc
abstract mixin class _$UserChangedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$UserChangedCopyWith(_UserChanged value, $Res Function(_UserChanged) _then) = __$UserChangedCopyWithImpl;
@useResult
$Res call({
 User? user
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$UserChangedCopyWithImpl<$Res>
    implements _$UserChangedCopyWith<$Res> {
  __$UserChangedCopyWithImpl(this._self, this._then);

  final _UserChanged _self;
  final $Res Function(_UserChanged) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(_UserChanged(
freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _NameEdited with DiagnosticableTreeMixin implements EditProfileEvent {
  const _NameEdited(this.text);
  

 final  String text;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameEditedCopyWith<_NameEdited> get copyWith => __$NameEditedCopyWithImpl<_NameEdited>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.nameEdited'))
    ..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameEdited&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.nameEdited(text: $text)';
}


}

/// @nodoc
abstract mixin class _$NameEditedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$NameEditedCopyWith(_NameEdited value, $Res Function(_NameEdited) _then) = __$NameEditedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$NameEditedCopyWithImpl<$Res>
    implements _$NameEditedCopyWith<$Res> {
  __$NameEditedCopyWithImpl(this._self, this._then);

  final _NameEdited _self;
  final $Res Function(_NameEdited) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_NameEdited(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveRequested with DiagnosticableTreeMixin implements EditProfileEvent {
  const _SaveRequested(this.name);
  

 final  String name;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.saveRequested'))
    ..add(DiagnosticsProperty('name', name));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.saveRequested(name: $name)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
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

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_SaveRequested(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PhotoSourcePicked with DiagnosticableTreeMixin implements EditProfileEvent {
  const _PhotoSourcePicked(this.source, this.cropLabels);
  

 final  AvatarPhotoSource source;
 final  AvatarCropLabels cropLabels;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoSourcePickedCopyWith<_PhotoSourcePicked> get copyWith => __$PhotoSourcePickedCopyWithImpl<_PhotoSourcePicked>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.photoSourcePicked'))
    ..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('cropLabels', cropLabels));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoSourcePicked&&(identical(other.source, source) || other.source == source)&&(identical(other.cropLabels, cropLabels) || other.cropLabels == cropLabels));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source,cropLabels);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.photoSourcePicked(source: $source, cropLabels: $cropLabels)';
}


}

/// @nodoc
abstract mixin class _$PhotoSourcePickedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$PhotoSourcePickedCopyWith(_PhotoSourcePicked value, $Res Function(_PhotoSourcePicked) _then) = __$PhotoSourcePickedCopyWithImpl;
@useResult
$Res call({
 AvatarPhotoSource source, AvatarCropLabels cropLabels
});




}
/// @nodoc
class __$PhotoSourcePickedCopyWithImpl<$Res>
    implements _$PhotoSourcePickedCopyWith<$Res> {
  __$PhotoSourcePickedCopyWithImpl(this._self, this._then);

  final _PhotoSourcePicked _self;
  final $Res Function(_PhotoSourcePicked) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,Object? cropLabels = null,}) {
  return _then(_PhotoSourcePicked(
null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AvatarPhotoSource,null == cropLabels ? _self.cropLabels : cropLabels // ignore: cast_nullable_to_non_nullable
as AvatarCropLabels,
  ));
}


}

/// @nodoc


class _RemovePhotoRequested with DiagnosticableTreeMixin implements EditProfileEvent {
  const _RemovePhotoRequested();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.removePhotoRequested'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemovePhotoRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.removePhotoRequested()';
}


}




/// @nodoc


class _PasswordEdited with DiagnosticableTreeMixin implements EditProfileEvent {
  const _PasswordEdited();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.passwordEdited'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordEdited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.passwordEdited()';
}


}




/// @nodoc


class _DeleteRequested with DiagnosticableTreeMixin implements EditProfileEvent {
  const _DeleteRequested(this.password);
  

 final  String password;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteRequestedCopyWith<_DeleteRequested> get copyWith => __$DeleteRequestedCopyWithImpl<_DeleteRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.deleteRequested'))
    ..add(DiagnosticsProperty('password', password));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.deleteRequested(password: $password)';
}


}

/// @nodoc
abstract mixin class _$DeleteRequestedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$DeleteRequestedCopyWith(_DeleteRequested value, $Res Function(_DeleteRequested) _then) = __$DeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$DeleteRequestedCopyWithImpl<$Res>
    implements _$DeleteRequestedCopyWith<$Res> {
  __$DeleteRequestedCopyWithImpl(this._self, this._then);

  final _DeleteRequested _self;
  final $Res Function(_DeleteRequested) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_DeleteRequested(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteConfirmed with DiagnosticableTreeMixin implements EditProfileEvent {
  const _DeleteConfirmed(this.password);
  

 final  String password;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteConfirmedCopyWith<_DeleteConfirmed> get copyWith => __$DeleteConfirmedCopyWithImpl<_DeleteConfirmed>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileEvent.deleteConfirmed'))
    ..add(DiagnosticsProperty('password', password));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteConfirmed&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileEvent.deleteConfirmed(password: $password)';
}


}

/// @nodoc
abstract mixin class _$DeleteConfirmedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$DeleteConfirmedCopyWith(_DeleteConfirmed value, $Res Function(_DeleteConfirmed) _then) = __$DeleteConfirmedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$DeleteConfirmedCopyWithImpl<$Res>
    implements _$DeleteConfirmedCopyWith<$Res> {
  __$DeleteConfirmedCopyWithImpl(this._self, this._then);

  final _DeleteConfirmed _self;
  final $Res Function(_DeleteConfirmed) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_DeleteConfirmed(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EditProfileState implements DiagnosticableTreeMixin {

 User? get user; bool get nameChanged; FieldError? get nameError; bool get autovalidate; bool get isSavingName; double? get uploadProgress; bool get isPreparingPhoto; bool get isRemovingPhoto; FieldError? get passwordError; bool get isDeleting; bool get askDelete; ProfileNotice? get notice; ProfileFailure? get failure;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as EditProfileState;
  properties
    ..add(DiagnosticsProperty('type', 'EditProfileState'))
    ..add(DiagnosticsProperty('user', _this.user))..add(DiagnosticsProperty('nameChanged', _this.nameChanged))..add(DiagnosticsProperty('nameError', _this.nameError))..add(DiagnosticsProperty('autovalidate', _this.autovalidate))..add(DiagnosticsProperty('isSavingName', _this.isSavingName))..add(DiagnosticsProperty('uploadProgress', _this.uploadProgress))..add(DiagnosticsProperty('isPreparingPhoto', _this.isPreparingPhoto))..add(DiagnosticsProperty('isRemovingPhoto', _this.isRemovingPhoto))..add(DiagnosticsProperty('passwordError', _this.passwordError))..add(DiagnosticsProperty('isDeleting', _this.isDeleting))..add(DiagnosticsProperty('askDelete', _this.askDelete))..add(DiagnosticsProperty('notice', _this.notice))..add(DiagnosticsProperty('failure', _this.failure));
}

@override
bool operator ==(Object other) {
  final _this = this as EditProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.nameChanged, _this.nameChanged) || other.nameChanged == _this.nameChanged)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.isSavingName, _this.isSavingName) || other.isSavingName == _this.isSavingName)&&(identical(other.uploadProgress, _this.uploadProgress) || other.uploadProgress == _this.uploadProgress)&&(identical(other.isPreparingPhoto, _this.isPreparingPhoto) || other.isPreparingPhoto == _this.isPreparingPhoto)&&(identical(other.isRemovingPhoto, _this.isRemovingPhoto) || other.isRemovingPhoto == _this.isRemovingPhoto)&&(identical(other.passwordError, _this.passwordError) || other.passwordError == _this.passwordError)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.askDelete, _this.askDelete) || other.askDelete == _this.askDelete)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as EditProfileState;
  return Object.hash(runtimeType,_this.user,_this.nameChanged,_this.nameError,_this.autovalidate,_this.isSavingName,_this.uploadProgress,_this.isPreparingPhoto,_this.isRemovingPhoto,_this.passwordError,_this.isDeleting,_this.askDelete,_this.notice,_this.failure);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as EditProfileState;
  return 'EditProfileState(user: ${_this.user}, nameChanged: ${_this.nameChanged}, nameError: ${_this.nameError}, autovalidate: ${_this.autovalidate}, isSavingName: ${_this.isSavingName}, uploadProgress: ${_this.uploadProgress}, isPreparingPhoto: ${_this.isPreparingPhoto}, isRemovingPhoto: ${_this.isRemovingPhoto}, passwordError: ${_this.passwordError}, isDeleting: ${_this.isDeleting}, askDelete: ${_this.askDelete}, notice: ${_this.notice}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 User? user, bool nameChanged, FieldError? nameError, bool autovalidate, bool isSavingName, double? uploadProgress, bool isPreparingPhoto, bool isRemovingPhoto, FieldError? passwordError, bool isDeleting, bool askDelete, ProfileNotice? notice, ProfileFailure? failure
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? nameChanged = null,Object? nameError = freezed,Object? autovalidate = null,Object? isSavingName = null,Object? uploadProgress = freezed,Object? isPreparingPhoto = null,Object? isRemovingPhoto = null,Object? passwordError = freezed,Object? isDeleting = null,Object? askDelete = null,Object? notice = freezed,Object? failure = freezed,}) {
  return _then(EditProfileState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,nameChanged: null == nameChanged ? _self.nameChanged : nameChanged // ignore: cast_nullable_to_non_nullable
as bool,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSavingName: null == isSavingName ? _self.isSavingName : isSavingName // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,isPreparingPhoto: null == isPreparingPhoto ? _self.isPreparingPhoto : isPreparingPhoto // ignore: cast_nullable_to_non_nullable
as bool,isRemovingPhoto: null == isRemovingPhoto ? _self.isRemovingPhoto : isRemovingPhoto // ignore: cast_nullable_to_non_nullable
as bool,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,askDelete: null == askDelete ? _self.askDelete : askDelete // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as ProfileNotice?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ProfileFailure?,
  ));
}
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User? user,  bool nameChanged,  FieldError? nameError,  bool autovalidate,  bool isSavingName,  double? uploadProgress,  bool isPreparingPhoto,  bool isRemovingPhoto,  FieldError? passwordError,  bool isDeleting,  bool askDelete,  ProfileNotice? notice,  ProfileFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.user,_that.nameChanged,_that.nameError,_that.autovalidate,_that.isSavingName,_that.uploadProgress,_that.isPreparingPhoto,_that.isRemovingPhoto,_that.passwordError,_that.isDeleting,_that.askDelete,_that.notice,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User? user,  bool nameChanged,  FieldError? nameError,  bool autovalidate,  bool isSavingName,  double? uploadProgress,  bool isPreparingPhoto,  bool isRemovingPhoto,  FieldError? passwordError,  bool isDeleting,  bool askDelete,  ProfileNotice? notice,  ProfileFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that.user,_that.nameChanged,_that.nameError,_that.autovalidate,_that.isSavingName,_that.uploadProgress,_that.isPreparingPhoto,_that.isRemovingPhoto,_that.passwordError,_that.isDeleting,_that.askDelete,_that.notice,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User? user,  bool nameChanged,  FieldError? nameError,  bool autovalidate,  bool isSavingName,  double? uploadProgress,  bool isPreparingPhoto,  bool isRemovingPhoto,  FieldError? passwordError,  bool isDeleting,  bool askDelete,  ProfileNotice? notice,  ProfileFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.user,_that.nameChanged,_that.nameError,_that.autovalidate,_that.isSavingName,_that.uploadProgress,_that.isPreparingPhoto,_that.isRemovingPhoto,_that.passwordError,_that.isDeleting,_that.askDelete,_that.notice,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileState with DiagnosticableTreeMixin implements EditProfileState {
  const _EditProfileState({this.user, this.nameChanged = false, this.nameError, this.autovalidate = false, this.isSavingName = false, this.uploadProgress, this.isPreparingPhoto = false, this.isRemovingPhoto = false, this.passwordError, this.isDeleting = false, this.askDelete = false, this.notice, this.failure});
  

@override final  User? user;
@override@JsonKey() final  bool nameChanged;
@override final  FieldError? nameError;
@override@JsonKey() final  bool autovalidate;
@override@JsonKey() final  bool isSavingName;
@override final  double? uploadProgress;
@override@JsonKey() final  bool isPreparingPhoto;
@override@JsonKey() final  bool isRemovingPhoto;
@override final  FieldError? passwordError;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool askDelete;
@override final  ProfileNotice? notice;
@override final  ProfileFailure? failure;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EditProfileState'))
    ..add(DiagnosticsProperty('user', user))..add(DiagnosticsProperty('nameChanged', nameChanged))..add(DiagnosticsProperty('nameError', nameError))..add(DiagnosticsProperty('autovalidate', autovalidate))..add(DiagnosticsProperty('isSavingName', isSavingName))..add(DiagnosticsProperty('uploadProgress', uploadProgress))..add(DiagnosticsProperty('isPreparingPhoto', isPreparingPhoto))..add(DiagnosticsProperty('isRemovingPhoto', isRemovingPhoto))..add(DiagnosticsProperty('passwordError', passwordError))..add(DiagnosticsProperty('isDeleting', isDeleting))..add(DiagnosticsProperty('askDelete', askDelete))..add(DiagnosticsProperty('notice', notice))..add(DiagnosticsProperty('failure', failure));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.user, user) || other.user == user)&&(identical(other.nameChanged, nameChanged) || other.nameChanged == nameChanged)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.isSavingName, isSavingName) || other.isSavingName == isSavingName)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.isPreparingPhoto, isPreparingPhoto) || other.isPreparingPhoto == isPreparingPhoto)&&(identical(other.isRemovingPhoto, isRemovingPhoto) || other.isRemovingPhoto == isRemovingPhoto)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.askDelete, askDelete) || other.askDelete == askDelete)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user,nameChanged,nameError,autovalidate,isSavingName,uploadProgress,isPreparingPhoto,isRemovingPhoto,passwordError,isDeleting,askDelete,notice,failure);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EditProfileState(user: $user, nameChanged: $nameChanged, nameError: $nameError, autovalidate: $autovalidate, isSavingName: $isSavingName, uploadProgress: $uploadProgress, isPreparingPhoto: $isPreparingPhoto, isRemovingPhoto: $isRemovingPhoto, passwordError: $passwordError, isDeleting: $isDeleting, askDelete: $askDelete, notice: $notice, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 User? user, bool nameChanged, FieldError? nameError, bool autovalidate, bool isSavingName, double? uploadProgress, bool isPreparingPhoto, bool isRemovingPhoto, FieldError? passwordError, bool isDeleting, bool askDelete, ProfileNotice? notice, ProfileFailure? failure
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? nameChanged = null,Object? nameError = freezed,Object? autovalidate = null,Object? isSavingName = null,Object? uploadProgress = freezed,Object? isPreparingPhoto = null,Object? isRemovingPhoto = null,Object? passwordError = freezed,Object? isDeleting = null,Object? askDelete = null,Object? notice = freezed,Object? failure = freezed,}) {
  return _then(_EditProfileState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,nameChanged: null == nameChanged ? _self.nameChanged : nameChanged // ignore: cast_nullable_to_non_nullable
as bool,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,isSavingName: null == isSavingName ? _self.isSavingName : isSavingName // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,isPreparingPhoto: null == isPreparingPhoto ? _self.isPreparingPhoto : isPreparingPhoto // ignore: cast_nullable_to_non_nullable
as bool,isRemovingPhoto: null == isRemovingPhoto ? _self.isRemovingPhoto : isRemovingPhoto // ignore: cast_nullable_to_non_nullable
as bool,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,askDelete: null == askDelete ? _self.askDelete : askDelete // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as ProfileNotice?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ProfileFailure?,
  ));
}

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
