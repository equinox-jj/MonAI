// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_csv_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportCsvEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExportCsvEvent()';
}


}

/// @nodoc
class $ExportCsvEventCopyWith<$Res>  {
$ExportCsvEventCopyWith(ExportCsvEvent _, $Res Function(ExportCsvEvent) __);
}


/// Adds pattern-matching-related methods to [ExportCsvEvent].
extension ExportCsvEventPatterns on ExportCsvEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _FromMoved value)?  fromMoved,TResult Function( _ToMoved value)?  toMoved,TResult Function( _DelimiterPicked value)?  delimiterPicked,TResult Function( _ExportRequested value)?  exportRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FromMoved() when fromMoved != null:
return fromMoved(_that);case _ToMoved() when toMoved != null:
return toMoved(_that);case _DelimiterPicked() when delimiterPicked != null:
return delimiterPicked(_that);case _ExportRequested() when exportRequested != null:
return exportRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _FromMoved value)  fromMoved,required TResult Function( _ToMoved value)  toMoved,required TResult Function( _DelimiterPicked value)  delimiterPicked,required TResult Function( _ExportRequested value)  exportRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _FromMoved():
return fromMoved(_that);case _ToMoved():
return toMoved(_that);case _DelimiterPicked():
return delimiterPicked(_that);case _ExportRequested():
return exportRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _FromMoved value)?  fromMoved,TResult? Function( _ToMoved value)?  toMoved,TResult? Function( _DelimiterPicked value)?  delimiterPicked,TResult? Function( _ExportRequested value)?  exportRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FromMoved() when fromMoved != null:
return fromMoved(_that);case _ToMoved() when toMoved != null:
return toMoved(_that);case _DelimiterPicked() when delimiterPicked != null:
return delimiterPicked(_that);case _ExportRequested() when exportRequested != null:
return exportRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int months)?  fromMoved,TResult Function( int months)?  toMoved,TResult Function( CsvDelimiter delimiter)?  delimiterPicked,TResult Function( String shareTitle)?  exportRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _FromMoved() when fromMoved != null:
return fromMoved(_that.months);case _ToMoved() when toMoved != null:
return toMoved(_that.months);case _DelimiterPicked() when delimiterPicked != null:
return delimiterPicked(_that.delimiter);case _ExportRequested() when exportRequested != null:
return exportRequested(_that.shareTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int months)  fromMoved,required TResult Function( int months)  toMoved,required TResult Function( CsvDelimiter delimiter)  delimiterPicked,required TResult Function( String shareTitle)  exportRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _FromMoved():
return fromMoved(_that.months);case _ToMoved():
return toMoved(_that.months);case _DelimiterPicked():
return delimiterPicked(_that.delimiter);case _ExportRequested():
return exportRequested(_that.shareTitle);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int months)?  fromMoved,TResult? Function( int months)?  toMoved,TResult? Function( CsvDelimiter delimiter)?  delimiterPicked,TResult? Function( String shareTitle)?  exportRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _FromMoved() when fromMoved != null:
return fromMoved(_that.months);case _ToMoved() when toMoved != null:
return toMoved(_that.months);case _DelimiterPicked() when delimiterPicked != null:
return delimiterPicked(_that.delimiter);case _ExportRequested() when exportRequested != null:
return exportRequested(_that.shareTitle);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ExportCsvEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExportCsvEvent.started()';
}


}




/// @nodoc


class _FromMoved implements ExportCsvEvent {
  const _FromMoved(this.months);
  

 final  int months;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FromMovedCopyWith<_FromMoved> get copyWith => __$FromMovedCopyWithImpl<_FromMoved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FromMoved&&(identical(other.months, months) || other.months == months));
}


@override
int get hashCode {
    return Object.hash(runtimeType,months);
}

@override
String toString() {
    return 'ExportCsvEvent.fromMoved(months: $months)';
}


}

