// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddEvent()';
}


}

/// @nodoc
class $QuickAddEventCopyWith<$Res>  {
$QuickAddEventCopyWith(QuickAddEvent _, $Res Function(QuickAddEvent) __);
}


/// Adds pattern-matching-related methods to [QuickAddEvent].
extension QuickAddEventPatterns on QuickAddEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TextChanged value)?  textChanged,TResult Function( _ContinueRequested value)?  continueRequested,TResult Function( _ContextChanged value)?  contextChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TextChanged() when textChanged != null:
return textChanged(_that);case _ContinueRequested() when continueRequested != null:
return continueRequested(_that);case _ContextChanged() when contextChanged != null:
return contextChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TextChanged value)  textChanged,required TResult Function( _ContinueRequested value)  continueRequested,required TResult Function( _ContextChanged value)  contextChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TextChanged():
return textChanged(_that);case _ContinueRequested():
return continueRequested(_that);case _ContextChanged():
return contextChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TextChanged value)?  textChanged,TResult? Function( _ContinueRequested value)?  continueRequested,TResult? Function( _ContextChanged value)?  contextChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TextChanged() when textChanged != null:
return textChanged(_that);case _ContinueRequested() when continueRequested != null:
return continueRequested(_that);case _ContextChanged() when contextChanged != null:
return contextChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String text)?  textChanged,TResult Function( String text)?  continueRequested,TResult Function( ParseContext context)?  contextChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TextChanged() when textChanged != null:
return textChanged(_that.text);case _ContinueRequested() when continueRequested != null:
return continueRequested(_that.text);case _ContextChanged() when contextChanged != null:
return contextChanged(_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String text)  textChanged,required TResult Function( String text)  continueRequested,required TResult Function( ParseContext context)  contextChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _TextChanged():
return textChanged(_that.text);case _ContinueRequested():
return continueRequested(_that.text);case _ContextChanged():
return contextChanged(_that.context);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String text)?  textChanged,TResult? Function( String text)?  continueRequested,TResult? Function( ParseContext context)?  contextChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TextChanged() when textChanged != null:
return textChanged(_that.text);case _ContinueRequested() when continueRequested != null:
return continueRequested(_that.text);case _ContextChanged() when contextChanged != null:
return contextChanged(_that.context);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements QuickAddEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddEvent.started()';
}


}




/// @nodoc


class _TextChanged implements QuickAddEvent {
  const _TextChanged(this.text);
  

 final  String text;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextChangedCopyWith<_TextChanged> get copyWith => __$TextChangedCopyWithImpl<_TextChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextChanged&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'QuickAddEvent.textChanged(text: $text)';
}


}

