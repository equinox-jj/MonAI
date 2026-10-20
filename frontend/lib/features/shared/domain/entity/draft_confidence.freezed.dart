// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_confidence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DraftConfidence {

 double get type; double get amount; double get wallet; double get category; double get date;
/// Create a copy of DraftConfidence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftConfidenceCopyWith<DraftConfidence> get copyWith => _$DraftConfidenceCopyWithImpl<DraftConfidence>(this as DraftConfidence, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DraftConfidence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftConfidence&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.wallet, _this.wallet) || other.wallet == _this.wallet)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.date, _this.date) || other.date == _this.date));
}


@override
int get hashCode {
  final _this = this as DraftConfidence;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.wallet,_this.category,_this.date);
}

@override
String toString() {
  final _this = this as DraftConfidence;
  return 'DraftConfidence(type: ${_this.type}, amount: ${_this.amount}, wallet: ${_this.wallet}, category: ${_this.category}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $DraftConfidenceCopyWith<$Res>  {
  factory $DraftConfidenceCopyWith(DraftConfidence value, $Res Function(DraftConfidence) _then) = _$DraftConfidenceCopyWithImpl;
@useResult
$Res call({
 double type, double amount, double wallet, double category, double date
});




}
/// @nodoc
class _$DraftConfidenceCopyWithImpl<$Res>
    implements $DraftConfidenceCopyWith<$Res> {
  _$DraftConfidenceCopyWithImpl(this._self, this._then);

  final DraftConfidence _self;
  final $Res Function(DraftConfidence) _then;

/// Create a copy of DraftConfidence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? amount = null,Object? wallet = null,Object? category = null,Object? date = null,}) {
  return _then(DraftConfidence(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftConfidence].
extension DraftConfidencePatterns on DraftConfidence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftConfidence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftConfidence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftConfidence value)  $default,){
final _that = this;
switch (_that) {
case _DraftConfidence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftConfidence value)?  $default,){
final _that = this;
switch (_that) {
case _DraftConfidence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double type,  double amount,  double wallet,  double category,  double date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftConfidence() when $default != null:
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double type,  double amount,  double wallet,  double category,  double date)  $default,) {final _that = this;
switch (_that) {
case _DraftConfidence():
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double type,  double amount,  double wallet,  double category,  double date)?  $default,) {final _that = this;
switch (_that) {
case _DraftConfidence() when $default != null:
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _DraftConfidence implements DraftConfidence {
  const _DraftConfidence({this.type = 0, this.amount = 0, this.wallet = 0, this.category = 0, this.date = 0});
  

@override@JsonKey() final  double type;
@override@JsonKey() final  double amount;
@override@JsonKey() final  double wallet;
@override@JsonKey() final  double category;
@override@JsonKey() final  double date;

/// Create a copy of DraftConfidence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftConfidenceCopyWith<_DraftConfidence> get copyWith => __$DraftConfidenceCopyWithImpl<_DraftConfidence>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftConfidence&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,wallet,category,date);
}

@override
String toString() {
    return 'DraftConfidence(type: $type, amount: $amount, wallet: $wallet, category: $category, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DraftConfidenceCopyWith<$Res> implements $DraftConfidenceCopyWith<$Res> {
  factory _$DraftConfidenceCopyWith(_DraftConfidence value, $Res Function(_DraftConfidence) _then) = __$DraftConfidenceCopyWithImpl;
@override @useResult
$Res call({
 double type, double amount, double wallet, double category, double date
});




}
/// @nodoc
class __$DraftConfidenceCopyWithImpl<$Res>
    implements _$DraftConfidenceCopyWith<$Res> {
  __$DraftConfidenceCopyWithImpl(this._self, this._then);

  final _DraftConfidence _self;
  final $Res Function(_DraftConfidence) _then;

/// Create a copy of DraftConfidence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? wallet = null,Object? category = null,Object? date = null,}) {
  return _then(_DraftConfidence(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
