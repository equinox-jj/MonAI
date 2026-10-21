// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_add_review_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAddReviewArgs {

 String get phrase; List<QuickAddDraft> get drafts;
/// Create a copy of QuickAddReviewArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAddReviewArgsCopyWith<QuickAddReviewArgs> get copyWith => _$QuickAddReviewArgsCopyWithImpl<QuickAddReviewArgs>(this as QuickAddReviewArgs, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuickAddReviewArgs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAddReviewArgs&&(identical(other.phrase, _this.phrase) || other.phrase == _this.phrase)&&const DeepCollectionEquality().equals(other.drafts, _this.drafts));
}


@override
int get hashCode {
  final _this = this as QuickAddReviewArgs;
  return Object.hash(runtimeType,_this.phrase,const DeepCollectionEquality().hash(_this.drafts));
}

@override
String toString() {
  final _this = this as QuickAddReviewArgs;
  return 'QuickAddReviewArgs(phrase: ${_this.phrase}, drafts: ${_this.drafts})';
}


}

/// @nodoc
abstract mixin class $QuickAddReviewArgsCopyWith<$Res>  {
  factory $QuickAddReviewArgsCopyWith(QuickAddReviewArgs value, $Res Function(QuickAddReviewArgs) _then) = _$QuickAddReviewArgsCopyWithImpl;
@useResult
$Res call({
 String phrase, List<QuickAddDraft> drafts
});




}
/// @nodoc
class _$QuickAddReviewArgsCopyWithImpl<$Res>
    implements $QuickAddReviewArgsCopyWith<$Res> {
  _$QuickAddReviewArgsCopyWithImpl(this._self, this._then);

  final QuickAddReviewArgs _self;
  final $Res Function(QuickAddReviewArgs) _then;

/// Create a copy of QuickAddReviewArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phrase = null,Object? drafts = null,}) {
  return _then(QuickAddReviewArgs(
phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,drafts: null == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAddReviewArgs].
extension QuickAddReviewArgsPatterns on QuickAddReviewArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAddReviewArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAddReviewArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAddReviewArgs value)  $default,){
final _that = this;
switch (_that) {
case _QuickAddReviewArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAddReviewArgs value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAddReviewArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phrase,  List<QuickAddDraft> drafts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAddReviewArgs() when $default != null:
return $default(_that.phrase,_that.drafts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phrase,  List<QuickAddDraft> drafts)  $default,) {final _that = this;
switch (_that) {
case _QuickAddReviewArgs():
return $default(_that.phrase,_that.drafts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phrase,  List<QuickAddDraft> drafts)?  $default,) {final _that = this;
switch (_that) {
case _QuickAddReviewArgs() when $default != null:
return $default(_that.phrase,_that.drafts);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAddReviewArgs implements QuickAddReviewArgs {
  const _QuickAddReviewArgs({required this.phrase, required  List<QuickAddDraft> drafts}): _drafts = drafts;
  

@override final  String phrase;
 final  List<QuickAddDraft> _drafts;
@override List<QuickAddDraft> get drafts {
  if (_drafts is EqualUnmodifiableListView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drafts);
}


/// Create a copy of QuickAddReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAddReviewArgsCopyWith<_QuickAddReviewArgs> get copyWith => __$QuickAddReviewArgsCopyWithImpl<_QuickAddReviewArgs>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAddReviewArgs&&(identical(other.phrase, phrase) || other.phrase == phrase)&&const DeepCollectionEquality().equals(other.drafts, _drafts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phrase,const DeepCollectionEquality().hash(_drafts));
}

@override
String toString() {
    return 'QuickAddReviewArgs(phrase: $phrase, drafts: $drafts)';
}


}

/// @nodoc
abstract mixin class _$QuickAddReviewArgsCopyWith<$Res> implements $QuickAddReviewArgsCopyWith<$Res> {
  factory _$QuickAddReviewArgsCopyWith(_QuickAddReviewArgs value, $Res Function(_QuickAddReviewArgs) _then) = __$QuickAddReviewArgsCopyWithImpl;
@override @useResult
$Res call({
 String phrase, List<QuickAddDraft> drafts
});




}
/// @nodoc
class __$QuickAddReviewArgsCopyWithImpl<$Res>
    implements _$QuickAddReviewArgsCopyWith<$Res> {
  __$QuickAddReviewArgsCopyWithImpl(this._self, this._then);

  final _QuickAddReviewArgs _self;
  final $Res Function(_QuickAddReviewArgs) _then;

/// Create a copy of QuickAddReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phrase = null,Object? drafts = null,}) {
  return _then(_QuickAddReviewArgs(
phrase: null == phrase ? _self.phrase : phrase // ignore: cast_nullable_to_non_nullable
as String,drafts: null == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as List<QuickAddDraft>,
  ));
}


}

// dart format on
