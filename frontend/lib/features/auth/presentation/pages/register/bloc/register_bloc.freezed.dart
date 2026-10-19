// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterEvent()';
}


}

/// @nodoc
class $RegisterEventCopyWith<$Res>  {
$RegisterEventCopyWith(RegisterEvent _, $Res Function(RegisterEvent) __);
}


/// Adds pattern-matching-related methods to [RegisterEvent].
extension RegisterEventPatterns on RegisterEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NameEdited value)?  nameEdited,TResult Function( _EmailEdited value)?  emailEdited,TResult Function( _PasswordEdited value)?  passwordEdited,TResult Function( _Submitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _EmailEdited() when emailEdited != null:
return emailEdited(_that);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that);case _Submitted() when submitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NameEdited value)  nameEdited,required TResult Function( _EmailEdited value)  emailEdited,required TResult Function( _PasswordEdited value)  passwordEdited,required TResult Function( _Submitted value)  submitted,}){
final _that = this;
switch (_that) {
case _NameEdited():
return nameEdited(_that);case _EmailEdited():
return emailEdited(_that);case _PasswordEdited():
return passwordEdited(_that);case _Submitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NameEdited value)?  nameEdited,TResult? Function( _EmailEdited value)?  emailEdited,TResult? Function( _PasswordEdited value)?  passwordEdited,TResult? Function( _Submitted value)?  submitted,}){
final _that = this;
switch (_that) {
case _NameEdited() when nameEdited != null:
return nameEdited(_that);case _EmailEdited() when emailEdited != null:
return emailEdited(_that);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that);case _Submitted() when submitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  nameEdited,TResult Function()?  emailEdited,TResult Function( String password)?  passwordEdited,TResult Function( String name,  String email,  String password)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameEdited() when nameEdited != null:
return nameEdited();case _EmailEdited() when emailEdited != null:
return emailEdited();case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that.password);case _Submitted() when submitted != null:
return submitted(_that.name,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  nameEdited,required TResult Function()  emailEdited,required TResult Function( String password)  passwordEdited,required TResult Function( String name,  String email,  String password)  submitted,}) {final _that = this;
switch (_that) {
case _NameEdited():
return nameEdited();case _EmailEdited():
return emailEdited();case _PasswordEdited():
return passwordEdited(_that.password);case _Submitted():
return submitted(_that.name,_that.email,_that.password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  nameEdited,TResult? Function()?  emailEdited,TResult? Function( String password)?  passwordEdited,TResult? Function( String name,  String email,  String password)?  submitted,}) {final _that = this;
switch (_that) {
case _NameEdited() when nameEdited != null:
return nameEdited();case _EmailEdited() when emailEdited != null:
return emailEdited();case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that.password);case _Submitted() when submitted != null:
return submitted(_that.name,_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _NameEdited implements RegisterEvent {
  const _NameEdited();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameEdited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterEvent.nameEdited()';
}


}




/// @nodoc


class _EmailEdited implements RegisterEvent {
  const _EmailEdited();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailEdited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterEvent.emailEdited()';
}


}




/// @nodoc


class _PasswordEdited implements RegisterEvent {
  const _PasswordEdited(this.password);
  

 final  String password;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordEditedCopyWith<_PasswordEdited> get copyWith => __$PasswordEditedCopyWithImpl<_PasswordEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordEdited&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString() {
    return 'RegisterEvent.passwordEdited(password: $password)';
}


}

/// @nodoc
abstract mixin class _$PasswordEditedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory _$PasswordEditedCopyWith(_PasswordEdited value, $Res Function(_PasswordEdited) _then) = __$PasswordEditedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$PasswordEditedCopyWithImpl<$Res>
    implements _$PasswordEditedCopyWith<$Res> {
  __$PasswordEditedCopyWithImpl(this._self, this._then);

  final _PasswordEdited _self;
  final $Res Function(_PasswordEdited) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_PasswordEdited(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Submitted implements RegisterEvent {
  const _Submitted({required this.name, required this.email, required this.password});
  

 final  String name;
 final  String email;
 final  String password;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittedCopyWith<_Submitted> get copyWith => __$SubmittedCopyWithImpl<_Submitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,password);
}

@override
String toString() {
    return 'RegisterEvent.submitted(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SubmittedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory _$SubmittedCopyWith(_Submitted value, $Res Function(_Submitted) _then) = __$SubmittedCopyWithImpl;
@useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class __$SubmittedCopyWithImpl<$Res>
    implements _$SubmittedCopyWith<$Res> {
  __$SubmittedCopyWithImpl(this._self, this._then);

  final _Submitted _self;
  final $Res Function(_Submitted) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_Submitted(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RegisterState {

/// [UiStatus.loading] while registering. [UiStatus.success] stays until
/// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
 UiStatus get status; FieldError? get nameError; FieldError? get emailError;/// The email already has an account; the field offers "Sign in instead".
 bool get emailTaken; FieldError? get passwordError;/// Drives the live "At least 8 characters" hint.
 bool get passwordLongEnough;/// A problem with the whole attempt, shown as a banner.
 AuthFormError? get formError;/// The first field with an error after a failed submit; the screen
/// focuses it so the keyboard and screen reader land on the error.
 AuthField? get focusField;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisterState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.emailError, _this.emailError) || other.emailError == _this.emailError)&&(identical(other.emailTaken, _this.emailTaken) || other.emailTaken == _this.emailTaken)&&(identical(other.passwordError, _this.passwordError) || other.passwordError == _this.passwordError)&&(identical(other.passwordLongEnough, _this.passwordLongEnough) || other.passwordLongEnough == _this.passwordLongEnough)&&(identical(other.formError, _this.formError) || other.formError == _this.formError)&&(identical(other.focusField, _this.focusField) || other.focusField == _this.focusField));
}


@override
int get hashCode {
  final _this = this as RegisterState;
  return Object.hash(runtimeType,_this.status,_this.nameError,_this.emailError,_this.emailTaken,_this.passwordError,_this.passwordLongEnough,_this.formError,_this.focusField);
}

@override
String toString() {
  final _this = this as RegisterState;
  return 'RegisterState(status: ${_this.status}, nameError: ${_this.nameError}, emailError: ${_this.emailError}, emailTaken: ${_this.emailTaken}, passwordError: ${_this.passwordError}, passwordLongEnough: ${_this.passwordLongEnough}, formError: ${_this.formError}, focusField: ${_this.focusField})';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, FieldError? nameError, FieldError? emailError, bool emailTaken, FieldError? passwordError, bool passwordLongEnough, AuthFormError? formError, AuthField? focusField
});


$AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? nameError = freezed,Object? emailError = freezed,Object? emailTaken = null,Object? passwordError = freezed,Object? passwordLongEnough = null,Object? formError = freezed,Object? focusField = freezed,}) {
  return _then(RegisterState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as FieldError?,emailTaken: null == emailTaken ? _self.emailTaken : emailTaken // ignore: cast_nullable_to_non_nullable
as bool,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,passwordLongEnough: null == passwordLongEnough ? _self.passwordLongEnough : passwordLongEnough // ignore: cast_nullable_to_non_nullable
as bool,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}
/// Create a copy of RegisterState
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


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? nameError,  FieldError? emailError,  bool emailTaken,  FieldError? passwordError,  bool passwordLongEnough,  AuthFormError? formError,  AuthField? focusField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.status,_that.nameError,_that.emailError,_that.emailTaken,_that.passwordError,_that.passwordLongEnough,_that.formError,_that.focusField);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? nameError,  FieldError? emailError,  bool emailTaken,  FieldError? passwordError,  bool passwordLongEnough,  AuthFormError? formError,  AuthField? focusField)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.status,_that.nameError,_that.emailError,_that.emailTaken,_that.passwordError,_that.passwordLongEnough,_that.formError,_that.focusField);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  FieldError? nameError,  FieldError? emailError,  bool emailTaken,  FieldError? passwordError,  bool passwordLongEnough,  AuthFormError? formError,  AuthField? focusField)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.status,_that.nameError,_that.emailError,_that.emailTaken,_that.passwordError,_that.passwordLongEnough,_that.formError,_that.focusField);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState implements RegisterState {
  const _RegisterState({this.status = UiStatus.initial, this.nameError, this.emailError, this.emailTaken = false, this.passwordError, this.passwordLongEnough = false, this.formError, this.focusField});
  

/// [UiStatus.loading] while registering. [UiStatus.success] stays until
/// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
@override@JsonKey() final  UiStatus status;
@override final  FieldError? nameError;
@override final  FieldError? emailError;
/// The email already has an account; the field offers "Sign in instead".
@override@JsonKey() final  bool emailTaken;
@override final  FieldError? passwordError;
/// Drives the live "At least 8 characters" hint.
@override@JsonKey() final  bool passwordLongEnough;
/// A problem with the whole attempt, shown as a banner.
@override final  AuthFormError? formError;
/// The first field with an error after a failed submit; the screen
/// focuses it so the keyboard and screen reader land on the error.
@override final  AuthField? focusField;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.status, status) || other.status == status)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.emailTaken, emailTaken) || other.emailTaken == emailTaken)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.passwordLongEnough, passwordLongEnough) || other.passwordLongEnough == passwordLongEnough)&&(identical(other.formError, formError) || other.formError == formError)&&(identical(other.focusField, focusField) || other.focusField == focusField));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,nameError,emailError,emailTaken,passwordError,passwordLongEnough,formError,focusField);
}

@override
String toString() {
    return 'RegisterState(status: $status, nameError: $nameError, emailError: $emailError, emailTaken: $emailTaken, passwordError: $passwordError, passwordLongEnough: $passwordLongEnough, formError: $formError, focusField: $focusField)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, FieldError? nameError, FieldError? emailError, bool emailTaken, FieldError? passwordError, bool passwordLongEnough, AuthFormError? formError, AuthField? focusField
});


@override $AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? nameError = freezed,Object? emailError = freezed,Object? emailTaken = null,Object? passwordError = freezed,Object? passwordLongEnough = null,Object? formError = freezed,Object? focusField = freezed,}) {
  return _then(_RegisterState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as FieldError?,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as FieldError?,emailTaken: null == emailTaken ? _self.emailTaken : emailTaken // ignore: cast_nullable_to_non_nullable
as bool,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,passwordLongEnough: null == passwordLongEnough ? _self.passwordLongEnough : passwordLongEnough // ignore: cast_nullable_to_non_nullable
as bool,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}

/// Create a copy of RegisterState
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
