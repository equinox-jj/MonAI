// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignInEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SignInEvent()';
}


}

/// @nodoc
class $SignInEventCopyWith<$Res>  {
$SignInEventCopyWith(SignInEvent _, $Res Function(SignInEvent) __);
}


/// Adds pattern-matching-related methods to [SignInEvent].
extension SignInEventPatterns on SignInEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EmailEdited value)?  emailEdited,TResult Function( _PasswordEdited value)?  passwordEdited,TResult Function( _Submitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailEdited() when emailEdited != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EmailEdited value)  emailEdited,required TResult Function( _PasswordEdited value)  passwordEdited,required TResult Function( _Submitted value)  submitted,}){
final _that = this;
switch (_that) {
case _EmailEdited():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EmailEdited value)?  emailEdited,TResult? Function( _PasswordEdited value)?  passwordEdited,TResult? Function( _Submitted value)?  submitted,}){
final _that = this;
switch (_that) {
case _EmailEdited() when emailEdited != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email)?  emailEdited,TResult Function( String password)?  passwordEdited,TResult Function( String email,  String password)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailEdited() when emailEdited != null:
return emailEdited(_that.email);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that.password);case _Submitted() when submitted != null:
return submitted(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email)  emailEdited,required TResult Function( String password)  passwordEdited,required TResult Function( String email,  String password)  submitted,}) {final _that = this;
switch (_that) {
case _EmailEdited():
return emailEdited(_that.email);case _PasswordEdited():
return passwordEdited(_that.password);case _Submitted():
return submitted(_that.email,_that.password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email)?  emailEdited,TResult? Function( String password)?  passwordEdited,TResult? Function( String email,  String password)?  submitted,}) {final _that = this;
switch (_that) {
case _EmailEdited() when emailEdited != null:
return emailEdited(_that.email);case _PasswordEdited() when passwordEdited != null:
return passwordEdited(_that.password);case _Submitted() when submitted != null:
return submitted(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _EmailEdited implements SignInEvent {
  const _EmailEdited(this.email);
  

 final  String email;

/// Create a copy of SignInEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailEditedCopyWith<_EmailEdited> get copyWith => __$EmailEditedCopyWithImpl<_EmailEdited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailEdited&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'SignInEvent.emailEdited(email: $email)';
}


}

/// @nodoc
abstract mixin class _$EmailEditedCopyWith<$Res> implements $SignInEventCopyWith<$Res> {
  factory _$EmailEditedCopyWith(_EmailEdited value, $Res Function(_EmailEdited) _then) = __$EmailEditedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$EmailEditedCopyWithImpl<$Res>
    implements _$EmailEditedCopyWith<$Res> {
  __$EmailEditedCopyWithImpl(this._self, this._then);

  final _EmailEdited _self;
  final $Res Function(_EmailEdited) _then;

/// Create a copy of SignInEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_EmailEdited(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PasswordEdited implements SignInEvent {
  const _PasswordEdited(this.password);
  

 final  String password;

/// Create a copy of SignInEvent
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
    return 'SignInEvent.passwordEdited(password: $password)';
}


}

/// @nodoc
abstract mixin class _$PasswordEditedCopyWith<$Res> implements $SignInEventCopyWith<$Res> {
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

/// Create a copy of SignInEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_PasswordEdited(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Submitted implements SignInEvent {
  const _Submitted({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of SignInEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittedCopyWith<_Submitted> get copyWith => __$SubmittedCopyWithImpl<_Submitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,password);
}

@override
String toString() {
    return 'SignInEvent.submitted(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SubmittedCopyWith<$Res> implements $SignInEventCopyWith<$Res> {
  factory _$SubmittedCopyWith(_Submitted value, $Res Function(_Submitted) _then) = __$SubmittedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$SubmittedCopyWithImpl<$Res>
    implements _$SubmittedCopyWith<$Res> {
  __$SubmittedCopyWithImpl(this._self, this._then);

  final _Submitted _self;
  final $Res Function(_Submitted) _then;

/// Create a copy of SignInEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_Submitted(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SignInState {

/// [UiStatus.loading] while signing in. [UiStatus.success] stays until
/// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
 UiStatus get status; FieldError? get emailError; FieldError? get passwordError;/// A problem with the whole attempt, shown as a banner.
 AuthFormError? get formError;/// A submit failed on the input, so each edit re-checks its field.
 bool get autovalidate;/// The first field with an error after a failed submit; the screen
/// focuses it so the keyboard and screen reader land on the error.
 AuthField? get focusField;
/// Create a copy of SignInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInStateCopyWith<SignInState> get copyWith => _$SignInStateCopyWithImpl<SignInState>(this as SignInState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignInState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.emailError, _this.emailError) || other.emailError == _this.emailError)&&(identical(other.passwordError, _this.passwordError) || other.passwordError == _this.passwordError)&&(identical(other.formError, _this.formError) || other.formError == _this.formError)&&(identical(other.autovalidate, _this.autovalidate) || other.autovalidate == _this.autovalidate)&&(identical(other.focusField, _this.focusField) || other.focusField == _this.focusField));
}


@override
int get hashCode {
  final _this = this as SignInState;
  return Object.hash(runtimeType,_this.status,_this.emailError,_this.passwordError,_this.formError,_this.autovalidate,_this.focusField);
}

@override
String toString() {
  final _this = this as SignInState;
  return 'SignInState(status: ${_this.status}, emailError: ${_this.emailError}, passwordError: ${_this.passwordError}, formError: ${_this.formError}, autovalidate: ${_this.autovalidate}, focusField: ${_this.focusField})';
}


}

/// @nodoc
abstract mixin class $SignInStateCopyWith<$Res>  {
  factory $SignInStateCopyWith(SignInState value, $Res Function(SignInState) _then) = _$SignInStateCopyWithImpl;
@useResult
$Res call({
 UiStatus status, FieldError? emailError, FieldError? passwordError, AuthFormError? formError, bool autovalidate, AuthField? focusField
});


$AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class _$SignInStateCopyWithImpl<$Res>
    implements $SignInStateCopyWith<$Res> {
  _$SignInStateCopyWithImpl(this._self, this._then);

  final SignInState _self;
  final $Res Function(SignInState) _then;

/// Create a copy of SignInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? emailError = freezed,Object? passwordError = freezed,Object? formError = freezed,Object? autovalidate = null,Object? focusField = freezed,}) {
  return _then(SignInState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as FieldError?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}
/// Create a copy of SignInState
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


/// Adds pattern-matching-related methods to [SignInState].
extension SignInStatePatterns on SignInState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInState value)  $default,){
final _that = this;
switch (_that) {
case _SignInState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInState value)?  $default,){
final _that = this;
switch (_that) {
case _SignInState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? emailError,  FieldError? passwordError,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignInState() when $default != null:
return $default(_that.status,_that.emailError,_that.passwordError,_that.formError,_that.autovalidate,_that.focusField);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UiStatus status,  FieldError? emailError,  FieldError? passwordError,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)  $default,) {final _that = this;
switch (_that) {
case _SignInState():
return $default(_that.status,_that.emailError,_that.passwordError,_that.formError,_that.autovalidate,_that.focusField);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UiStatus status,  FieldError? emailError,  FieldError? passwordError,  AuthFormError? formError,  bool autovalidate,  AuthField? focusField)?  $default,) {final _that = this;
switch (_that) {
case _SignInState() when $default != null:
return $default(_that.status,_that.emailError,_that.passwordError,_that.formError,_that.autovalidate,_that.focusField);case _:
  return null;

}
}

}

/// @nodoc


class _SignInState implements SignInState {
  const _SignInState({this.status = UiStatus.initial, this.emailError, this.passwordError, this.formError, this.autovalidate = false, this.focusField});
  

/// [UiStatus.loading] while signing in. [UiStatus.success] stays until
/// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
@override@JsonKey() final  UiStatus status;
@override final  FieldError? emailError;
@override final  FieldError? passwordError;
/// A problem with the whole attempt, shown as a banner.
@override final  AuthFormError? formError;
/// A submit failed on the input, so each edit re-checks its field.
@override@JsonKey() final  bool autovalidate;
/// The first field with an error after a failed submit; the screen
/// focuses it so the keyboard and screen reader land on the error.
@override final  AuthField? focusField;

/// Create a copy of SignInState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInStateCopyWith<_SignInState> get copyWith => __$SignInStateCopyWithImpl<_SignInState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInState&&(identical(other.status, status) || other.status == status)&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.formError, formError) || other.formError == formError)&&(identical(other.autovalidate, autovalidate) || other.autovalidate == autovalidate)&&(identical(other.focusField, focusField) || other.focusField == focusField));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,emailError,passwordError,formError,autovalidate,focusField);
}

@override
String toString() {
    return 'SignInState(status: $status, emailError: $emailError, passwordError: $passwordError, formError: $formError, autovalidate: $autovalidate, focusField: $focusField)';
}


}

/// @nodoc
abstract mixin class _$SignInStateCopyWith<$Res> implements $SignInStateCopyWith<$Res> {
  factory _$SignInStateCopyWith(_SignInState value, $Res Function(_SignInState) _then) = __$SignInStateCopyWithImpl;
@override @useResult
$Res call({
 UiStatus status, FieldError? emailError, FieldError? passwordError, AuthFormError? formError, bool autovalidate, AuthField? focusField
});


@override $AuthFormErrorCopyWith<$Res>? get formError;

}
/// @nodoc
class __$SignInStateCopyWithImpl<$Res>
    implements _$SignInStateCopyWith<$Res> {
  __$SignInStateCopyWithImpl(this._self, this._then);

  final _SignInState _self;
  final $Res Function(_SignInState) _then;

/// Create a copy of SignInState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? emailError = freezed,Object? passwordError = freezed,Object? formError = freezed,Object? autovalidate = null,Object? focusField = freezed,}) {
  return _then(_SignInState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as FieldError?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as FieldError?,formError: freezed == formError ? _self.formError : formError // ignore: cast_nullable_to_non_nullable
as AuthFormError?,autovalidate: null == autovalidate ? _self.autovalidate : autovalidate // ignore: cast_nullable_to_non_nullable
as bool,focusField: freezed == focusField ? _self.focusField : focusField // ignore: cast_nullable_to_non_nullable
as AuthField?,
  ));
}

/// Create a copy of SignInState
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