/// @nodoc
abstract mixin class _$FromMovedCopyWith<$Res> implements $ExportCsvEventCopyWith<$Res> {
  factory _$FromMovedCopyWith(_FromMoved value, $Res Function(_FromMoved) _then) = __$FromMovedCopyWithImpl;
@useResult
$Res call({
 int months
});




}
/// @nodoc
class __$FromMovedCopyWithImpl<$Res>
    implements _$FromMovedCopyWith<$Res> {
  __$FromMovedCopyWithImpl(this._self, this._then);

  final _FromMoved _self;
  final $Res Function(_FromMoved) _then;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? months = null,}) {
  return _then(_FromMoved(
null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ToMoved implements ExportCsvEvent {
  const _ToMoved(this.months);
  

 final  int months;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToMovedCopyWith<_ToMoved> get copyWith => __$ToMovedCopyWithImpl<_ToMoved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToMoved&&(identical(other.months, months) || other.months == months));
}


@override
int get hashCode {
    return Object.hash(runtimeType,months);
}

@override
String toString() {
    return 'ExportCsvEvent.toMoved(months: $months)';
}


}

/// @nodoc
abstract mixin class _$ToMovedCopyWith<$Res> implements $ExportCsvEventCopyWith<$Res> {
  factory _$ToMovedCopyWith(_ToMoved value, $Res Function(_ToMoved) _then) = __$ToMovedCopyWithImpl;
@useResult
$Res call({
 int months
});




}
/// @nodoc
class __$ToMovedCopyWithImpl<$Res>
    implements _$ToMovedCopyWith<$Res> {
  __$ToMovedCopyWithImpl(this._self, this._then);

  final _ToMoved _self;
  final $Res Function(_ToMoved) _then;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? months = null,}) {
  return _then(_ToMoved(
null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _DelimiterPicked implements ExportCsvEvent {
  const _DelimiterPicked(this.delimiter);
  

 final  CsvDelimiter delimiter;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DelimiterPickedCopyWith<_DelimiterPicked> get copyWith => __$DelimiterPickedCopyWithImpl<_DelimiterPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DelimiterPicked&&(identical(other.delimiter, delimiter) || other.delimiter == delimiter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,delimiter);
}

@override
String toString() {
    return 'ExportCsvEvent.delimiterPicked(delimiter: $delimiter)';
}


}

/// @nodoc
abstract mixin class _$DelimiterPickedCopyWith<$Res> implements $ExportCsvEventCopyWith<$Res> {
  factory _$DelimiterPickedCopyWith(_DelimiterPicked value, $Res Function(_DelimiterPicked) _then) = __$DelimiterPickedCopyWithImpl;
@useResult
$Res call({
 CsvDelimiter delimiter
});




}
/// @nodoc
class __$DelimiterPickedCopyWithImpl<$Res>
    implements _$DelimiterPickedCopyWith<$Res> {
  __$DelimiterPickedCopyWithImpl(this._self, this._then);

  final _DelimiterPicked _self;
  final $Res Function(_DelimiterPicked) _then;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? delimiter = null,}) {
  return _then(_DelimiterPicked(
null == delimiter ? _self.delimiter : delimiter // ignore: cast_nullable_to_non_nullable
as CsvDelimiter,
  ));
}


}

/// @nodoc


class _ExportRequested implements ExportCsvEvent {
  const _ExportRequested({required this.shareTitle});
  

 final  String shareTitle;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportRequestedCopyWith<_ExportRequested> get copyWith => __$ExportRequestedCopyWithImpl<_ExportRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportRequested&&(identical(other.shareTitle, shareTitle) || other.shareTitle == shareTitle));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shareTitle);
}

@override
String toString() {
    return 'ExportCsvEvent.exportRequested(shareTitle: $shareTitle)';
}


}

/// @nodoc
abstract mixin class _$ExportRequestedCopyWith<$Res> implements $ExportCsvEventCopyWith<$Res> {
  factory _$ExportRequestedCopyWith(_ExportRequested value, $Res Function(_ExportRequested) _then) = __$ExportRequestedCopyWithImpl;
@useResult
$Res call({
 String shareTitle
});




}
/// @nodoc
class __$ExportRequestedCopyWithImpl<$Res>
    implements _$ExportRequestedCopyWith<$Res> {
  __$ExportRequestedCopyWithImpl(this._self, this._then);

  final _ExportRequested _self;
  final $Res Function(_ExportRequested) _then;

/// Create a copy of ExportCsvEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? shareTitle = null,}) {
  return _then(_ExportRequested(
shareTitle: null == shareTitle ? _self.shareTitle : shareTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ExportCsvState {

/// The months to export.
 ExportRange get range;/// The latest month that can be exported: the current one.
 DateTime get currentMonth; CsvDelimiter get delimiter; bool get isExporting;/// Why the last export failed; cleared by any change.
 ExportFailure? get failure;/// Set once the file was shared; the sheet closes.
 ExportedCsv? get exported;
/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportCsvStateCopyWith<ExportCsvState> get copyWith => _$ExportCsvStateCopyWithImpl<ExportCsvState>(this as ExportCsvState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExportCsvState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvState&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.currentMonth, _this.currentMonth) || other.currentMonth == _this.currentMonth)&&(identical(other.delimiter, _this.delimiter) || other.delimiter == _this.delimiter)&&(identical(other.isExporting, _this.isExporting) || other.isExporting == _this.isExporting)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.exported, _this.exported) || other.exported == _this.exported));
}


@override
int get hashCode {
  final _this = this as ExportCsvState;
  return Object.hash(runtimeType,_this.range,_this.currentMonth,_this.delimiter,_this.isExporting,_this.failure,_this.exported);
}

@override
String toString() {
  final _this = this as ExportCsvState;
  return 'ExportCsvState(range: ${_this.range}, currentMonth: ${_this.currentMonth}, delimiter: ${_this.delimiter}, isExporting: ${_this.isExporting}, failure: ${_this.failure}, exported: ${_this.exported})';
}


}

