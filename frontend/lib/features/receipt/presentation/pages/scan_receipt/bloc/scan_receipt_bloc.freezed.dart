// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_receipt_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanReceiptEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanReceiptEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanReceiptEvent()';
}


}

/// @nodoc
class $ScanReceiptEventCopyWith<$Res>  {
$ScanReceiptEventCopyWith(ScanReceiptEvent _, $Res Function(ScanReceiptEvent) __);
}


/// Adds pattern-matching-related methods to [ScanReceiptEvent].
extension ScanReceiptEventPatterns on ScanReceiptEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CameraStatusChanged value)?  cameraStatusChanged,TResult Function( _FlashToggled value)?  flashToggled,TResult Function( _CaptureStarted value)?  captureStarted,TResult Function( _CaptureFailed value)?  captureFailed,TResult Function( _PhotoTaken value)?  photoTaken,TResult Function( _PhotoPicked value)?  photoPicked,TResult Function( _RetakeRequested value)?  retakeRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraStatusChanged() when cameraStatusChanged != null:
return cameraStatusChanged(_that);case _FlashToggled() when flashToggled != null:
return flashToggled(_that);case _CaptureStarted() when captureStarted != null:
return captureStarted(_that);case _CaptureFailed() when captureFailed != null:
return captureFailed(_that);case _PhotoTaken() when photoTaken != null:
return photoTaken(_that);case _PhotoPicked() when photoPicked != null:
return photoPicked(_that);case _RetakeRequested() when retakeRequested != null:
return retakeRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CameraStatusChanged value)  cameraStatusChanged,required TResult Function( _FlashToggled value)  flashToggled,required TResult Function( _CaptureStarted value)  captureStarted,required TResult Function( _CaptureFailed value)  captureFailed,required TResult Function( _PhotoTaken value)  photoTaken,required TResult Function( _PhotoPicked value)  photoPicked,required TResult Function( _RetakeRequested value)  retakeRequested,}){
final _that = this;
switch (_that) {
case _CameraStatusChanged():
return cameraStatusChanged(_that);case _FlashToggled():
return flashToggled(_that);case _CaptureStarted():
return captureStarted(_that);case _CaptureFailed():
return captureFailed(_that);case _PhotoTaken():
return photoTaken(_that);case _PhotoPicked():
return photoPicked(_that);case _RetakeRequested():
return retakeRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CameraStatusChanged value)?  cameraStatusChanged,TResult? Function( _FlashToggled value)?  flashToggled,TResult? Function( _CaptureStarted value)?  captureStarted,TResult? Function( _CaptureFailed value)?  captureFailed,TResult? Function( _PhotoTaken value)?  photoTaken,TResult? Function( _PhotoPicked value)?  photoPicked,TResult? Function( _RetakeRequested value)?  retakeRequested,}){
final _that = this;
switch (_that) {
case _CameraStatusChanged() when cameraStatusChanged != null:
return cameraStatusChanged(_that);case _FlashToggled() when flashToggled != null:
return flashToggled(_that);case _CaptureStarted() when captureStarted != null:
return captureStarted(_that);case _CaptureFailed() when captureFailed != null:
return captureFailed(_that);case _PhotoTaken() when photoTaken != null:
return photoTaken(_that);case _PhotoPicked() when photoPicked != null:
return photoPicked(_that);case _RetakeRequested() when retakeRequested != null:
return retakeRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CameraStatus status)?  cameraStatusChanged,TResult Function()?  flashToggled,TResult Function()?  captureStarted,TResult Function()?  captureFailed,TResult Function( String path)?  photoTaken,TResult Function( String? path)?  photoPicked,TResult Function()?  retakeRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraStatusChanged() when cameraStatusChanged != null:
return cameraStatusChanged(_that.status);case _FlashToggled() when flashToggled != null:
return flashToggled();case _CaptureStarted() when captureStarted != null:
return captureStarted();case _CaptureFailed() when captureFailed != null:
return captureFailed();case _PhotoTaken() when photoTaken != null:
return photoTaken(_that.path);case _PhotoPicked() when photoPicked != null:
return photoPicked(_that.path);case _RetakeRequested() when retakeRequested != null:
return retakeRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CameraStatus status)  cameraStatusChanged,required TResult Function()  flashToggled,required TResult Function()  captureStarted,required TResult Function()  captureFailed,required TResult Function( String path)  photoTaken,required TResult Function( String? path)  photoPicked,required TResult Function()  retakeRequested,}) {final _that = this;
switch (_that) {
case _CameraStatusChanged():
return cameraStatusChanged(_that.status);case _FlashToggled():
return flashToggled();case _CaptureStarted():
return captureStarted();case _CaptureFailed():
return captureFailed();case _PhotoTaken():
return photoTaken(_that.path);case _PhotoPicked():
return photoPicked(_that.path);case _RetakeRequested():
return retakeRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CameraStatus status)?  cameraStatusChanged,TResult? Function()?  flashToggled,TResult? Function()?  captureStarted,TResult? Function()?  captureFailed,TResult? Function( String path)?  photoTaken,TResult? Function( String? path)?  photoPicked,TResult? Function()?  retakeRequested,}) {final _that = this;
switch (_that) {
case _CameraStatusChanged() when cameraStatusChanged != null:
return cameraStatusChanged(_that.status);case _FlashToggled() when flashToggled != null:
return flashToggled();case _CaptureStarted() when captureStarted != null:
return captureStarted();case _CaptureFailed() when captureFailed != null:
return captureFailed();case _PhotoTaken() when photoTaken != null:
return photoTaken(_that.path);case _PhotoPicked() when photoPicked != null:
return photoPicked(_that.path);case _RetakeRequested() when retakeRequested != null:
return retakeRequested();case _:
  return null;

}
}

}

