// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_budget_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetBudgetRequest {

@JsonKey(name: 'limit_amount') int get limitAmount;
/// Create a copy of SetBudgetRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetBudgetRequestCopyWith<SetBudgetRequest> get copyWith => _$SetBudgetRequestCopyWithImpl<SetBudgetRequest>(this as SetBudgetRequest, _$identity);

  /// Serializes this SetBudgetRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetBudgetRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetBudgetRequest&&(identical(other.limitAmount, _this.limitAmount) || other.limitAmount == _this.limitAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetBudgetRequest;
  return Object.hash(runtimeType,_this.limitAmount);
}

@override
String toString() {
  final _this = this as SetBudgetRequest;
  return 'SetBudgetRequest(limitAmount: ${_this.limitAmount})';
}


}

/// @nodoc
abstract mixin class $SetBudgetRequestCopyWith<$Res>  {
  factory $SetBudgetRequestCopyWith(SetBudgetRequest value, $Res Function(SetBudgetRequest) _then) = _$SetBudgetRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'limit_amount') int limitAmount
});




}
/// @nodoc
class _$SetBudgetRequestCopyWithImpl<$Res>
    implements $SetBudgetRequestCopyWith<$Res> {
  _$SetBudgetRequestCopyWithImpl(this._self, this._then);

  final SetBudgetRequest _self;
  final $Res Function(SetBudgetRequest) _then;

/// Create a copy of SetBudgetRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limitAmount = null,}) {
  return _then(SetBudgetRequest(
limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SetBudgetRequest].
extension SetBudgetRequestPatterns on SetBudgetRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetBudgetRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetBudgetRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetBudgetRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetBudgetRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetBudgetRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetBudgetRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'limit_amount')  int limitAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetBudgetRequest() when $default != null:
return $default(_that.limitAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'limit_amount')  int limitAmount)  $default,) {final _that = this;
switch (_that) {
case _SetBudgetRequest():
return $default(_that.limitAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'limit_amount')  int limitAmount)?  $default,) {final _that = this;
switch (_that) {
case _SetBudgetRequest() when $default != null:
return $default(_that.limitAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetBudgetRequest implements SetBudgetRequest {
  const _SetBudgetRequest({@JsonKey(name: 'limit_amount') required this.limitAmount});
  factory _SetBudgetRequest.fromJson(Map<String, dynamic> json) => _$SetBudgetRequestFromJson(json);

@override@JsonKey(name: 'limit_amount') final  int limitAmount;

/// Create a copy of SetBudgetRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetBudgetRequestCopyWith<_SetBudgetRequest> get copyWith => __$SetBudgetRequestCopyWithImpl<_SetBudgetRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetBudgetRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetBudgetRequest&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,limitAmount);
}

@override
String toString() {
    return 'SetBudgetRequest(limitAmount: $limitAmount)';
}


}

/// @nodoc
abstract mixin class _$SetBudgetRequestCopyWith<$Res> implements $SetBudgetRequestCopyWith<$Res> {
  factory _$SetBudgetRequestCopyWith(_SetBudgetRequest value, $Res Function(_SetBudgetRequest) _then) = __$SetBudgetRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'limit_amount') int limitAmount
});




}
/// @nodoc
class __$SetBudgetRequestCopyWithImpl<$Res>
    implements _$SetBudgetRequestCopyWith<$Res> {
  __$SetBudgetRequestCopyWithImpl(this._self, this._then);

  final _SetBudgetRequest _self;
  final $Res Function(_SetBudgetRequest) _then;

/// Create a copy of SetBudgetRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limitAmount = null,}) {
  return _then(_SetBudgetRequest(
limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
