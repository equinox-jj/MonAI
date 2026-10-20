// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddReading {

 List<QuickAddDraft> get drafts; DraftEngine get engine;/// Why the AI failed; set only when [engine] is
/// [DraftEngine.fallback].
 QuickAddAiFailure? get aiFailure;
/// Create a copy of QuickAddReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddReadingCopyWith<QuickAddReading> get copyWith => _$QuickAddReadingCopyWithImpl<QuickAddReading>(this as QuickAddReading, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuickAddReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReading&&const DeepCollectionEquality().equals(other.drafts, _this.drafts)&&(identical(other.engine, _this.engine) || other.engine == _this.engine)&&(identical(other.aiFailure, _this.aiFailure) || other.aiFailure == _this.aiFailure));
}


@override
int get hashCode {
  final _this = this as QuickAddReading;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.drafts),_this.engine,_this.aiFailure);
}

@override
String toString() {
  final _this = this as QuickAddReading;
  return 'QuickAddReading(drafts: ${_this.drafts}, engine: ${_this.engine}, aiFailure: ${_this.aiFailure})';
}


}

/// @nodoc
abstract mixin class $QuickAddReadingCopyWith<$Res>  {
  factory $QuickAddReadingCopyWith(QuickAddReading value, $Res Function(QuickAddReading) _then) = _$QuickAddReadingCopyWithImpl;
@useResult
$Res call({
 List<QuickAddDraft> drafts, DraftEngine engine, QuickAddAiFailure? aiFailure
});




}
/// @nodoc
class _$QuickAddReadingCopyWithImpl<$Res>
    implements $QuickAddReadingCopyWith<$Res> {
  _$QuickAddReadingCopyWithImpl(this._self, this._then);

  final QuickAddReading _self;
  final $Res Function(QuickAddReading) _then;

/// Create a copy of QuickAddReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drafts = null,Object? engine = null,Object? aiFailure = freezed,}) {
  return _then(QuickAddReading(
drafts: null == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as DraftEngine,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as QuickAddAiFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAddReading].
extension QuickAddReadingPatterns on QuickAddReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddReading value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddReading value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddReading() when $default != null:
return $default(_that.drafts,_that.engine,_that.aiFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure)  $default,) {final _that = this;
switch (_that) {
case _QuickAddReading():
return $default(_that.drafts,_that.engine,_that.aiFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuickAddDraft> drafts,  DraftEngine engine,  QuickAddAiFailure? aiFailure)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddReading() when $default != null:
return $default(_that.drafts,_that.engine,_that.aiFailure);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddReading implements QuickAddReading {
  const _QuickAddReading({required  List<QuickAddDraft> drafts, required this.engine, this.aiFailure}): _drafts = drafts;
  

 final  List<QuickAddDraft> _drafts;
@override List<QuickAddDraft> get drafts {
  if (_drafts is EqualUnmodifiableListView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drafts);
}

@override final  DraftEngine engine;
/// Why the AI failed; set only when [engine] is
/// [DraftEngine.fallback].
@override final  QuickAddAiFailure? aiFailure;

/// Create a copy of QuickAddReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddReadingCopyWith<_QuickAddReading> get copyWith => __$QuickAddReadingCopyWithImpl<_QuickAddReading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddReading&&const DeepCollectionEquality().equals(other.drafts, _drafts)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.aiFailure, aiFailure) || other.aiFailure == aiFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_drafts),engine,aiFailure);
}

@override
String toString() {
    return 'QuickAddReading(drafts: $drafts, engine: $engine, aiFailure: $aiFailure)';
}


}

/// @nodoc
abstract mixin class _$QuickAddReadingCopyWith<$Res> implements $QuickAddReadingCopyWith<$Res> {
  factory _$QuickAddReadingCopyWith(_QuickAddReading value, $Res Function(_QuickAddReading) _then) = __$QuickAddReadingCopyWithImpl;
@override @useResult
$Res call({
 List<QuickAddDraft> drafts, DraftEngine engine, QuickAddAiFailure? aiFailure
});




}
/// @nodoc
class __$QuickAddReadingCopyWithImpl<$Res>
    implements _$QuickAddReadingCopyWith<$Res> {
  __$QuickAddReadingCopyWithImpl(this._self, this._then);

  final _QuickAddReading _self;
  final $Res Function(_QuickAddReading) _then;

/// Create a copy of QuickAddReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drafts = null,Object? engine = null,Object? aiFailure = freezed,}) {
  return _then(_QuickAddReading(
drafts: null == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as DraftEngine,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as QuickAddAiFailure?,
  ));
}


}

// dart format on