/// @nodoc


class _CameraStatusChanged implements ScanReceiptEvent {
  const _CameraStatusChanged(this.status);
  

 final  CameraStatus status;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraStatusChangedCopyWith<_CameraStatusChanged> get copyWith => __$CameraStatusChangedCopyWithImpl<_CameraStatusChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraStatusChanged&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status);
}

@override
String toString() {
    return 'ScanReceiptEvent.cameraStatusChanged(status: $status)';
}


}

/// @nodoc
abstract mixin class _$CameraStatusChangedCopyWith<$Res> implements $ScanReceiptEventCopyWith<$Res> {
  factory _$CameraStatusChangedCopyWith(_CameraStatusChanged value, $Res Function(_CameraStatusChanged) _then) = __$CameraStatusChangedCopyWithImpl;
@useResult
$Res call({
 CameraStatus status
});




}
/// @nodoc
class __$CameraStatusChangedCopyWithImpl<$Res>
    implements _$CameraStatusChangedCopyWith<$Res> {
  __$CameraStatusChangedCopyWithImpl(this._self, this._then);

  final _CameraStatusChanged _self;
  final $Res Function(_CameraStatusChanged) _then;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_CameraStatusChanged(
null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CameraStatus,
  ));
}


}

/// @nodoc


class _FlashToggled implements ScanReceiptEvent {
  const _FlashToggled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanReceiptEvent.flashToggled()';
}


}




/// @nodoc


class _CaptureStarted implements ScanReceiptEvent {
  const _CaptureStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanReceiptEvent.captureStarted()';
}


}




/// @nodoc


class _CaptureFailed implements ScanReceiptEvent {
  const _CaptureFailed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanReceiptEvent.captureFailed()';
}


}




/// @nodoc


class _PhotoTaken implements ScanReceiptEvent {
  const _PhotoTaken(this.path);
  

 final  String path;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoTakenCopyWith<_PhotoTaken> get copyWith => __$PhotoTakenCopyWithImpl<_PhotoTaken>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoTaken&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode {
    return Object.hash(runtimeType,path);
}

@override
String toString() {
    return 'ScanReceiptEvent.photoTaken(path: $path)';
}


}

