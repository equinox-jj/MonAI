// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyReportResponse {

@JsonKey(name: 'success') bool? get success;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'data') MonthlyReportData? get data;
/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportResponseCopyWith<MonthlyReportResponse> get copyWith => _$MonthlyReportResponseCopyWithImpl<MonthlyReportResponse>(this as MonthlyReportResponse, _$identity);

  /// Serializes this MonthlyReportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyReportResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReportResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyReportResponse;
  return Object.hash(runtimeType,_this.success,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as MonthlyReportResponse;
  return 'MonthlyReportResponse(success: ${_this.success}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $MonthlyReportResponseCopyWith<$Res>  {
  factory $MonthlyReportResponseCopyWith(MonthlyReportResponse value, $Res Function(MonthlyReportResponse) _then) = _$MonthlyReportResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') MonthlyReportData? data
});


$MonthlyReportDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$MonthlyReportResponseCopyWithImpl<$Res>
    implements $MonthlyReportResponseCopyWith<$Res> {
  _$MonthlyReportResponseCopyWithImpl(this._self, this._then);

  final MonthlyReportResponse _self;
  final $Res Function(MonthlyReportResponse) _then;

/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(MonthlyReportResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MonthlyReportData?,
  ));
}
/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MonthlyReportDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReportResponse].
extension MonthlyReportResponsePatterns on MonthlyReportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReportResponse value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MonthlyReportData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReportResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MonthlyReportData? data)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool? success, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'data')  MonthlyReportData? data)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyReportResponse implements MonthlyReportResponse {
  const _MonthlyReportResponse({@JsonKey(name: 'success') this.success, @JsonKey(name: 'message') this.message, @JsonKey(name: 'data') this.data});
  factory _MonthlyReportResponse.fromJson(Map<String, dynamic> json) => _$MonthlyReportResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool? success;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'data') final  MonthlyReportData? data;

/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportResponseCopyWith<_MonthlyReportResponse> get copyWith => __$MonthlyReportResponseCopyWithImpl<_MonthlyReportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyReportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReportResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,data);
}

@override
String toString() {
    return 'MonthlyReportResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportResponseCopyWith<$Res> implements $MonthlyReportResponseCopyWith<$Res> {
  factory _$MonthlyReportResponseCopyWith(_MonthlyReportResponse value, $Res Function(_MonthlyReportResponse) _then) = __$MonthlyReportResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool? success,@JsonKey(name: 'message') String? message,@JsonKey(name: 'data') MonthlyReportData? data
});


@override $MonthlyReportDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$MonthlyReportResponseCopyWithImpl<$Res>
    implements _$MonthlyReportResponseCopyWith<$Res> {
  __$MonthlyReportResponseCopyWithImpl(this._self, this._then);

  final _MonthlyReportResponse _self;
  final $Res Function(_MonthlyReportResponse) _then;

/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = freezed,Object? message = freezed,Object? data = freezed,}) {
  return _then(_MonthlyReportResponse(
success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MonthlyReportData?,
  ));
}

/// Create a copy of MonthlyReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MonthlyReportDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MonthlyReportData {

@JsonKey(name: 'month') String? get month;@JsonKey(name: 'income_total') int? get incomeTotal;@JsonKey(name: 'expense_total') int? get expenseTotal;@JsonKey(name: 'net') int? get net;@JsonKey(name: 'previous') PreviousMonthData? get previous;@JsonKey(name: 'expense_change_percent') double? get expenseChangePercent;@JsonKey(name: 'categories') List<CategoryBreakdownData>? get categories;
/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportDataCopyWith<MonthlyReportData> get copyWith => _$MonthlyReportDataCopyWithImpl<MonthlyReportData>(this as MonthlyReportData, _$identity);

  /// Serializes this MonthlyReportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyReportData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReportData&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.incomeTotal, _this.incomeTotal) || other.incomeTotal == _this.incomeTotal)&&(identical(other.expenseTotal, _this.expenseTotal) || other.expenseTotal == _this.expenseTotal)&&(identical(other.net, _this.net) || other.net == _this.net)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&(identical(other.expenseChangePercent, _this.expenseChangePercent) || other.expenseChangePercent == _this.expenseChangePercent)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyReportData;
  return Object.hash(runtimeType,_this.month,_this.incomeTotal,_this.expenseTotal,_this.net,_this.previous,_this.expenseChangePercent,const DeepCollectionEquality().hash(_this.categories));
}