/// @nodoc
abstract mixin class $ExportCsvStateCopyWith<$Res>  {
  factory $ExportCsvStateCopyWith(ExportCsvState value, $Res Function(ExportCsvState) _then) = _$ExportCsvStateCopyWithImpl;
@useResult
$Res call({
 ExportRange range, DateTime currentMonth, CsvDelimiter delimiter, bool isExporting, ExportFailure? failure, ExportedCsv? exported
});




}
/// @nodoc
class _$ExportCsvStateCopyWithImpl<$Res>
    implements $ExportCsvStateCopyWith<$Res> {
  _$ExportCsvStateCopyWithImpl(this._self, this._then);

  final ExportCsvState _self;
  final $Res Function(ExportCsvState) _then;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? currentMonth = null,Object? delimiter = null,Object? isExporting = null,Object? failure = freezed,Object? exported = freezed,}) {
  return _then(ExportCsvState(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ExportRange,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as DateTime,delimiter: null == delimiter ? _self.delimiter : delimiter // ignore: cast_nullable_to_non_nullable
as CsvDelimiter,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ExportFailure?,exported: freezed == exported ? _self.exported : exported // ignore: cast_nullable_to_non_nullable
as ExportedCsv?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportCsvState].
extension ExportCsvStatePatterns on ExportCsvState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportCsvState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportCsvState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportCsvState value)  $default,){
final _that = this;
switch (_that) {
case _ExportCsvState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportCsvState value)?  $default,){
final _that = this;
switch (_that) {
case _ExportCsvState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportRange range,  DateTime currentMonth,  CsvDelimiter delimiter,  bool isExporting,  ExportFailure? failure,  ExportedCsv? exported)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportCsvState() when $default != null:
return $default(_that.range,_that.currentMonth,_that.delimiter,_that.isExporting,_that.failure,_that.exported);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportRange range,  DateTime currentMonth,  CsvDelimiter delimiter,  bool isExporting,  ExportFailure? failure,  ExportedCsv? exported)  $default,) {final _that = this;
switch (_that) {
case _ExportCsvState():
return $default(_that.range,_that.currentMonth,_that.delimiter,_that.isExporting,_that.failure,_that.exported);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportRange range,  DateTime currentMonth,  CsvDelimiter delimiter,  bool isExporting,  ExportFailure? failure,  ExportedCsv? exported)?  $default,) {final _that = this;
switch (_that) {
case _ExportCsvState() when $default != null:
return $default(_that.range,_that.currentMonth,_that.delimiter,_that.isExporting,_that.failure,_that.exported);case _:
  return null;

}
}

}

/// @nodoc


class _ExportCsvState implements ExportCsvState {
  const _ExportCsvState({required this.range, required this.currentMonth, this.delimiter = CsvDelimiter.comma, this.isExporting = false, this.failure, this.exported});
  

/// The months to export.
@override final  ExportRange range;
/// The latest month that can be exported: the current one.
@override final  DateTime currentMonth;
@override@JsonKey() final  CsvDelimiter delimiter;
@override@JsonKey() final  bool isExporting;
/// Why the last export failed; cleared by any change.
@override final  ExportFailure? failure;
/// Set once the file was shared; the sheet closes.
@override final  ExportedCsv? exported;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportCsvStateCopyWith<_ExportCsvState> get copyWith => __$ExportCsvStateCopyWithImpl<_ExportCsvState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportCsvState&&(identical(other.range, range) || other.range == range)&&(identical(other.currentMonth, currentMonth) || other.currentMonth == currentMonth)&&(identical(other.delimiter, delimiter) || other.delimiter == delimiter)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.exported, exported) || other.exported == exported));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range,currentMonth,delimiter,isExporting,failure,exported);
}

@override
String toString() {
    return 'ExportCsvState(range: $range, currentMonth: $currentMonth, delimiter: $delimiter, isExporting: $isExporting, failure: $failure, exported: $exported)';
}


}

/// @nodoc
abstract mixin class _$ExportCsvStateCopyWith<$Res> implements $ExportCsvStateCopyWith<$Res> {
  factory _$ExportCsvStateCopyWith(_ExportCsvState value, $Res Function(_ExportCsvState) _then) = __$ExportCsvStateCopyWithImpl;
@override @useResult
$Res call({
 ExportRange range, DateTime currentMonth, CsvDelimiter delimiter, bool isExporting, ExportFailure? failure, ExportedCsv? exported
});




}
/// @nodoc
class __$ExportCsvStateCopyWithImpl<$Res>
    implements _$ExportCsvStateCopyWith<$Res> {
  __$ExportCsvStateCopyWithImpl(this._self, this._then);

  final _ExportCsvState _self;
  final $Res Function(_ExportCsvState) _then;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? currentMonth = null,Object? delimiter = null,Object? isExporting = null,Object? failure = freezed,Object? exported = freezed,}) {
  return _then(_ExportCsvState(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ExportRange,currentMonth: null == currentMonth ? _self.currentMonth : currentMonth // ignore: cast_nullable_to_non_nullable
as DateTime,delimiter: null == delimiter ? _self.delimiter : delimiter // ignore: cast_nullable_to_non_nullable
as CsvDelimiter,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ExportFailure?,exported: freezed == exported ? _self.exported : exported // ignore: cast_nullable_to_non_nullable
as ExportedCsv?,
  ));
}


}

// dart format on
