// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') BudgetData? get data;
/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetResponseCopyWith<BudgetResponse> get copyWith => _$BudgetResponseCopyWithImpl<BudgetResponse>(this as BudgetResponse, _$identity);

  /// Serializes this BudgetResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BudgetResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BudgetResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as BudgetResponse;
  return 'BudgetResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $BudgetResponseCopyWith<$Res>  {
  factory $BudgetResponseCopyWith(BudgetResponse value, $Res Function(BudgetResponse) _then) = _$BudgetResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') BudgetData? data
});


$BudgetDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$BudgetResponseCopyWithImpl<$Res>
    implements $BudgetResponseCopyWith<$Res> {
  _$BudgetResponseCopyWithImpl(this._self, this._then);

  final BudgetResponse _self;
  final $Res Function(BudgetResponse) _then;

/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(BudgetResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BudgetData?,
  ));
}
/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BudgetDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetResponse].
extension BudgetResponsePatterns on BudgetResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetResponse value)  $default,){
final _that = this;
switch (_that) {
case _BudgetResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  BudgetData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  BudgetData? data)  $default,) {final _that = this;
switch (_that) {
case _BudgetResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  BudgetData? data)?  $default,) {final _that = this;
switch (_that) {
case _BudgetResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetResponse implements BudgetResponse {
  const _BudgetResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _BudgetResponse.fromJson(Map<String, dynamic> json) => _$BudgetResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  BudgetData? data;

/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetResponseCopyWith<_BudgetResponse> get copyWith => __$BudgetResponseCopyWithImpl<_BudgetResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'BudgetResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BudgetResponseCopyWith<$Res> implements $BudgetResponseCopyWith<$Res> {
  factory _$BudgetResponseCopyWith(_BudgetResponse value, $Res Function(_BudgetResponse) _then) = __$BudgetResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') BudgetData? data
});


@override $BudgetDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$BudgetResponseCopyWithImpl<$Res>
    implements _$BudgetResponseCopyWith<$Res> {
  __$BudgetResponseCopyWithImpl(this._self, this._then);

  final _BudgetResponse _self;
  final $Res Function(_BudgetResponse) _then;

/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_BudgetResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BudgetData?,
  ));
}

/// Create a copy of BudgetResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BudgetDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$BudgetData {

@JsonKey(name: 'month') String? get month;@JsonKey(name: 'limit_amount') int? get limitAmount;@JsonKey(name: 'spent') int? get spent;@JsonKey(name: 'remaining') int? get remaining;@JsonKey(name: 'progress_percent') double? get progressPercent;@JsonKey(name: 'status') String? get status;
/// Create a copy of BudgetData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetDataCopyWith<BudgetData> get copyWith => _$BudgetDataCopyWithImpl<BudgetData>(this as BudgetData, _$identity);

  /// Serializes this BudgetData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BudgetData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetData&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.limitAmount, _this.limitAmount) || other.limitAmount == _this.limitAmount)&&(identical(other.spent, _this.spent) || other.spent == _this.spent)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.progressPercent, _this.progressPercent) || other.progressPercent == _this.progressPercent)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BudgetData;
  return Object.hash(runtimeType,_this.month,_this.limitAmount,_this.spent,_this.remaining,_this.progressPercent,_this.status);
}