@override
String toString() {
  final _this = this as MonthlyReportData;
  return 'MonthlyReportData(month: ${_this.month}, incomeTotal: ${_this.incomeTotal}, expenseTotal: ${_this.expenseTotal}, net: ${_this.net}, previous: ${_this.previous}, expenseChangePercent: ${_this.expenseChangePercent}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $MonthlyReportDataCopyWith<$Res>  {
  factory $MonthlyReportDataCopyWith(MonthlyReportData value, $Res Function(MonthlyReportData) _then) = _$MonthlyReportDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'income_total') int? incomeTotal,@JsonKey(name: 'expense_total') int? expenseTotal,@JsonKey(name: 'net') int? net,@JsonKey(name: 'previous') PreviousMonthData? previous,@JsonKey(name: 'expense_change_percent') double? expenseChangePercent,@JsonKey(name: 'categories') List<CategoryBreakdownData>? categories
});


$PreviousMonthDataCopyWith<$Res>? get previous;

}
/// @nodoc
class _$MonthlyReportDataCopyWithImpl<$Res>
    implements $MonthlyReportDataCopyWith<$Res> {
  _$MonthlyReportDataCopyWithImpl(this._self, this._then);

  final MonthlyReportData _self;
  final $Res Function(MonthlyReportData) _then;

/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = freezed,Object? incomeTotal = freezed,Object? expenseTotal = freezed,Object? net = freezed,Object? previous = freezed,Object? expenseChangePercent = freezed,Object? categories = freezed,}) {
  return _then(MonthlyReportData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,incomeTotal: freezed == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int?,expenseTotal: freezed == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int?,net: freezed == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as PreviousMonthData?,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>?,
  ));
}
/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviousMonthDataCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $PreviousMonthDataCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReportData].
extension MonthlyReportDataPatterns on MonthlyReportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReportData value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReportData value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal, @JsonKey(name: 'net')  int? net, @JsonKey(name: 'previous')  PreviousMonthData? previous, @JsonKey(name: 'expense_change_percent')  double? expenseChangePercent, @JsonKey(name: 'categories')  List<CategoryBreakdownData>? categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReportData() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.expenseChangePercent,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal, @JsonKey(name: 'net')  int? net, @JsonKey(name: 'previous')  PreviousMonthData? previous, @JsonKey(name: 'expense_change_percent')  double? expenseChangePercent, @JsonKey(name: 'categories')  List<CategoryBreakdownData>? categories)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportData():
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.expenseChangePercent,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal, @JsonKey(name: 'net')  int? net, @JsonKey(name: 'previous')  PreviousMonthData? previous, @JsonKey(name: 'expense_change_percent')  double? expenseChangePercent, @JsonKey(name: 'categories')  List<CategoryBreakdownData>? categories)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReportData() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.expenseChangePercent,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyReportData implements MonthlyReportData {
  const _MonthlyReportData({@JsonKey(name: 'month') this.month, @JsonKey(name: 'income_total') this.incomeTotal, @JsonKey(name: 'expense_total') this.expenseTotal, @JsonKey(name: 'net') this.net, @JsonKey(name: 'previous') this.previous, @JsonKey(name: 'expense_change_percent') this.expenseChangePercent, @JsonKey(name: 'categories')  List<CategoryBreakdownData>? categories}): _categories = categories;
  factory _MonthlyReportData.fromJson(Map<String, dynamic> json) => _$MonthlyReportDataFromJson(json);

@override@JsonKey(name: 'month') final  String? month;
@override@JsonKey(name: 'income_total') final  int? incomeTotal;
@override@JsonKey(name: 'expense_total') final  int? expenseTotal;
@override@JsonKey(name: 'net') final  int? net;
@override@JsonKey(name: 'previous') final  PreviousMonthData? previous;
@override@JsonKey(name: 'expense_change_percent') final  double? expenseChangePercent;
 final  List<CategoryBreakdownData>? _categories;
@override@JsonKey(name: 'categories') List<CategoryBreakdownData>? get categories {
  final value = _categories;
  if (value == null) return null;
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportDataCopyWith<_MonthlyReportData> get copyWith => __$MonthlyReportDataCopyWithImpl<_MonthlyReportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyReportDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReportData&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeTotal, incomeTotal) || other.incomeTotal == incomeTotal)&&(identical(other.expenseTotal, expenseTotal) || other.expenseTotal == expenseTotal)&&(identical(other.net, net) || other.net == net)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&const DeepCollectionEquality().equals(other.categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,month,incomeTotal,expenseTotal,net,previous,expenseChangePercent,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'MonthlyReportData(month: $month, incomeTotal: $incomeTotal, expenseTotal: $expenseTotal, net: $net, previous: $previous, expenseChangePercent: $expenseChangePercent, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportDataCopyWith<$Res> implements $MonthlyReportDataCopyWith<$Res> {
  factory _$MonthlyReportDataCopyWith(_MonthlyReportData value, $Res Function(_MonthlyReportData) _then) = __$MonthlyReportDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'income_total') int? incomeTotal,@JsonKey(name: 'expense_total') int? expenseTotal,@JsonKey(name: 'net') int? net,@JsonKey(name: 'previous') PreviousMonthData? previous,@JsonKey(name: 'expense_change_percent') double? expenseChangePercent,@JsonKey(name: 'categories') List<CategoryBreakdownData>? categories
});