/// @nodoc
abstract mixin class _$TextChangedCopyWith<$Res> implements $QuickAddEventCopyWith<$Res> {
  factory _$TextChangedCopyWith(_TextChanged value, $Res Function(_TextChanged) _then) = __$TextChangedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$TextChangedCopyWithImpl<$Res>
    implements _$TextChangedCopyWith<$Res> {
  __$TextChangedCopyWithImpl(this._self, this._then);

  final _TextChanged _self;
  final $Res Function(_TextChanged) _then;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_TextChanged(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ContinueRequested implements QuickAddEvent {
  const _ContinueRequested(this.text);
  

 final  String text;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContinueRequestedCopyWith<_ContinueRequested> get copyWith => __$ContinueRequestedCopyWithImpl<_ContinueRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContinueRequested&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'QuickAddEvent.continueRequested(text: $text)';
}


}

/// @nodoc
abstract mixin class _$ContinueRequestedCopyWith<$Res> implements $QuickAddEventCopyWith<$Res> {
  factory _$ContinueRequestedCopyWith(_ContinueRequested value, $Res Function(_ContinueRequested) _then) = __$ContinueRequestedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$ContinueRequestedCopyWithImpl<$Res>
    implements _$ContinueRequestedCopyWith<$Res> {
  __$ContinueRequestedCopyWithImpl(this._self, this._then);

  final _ContinueRequested _self;
  final $Res Function(_ContinueRequested) _then;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_ContinueRequested(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ContextChanged implements QuickAddEvent {
  const _ContextChanged(this.context);
  

 final  ParseContext context;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContextChangedCopyWith<_ContextChanged> get copyWith => __$ContextChangedCopyWithImpl<_ContextChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContextChanged&&(identical(other.context, context) || other.context == context));
}


@override
int get hashCode {
    return Object.hash(runtimeType,context);
}

@override
String toString() {
    return 'QuickAddEvent.contextChanged(context: $context)';
}


}

/// @nodoc
abstract mixin class _$ContextChangedCopyWith<$Res> implements $QuickAddEventCopyWith<$Res> {
  factory _$ContextChangedCopyWith(_ContextChanged value, $Res Function(_ContextChanged) _then) = __$ContextChangedCopyWithImpl;
@useResult
$Res call({
 ParseContext context
});




}
/// @nodoc
class __$ContextChangedCopyWithImpl<$Res>
    implements _$ContextChangedCopyWith<$Res> {
  __$ContextChangedCopyWithImpl(this._self, this._then);

  final _ContextChanged _self;
  final $Res Function(_ContextChanged) _then;

/// Create a copy of QuickAddEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? context = null,}) {
  return _then(_ContextChanged(
null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as ParseContext,
  ));
}


}

/// @nodoc
mixin _$QuickAddState {

 ParseContext? get context; String get phrase; List<QuickAddDraft> get drafts; DraftEngine get engine; QuickAddAiFailure? get aiFailure; bool get isAsking; QuickAddNavigation? get navigation;
/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddStateCopyWith<QuickAddState> get copyWith => _$QuickAddStateCopyWithImpl<QuickAddState>(this as QuickAddState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuickAddState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddState&&(identical(other.context, _this.context) || other.context == _this.context)&&(identical(other.phrase, _this.phrase) || other.phrase == _this.phrase)&&const DeepCollectionEquality().equals(other.drafts, _this.drafts)&&(identical(other.engine, _this.engine) || other.engine == _this.engine)&&(identical(other.aiFailure, _this.aiFailure) || other.aiFailure == _this.aiFailure)&&(identical(other.isAsking, _this.isAsking) || other.isAsking == _this.isAsking)&&(identical(other.navigation, _this.navigation) || other.navigation == _this.navigation));
}


@override
int get hashCode {
  final _this = this as QuickAddState;
  return Object.hash(runtimeType,_this.context,_this.phrase,const DeepCollectionEquality().hash(_this.drafts),_this.engine,_this.aiFailure,_this.isAsking,_this.navigation);
}

@override
String toString() {
  final _this = this as QuickAddState;
  return 'QuickAddState(context: ${_this.context}, phrase: ${_this.phrase}, drafts: ${_this.drafts}, engine: ${_this.engine}, aiFailure: ${_this.aiFailure}, isAsking: ${_this.isAsking}, navigation: ${_this.navigation})';
}


}

/// @nodoc
abstract mixin class $QuickAddStateCopyWith<$Res>  {
  factory $QuickAddStateCopyWith(QuickAddState value, $Res Function(QuickAddState) _then) = _$QuickAddStateCopyWithImpl;
@useResult
$Res call({
 ParseContext? context, String phrase, List<QuickAddDraft> drafts, DraftEngine engine, QuickAddAiFailure? aiFailure, bool isAsking, QuickAddNavigation? navigation
});


$QuickAddNavigationCopyWith<$Res>? get navigation;

}
/// @nodoc
class _$QuickAddStateCopyWithImpl<$Res>
    implements $QuickAddStateCopyWith<$Res> {
  _$QuickAddStateCopyWithImpl(this._self, this._then);

  final QuickAddState _self;
  final $Res Function(QuickAddState) _then;

/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? context = freezed,Object? phrase = null,Object? drafts = null,Object? engine = null,Object? aiFailure = freezed,Object? isAsking = null,Object? navigation = freezed,}) {
  return _then(QuickAddState(
context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as ParseContext?,phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,drafts: null == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as DraftEngine,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as QuickAddAiFailure?,isAsking: null == isAsking ? _self.isAsking : isAsking // ignore: cast_nullable_to_non_nullable
as bool,navigation: freezed == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as QuickAddNavigation?,
  ));
}
/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddNavigationCopyWith<$Res>? get navigation {
    if (_self.navigation == null) {
    return null;
  }

  return $QuickAddNavigationCopyWith<$Res>(_self.navigation!, (value) {
    return _then(_self.copyWith(navigation: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuickAddState].
extension QuickAddStatePatterns on QuickAddState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddState value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddState value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ParseContext? context,  String phrase,  List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure,  bool isAsking,  QuickAddNavigation? navigation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddState() when $default != null:
return $default(_that.context,_that.phrase,_that.drafts,_that.engine,_that.aiFailure,_that.isAsking,_that.navigation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ParseContext? context,  String phrase,  List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure,  bool isAsking,  QuickAddNavigation? navigation)  $default,) {final _that = this;
switch (_that) {
case _QuickAddState():
return $default(_that.context,_that.phrase,_that.drafts,_that.engine,_that.aiFailure,_that.isAsking,_that.navigation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ParseContext? context,  String phrase,  List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure,  bool isAsking,  QuickAddNavigation? navigation)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddState() when $default != null:
return $default(_that.context,_that.phrase,_that.drafts,_that.engine,_that.aiFailure,_that.isAsking,_that.navigation);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddState implements QuickAddState {
  const _QuickAddState({this.context, this.phrase = '',  List<QuickAddDraft> drafts = const [], this.engine = DraftEngine.local, this.aiFailure, this.isAsking = false, this.navigation}): _drafts = drafts;
  

@override final  ParseContext? context;
@override@JsonKey() final  String phrase;
 final  List<QuickAddDraft> _drafts;
@override@JsonKey() List<QuickAddDraft> get drafts {
  if (_drafts is EqualUnmodifiableListView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drafts);
}

@override@JsonKey() final  DraftEngine engine;
@override final  QuickAddAiFailure? aiFailure;
@override@JsonKey() final  bool isAsking;
@override final  QuickAddNavigation? navigation;

/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddStateCopyWith<_QuickAddState> get copyWith => __$QuickAddStateCopyWithImpl<_QuickAddState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddState&&(identical(other.context, context) || other.context == context)&&(identical(other.phrase, phrase) || other.phrase == phrase)&&const DeepCollectionEquality().equals(other.drafts, _drafts)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.aiFailure, aiFailure) || other.aiFailure == aiFailure)&&(identical(other.isAsking, isAsking) || other.isAsking == isAsking)&&(identical(other.navigation, navigation) || other.navigation == navigation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,context,phrase,const DeepCollectionEquality().hash(_drafts),engine,aiFailure,isAsking,navigation);
}

@override
String toString() {
    return 'QuickAddState(context: $context, phrase: $phrase, drafts: $drafts, engine: $engine, aiFailure: $aiFailure, isAsking: $isAsking, navigation: $navigation)';
}


}

/// @nodoc
abstract mixin class _$QuickAddStateCopyWith<$Res> implements $QuickAddStateCopyWith<$Res> {
  factory _$QuickAddStateCopyWith(_QuickAddState value, $Res Function(_QuickAddState) _then) = __$QuickAddStateCopyWithImpl;
@override @useResult
$Res call({
 ParseContext? context, String phrase, List<QuickAddDraft> drafts, DraftEngine engine, QuickAddAiFailure? aiFailure, bool isAsking, QuickAddNavigation? navigation
});


@override $QuickAddNavigationCopyWith<$Res>? get navigation;

}
/// @nodoc
class __$QuickAddStateCopyWithImpl<$Res>
    implements _$QuickAddStateCopyWith<$Res> {
  __$QuickAddStateCopyWithImpl(this._self, this._then);

  final _QuickAddState _self;
  final $Res Function(_QuickAddState) _then;

/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? context = freezed,Object? phrase = null,Object? drafts = null,Object? engine = null,Object? aiFailure = freezed,Object? isAsking = null,Object? navigation = freezed,}) {
  return _then(_QuickAddState(
context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as ParseContext?,phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,drafts: null == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as DraftEngine,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as QuickAddAiFailure?,isAsking: null == isAsking ? _self.isAsking : isAsking // ignore: cast_nullable_to_non_nullable
as bool,navigation: freezed == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as QuickAddNavigation?,
  ));
}

/// Create a copy of QuickAddState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddNavigationCopyWith<$Res>? get navigation {
    if (_self.navigation == null) {
    return null;
  }

  return $QuickAddNavigationCopyWith<$Res>(_self.navigation!, (value) {
    return _then(_self.copyWith(navigation: value));
  });
}
}