/// @nodoc
abstract mixin class _$PhotoTakenCopyWith<$Res> implements $ScanReceiptEventCopyWith<$Res> {
  factory _$PhotoTakenCopyWith(_PhotoTaken value, $Res Function(_PhotoTaken) _then) = __$PhotoTakenCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class __$PhotoTakenCopyWithImpl<$Res>
    implements _$PhotoTakenCopyWith<$Res> {
  __$PhotoTakenCopyWithImpl(this._self, this._then);

  final _PhotoTaken _self;
  final $Res Function(_PhotoTaken) _then;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(_PhotoTaken(
null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PhotoPicked implements ScanReceiptEvent {
  const _PhotoPicked(this.path);
  

 final  String? path;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoPickedCopyWith<_PhotoPicked> get copyWith => __$PhotoPickedCopyWithImpl<_PhotoPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoPicked&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode {
    return Object.hash(runtimeType,path);
}

@override
String toString() {
    return 'ScanReceiptEvent.photoPicked(path: $path)';
}


}

/// @nodoc
abstract mixin class _$PhotoPickedCopyWith<$Res> implements $ScanReceiptEventCopyWith<$Res> {
  factory _$PhotoPickedCopyWith(_PhotoPicked value, $Res Function(_PhotoPicked) _then) = __$PhotoPickedCopyWithImpl;
@useResult
$Res call({
 String? path
});




}
/// @nodoc
class __$PhotoPickedCopyWithImpl<$Res>
    implements _$PhotoPickedCopyWith<$Res> {
  __$PhotoPickedCopyWithImpl(this._self, this._then);

  final _PhotoPicked _self;
  final $Res Function(_PhotoPicked) _then;

/// Create a copy of ScanReceiptEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = freezed,}) {
  return _then(_PhotoPicked(
freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _RetakeRequested implements ScanReceiptEvent {
  const _RetakeRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetakeRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ScanReceiptEvent.retakeRequested()';
}


}




/// @nodoc
mixin _$ScanReceiptState {

 ScanPhase get phase; CameraStatus get camera; bool get flashOn; bool get isCapturing; bool get captureFailed; ReceiptReviewArgs? get review;
/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanReceiptStateCopyWith<ScanReceiptState> get copyWith => _$ScanReceiptStateCopyWithImpl<ScanReceiptState>(this as ScanReceiptState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScanReceiptState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanReceiptState&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.camera, _this.camera) || other.camera == _this.camera)&&(identical(other.flashOn, _this.flashOn) || other.flashOn == _this.flashOn)&&(identical(other.isCapturing, _this.isCapturing) || other.isCapturing == _this.isCapturing)&&(identical(other.captureFailed, _this.captureFailed) || other.captureFailed == _this.captureFailed)&&(identical(other.review, _this.review) || other.review == _this.review));
}


@override
int get hashCode {
  final _this = this as ScanReceiptState;
  return Object.hash(runtimeType,_this.phase,_this.camera,_this.flashOn,_this.isCapturing,_this.captureFailed,_this.review);
}

@override
String toString() {
  final _this = this as ScanReceiptState;
  return 'ScanReceiptState(phase: ${_this.phase}, camera: ${_this.camera}, flashOn: ${_this.flashOn}, isCapturing: ${_this.isCapturing}, captureFailed: ${_this.captureFailed}, review: ${_this.review})';
}


}

/// @nodoc
abstract mixin class $ScanReceiptStateCopyWith<$Res>  {
  factory $ScanReceiptStateCopyWith(ScanReceiptState value, $Res Function(ScanReceiptState) _then) = _$ScanReceiptStateCopyWithImpl;
@useResult
$Res call({
 ScanPhase phase, CameraStatus camera, bool flashOn, bool isCapturing, bool captureFailed, ReceiptReviewArgs? review
});


$ScanPhaseCopyWith<$Res> get phase;$ReceiptReviewArgsCopyWith<$Res>? get review;

}
/// @nodoc
class _$ScanReceiptStateCopyWithImpl<$Res>
    implements $ScanReceiptStateCopyWith<$Res> {
  _$ScanReceiptStateCopyWithImpl(this._self, this._then);

  final ScanReceiptState _self;
  final $Res Function(ScanReceiptState) _then;

/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? camera = null,Object? flashOn = null,Object? isCapturing = null,Object? captureFailed = null,Object? review = freezed,}) {
  return _then(ScanReceiptState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScanPhase,camera: null == camera ? _self.camera : camera // ignore: cast_nullable_to_non_nullable
as CameraStatus,flashOn: null == flashOn ? _self.flashOn : flashOn // ignore: cast_nullable_to_non_nullable
as bool,isCapturing: null == isCapturing ? _self.isCapturing : isCapturing // ignore: cast_nullable_to_non_nullable
as bool,captureFailed: null == captureFailed ? _self.captureFailed : captureFailed // ignore: cast_nullable_to_non_nullable
as bool,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as ReceiptReviewArgs?,
  ));
}
/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScanPhaseCopyWith<$Res> get phase {
  
  return $ScanPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptReviewArgsCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $ReceiptReviewArgsCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScanReceiptState].
extension ScanReceiptStatePatterns on ScanReceiptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanReceiptState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanReceiptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanReceiptState value)  $default,){
final _that = this;
switch (_that) {
case _ScanReceiptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanReceiptState value)?  $default,){
final _that = this;
switch (_that) {
case _ScanReceiptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScanPhase phase,  CameraStatus camera,  bool flashOn,  bool isCapturing,  bool captureFailed,  ReceiptReviewArgs? review)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanReceiptState() when $default != null:
return $default(_that.phase,_that.camera,_that.flashOn,_that.isCapturing,_that.captureFailed,_that.review);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScanPhase phase,  CameraStatus camera,  bool flashOn,  bool isCapturing,  bool captureFailed,  ReceiptReviewArgs? review)  $default,) {final _that = this;
switch (_that) {
case _ScanReceiptState():
return $default(_that.phase,_that.camera,_that.flashOn,_that.isCapturing,_that.captureFailed,_that.review);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScanPhase phase,  CameraStatus camera,  bool flashOn,  bool isCapturing,  bool captureFailed,  ReceiptReviewArgs? review)?  $default,) {final _that = this;
switch (_that) {
case _ScanReceiptState() when $default != null:
return $default(_that.phase,_that.camera,_that.flashOn,_that.isCapturing,_that.captureFailed,_that.review);case _:
  return null;

}
}

}

