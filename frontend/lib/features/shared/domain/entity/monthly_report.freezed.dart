// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyReport {

/// The first of the month.
 DateTime get month; int get incomeTotal; int get expenseTotal; int get net; PreviousMonthTotals get previous;/// Expenses by category, largest first.
 List<CategoryBreakdown> get categories;/// Null when the previous month had no expenses.
 double? get expenseChangePercent;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthlyReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.incomeTotal, _this.incomeTotal) || other.incomeTotal == _this.incomeTotal)&&(identical(other.expenseTotal, _this.expenseTotal) || other.expenseTotal == _this.expenseTotal)&&(identical(other.net, _this.net) || other.net == _this.net)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.expenseChangePercent, _this.expenseChangePercent) || other.expenseChangePercent == _this.expenseChangePercent));
}


@override
int get hashCode {
  final _this = this as MonthlyReport;
  return Object.hash(runtimeType,_this.month,_this.incomeTotal,_this.expenseTotal,_this.net,_this.previous,const DeepCollectionEquality().hash(_this.categories),_this.expenseChangePercent);
}

@override
String toString() {
  final _this = this as MonthlyReport;
  return 'MonthlyReport(month: ${_this.month}, incomeTotal: ${_this.incomeTotal}, expenseTotal: ${_this.expenseTotal}, net: ${_this.net}, previous: ${_this.previous}, categories: ${_this.categories}, expenseChangePercent: ${_this.expenseChangePercent})';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 DateTime month, int incomeTotal, int expenseTotal, int net, PreviousMonthTotals previous, List<CategoryBreakdown> categories, double? expenseChangePercent
});


$PreviousMonthTotalsCopyWith<$Res> get previous;

}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? incomeTotal = null,Object? expenseTotal = null,Object? net = null,Object? previous = null,Object? categories = null,Object? expenseChangePercent = freezed,}) {
  return _then(MonthlyReport(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int,previous: null == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as PreviousMonthTotals,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdown>,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviousMonthTotalsCopyWith<$Res> get previous {
  
  return $PreviousMonthTotalsCopyWith<$Res>(_self.previous, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int incomeTotal,  int expenseTotal,  int net,  PreviousMonthTotals previous,  List<CategoryBreakdown> categories,  double? expenseChangePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.categories,_that.expenseChangePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int incomeTotal,  int expenseTotal,  int net,  PreviousMonthTotals previous,  List<CategoryBreakdown> categories,  double? expenseChangePercent)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.categories,_that.expenseChangePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int incomeTotal,  int expenseTotal,  int net,  PreviousMonthTotals previous,  List<CategoryBreakdown> categories,  double? expenseChangePercent)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal,_that.net,_that.previous,_that.categories,_that.expenseChangePercent);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyReport implements MonthlyReport {
  const _MonthlyReport({required this.month, required this.incomeTotal, required this.expenseTotal, required this.net, required this.previous, required  List<CategoryBreakdown> categories, this.expenseChangePercent}): _categories = categories;
  

/// The first of the month.
@override final  DateTime month;
@override final  int incomeTotal;
@override final  int expenseTotal;
@override final  int net;
@override final  PreviousMonthTotals previous;
/// Expenses by category, largest first.
 final  List<CategoryBreakdown> _categories;
/// Expenses by category, largest first.
@override List<CategoryBreakdown> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Null when the previous month had no expenses.
@override final  double? expenseChangePercent;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeTotal, incomeTotal) || other.incomeTotal == incomeTotal)&&(identical(other.expenseTotal, expenseTotal) || other.expenseTotal == expenseTotal)&&(identical(other.net, net) || other.net == net)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,incomeTotal,expenseTotal,net,previous,const DeepCollectionEquality().hash(_categories),expenseChangePercent);
}

@override
String toString() {
    return 'MonthlyReport(month: $month, incomeTotal: $incomeTotal, expenseTotal: $expenseTotal, net: $net, previous: $previous, categories: $categories, expenseChangePercent: $expenseChangePercent)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int incomeTotal, int expenseTotal, int net, PreviousMonthTotals previous, List<CategoryBreakdown> categories, double? expenseChangePercent
});


