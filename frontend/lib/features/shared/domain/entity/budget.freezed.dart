// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Budget {

/// The first of the month.
 DateTime get month; int get limitAmount; int get spent; int get remaining; double get progressPercent; BudgetStatus get status;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Budget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.limitAmount, _this.limitAmount) || other.limitAmount == _this.limitAmount)&&(identical(other.spent, _this.spent) || other.spent == _this.spent)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.progressPercent, _this.progressPercent) || other.progressPercent == _this.progressPercent)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as Budget;
  return Object.hash(runtimeType,_this.month,_this.limitAmount,_this.spent,_this.remaining,_this.progressPercent,_this.status);
}

@override
String toString() {
  final _this = this as Budget;
  return 'Budget(month: ${_this.month}, limitAmount: ${_this.limitAmount}, spent: ${_this.spent}, remaining: ${_this.remaining}, progressPercent: ${_this.progressPercent}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 DateTime month, int limitAmount, int spent, int remaining, double progressPercent, BudgetStatus status
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? limitAmount = null,Object? spent = null,Object? remaining = null,Object? progressPercent = null,Object? status = null,}) {
  return _then(Budget(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int limitAmount,  int spent,  int remaining,  double progressPercent,  BudgetStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.month,_that.limitAmount,_that.spent,_that.remaining,_that.progressPercent,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int limitAmount,  int spent,  int remaining,  double progressPercent,  BudgetStatus status)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.month,_that.limitAmount,_that.spent,_that.remaining,_that.progressPercent,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int limitAmount,  int spent,  int remaining,  double progressPercent,  BudgetStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.month,_that.limitAmount,_that.spent,_that.remaining,_that.progressPercent,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _Budget implements Budget {
  const _Budget({required this.month, required this.limitAmount, required this.spent, required this.remaining, required this.progressPercent, required this.status});
  

/// The first of the month.
@override final  DateTime month;
@override final  int limitAmount;
@override final  int spent;
@override final  int remaining;
@override final  double progressPercent;
@override final  BudgetStatus status;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.month, month) || other.month == month)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,limitAmount,spent,remaining,progressPercent,status);
}

@override
String toString() {
    return 'Budget(month: $month, limitAmount: $limitAmount, spent: $spent, remaining: $remaining, progressPercent: $progressPercent, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int limitAmount, int spent, int remaining, double progressPercent, BudgetStatus status
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? limitAmount = null,Object? spent = null,Object? remaining = null,Object? progressPercent = null,Object? status = null,}) {
  return _then(_Budget(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,
  ));
}


}

// dart format on
