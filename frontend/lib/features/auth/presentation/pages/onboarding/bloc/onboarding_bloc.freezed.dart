// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OnboardingEvent()';
}


}

/// @nodoc
class $OnboardingEventCopyWith<$Res>  {
$OnboardingEventCopyWith(OnboardingEvent _, $Res Function(OnboardingEvent) __);
}


/// Adds pattern-matching-related methods to [OnboardingEvent].
extension OnboardingEventPatterns on OnboardingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NextPressed value)?  nextPressed,TResult Function( _BackPressed value)?  backPressed,TResult Function( _PageChanged value)?  pageChanged,TResult Function( _ExitPressed value)?  exitPressed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextPressed() when nextPressed != null:
return nextPressed(_that);case _BackPressed() when backPressed != null:
return backPressed(_that);case _PageChanged() when pageChanged != null:
return pageChanged(_that);case _ExitPressed() when exitPressed != null:
return exitPressed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NextPressed value)  nextPressed,required TResult Function( _BackPressed value)  backPressed,required TResult Function( _PageChanged value)  pageChanged,required TResult Function( _ExitPressed value)  exitPressed,}){
final _that = this;
switch (_that) {
case _NextPressed():
return nextPressed(_that);case _BackPressed():
return backPressed(_that);case _PageChanged():
return pageChanged(_that);case _ExitPressed():
return exitPressed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NextPressed value)?  nextPressed,TResult? Function( _BackPressed value)?  backPressed,TResult? Function( _PageChanged value)?  pageChanged,TResult? Function( _ExitPressed value)?  exitPressed,}){
final _that = this;
switch (_that) {
case _NextPressed() when nextPressed != null:
return nextPressed(_that);case _BackPressed() when backPressed != null:
return backPressed(_that);case _PageChanged() when pageChanged != null:
return pageChanged(_that);case _ExitPressed() when exitPressed != null:
return exitPressed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  nextPressed,TResult Function()?  backPressed,TResult Function( int page)?  pageChanged,TResult Function( OnboardingExit exit)?  exitPressed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextPressed() when nextPressed != null:
return nextPressed();case _BackPressed() when backPressed != null:
return backPressed();case _PageChanged() when pageChanged != null:
return pageChanged(_that.page);case _ExitPressed() when exitPressed != null:
return exitPressed(_that.exit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  nextPressed,required TResult Function()  backPressed,required TResult Function( int page)  pageChanged,required TResult Function( OnboardingExit exit)  exitPressed,}) {final _that = this;
switch (_that) {
case _NextPressed():
return nextPressed();case _BackPressed():
return backPressed();case _PageChanged():
return pageChanged(_that.page);case _ExitPressed():
return exitPressed(_that.exit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  nextPressed,TResult? Function()?  backPressed,TResult? Function( int page)?  pageChanged,TResult? Function( OnboardingExit exit)?  exitPressed,}) {final _that = this;
switch (_that) {
case _NextPressed() when nextPressed != null:
return nextPressed();case _BackPressed() when backPressed != null:
return backPressed();case _PageChanged() when pageChanged != null:
return pageChanged(_that.page);case _ExitPressed() when exitPressed != null:
return exitPressed(_that.exit);case _:
  return null;

}
}

}

/// @nodoc


class _NextPressed implements OnboardingEvent {
  const _NextPressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OnboardingEvent.nextPressed()';
}


}




/// @nodoc


class _BackPressed implements OnboardingEvent {
  const _BackPressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OnboardingEvent.backPressed()';
}


}




/// @nodoc


class _PageChanged implements OnboardingEvent {
  const _PageChanged(this.page);
  

 final  int page;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageChangedCopyWith<_PageChanged> get copyWith => __$PageChangedCopyWithImpl<_PageChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageChanged&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode {
    return Object.hash(runtimeType,page);
}

@override
String toString() {
    return 'OnboardingEvent.pageChanged(page: $page)';
}


}

/// @nodoc
abstract mixin class _$PageChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory _$PageChangedCopyWith(_PageChanged value, $Res Function(_PageChanged) _then) = __$PageChangedCopyWithImpl;
@useResult
$Res call({
 int page
});




}
/// @nodoc
class __$PageChangedCopyWithImpl<$Res>
    implements _$PageChangedCopyWith<$Res> {
  __$PageChangedCopyWithImpl(this._self, this._then);

  final _PageChanged _self;
  final $Res Function(_PageChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? page = null,}) {
  return _then(_PageChanged(
null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ExitPressed implements OnboardingEvent {
  const _ExitPressed(this.exit);
  

 final  OnboardingExit exit;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExitPressedCopyWith<_ExitPressed> get copyWith => __$ExitPressedCopyWithImpl<_ExitPressed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExitPressed&&(identical(other.exit, exit) || other.exit == exit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exit);
}

@override
String toString() {
    return 'OnboardingEvent.exitPressed(exit: $exit)';
}


}

/// @nodoc
abstract mixin class _$ExitPressedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory _$ExitPressedCopyWith(_ExitPressed value, $Res Function(_ExitPressed) _then) = __$ExitPressedCopyWithImpl;
@useResult
$Res call({
 OnboardingExit exit
});




}
/// @nodoc
class __$ExitPressedCopyWithImpl<$Res>
    implements _$ExitPressedCopyWith<$Res> {
  __$ExitPressedCopyWithImpl(this._self, this._then);

  final _ExitPressed _self;
  final $Res Function(_ExitPressed) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exit = null,}) {
  return _then(_ExitPressed(
null == exit ? _self.exit : exit // ignore: cast_nullable_to_non_nullable
as OnboardingExit,
  ));
}


}

/// @nodoc
mixin _$OnboardingState {

 int get page; UiStatus get status; OnboardingExit? get exit;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.exit, _this.exit) || other.exit == _this.exit));
}


@override
int get hashCode {
  final _this = this as OnboardingState;
  return Object.hash(runtimeType,_this.page,_this.status,_this.exit);
}

@override
String toString() {
  final _this = this as OnboardingState;
  return 'OnboardingState(page: ${_this.page}, status: ${_this.status}, exit: ${_this.exit})';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int page, UiStatus status, OnboardingExit? exit
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? status = null,Object? exit = freezed,}) {
  return _then(OnboardingState(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,exit: freezed == exit ? _self.exit : exit // ignore: cast_nullable_to_non_nullable
as OnboardingExit?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  UiStatus status,  OnboardingExit? exit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.page,_that.status,_that.exit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  UiStatus status,  OnboardingExit? exit)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.page,_that.status,_that.exit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  UiStatus status,  OnboardingExit? exit)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.page,_that.status,_that.exit);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.page = 0, this.status = UiStatus.initial, this.exit});
  

@override@JsonKey() final  int page;
@override@JsonKey() final  UiStatus status;
@override final  OnboardingExit? exit;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.page, page) || other.page == page)&&(identical(other.status, status) || other.status == status)&&(identical(other.exit, exit) || other.exit == exit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,page,status,exit);
}

@override
String toString() {
    return 'OnboardingState(page: $page, status: $status, exit: $exit)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int page, UiStatus status, OnboardingExit? exit
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? status = null,Object? exit = freezed,}) {
  return _then(_OnboardingState(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,exit: freezed == exit ? _self.exit : exit // ignore: cast_nullable_to_non_nullable
as OnboardingExit?,
  ));
}


}

// dart format on