@override $PreviousMonthTotalsCopyWith<$Res> get previous;

}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? incomeTotal = null,Object? expenseTotal = null,Object? net = null,Object? previous = null,Object? categories = null,Object? expenseChangePercent = freezed,}) {
  return _then(_MonthlyReport(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int,previous: null == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as PreviousMonthTotals,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdown>,expenseChangePercent: freezed == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviousMonthTotalsCopyWith<$Res> get previous {
  
  return $PreviousMonthTotalsCopyWith<$Res>(_self.previous, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

/// @nodoc
mixin _$PreviousMonthTotals {

 DateTime get month; int get incomeTotal; int get expenseTotal;
/// Create a copy of PreviousMonthTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviousMonthTotalsCopyWith<PreviousMonthTotals> get copyWith => _$PreviousMonthTotalsCopyWithImpl<PreviousMonthTotals>(this as PreviousMonthTotals, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PreviousMonthTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviousMonthTotals&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.incomeTotal, _this.incomeTotal) || other.incomeTotal == _this.incomeTotal)&&(identical(other.expenseTotal, _this.expenseTotal) || other.expenseTotal == _this.expenseTotal));
}


@override
int get hashCode {
  final _this = this as PreviousMonthTotals;
  return Object.hash(runtimeType,_this.month,_this.incomeTotal,_this.expenseTotal);
}

@override
String toString() {
  final _this = this as PreviousMonthTotals;
  return 'PreviousMonthTotals(month: ${_this.month}, incomeTotal: ${_this.incomeTotal}, expenseTotal: ${_this.expenseTotal})';
}


}

/// @nodoc
abstract mixin class $PreviousMonthTotalsCopyWith<$Res>  {
  factory $PreviousMonthTotalsCopyWith(PreviousMonthTotals value, $Res Function(PreviousMonthTotals) _then) = _$PreviousMonthTotalsCopyWithImpl;
@useResult
$Res call({
 DateTime month, int incomeTotal, int expenseTotal
});




}
/// @nodoc
class _$PreviousMonthTotalsCopyWithImpl<$Res>
    implements $PreviousMonthTotalsCopyWith<$Res> {
  _$PreviousMonthTotalsCopyWithImpl(this._self, this._then);

  final PreviousMonthTotals _self;
  final $Res Function(PreviousMonthTotals) _then;

/// Create a copy of PreviousMonthTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? incomeTotal = null,Object? expenseTotal = null,}) {
  return _then(PreviousMonthTotals(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviousMonthTotals].
extension PreviousMonthTotalsPatterns on PreviousMonthTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviousMonthTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviousMonthTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviousMonthTotals value)  $default,){
final _that = this;
switch (_that) {
case _PreviousMonthTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviousMonthTotals value)?  $default,){
final _that = this;
switch (_that) {
case _PreviousMonthTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int incomeTotal,  int expenseTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviousMonthTotals() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int incomeTotal,  int expenseTotal)  $default,) {final _that = this;
switch (_that) {
case _PreviousMonthTotals():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int incomeTotal,  int expenseTotal)?  $default,) {final _that = this;
switch (_that) {
case _PreviousMonthTotals() when $default != null:
return $default(_that.month,_that.incomeTotal,_that.expenseTotal);case _:
  return null;

}
}

}

/// @nodoc


class _PreviousMonthTotals implements PreviousMonthTotals {
  const _PreviousMonthTotals({required this.month, required this.incomeTotal, required this.expenseTotal});
  

@override final  DateTime month;
@override final  int incomeTotal;
@override final  int expenseTotal;

/// Create a copy of PreviousMonthTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviousMonthTotalsCopyWith<_PreviousMonthTotals> get copyWith => __$PreviousMonthTotalsCopyWithImpl<_PreviousMonthTotals>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousMonthTotals&&(identical(other.month, month) || other.month == month)&&(identical(other.incomeTotal, incomeTotal) || other.incomeTotal == incomeTotal)&&(identical(other.expenseTotal, expenseTotal) || other.expenseTotal == expenseTotal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,incomeTotal,expenseTotal);
}

@override
String toString() {
    return 'PreviousMonthTotals(month: $month, incomeTotal: $incomeTotal, expenseTotal: $expenseTotal)';
}


}

/// @nodoc
abstract mixin class _$PreviousMonthTotalsCopyWith<$Res> implements $PreviousMonthTotalsCopyWith<$Res> {
  factory _$PreviousMonthTotalsCopyWith(_PreviousMonthTotals value, $Res Function(_PreviousMonthTotals) _then) = __$PreviousMonthTotalsCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int incomeTotal, int expenseTotal
});




}
/// @nodoc
class __$PreviousMonthTotalsCopyWithImpl<$Res>
    implements _$PreviousMonthTotalsCopyWith<$Res> {
  __$PreviousMonthTotalsCopyWithImpl(this._self, this._then);

  final _PreviousMonthTotals _self;
  final $Res Function(_PreviousMonthTotals) _then;

/// Create a copy of PreviousMonthTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? incomeTotal = null,Object? expenseTotal = null,}) {
  return _then(_PreviousMonthTotals(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,incomeTotal: null == incomeTotal ? _self.incomeTotal : incomeTotal // ignore: cast_nullable_to_non_nullable
as int,expenseTotal: null == expenseTotal ? _self.expenseTotal : expenseTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CategoryBreakdown {

 String get categoryId; String get name; int get amount; double get sharePercent; int get previousAmount; String? get icon; String? get color;/// Null when the category had no expenses the previous month.
 double? get changePercent;
/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith => _$CategoryBreakdownCopyWithImpl<CategoryBreakdown>(this as CategoryBreakdown, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CategoryBreakdown;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdown&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.sharePercent, _this.sharePercent) || other.sharePercent == _this.sharePercent)&&(identical(other.previousAmount, _this.previousAmount) || other.previousAmount == _this.previousAmount)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.changePercent, _this.changePercent) || other.changePercent == _this.changePercent));
}


