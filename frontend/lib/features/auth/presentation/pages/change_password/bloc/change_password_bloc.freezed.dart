// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePasswordEvent {

 String get currentPassword;
/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordEventCopyWith<ChangePasswordEvent> get copyWith => _$ChangePasswordEventCopyWithImpl<ChangePasswordEvent>(this as ChangePasswordEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangePasswordEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordEvent&&(identical(other.currentPassword, _this.currentPassword) || other.currentPassword == _this.currentPassword));
}


@override
int get hashCode {
  final _this = this as ChangePasswordEvent;
  return Object.hash(runtimeType,_this.currentPassword);
}

@override
String toString() {
  final _this = this as ChangePasswordEvent;
  return 'ChangePasswordEvent(currentPassword: ${_this.currentPassword})';
}


}

/// @nodoc
abstract mixin class $ChangePasswordEventCopyWith<$Res>  {
  factory $ChangePasswordEventCopyWith(ChangePasswordEvent value, $Res Function(ChangePasswordEvent) _then) = _$ChangePasswordEventCopyWithImpl;
@useResult
$Res call({
 String currentPassword
});




}
/// @nodoc
class _$ChangePasswordEventCopyWithImpl<$Res>
    implements $ChangePasswordEventCopyWith<$Res> {
  _$ChangePasswordEventCopyWithImpl(this._self, this._then);

  final ChangePasswordEvent _self;
  final $Res Function(ChangePasswordEvent) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPassword = null,}) {
  return _then(_self.copyWith(
currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordEvent].
extension ChangePasswordEventPatterns on ChangePasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CurrentPasswordEdited value)?  currentPasswordEdited,TResult Function( _NewPasswordEdited value)?  newPasswordEdited,TResult Function( _Submitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentPasswordEdited() when currentPasswordEdited != null:
return currentPasswordEdited(_that);case _NewPasswordEdited() when newPasswordEdited != null:
return newPasswordEdited(_that);case _Submitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CurrentPasswordEdited value)  currentPasswordEdited,required TResult Function( _NewPasswordEdited value)  newPasswordEdited,required TResult Function( _Submitted value)  submitted,}){
final _that = this;
switch (_that) {
case _CurrentPasswordEdited():
return currentPasswordEdited(_that);case _NewPasswordEdited():
return newPasswordEdited(_that);case _Submitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CurrentPasswordEdited value)?  currentPasswordEdited,TResult? Function( _NewPasswordEdited value)?  newPasswordEdited,TResult? Function( _Submitted value)?  submitted,}){
final _that = this;
switch (_that) {
case _CurrentPasswordEdited() when currentPasswordEdited != null:
return currentPasswordEdited(_that);case _NewPasswordEdited() when newPasswordEdited != null:
return newPasswordEdited(_that);case _Submitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String currentPassword)?  currentPasswordEdited,TResult Function( String newPassword,  String currentPassword)?  newPasswordEdited,TResult Function( String currentPassword,  String newPassword)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentPasswordEdited() when currentPasswordEdited != null:
return currentPasswordEdited(_that.currentPassword);case _NewPasswordEdited() when newPasswordEdited != null:
return newPasswordEdited(_that.newPassword,_that.currentPassword);case _Submitted() when submitted != null:
return submitted(_that.currentPassword,_that.newPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String currentPassword)  currentPasswordEdited,required TResult Function( String newPassword,  String currentPassword)  newPasswordEdited,required TResult Function( String currentPassword,  String newPassword)  submitted,}) {final _that = this;
switch (_that) {
case _CurrentPasswordEdited():
return currentPasswordEdited(_that.currentPassword);case _NewPasswordEdited():
return newPasswordEdited(_that.newPassword,_that.currentPassword);case _Submitted():
return submitted(_that.currentPassword,_that.newPassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String currentPassword)?  currentPasswordEdited,TResult? Function( String newPassword,  String currentPassword)?  newPasswordEdited,TResult? Function( String currentPassword,  String newPassword)?  submitted,}) {final _that = this;
switch (_that) {
case _CurrentPasswordEdited() when currentPasswordEdited != null:
return currentPasswordEdited(_that.currentPassword);case _NewPasswordEdited() when newPasswordEdited != null:
return newPasswordEdited(_that.newPassword,_that.currentPassword);case _Submitted() when submitted != null:
return submitted(_that.currentPassword,_that.newPassword);case _:
  return null;

}
}

}

