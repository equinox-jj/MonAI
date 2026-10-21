// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_review_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptReviewArgs {

 String get photoPath; String get ocrText; ReceiptDraft get draft; ReceiptAiFailure? get aiFailure;
/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptReviewArgsCopyWith<ReceiptReviewArgs> get copyWith => _$ReceiptReviewArgsCopyWithImpl<ReceiptReviewArgs>(this as ReceiptReviewArgs, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptReviewArgs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptReviewArgs&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.ocrText, _this.ocrText) || other.ocrText == _this.ocrText)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.aiFailure, _this.aiFailure) || other.aiFailure == _this.aiFailure));
}


@override
int get hashCode {
  final _this = this as ReceiptReviewArgs;
  return Object.hash(runtimeType,_this.photoPath,_this.ocrText,_this.draft,_this.aiFailure);
}

@override
String toString() {
  final _this = this as ReceiptReviewArgs;
  return 'ReceiptReviewArgs(photoPath: ${_this.photoPath}, ocrText: ${_this.ocrText}, draft: ${_this.draft}, aiFailure: ${_this.aiFailure})';
}


}

/// @nodoc
abstract mixin class $ReceiptReviewArgsCopyWith<$Res>  {
  factory $ReceiptReviewArgsCopyWith(ReceiptReviewArgs value, $Res Function(ReceiptReviewArgs) _then) = _$ReceiptReviewArgsCopyWithImpl;
@useResult
$Res call({
 String photoPath, String ocrText, ReceiptDraft draft, ReceiptAiFailure? aiFailure
});


$ReceiptDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$ReceiptReviewArgsCopyWithImpl<$Res>
    implements $ReceiptReviewArgsCopyWith<$Res> {
  _$ReceiptReviewArgsCopyWithImpl(this._self, this._then);

  final ReceiptReviewArgs _self;
  final $Res Function(ReceiptReviewArgs) _then;

/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photoPath = null,Object? ocrText = null,Object? draft = null,Object? aiFailure = freezed,}) {
  return _then(ReceiptReviewArgs(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,ocrText: null == ocrText ? _self.ocrText : ocrText // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraft,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,
  ));
}
/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftCopyWith<$Res> get draft {
  
  return $ReceiptDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptReviewArgs].
extension ReceiptReviewArgsPatterns on ReceiptReviewArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptReviewArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptReviewArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptReviewArgs value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptReviewArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptReviewArgs value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptReviewArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String photoPath,  String ocrText,  ReceiptDraft draft,  ReceiptAiFailure? aiFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptReviewArgs() when $default != null:
return $default(_that.photoPath,_that.ocrText,_that.draft,_that.aiFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String photoPath,  String ocrText,  ReceiptDraft draft,  ReceiptAiFailure? aiFailure)  $default,) {final _that = this;
switch (_that) {
case _ReceiptReviewArgs():
return $default(_that.photoPath,_that.ocrText,_that.draft,_that.aiFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String photoPath,  String ocrText,  ReceiptDraft draft,  ReceiptAiFailure? aiFailure)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptReviewArgs() when $default != null:
return $default(_that.photoPath,_that.ocrText,_that.draft,_that.aiFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptReviewArgs implements ReceiptReviewArgs {
  const _ReceiptReviewArgs({required this.photoPath, required this.ocrText, required this.draft, this.aiFailure});
  

@override final  String photoPath;
@override final  String ocrText;
@override final  ReceiptDraft draft;
@override final  ReceiptAiFailure? aiFailure;

/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptReviewArgsCopyWith<_ReceiptReviewArgs> get copyWith => __$ReceiptReviewArgsCopyWithImpl<_ReceiptReviewArgs>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptReviewArgs&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.ocrText, ocrText) || other.ocrText == ocrText)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.aiFailure, aiFailure) || other.aiFailure == aiFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,photoPath,ocrText,draft,aiFailure);
}

@override
String toString() {
    return 'ReceiptReviewArgs(photoPath: $photoPath, ocrText: $ocrText, draft: $draft, aiFailure: $aiFailure)';
}


}

/// @nodoc
abstract mixin class _$ReceiptReviewArgsCopyWith<$Res> implements $ReceiptReviewArgsCopyWith<$Res> {
  factory _$ReceiptReviewArgsCopyWith(_ReceiptReviewArgs value, $Res Function(_ReceiptReviewArgs) _then) = __$ReceiptReviewArgsCopyWithImpl;
@override @useResult
$Res call({
 String photoPath, String ocrText, ReceiptDraft draft, ReceiptAiFailure? aiFailure
});


@override $ReceiptDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$ReceiptReviewArgsCopyWithImpl<$Res>
    implements _$ReceiptReviewArgsCopyWith<$Res> {
  __$ReceiptReviewArgsCopyWithImpl(this._self, this._then);

  final _ReceiptReviewArgs _self;
  final $Res Function(_ReceiptReviewArgs) _then;

/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photoPath = null,Object? ocrText = null,Object? draft = null,Object? aiFailure = freezed,}) {
  return _then(_ReceiptReviewArgs(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,ocrText: null == ocrText ? _self.ocrText : ocrText // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ReceiptDraft,aiFailure: freezed == aiFailure ? _self.aiFailure : aiFailure // ignore: cast_nullable_to_non_nullable
as ReceiptAiFailure?,
  ));
}

/// Create a copy of ReceiptReviewArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptDraftCopyWith<$Res> get draft {
  
  return $ReceiptDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