@override
int get hashCode {
  final _this = this as CategoryBreakdown;
  return Object.hash(runtimeType,_this.categoryId,_this.name,_this.amount,_this.sharePercent,_this.previousAmount,_this.icon,_this.color,_this.changePercent);
}

@override
String toString() {
  final _this = this as CategoryBreakdown;
  return 'CategoryBreakdown(categoryId: ${_this.categoryId}, name: ${_this.name}, amount: ${_this.amount}, sharePercent: ${_this.sharePercent}, previousAmount: ${_this.previousAmount}, icon: ${_this.icon}, color: ${_this.color}, changePercent: ${_this.changePercent})';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownCopyWith<$Res>  {
  factory $CategoryBreakdownCopyWith(CategoryBreakdown value, $Res Function(CategoryBreakdown) _then) = _$CategoryBreakdownCopyWithImpl;
@useResult
$Res call({
 String categoryId, String name, int amount, double sharePercent, int previousAmount, String? icon, String? color, double? changePercent
});




}
/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final CategoryBreakdown _self;
  final $Res Function(CategoryBreakdown) _then;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? amount = null,Object? sharePercent = null,Object? previousAmount = null,Object? icon = freezed,Object? color = freezed,Object? changePercent = freezed,}) {
  return _then(CategoryBreakdown(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sharePercent: null == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double,previousAmount: null == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdown].
extension CategoryBreakdownPatterns on CategoryBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String name,  int amount,  double sharePercent,  int previousAmount,  String? icon,  String? color,  double? changePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
return $default(_that.categoryId,_that.name,_that.amount,_that.sharePercent,_that.previousAmount,_that.icon,_that.color,_that.changePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String name,  int amount,  double sharePercent,  int previousAmount,  String? icon,  String? color,  double? changePercent)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdown():
return $default(_that.categoryId,_that.name,_that.amount,_that.sharePercent,_that.previousAmount,_that.icon,_that.color,_that.changePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String name,  int amount,  double sharePercent,  int previousAmount,  String? icon,  String? color,  double? changePercent)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdown() when $default != null:
return $default(_that.categoryId,_that.name,_that.amount,_that.sharePercent,_that.previousAmount,_that.icon,_that.color,_that.changePercent);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryBreakdown implements CategoryBreakdown {
  const _CategoryBreakdown({required this.categoryId, required this.name, required this.amount, required this.sharePercent, required this.previousAmount, this.icon, this.color, this.changePercent});
  

@override final  String categoryId;
@override final  String name;
@override final  int amount;
@override final  double sharePercent;
@override final  int previousAmount;
@override final  String? icon;
@override final  String? color;
/// Null when the category had no expenses the previous month.
@override final  double? changePercent;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownCopyWith<_CategoryBreakdown> get copyWith => __$CategoryBreakdownCopyWithImpl<_CategoryBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdown&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sharePercent, sharePercent) || other.sharePercent == sharePercent)&&(identical(other.previousAmount, previousAmount) || other.previousAmount == previousAmount)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,name,amount,sharePercent,previousAmount,icon,color,changePercent);
}

@override
String toString() {
    return 'CategoryBreakdown(categoryId: $categoryId, name: $name, amount: $amount, sharePercent: $sharePercent, previousAmount: $previousAmount, icon: $icon, color: $color, changePercent: $changePercent)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownCopyWith<$Res> implements $CategoryBreakdownCopyWith<$Res> {
  factory _$CategoryBreakdownCopyWith(_CategoryBreakdown value, $Res Function(_CategoryBreakdown) _then) = __$CategoryBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String name, int amount, double sharePercent, int previousAmount, String? icon, String? color, double? changePercent
});




}
/// @nodoc
class __$CategoryBreakdownCopyWithImpl<$Res>
    implements _$CategoryBreakdownCopyWith<$Res> {
  __$CategoryBreakdownCopyWithImpl(this._self, this._then);

  final _CategoryBreakdown _self;
  final $Res Function(_CategoryBreakdown) _then;

/// Create a copy of CategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? amount = null,Object? sharePercent = null,Object? previousAmount = null,Object? icon = freezed,Object? color = freezed,Object? changePercent = freezed,}) {
  return _then(_CategoryBreakdown(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sharePercent: null == sharePercent ? _self.sharePercent : sharePercent // ignore: cast_nullable_to_non_nullable
as double,previousAmount: null == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,changePercent: freezed == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