/// @nodoc


class _CurrentPasswordEdited implements ChangePasswordEvent {
  const _CurrentPasswordEdited(this.currentPassword);
  

@override final  String currentPassword;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentPasswordEditedCopyWith<_CurrentPasswordEdited> get copyWith => __$CurrentPasswordEditedCopyWithImpl<_CurrentPasswordEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentPasswordEdited&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentPassword);
}

@override
String toString() {
    return 'ChangePasswordEvent.currentPasswordEdited(currentPassword: $currentPassword)';
}


}

/// @nodoc
abstract mixin class _$CurrentPasswordEditedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory _$CurrentPasswordEditedCopyWith(_CurrentPasswordEdited value, $Res Function(_CurrentPasswordEdited) _then) = __$CurrentPasswordEditedCopyWithImpl;
@override @useResult
$Res call({
 String currentPassword
});




}
/// @nodoc
class __$CurrentPasswordEditedCopyWithImpl<$Res>
    implements _$CurrentPasswordEditedCopyWith<$Res> {
  __$CurrentPasswordEditedCopyWithImpl(this._self, this._then);

  final _CurrentPasswordEdited _self;
  final $Res Function(_CurrentPasswordEdited) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPassword = null,}) {
  return _then(_CurrentPasswordEdited(
null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NewPasswordEdited implements ChangePasswordEvent {
  const _NewPasswordEdited({required this.newPassword, required this.currentPassword});
  

 final  String newPassword;
@override final  String currentPassword;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewPasswordEditedCopyWith<_NewPasswordEdited> get copyWith => __$NewPasswordEditedCopyWithImpl<_NewPasswordEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewPasswordEdited&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword));
}


@override
int get hashCode {
    return Object.hash(runtimeType,newPassword,currentPassword);
}

@override
String toString() {
    return 'ChangePasswordEvent.newPasswordEdited(newPassword: $newPassword, currentPassword: $currentPassword)';
}


}

/// @nodoc
abstract mixin class _$NewPasswordEditedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory _$NewPasswordEditedCopyWith(_NewPasswordEdited value, $Res Function(_NewPasswordEdited) _then) = __$NewPasswordEditedCopyWithImpl;
@override @useResult
$Res call({
 String newPassword, String currentPassword
});




}
/// @nodoc
class __$NewPasswordEditedCopyWithImpl<$Res>
    implements _$NewPasswordEditedCopyWith<$Res> {
  __$NewPasswordEditedCopyWithImpl(this._self, this._then);

  final _NewPasswordEdited _self;
  final $Res Function(_NewPasswordEdited) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newPassword = null,Object? currentPassword = null,}) {
  return _then(_NewPasswordEdited(
newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Submitted implements ChangePasswordEvent {
  const _Submitted({required this.currentPassword, required this.newPassword});
  

@override final  String currentPassword;
 final  String newPassword;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittedCopyWith<_Submitted> get copyWith => __$SubmittedCopyWithImpl<_Submitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentPassword,newPassword);
}

@override
String toString() {
    return 'ChangePasswordEvent.submitted(currentPassword: $currentPassword, newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class _$SubmittedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory _$SubmittedCopyWith(_Submitted value, $Res Function(_Submitted) _then) = __$SubmittedCopyWithImpl;
@override @useResult
$Res call({
 String currentPassword, String newPassword
});




}
/// @nodoc
class __$SubmittedCopyWithImpl<$Res>
    implements _$SubmittedCopyWith<$Res> {
  __$SubmittedCopyWithImpl(this._self, this._then);

  final _Submitted _self;
  final $Res Function(_Submitted) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPassword = null,Object? newPassword = null,}) {
  return _then(_Submitted(
currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChangePasswordState {

 UiStatus get status; FieldError? get currentPasswordError; FieldError? get newPasswordError; bool get hasCurrentPassword; bool get hasNewPassword; bool get newPasswordLongEnough; AuthFormError? get formError; bool get autovalidate; AuthField? get focusField;
/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordStateCopyWith<ChangePasswordState> get copyWith => _$ChangePasswordStateCopyWithImpl<ChangePasswordState>(this as ChangePasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangePasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.currentPasswordError, _this.currentPasswordError) || other.currentPasswordError == _this.currentPasswordError)&&(identical(other.newPasswordError, _this.newPasswordError) || other.newPasswordError == _this.newPasswordError)&&(identical(other.hasCurrentPassword, _this.hasCurrentPassword) || other.hasCurrentPassword == _this.hasCurrentPassword)&&(identical(other.hasNewPassword, _this.hasNewPassword) || other.hasNewPassword == _this.hasNewPassword)&&(identical(other.newPasswordLongEnough, _this.newPasswordLongEnough) || other.newPasswordLongEnough == _this.newPasswordLongEnough)&&(identical(other.formError, _this.formError) || other.formError == _this.formError)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.focusField, _this.focusField) || other.focusField == _this.focusField));
}