/// @nodoc


class _ScanReceiptState implements ScanReceiptState {
  const _ScanReceiptState({this.phase = const ScanPhase.camera(), this.camera = CameraStatus.opening, this.flashOn = false, this.isCapturing = false, this.captureFailed = false, this.review});
  

@override@JsonKey() final  ScanPhase phase;
@override@JsonKey() final  CameraStatus camera;
@override@JsonKey() final  bool flashOn;
@override@JsonKey() final  bool isCapturing;
@override@JsonKey() final  bool captureFailed;
@override final  ReceiptReviewArgs? review;

/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanReceiptStateCopyWith<_ScanReceiptState> get copyWith => __$ScanReceiptStateCopyWithImpl<_ScanReceiptState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanReceiptState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.camera, camera) || other.camera == camera)&&(identical(other.flashOn, flashOn) || other.flashOn == flashOn)&&(identical(other.isCapturing, isCapturing) || other.isCapturing == isCapturing)&&(identical(other.captureFailed, captureFailed) || other.captureFailed == captureFailed)&&(identical(other.review, review) || other.review == review));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phase,camera,flashOn,isCapturing,captureFailed,review);
}

@override
String toString() {
    return 'ScanReceiptState(phase: $phase, camera: $camera, flashOn: $flashOn, isCapturing: $isCapturing, captureFailed: $captureFailed, review: $review)';
}


}

/// @nodoc
abstract mixin class _$ScanReceiptStateCopyWith<$Res> implements $ScanReceiptStateCopyWith<$Res> {
  factory _$ScanReceiptStateCopyWith(_ScanReceiptState value, $Res Function(_ScanReceiptState) _then) = __$ScanReceiptStateCopyWithImpl;
@override @useResult
$Res call({
 ScanPhase phase, CameraStatus camera, bool flashOn, bool isCapturing, bool captureFailed, ReceiptReviewArgs? review
});


@override $ScanPhaseCopyWith<$Res> get phase;@override $ReceiptReviewArgsCopyWith<$Res>? get review;

}
/// @nodoc
class __$ScanReceiptStateCopyWithImpl<$Res>
    implements _$ScanReceiptStateCopyWith<$Res> {
  __$ScanReceiptStateCopyWithImpl(this._self, this._then);

  final _ScanReceiptState _self;
  final $Res Function(_ScanReceiptState) _then;

/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? camera = null,Object? flashOn = null,Object? isCapturing = null,Object? captureFailed = null,Object? review = freezed,}) {
  return _then(_ScanReceiptState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScanPhase,camera: null == camera ? _self.camera : camera // ignore: cast_nullable_to_non_nullable
as CameraStatus,flashOn: null == flashOn ? _self.flashOn : flashOn // ignore: cast_nullable_to_non_nullable
as bool,isCapturing: null == isCapturing ? _self.isCapturing : isCapturing // ignore: cast_nullable_to_non_nullable
as bool,captureFailed: null == captureFailed ? _self.captureFailed : captureFailed // ignore: cast_nullable_to_non_nullable
as bool,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as ReceiptReviewArgs?,
  ));
}

/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScanPhaseCopyWith<$Res> get phase {
  
  return $ScanPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}/// Create a copy of ScanReceiptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptReviewArgsCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $ReceiptReviewArgsCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}

// dart format on