/// @nodoc
mixin _$QuickAddNavigation {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddNavigation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'QuickAddNavigation()';
}


}

/// @nodoc
class $QuickAddNavigationCopyWith<$Res>  {
$QuickAddNavigationCopyWith(QuickAddNavigation _, $Res Function(QuickAddNavigation) __);
}


/// Adds pattern-matching-related methods to [QuickAddNavigation].
extension QuickAddNavigationPatterns on QuickAddNavigation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuickAddFormNavigation value)?  form,TResult Function( QuickAddReviewNavigation value)?  review,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuickAddFormNavigation() when form != null:
return form(_that);case QuickAddReviewNavigation() when review != null:
return review(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuickAddFormNavigation value)  form,required TResult Function( QuickAddReviewNavigation value)  review,}){
final _that = this;
switch (_that) {
case QuickAddFormNavigation():
return form(_that);case QuickAddReviewNavigation():
return review(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuickAddFormNavigation value)?  form,TResult? Function( QuickAddReviewNavigation value)?  review,}){
final _that = this;
switch (_that) {
case QuickAddFormNavigation() when form != null:
return form(_that);case QuickAddReviewNavigation() when review != null:
return review(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( QuickAddDraft draft)?  form,TResult Function( QuickAddReviewArgs args)?  review,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuickAddFormNavigation() when form != null:
return form(_that.draft);case QuickAddReviewNavigation() when review != null:
return review(_that.args);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( QuickAddDraft draft)  form,required TResult Function( QuickAddReviewArgs args)  review,}) {final _that = this;
switch (_that) {
case QuickAddFormNavigation():
return form(_that.draft);case QuickAddReviewNavigation():
return review(_that.args);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( QuickAddDraft draft)?  form,TResult? Function( QuickAddReviewArgs args)?  review,}) {final _that = this;
switch (_that) {
case QuickAddFormNavigation() when form != null:
return form(_that.draft);case QuickAddReviewNavigation() when review != null:
return review(_that.args);case _:
  return null;

}
}

}