@override
int get hashCode {
  final _this = this as ChangePasswordState;
  return Object.hash(runtimeType,_this.status,_this.currentPasswordError,_this.newPasswordError,_this.hasCurrentPassword,_this.hasNewPassword,_this.newPasswordLongEnough,_this.formError,_this.autovalidate,_this.focusField);
}

@override
String toString() {
  final _this = this as ChangePasswordState;
  return 'ChangePasswordState(status: ${_this.status}, currentPasswordError: ${_this.currentPasswordError}, newPasswordError: ${_this.newPasswordError}, hasCurrentPassword: ${_this.hasCurrentPassword}, hasNewPassword: ${_this.hasNewPassword}, newPasswordLongEnough: ${_this.newPasswordLongEnough}, formError: ${_this.formError}, autovalidate: ${_this.autovalidate}, focusField: ${_this.focusField})';
}


}

/// @nodoc
abstract mixin class $ChangePasswordStateCopyWith<$Res>  {
  factory $ChangePasswordStateCopyWith(ChangePasswordState value, $Res Function(ChangePasswordState) _then) = _$ChangePasswordStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, FieldError? currentPasswordError, FieldError? newPasswordError, bool hasCurrentPassword, bool hasNewPassword, bool newPasswordLongEnough, AuthFormError? formError, bool autovalidate, AuthField? focusField
});


$AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final ChangePasswordState _self;
  final $Res Function(ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? currentPasswordError = freezed,Object? newPasswordError = freezed,Object? hasCurrentPassword = null,Object? hasNewPassword = null,Object? newPasswordLongEnough = null,Object? formError = freezed,Object? autovalidate = null,Object? focusField = freezed,}) {
  return _then(ChangePasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,currentPasswordError: freezed == currentPasswordError ? _self.currentPasswordError : currentPasswordError // ignore: cast_nullable_to_non_nullable
as FieldError?,newPasswordError: freezed == newPasswordError ? _self.newPasswordError : newPasswordError // ignore: cast_nullable_to_non_nullable
as FieldError?,hasCurrentPassword: null == hasCurrentPassword ? _self.hasCurrentPassword : hasCurrentPassword // ignore: cast_nullable_to_non_nullable
as bool,hasNewPassword: null == hasNewPassword ? _self.hasNewPassword : hasNewPassword // ignore: cast_nullable_to_non_nullable
as bool,newPasswordLongEnough: null == newPasswordLongEnough ? _self.newPasswordLongEnough : newPasswordLongEnough // ignore: cast_nullable_to_non_nullable
as bool,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}
/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFormErrorCopyWith<$Res>? get formError {
    if (_self.formError == null) {
    return null;
  }

  return $AuthFormErrorCopyWith<$Res>(_self.formError!, (value) {
    return _then(_self.copyWith(formError: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangePasswordState].
extension ChangePasswordStatePatterns on ChangePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? currentPasswordError,  FieldError? newPasswordError,  bool hasCurrentPassword,  bool hasNewPassword,  bool newPasswordLongEnough,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.status,_that.currentPasswordError,_that.newPasswordError,_that.hasCurrentPassword,_that.hasNewPassword,_that.newPasswordLongEnough,_that.formError,_that.autovalidate,_that.focusField);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? currentPasswordError,  FieldError? newPasswordError,  bool hasCurrentPassword,  bool hasNewPassword,  bool newPasswordLongEnough,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState():
return $default(_that.status,_that.currentPasswordError,_that.newPasswordError,_that.hasCurrentPassword,_that.hasNewPassword,_that.newPasswordLongEnough,_that.formError,_that.autovalidate,_that.focusField);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  FieldError? currentPasswordError,  FieldError? newPasswordError,  bool hasCurrentPassword,  bool hasNewPassword,  bool newPasswordLongEnough,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)?  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.status,_that.currentPasswordError,_that.newPasswordError,_that.hasCurrentPassword,_that.hasNewPassword,_that.newPasswordLongEnough,_that.formError,_that.autovalidate,_that.focusField);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePasswordState implements ChangePasswordState {
  const _ChangePasswordState({this.status = UiStatus.initial, this.currentPasswordError, this.newPasswordError, this.hasCurrentPassword = false, this.hasNewPassword = false, this.newPasswordLongEnough = false, this.formError, this.autovalidate = false, this.focusField});
  

@override@JsonKey() final  UiStatus status;
@override final  FieldError? currentPasswordError;
@override final  FieldError? newPasswordError;
@override@JsonKey() final  bool hasCurrentPassword;
@override@JsonKey() final  bool hasNewPassword;
@override@JsonKey() final  bool newPasswordLongEnough;
@override final  AuthFormError? formError;
@override@JsonKey() final  bool autovalidate;
@override final  AuthField? focusField;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePasswordStateCopyWith<_ChangePasswordState> get copyWith => __$ChangePasswordStateCopyWithImpl<_ChangePasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentPasswordError, currentPasswordError) || other.currentPasswordError == currentPasswordError)&&(identical(other.newPasswordError, newPasswordError) || other.newPasswordError == newPasswordError)&&(identical(other.hasCurrentPassword, hasCurrentPassword) || other.hasCurrentPassword == hasCurrentPassword)&&(identical(other.hasNewPassword, hasNewPassword) || other.hasNewPassword == hasNewPassword)&&(identical(other.newPasswordLongEnough, newPasswordLongEnough) || other.newPasswordLongEnough == newPasswordLongEnough)&&(identical(other.formError, formError) || other.formError == formError)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.focusField, focusField) || other.focusField == focusField));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,currentPasswordError,newPasswordError,hasCurrentPassword,hasNewPassword,newPasswordLongEnough,formError,autovalidate,focusField);
}