@override
String toString() {
  final _this = this as BudgetData;
  return 'BudgetData(month: ${_this.month}, limitAmount: ${_this.limitAmount}, spent: ${_this.spent}, remaining: ${_this.remaining}, progressPercent: ${_this.progressPercent}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $BudgetDataCopyWith<$Res>  {
  factory $BudgetDataCopyWith(BudgetData value, $Res Function(BudgetData) _then) = _$BudgetDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'limit_amount') int? limitAmount,@JsonKey(name: 'spent') int? spent,@JsonKey(name: 'remaining') int? remaining,@JsonKey(name: 'progress_percent') double? progressPercent,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class _$BudgetDataCopyWithImpl<$Res>
    implements $BudgetDataCopyWith<$Res> {
  _$BudgetDataCopyWithImpl(this._self, this._then);

  final BudgetData _self;
  final $Res Function(BudgetData) _then;

/// Create a copy of BudgetData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = freezed,Object? limitAmount = freezed,Object? spent = freezed,Object? remaining = freezed,Object? progressPercent = freezed,Object? status = freezed,}) {
  return _then(BudgetData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: freezed == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int?,spent: freezed == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetData].
extension BudgetDataPatterns on BudgetData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetData value)  $default,){
final _that = this;
switch (_that) {
case _BudgetData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetData value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'limit_amount')  int? limitAmount, @JsonKey(name: 'spent')  int? spent, @JsonKey(name: 'remaining')  int? remaining, @JsonKey(name: 'progress_percent')  double? progressPercent, @JsonKey(name: 'status')  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'limit_amount')  int? limitAmount, @JsonKey(name: 'spent')  int? spent, @JsonKey(name: 'remaining')  int? remaining, @JsonKey(name: 'progress_percent')  double? progressPercent, @JsonKey(name: 'status')  String? status)  $default,) {final _that = this;
switch (_that) {
case _BudgetData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'limit_amount')  int? limitAmount, @JsonKey(name: 'spent')  int? spent, @JsonKey(name: 'remaining')  int? remaining, @JsonKey(name: 'progress_percent')  double? progressPercent, @JsonKey(name: 'status')  String? status)?  $default,) {final _that = this;
switch (_that) {
case _BudgetData() when $default != null:
return $default(_that.month,_that.limitAmount,_that.spent,_that.remaining,_that.progressPercent,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetData implements BudgetData {
  const _BudgetData({@JsonKey(name: 'month') this.month, @JsonKey(name: 'limit_amount') this.limitAmount, @JsonKey(name: 'spent') this.spent, @JsonKey(name: 'remaining') this.remaining, @JsonKey(name: 'progress_percent') this.progressPercent, @JsonKey(name: 'status') this.status});
  factory _BudgetData.fromJson(Map<String, dynamic> json) => _$BudgetDataFromJson(json);

@override@JsonKey(name: 'month') final  String? month;
@override@JsonKey(name: 'limit_amount') final  int? limitAmount;
@override@JsonKey(name: 'spent') final  int? spent;
@override@JsonKey(name: 'remaining') final  int? remaining;
@override@JsonKey(name: 'progress_percent') final  double? progressPercent;
@override@JsonKey(name: 'status') final  String? status;

/// Create a copy of BudgetData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDataCopyWith<_BudgetData> get copyWith => __$BudgetDataCopyWithImpl<_BudgetData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetData&&(identical(other.month, month) || other.month == month)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,month,limitAmount,spent,remaining,progressPercent,status);
}

@override
String toString() {
    return 'BudgetData(month: $month, limitAmount: $limitAmount, spent: $spent, remaining: $remaining, progressPercent: $progressPercent, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BudgetDataCopyWith<$Res> implements $BudgetDataCopyWith<$Res> {
  factory _$BudgetDataCopyWith(_BudgetData value, $Res Function(_BudgetData) _then) = __$BudgetDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'limit_amount') int? limitAmount,@JsonKey(name: 'spent') int? spent,@JsonKey(name: 'remaining') int? remaining,@JsonKey(name: 'progress_percent') double? progressPercent,@JsonKey(name: 'status') String? status
});




}
/// @nodoc
class __$BudgetDataCopyWithImpl<$Res>
    implements _$BudgetDataCopyWith<$Res> {
  __$BudgetDataCopyWithImpl(this._self, this._then);

  final _BudgetData _self;
  final $Res Function(_BudgetData) _then;

/// Create a copy of BudgetData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = freezed,Object? limitAmount = freezed,Object? spent = freezed,Object? remaining = freezed,Object? progressPercent = freezed,Object? status = freezed,}) {
  return _then(_BudgetData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: freezed == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int?,spent: freezed == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int?,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