/// @nodoc


class QuickAddFormNavigation implements QuickAddNavigation {
  const QuickAddFormNavigation(this.draft);
  

 final  QuickAddDraft draft;

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddFormNavigationCopyWith<QuickAddFormNavigation> get copyWith => _$QuickAddFormNavigationCopyWithImpl<QuickAddFormNavigation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddFormNavigation&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,draft);
}

@override
String toString() {
    return 'QuickAddNavigation.form(draft: $draft)';
}


}

/// @nodoc
abstract mixin class $QuickAddFormNavigationCopyWith<$Res> implements $QuickAddNavigationCopyWith<$Res> {
  factory $QuickAddFormNavigationCopyWith(QuickAddFormNavigation value, $Res Function(QuickAddFormNavigation) _then) = _$QuickAddFormNavigationCopyWithImpl;
@useResult
$Res call({
 QuickAddDraft draft
});


$QuickAddDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$QuickAddFormNavigationCopyWithImpl<$Res>
    implements $QuickAddFormNavigationCopyWith<$Res> {
  _$QuickAddFormNavigationCopyWithImpl(this._self, this._then);

  final QuickAddFormNavigation _self;
  final $Res Function(QuickAddFormNavigation) _then;

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(QuickAddFormNavigation(
null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as QuickAddDraft,
  ));
}

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddDraftCopyWith<$Res> get draft {
  
  return $QuickAddDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc


class QuickAddReviewNavigation implements QuickAddNavigation {
  const QuickAddReviewNavigation(this.args);
  

 final  QuickAddReviewArgs args;

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddReviewNavigationCopyWith<QuickAddReviewNavigation> get copyWith => _$QuickAddReviewNavigationCopyWithImpl<QuickAddReviewNavigation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReviewNavigation&&(identical(other.args, args) || other.args == args));
}


@override
int get hashCode {
    return Object.hash(runtimeType,args);
}

@override
String toString() {
    return 'QuickAddNavigation.review(args: $args)';
}


}

/// @nodoc
abstract mixin class $QuickAddReviewNavigationCopyWith<$Res> implements $QuickAddNavigationCopyWith<$Res> {
  factory $QuickAddReviewNavigationCopyWith(QuickAddReviewNavigation value, $Res Function(QuickAddReviewNavigation) _then) = _$QuickAddReviewNavigationCopyWithImpl;
@useResult
$Res call({
 QuickAddReviewArgs args
});


$QuickAddReviewArgsCopyWith<$Res> get args;

}
/// @nodoc
class _$QuickAddReviewNavigationCopyWithImpl<$Res>
    implements $QuickAddReviewNavigationCopyWith<$Res> {
  _$QuickAddReviewNavigationCopyWithImpl(this._self, this._then);

  final QuickAddReviewNavigation _self;
  final $Res Function(QuickAddReviewNavigation) _then;

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? args = null,}) {
  return _then(QuickAddReviewNavigation(
null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as QuickAddReviewArgs,
  ));
}

/// Create a copy of QuickAddNavigation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickAddReviewArgsCopyWith<$Res> get args {
  
  return $QuickAddReviewArgsCopyWith<$Res>(_self.args, (value) {
    return _then(_self.copyWith(args: value));
  });
}
}

// dart format on