@override
String toString() {
    return 'ChangePasswordState(status: $status, currentPasswordError: $currentPasswordError, newPasswordError: $newPasswordError, hasCurrentPassword: $hasCurrentPassword, hasNewPassword: $hasNewPassword, newPasswordLongEnough: $newPasswordLongEnough, formError: $formError, autovalidate: $autovalidate, focusField: $focusField)';
}


}

/// @nodoc
abstract mixin class _$ChangePasswordStateCopyWith<$Res> implements $ChangePasswordStateCopyWith<$Res> {
  factory _$ChangePasswordStateCopyWith(_ChangePasswordState value, $Res Function(_ChangePasswordState) _then) = __$ChangePasswordStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, FieldError? currentPasswordError, FieldError? newPasswordError, bool hasCurrentPassword, bool hasNewPassword, bool newPasswordLongEnough, AuthFormError? formError, bool autovalidate, AuthField? focusField
});


@override $AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class __$ChangePasswordStateCopyWithImpl<$Res>
    implements _$ChangePasswordStateCopyWith<$Res> {
  __$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final _ChangePasswordState _self;
  final $Res Function(_ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? currentPasswordError = freezed,Object? newPasswordError = freezed,Object? hasCurrentPassword = null,Object? hasNewPassword = null,Object? newPasswordLongEnough = null,Object? formError = freezed,Object? autovalidate = null,Object? focusField = freezed,}) {
  return _then(_ChangePasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,currentPasswordError: freezed == currentPasswordError ? _self.currentPasswordError : currentPasswordError // ignore: cast_nullable_to_non_nullable
as FieldError?,newPasswordError: freezed == newPasswordError ? _self.newPasswordError : newPasswordError // ignore: cast_nullable_to_non_nullable
as FieldError?,hasCurrentPassword: null == hasCurrentPassword ? _self.hasCurrentPassword : hasCurrentPassword // ignore: cast_nullable_to_non_nullable
as bool,hasNewPassword: null == hasNewPassword ? _self.hasNewPassword : hasNewPassword // ignore: cast_nullable_to_non_nullable
as bool,newPasswordLongEnough: null == newPasswordLongEnough ? _self.newPasswordLongEnough : newPasswordLongEnough // ignore: cast_nullable_to_non_nullable
as bool,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFormErrorCopyWith<$Res>? get formError {
    if (_self.formError == null) {
    return null;
  }

  return $AuthFormErrorCopyWith<$Res>(_self.formError!, (value) {
    return _then(_self.copyWith(formError: value));
  });
}
}

// dart format on