@override $PreviousMonthDataCopyWith<$Res>? get previous;

}
/// @nodoc
class __$MonthlyReportDataCopyWithImpl<$Res>
    implements _$MonthlyReportDataCopyWith<$Res> {
  __$MonthlyReportDataCopyWithImpl(this._self, this._then);

  final _MonthlyReportData _self;
  final $Res Function(_MonthlyReportData) _then;

/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = freezed,Object? incomeTotal = freezed,Object? expenseTotal = freezed,Object? net = freezed,Object? previous = freezed,Object? expenseChangePercent = freezed,Object? categories = freezed,}) {
  return _then(_MonthlyReportData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,incomeTotal: freezed == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int?,expenseTotal: freezed == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int?,net: freezed == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as PreviousMonthData?,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,categories: freezed == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownData>?,
  ));
}

/// Create a copy of MonthlyReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviousMonthDataCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $PreviousMonthDataCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// @nodoc
mixin _$PreviousMonthData {

@JsonKey(name: 'month') String? get month;@JsonKey(name: 'income_total') int? get incomeTotal;@JsonKey(name: 'expense_total') int? get expenseTotal;
/// Create a copy of PreviousMonthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviousMonthDataCopyWith<PreviousMonthData> get copyWith => _$PreviousMonthDataCopyWithImpl<PreviousMonthData>(this as PreviousMonthData, _$identity);

  /// Serializes this PreviousMonthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PreviousMonthData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviousMonthData&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.incomeTotal, _this.incomeTotal) || other.incomeTotal == _this.incomeTotal)&&(identical(other.expenseTotal, _this.expenseTotal) || other.expenseTotal == _this.expenseTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PreviousMonthData;
  return Object.hash(runtimeType,_this.month,_this.incomeTotal,_this.expenseTotal);
}

@override
String toString() {
  final _this = this as PreviousMonthData;
  return 'PreviousMonthData(month: ${_this.month}, incomeTotal: ${_this.incomeTotal}, expenseTotal: ${_this.expenseTotal})';
}


}

