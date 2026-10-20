// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanPhase {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanPhase()';
}


}

/// @nodoc
class $ScanPhaseCopyWith<$Res>  {
$ScanPhaseCopyWith(ScanPhase _, $Res Function(ScanPhase) __);
}


/// Adds pattern-matching-related methods to [ScanPhase].
extension ScanPhasePatterns on ScanPhase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CameraScanPhase value)?  camera,TResult Function( ProcessingScanPhase value)?  processing,TResult Function( NoTextScanPhase value)?  noText,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CameraScanPhase() when camera != null:
return camera(_that);case ProcessingScanPhase() when processing != null:
return processing(_that);case NoTextScanPhase() when noText != null:
return noText(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CameraScanPhase value)  camera,required TResult Function( ProcessingScanPhase value)  processing,required TResult Function( NoTextScanPhase value)  noText,}){
final _that = this;
switch (_that) {
case CameraScanPhase():
return camera(_that);case ProcessingScanPhase():
return processing(_that);case NoTextScanPhase():
return noText(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CameraScanPhase value)?  camera,TResult? Function( ProcessingScanPhase value)?  processing,TResult? Function( NoTextScanPhase value)?  noText,}){
final _that = this;
switch (_that) {
case CameraScanPhase() when camera != null:
return camera(_that);case ProcessingScanPhase() when processing != null:
return processing(_that);case NoTextScanPhase() when noText != null:
return noText(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  camera,TResult Function( String photoPath,  ProcessingStep step)?  processing,TResult Function( String photoPath)?  noText,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CameraScanPhase() when camera != null:
return camera();case ProcessingScanPhase() when processing != null:
return processing(_that.photoPath,_that.step);case NoTextScanPhase() when noText != null:
return noText(_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  camera,required TResult Function( String photoPath,  ProcessingStep step)  processing,required TResult Function( String photoPath)  noText,}) {final _that = this;
switch (_that) {
case CameraScanPhase():
return camera();case ProcessingScanPhase():
return processing(_that.photoPath,_that.step);case NoTextScanPhase():
return noText(_that.photoPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  camera,TResult? Function( String photoPath,  ProcessingStep step)?  processing,TResult? Function( String photoPath)?  noText,}) {final _that = this;
switch (_that) {
case CameraScanPhase() when camera != null:
return camera();case ProcessingScanPhase() when processing != null:
return processing(_that.photoPath,_that.step);case NoTextScanPhase() when noText != null:
return noText(_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc


class CameraScanPhase implements ScanPhase {
  const CameraScanPhase();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraScanPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanPhase.camera()';
}


}




/// @nodoc


class ProcessingScanPhase implements ScanPhase {
  const ProcessingScanPhase({required this.photoPath, required this.step});
  

 final  String photoPath;
 final  ProcessingStep step;

/// Create a copy of ScanPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessingScanPhaseCopyWith<ProcessingScanPhase> get copyWith => _$ProcessingScanPhaseCopyWithImpl<ProcessingScanPhase>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessingScanPhase&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode {
    return Object.hash(runtimeType,photoPath,step);
}

@override
String toString() {
    return 'ScanPhase.processing(photoPath: $photoPath, step: $step)';
}


}

/// @nodoc
abstract mixin class $ProcessingScanPhaseCopyWith<$Res> implements $ScanPhaseCopyWith<$Res> {
  factory $ProcessingScanPhaseCopyWith(ProcessingScanPhase value, $Res Function(ProcessingScanPhase) _then) = _$ProcessingScanPhaseCopyWithImpl;
@useResult
$Res call({
 String photoPath, ProcessingStep step
});




}
/// @nodoc
class _$ProcessingScanPhaseCopyWithImpl<$Res>
    implements $ProcessingScanPhaseCopyWith<$Res> {
  _$ProcessingScanPhaseCopyWithImpl(this._self, this._then);

  final ProcessingScanPhase _self;
  final $Res Function(ProcessingScanPhase) _then;

/// Create a copy of ScanPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? photoPath = null,Object? step = null,}) {
  return _then(ProcessingScanPhase(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ProcessingStep,
  ));
}


}

/// @nodoc


class NoTextScanPhase implements ScanPhase {
  const NoTextScanPhase({required this.photoPath});
  

 final  String photoPath;

/// Create a copy of ScanPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoTextScanPhaseCopyWith<NoTextScanPhase> get copyWith => _$NoTextScanPhaseCopyWithImpl<NoTextScanPhase>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NoTextScanPhase&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,photoPath);
}

@override
String toString() {
    return 'ScanPhase.noText(photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $NoTextScanPhaseCopyWith<$Res> implements $ScanPhaseCopyWith<$Res> {
  factory $NoTextScanPhaseCopyWith(NoTextScanPhase value, $Res Function(NoTextScanPhase) _then) = _$NoTextScanPhaseCopyWithImpl;
@useResult
$Res call({
 String photoPath
});




}
/// @nodoc
class _$NoTextScanPhaseCopyWithImpl<$Res>
    implements $NoTextScanPhaseCopyWith<$Res> {
  _$NoTextScanPhaseCopyWithImpl(this._self, this._then);

  final NoTextScanPhase _self;
  final $Res Function(NoTextScanPhase) _then;

/// Create a copy of ScanPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? photoPath = null,}) {
  return _then(NoTextScanPhase(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
