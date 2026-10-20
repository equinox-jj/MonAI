// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_confidence_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DraftConfidenceData {

@JsonKey(name: 'type') double? get type;@JsonKey(name: 'amount') double? get amount;@JsonKey(name: 'wallet') double? get wallet;@JsonKey(name: 'category') double? get category;@JsonKey(name: 'date') double? get date;
/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftConfidenceDataCopyWith<DraftConfidenceData> get copyWith => _$DraftConfidenceDataCopyWithImpl<DraftConfidenceData>(this as DraftConfidenceData, _$identity);

  /// Serializes this DraftConfidenceData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DraftConfidenceData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftConfidenceData&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.wallet, _this.wallet) || other.wallet == _this.wallet)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.date, _this.date) || other.date == _this.date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DraftConfidenceData;
  return Object.hash(runtimeType,_this.type,_this.amount,_this.wallet,_this.category,_this.date);
}

@override
String toString() {
  final _this = this as DraftConfidenceData;
  return 'DraftConfidenceData(type: ${_this.type}, amount: ${_this.amount}, wallet: ${_this.wallet}, category: ${_this.category}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $DraftConfidenceDataCopyWith<$Res>  {
  factory $DraftConfidenceDataCopyWith(DraftConfidenceData value, $Res Function(DraftConfidenceData) _then) = _$DraftConfidenceDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') double? type,@JsonKey(name: 'amount') double? amount,@JsonKey(name: 'wallet') double? wallet,@JsonKey(name: 'category') double? category,@JsonKey(name: 'date') double? date
});




}
/// @nodoc
class _$DraftConfidenceDataCopyWithImpl<$Res>
    implements $DraftConfidenceDataCopyWith<$Res> {
  _$DraftConfidenceDataCopyWithImpl(this._self, this._then);

  final DraftConfidenceData _self;
  final $Res Function(DraftConfidenceData) _then;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? amount = freezed,Object? wallet = freezed,Object? category = freezed,Object? date = freezed,}) {
  return _then(DraftConfidenceData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftConfidenceData].
extension DraftConfidenceDataPatterns on DraftConfidenceData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftConfidenceData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftConfidenceData value)  $default,){
final _that = this;
switch (_that) {
case _DraftConfidenceData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftConfidenceData value)?  $default,){
final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)  $default,) {final _that = this;
switch (_that) {
case _DraftConfidenceData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  double? type, @JsonKey(name: 'amount')  double? amount, @JsonKey(name: 'wallet')  double? wallet, @JsonKey(name: 'category')  double? category, @JsonKey(name: 'date')  double? date)?  $default,) {final _that = this;
switch (_that) {
case _DraftConfidenceData() when $default != null:
return $default(_that.type,_that.amount,_that.wallet,_that.category,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DraftConfidenceData implements DraftConfidenceData {
  const _DraftConfidenceData({@JsonKey(name: 'type') this.type, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'wallet') this.wallet, @JsonKey(name: 'category') this.category, @JsonKey(name: 'date') this.date});
  factory _DraftConfidenceData.fromJson(Map<String, dynamic> json) => _$DraftConfidenceDataFromJson(json);

@override@JsonKey(name: 'type') final  double? type;
@override@JsonKey(name: 'amount') final  double? amount;
@override@JsonKey(name: 'wallet') final  double? wallet;
@override@JsonKey(name: 'category') final  double? category;
@override@JsonKey(name: 'date') final  double? date;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftConfidenceDataCopyWith<_DraftConfidenceData> get copyWith => __$DraftConfidenceDataCopyWithImpl<_DraftConfidenceData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DraftConfidenceDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftConfidenceData&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,amount,wallet,category,date);
}

@override
String toString() {
    return 'DraftConfidenceData(type: $type, amount: $amount, wallet: $wallet, category: $category, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DraftConfidenceDataCopyWith<$Res> implements $DraftConfidenceDataCopyWith<$Res> {
  factory _$DraftConfidenceDataCopyWith(_DraftConfidenceData value, $Res Function(_DraftConfidenceData) _then) = __$DraftConfidenceDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') double? type,@JsonKey(name: 'amount') double? amount,@JsonKey(name: 'wallet') double? wallet,@JsonKey(name: 'category') double? category,@JsonKey(name: 'date') double? date
});




}
/// @nodoc
class __$DraftConfidenceDataCopyWithImpl<$Res>
    implements _$DraftConfidenceDataCopyWith<$Res> {
  __$DraftConfidenceDataCopyWithImpl(this._self, this._then);

  final _DraftConfidenceData _self;
  final $Res Function(_DraftConfidenceData) _then;

/// Create a copy of DraftConfidenceData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? amount = freezed,Object? wallet = freezed,Object? category = freezed,Object? date = freezed,}) {
  return _then(_DraftConfidenceData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as double?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