/// @nodoc
abstract mixin class $PreviousMonthDataCopyWith<$Res>  {
  factory $PreviousMonthDataCopyWith(PreviousMonthData value, $Res Function(PreviousMonthData) _then) = _$PreviousMonthDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'income_total') int? incomeTotal,@JsonKey(name: 'expense_total') int? expenseTotal
});




}
/// @nodoc
class _$PreviousMonthDataCopyWithImpl<$Res>
    implements $PreviousMonthDataCopyWith<$Res> {
  _$PreviousMonthDataCopyWithImpl(this._self, this._then);

  final PreviousMonthData _self;
  final $Res Function(PreviousMonthData) _then;

/// Create a copy of PreviousMonthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = freezed,Object? incomeTotal = freezed,Object? expenseTotal = freezed,}) {
  return _then(PreviousMonthData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,incomeTotal: freezed == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int?,expenseTotal: freezed == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviousMonthData].
extension PreviousMonthDataPatterns on PreviousMonthData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviousMonthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviousMonthData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviousMonthData value)  $default,){
final _that = this;
switch (_that) {
case _PreviousMonthData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviousMonthData value)?  $default,){
final _that = this;
switch (_that) {
case _PreviousMonthData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviousMonthData() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal)  $default,) {final _that = this;
switch (_that) {
case _PreviousMonthData():
return $default(_that.month,_that.incomeTotal,_that.expenseTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'month')  String? month, @JsonKey(name: 'income_total')  int? incomeTotal, @JsonKey(name: 'expense_total')  int? expenseTotal)?  $default,) {final _that = this;
switch (_that) {
case _PreviousMonthData() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreviousMonthData implements PreviousMonthData {
  const _PreviousMonthData({@JsonKey(name: 'month') this.month, @JsonKey(name: 'income_total') this.incomeTotal, @JsonKey(name: 'expense_total') this.expenseTotal});
  factory _PreviousMonthData.fromJson(Map<String, dynamic> json) => _$PreviousMonthDataFromJson(json);

@override@JsonKey(name: 'month') final  String? month;
@override@JsonKey(name: 'income_total') final  int? incomeTotal;
@override@JsonKey(name: 'expense_total') final  int? expenseTotal;

/// Create a copy of PreviousMonthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviousMonthDataCopyWith<_PreviousMonthData> get copyWith => __$PreviousMonthDataCopyWithImpl<_PreviousMonthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreviousMonthDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousMonthData&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeTotal, incomeTotal) || other.incomeTotal == incomeTotal)&&(identical(other.expenseTotal, expenseTotal) || other.expenseTotal == expenseTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,month,incomeTotal,expenseTotal);
}

@override
String toString() {
    return 'PreviousMonthData(month: $month, incomeTotal: $incomeTotal, expenseTotal: $expenseTotal)';
}


}

/// @nodoc
abstract mixin class _$PreviousMonthDataCopyWith<$Res> implements $PreviousMonthDataCopyWith<$Res> {
  factory _$PreviousMonthDataCopyWith(_PreviousMonthData value, $Res Function(_PreviousMonthData) _then) = __$PreviousMonthDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'month') String? month,@JsonKey(name: 'income_total') int? incomeTotal,@JsonKey(name: 'expense_total') int? expenseTotal
});




}
/// @nodoc
class __$PreviousMonthDataCopyWithImpl<$Res>
    implements _$PreviousMonthDataCopyWith<$Res> {
  __$PreviousMonthDataCopyWithImpl(this._self, this._then);

  final _PreviousMonthData _self;
  final $Res Function(_PreviousMonthData) _then;

/// Create a copy of PreviousMonthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = freezed,Object? incomeTotal = freezed,Object? expenseTotal = freezed,}) {
  return _then(_PreviousMonthData(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String?,incomeTotal: freezed == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int?,expenseTotal: freezed == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CategoryBreakdownData {

@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'color') String? get color;@JsonKey(name: 'amount') int? get amount;@JsonKey(name: 'share_percent') double? get sharePercent;@JsonKey(name: 'previous_amount') int? get previousAmount;@JsonKey(name: 'change_percent') double? get changePercent;
/// Create a copy of CategoryBreakdownData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownDataCopyWith<CategoryBreakdownData> get copyWith => _$CategoryBreakdownDataCopyWithImpl<CategoryBreakdownData>(this as CategoryBreakdownData, _$identity);

  /// Serializes this CategoryBreakdownData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryBreakdownData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownData&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.sharePercent, _this.sharePercent) || other.sharePercent == _this.sharePercent)&&(identical(other.previousAmount, _this.previousAmount) || other.previousAmount == _this.previousAmount)&&(identical(other.changePercent, _this.changePercent) || other.changePercent == _this.changePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryBreakdownData;
  return Object.hash(runtimeType,_this.categoryId,_this.name,_this.icon,_this.color,_this.amount,_this.sharePercent,_this.previousAmount,_this.changePercent);
}

@override
String toString() {
  final _this = this as CategoryBreakdownData;
  return 'CategoryBreakdownData(categoryId: ${_this.categoryId}, name: ${_this.name}, icon: ${_this.icon}, color: ${_this.color}, amount: ${_this.amount}, sharePercent: ${_this.sharePercent}, previousAmount: ${_this.previousAmount}, changePercent: ${_this.changePercent})';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownDataCopyWith<$Res>  {
  factory $CategoryBreakdownDataCopyWith(CategoryBreakdownData value, $Res Function(CategoryBreakdownData) _then) = _$CategoryBreakdownDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'share_percent') double? sharePercent,@JsonKey(name: 'previous_amount') int? previousAmount,@JsonKey(name: 'change_percent') double? changePercent
});




}
/// @nodoc
class _$CategoryBreakdownDataCopyWithImpl<$Res>
    implements $CategoryBreakdownDataCopyWith<$Res> {
  _$CategoryBreakdownDataCopyWithImpl(this._self, this._then);

  final CategoryBreakdownData _self;
  final $Res Function(CategoryBreakdownData) _then;

/// Create a copy of CategoryBreakdownData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? amount = freezed,Object? sharePercent = freezed,Object? previousAmount = freezed,Object? changePercent = freezed,}) {
  return _then(CategoryBreakdownData(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,sharePercent: freezed == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double?,previousAmount: freezed == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as int?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdownData].
extension CategoryBreakdownDataPatterns on CategoryBreakdownData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownData value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownData value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'share_percent')  double? sharePercent, @JsonKey(name: 'previous_amount')  int? previousAmount, @JsonKey(name: 'change_percent')  double? changePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownData() when $default != null:
return $default(_that.categoryId,_that.name,_that.icon,_that.color,_that.amount,_that.sharePercent,_that.previousAmount,_that.changePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'share_percent')  double? sharePercent, @JsonKey(name: 'previous_amount')  int? previousAmount, @JsonKey(name: 'change_percent')  double? changePercent)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownData():
return $default(_that.categoryId,_that.name,_that.icon,_that.color,_that.amount,_that.sharePercent,_that.previousAmount,_that.changePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'color')  String? color, @JsonKey(name: 'amount')  int? amount, @JsonKey(name: 'share_percent')  double? sharePercent, @JsonKey(name: 'previous_amount')  int? previousAmount, @JsonKey(name: 'change_percent')  double? changePercent)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownData() when $default != null:
return $default(_that.categoryId,_that.name,_that.icon,_that.color,_that.amount,_that.sharePercent,_that.previousAmount,_that.changePercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownData implements CategoryBreakdownData {
  const _CategoryBreakdownData({@JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'name') this.name, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'color') this.color, @JsonKey(name: 'amount') this.amount, @JsonKey(name: 'share_percent') this.sharePercent, @JsonKey(name: 'previous_amount') this.previousAmount, @JsonKey(name: 'change_percent') this.changePercent});
  factory _CategoryBreakdownData.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownDataFromJson(json);

@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'color') final  String? color;
@override@JsonKey(name: 'amount') final  int? amount;
@override@JsonKey(name: 'share_percent') final  double? sharePercent;
@override@JsonKey(name: 'previous_amount') final  int? previousAmount;
@override@JsonKey(name: 'change_percent') final  double? changePercent;

/// Create a copy of CategoryBreakdownData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownDataCopyWith<_CategoryBreakdownData> get copyWith => __$CategoryBreakdownDataCopyWithImpl<_CategoryBreakdownData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownData&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sharePercent, sharePercent) || other.sharePercent == sharePercent)&&(identical(other.previousAmount, previousAmount) || other.previousAmount == previousAmount)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,name,icon,color,amount,sharePercent,previousAmount,changePercent);
}

@override
String toString() {
    return 'CategoryBreakdownData(categoryId: $categoryId, name: $name, icon: $icon, color: $color, amount: $amount, sharePercent: $sharePercent, previousAmount: $previousAmount, changePercent: $changePercent)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownDataCopyWith<$Res> implements $CategoryBreakdownDataCopyWith<$Res> {
  factory _$CategoryBreakdownDataCopyWith(_CategoryBreakdownData value, $Res Function(_CategoryBreakdownData) _then) = __$CategoryBreakdownDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'name') String? name,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'color') String? color,@JsonKey(name: 'amount') int? amount,@JsonKey(name: 'share_percent') double? sharePercent,@JsonKey(name: 'previous_amount') int? previousAmount,@JsonKey(name: 'change_percent') double? changePercent
});




}
/// @nodoc
class __$CategoryBreakdownDataCopyWithImpl<$Res>
    implements _$CategoryBreakdownDataCopyWith<$Res> {
  __$CategoryBreakdownDataCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownData _self;
  final $Res Function(_CategoryBreakdownData) _then;

/// Create a copy of CategoryBreakdownData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? name = freezed,Object? icon = freezed,Object? color = freezed,Object? amount = freezed,Object? sharePercent = freezed,Object? previousAmount = freezed,Object? changePercent = freezed,}) {
  return _then(_CategoryBreakdownData(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,sharePercent: freezed == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double?,previousAmount: freezed == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as int?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
