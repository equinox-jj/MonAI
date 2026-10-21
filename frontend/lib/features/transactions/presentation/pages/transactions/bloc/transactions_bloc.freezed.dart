// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent()';
}


}

/// @nodoc
class $TransactionsEventCopyWith<$Res>  {
$TransactionsEventCopyWith(TransactionsEvent _, $Res Function(TransactionsEvent) __);
}


/// Adds pattern-matching-related methods to [TransactionsEvent].
extension TransactionsEventPatterns on TransactionsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Refreshed value)?  refreshed,TResult Function( _PreviousMonthPressed value)?  previousMonthPressed,TResult Function( _NextMonthPressed value)?  nextMonthPressed,TResult Function( _MonthPicked value)?  monthPicked,TResult Function( _MonthPickerYearShown value)?  monthPickerYearShown,TResult Function( _WalletFilterPicked value)?  walletFilterPicked,TResult Function( _CategoryFilterPicked value)?  categoryFilterPicked,TResult Function( _TypeFilterPicked value)?  typeFilterPicked,TResult Function( _FiltersCleared value)?  filtersCleared,TResult Function( _LoadMoreRequested value)?  loadMoreRequested,TResult Function( _Selected value)?  selected,TResult Function( _DeleteRequested value)?  deleteRequested,TResult Function( _TransactionsChanged value)?  transactionsChanged,TResult Function( _DailyNetsChanged value)?  dailyNetsChanged,TResult Function( _ReportChanged value)?  reportChanged,TResult Function( _LookupsChanged value)?  lookupsChanged,TResult Function( _ExpenseTotalsChanged value)?  expenseTotalsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _PreviousMonthPressed() when previousMonthPressed != null:
return previousMonthPressed(_that);case _NextMonthPressed() when nextMonthPressed != null:
return nextMonthPressed(_that);case _MonthPicked() when monthPicked != null:
return monthPicked(_that);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that);case _FiltersCleared() when filtersCleared != null:
return filtersCleared(_that);case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _Selected() when selected != null:
return selected(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that);case _DailyNetsChanged() when dailyNetsChanged != null:
return dailyNetsChanged(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that);case _ExpenseTotalsChanged() when expenseTotalsChanged != null:
return expenseTotalsChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Refreshed value)  refreshed,required TResult Function( _PreviousMonthPressed value)  previousMonthPressed,required TResult Function( _NextMonthPressed value)  nextMonthPressed,required TResult Function( _MonthPicked value)  monthPicked,required TResult Function( _MonthPickerYearShown value)  monthPickerYearShown,required TResult Function( _WalletFilterPicked value)  walletFilterPicked,required TResult Function( _CategoryFilterPicked value)  categoryFilterPicked,required TResult Function( _TypeFilterPicked value)  typeFilterPicked,required TResult Function( _FiltersCleared value)  filtersCleared,required TResult Function( _LoadMoreRequested value)  loadMoreRequested,required TResult Function( _Selected value)  selected,required TResult Function( _DeleteRequested value)  deleteRequested,required TResult Function( _TransactionsChanged value)  transactionsChanged,required TResult Function( _DailyNetsChanged value)  dailyNetsChanged,required TResult Function( _ReportChanged value)  reportChanged,required TResult Function( _LookupsChanged value)  lookupsChanged,required TResult Function( _ExpenseTotalsChanged value)  expenseTotalsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Refreshed():
return refreshed(_that);case _PreviousMonthPressed():
return previousMonthPressed(_that);case _NextMonthPressed():
return nextMonthPressed(_that);case _MonthPicked():
return monthPicked(_that);case _MonthPickerYearShown():
return monthPickerYearShown(_that);case _WalletFilterPicked():
return walletFilterPicked(_that);case _CategoryFilterPicked():
return categoryFilterPicked(_that);case _TypeFilterPicked():
return typeFilterPicked(_that);case _FiltersCleared():
return filtersCleared(_that);case _LoadMoreRequested():
return loadMoreRequested(_that);case _Selected():
return selected(_that);case _DeleteRequested():
return deleteRequested(_that);case _TransactionsChanged():
return transactionsChanged(_that);case _DailyNetsChanged():
return dailyNetsChanged(_that);case _ReportChanged():
return reportChanged(_that);case _LookupsChanged():
return lookupsChanged(_that);case _ExpenseTotalsChanged():
return expenseTotalsChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Refreshed value)?  refreshed,TResult? Function( _PreviousMonthPressed value)?  previousMonthPressed,TResult? Function( _NextMonthPressed value)?  nextMonthPressed,TResult? Function( _MonthPicked value)?  monthPicked,TResult? Function( _MonthPickerYearShown value)?  monthPickerYearShown,TResult? Function( _WalletFilterPicked value)?  walletFilterPicked,TResult? Function( _CategoryFilterPicked value)?  categoryFilterPicked,TResult? Function( _TypeFilterPicked value)?  typeFilterPicked,TResult? Function( _FiltersCleared value)?  filtersCleared,TResult? Function( _LoadMoreRequested value)?  loadMoreRequested,TResult? Function( _Selected value)?  selected,TResult? Function( _DeleteRequested value)?  deleteRequested,TResult? Function( _TransactionsChanged value)?  transactionsChanged,TResult? Function( _DailyNetsChanged value)?  dailyNetsChanged,TResult? Function( _ReportChanged value)?  reportChanged,TResult? Function( _LookupsChanged value)?  lookupsChanged,TResult? Function( _ExpenseTotalsChanged value)?  expenseTotalsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refreshed() when refreshed != null:
return refreshed(_that);case _PreviousMonthPressed() when previousMonthPressed != null:
return previousMonthPressed(_that);case _NextMonthPressed() when nextMonthPressed != null:
return nextMonthPressed(_that);case _MonthPicked() when monthPicked != null:
return monthPicked(_that);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that);case _FiltersCleared() when filtersCleared != null:
return filtersCleared(_that);case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _Selected() when selected != null:
return selected(_that);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that);case _DailyNetsChanged() when dailyNetsChanged != null:
return dailyNetsChanged(_that);case _ReportChanged() when reportChanged != null:
return reportChanged(_that);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that);case _ExpenseTotalsChanged() when expenseTotalsChanged != null:
return expenseTotalsChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshed,TResult Function()?  previousMonthPressed,TResult Function()?  nextMonthPressed,TResult Function( DateTime month)?  monthPicked,TResult Function( int year)?  monthPickerYearShown,TResult Function( String? walletId)?  walletFilterPicked,TResult Function( String? categoryId)?  categoryFilterPicked,TResult Function( TransactionType? type)?  typeFilterPicked,TResult Function()?  filtersCleared,TResult Function()?  loadMoreRequested,TResult Function( String? id)?  selected,TResult Function( String id)?  deleteRequested,TResult Function( List<Transaction> transactions)?  transactionsChanged,TResult Function( Map<DateTime, int> nets)?  dailyNetsChanged,TResult Function( MonthlyReport? report)?  reportChanged,TResult Function( TransactionLookups lookups)?  lookupsChanged,TResult Function( Map<DateTime, int> totals)?  expenseTotalsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _PreviousMonthPressed() when previousMonthPressed != null:
return previousMonthPressed();case _NextMonthPressed() when nextMonthPressed != null:
return nextMonthPressed();case _MonthPicked() when monthPicked != null:
return monthPicked(_that.month);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that.year);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that.type);case _FiltersCleared() when filtersCleared != null:
return filtersCleared();case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _Selected() when selected != null:
return selected(_that.id);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.id);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that.transactions);case _DailyNetsChanged() when dailyNetsChanged != null:
return dailyNetsChanged(_that.nets);case _ReportChanged() when reportChanged != null:
return reportChanged(_that.report);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _ExpenseTotalsChanged() when expenseTotalsChanged != null:
return expenseTotalsChanged(_that.totals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshed,required TResult Function()  previousMonthPressed,required TResult Function()  nextMonthPressed,required TResult Function( DateTime month)  monthPicked,required TResult Function( int year)  monthPickerYearShown,required TResult Function( String? walletId)  walletFilterPicked,required TResult Function( String? categoryId)  categoryFilterPicked,required TResult Function( TransactionType? type)  typeFilterPicked,required TResult Function()  filtersCleared,required TResult Function()  loadMoreRequested,required TResult Function( String? id)  selected,required TResult Function( String id)  deleteRequested,required TResult Function( List<Transaction> transactions)  transactionsChanged,required TResult Function( Map<DateTime, int> nets)  dailyNetsChanged,required TResult Function( MonthlyReport? report)  reportChanged,required TResult Function( TransactionLookups lookups)  lookupsChanged,required TResult Function( Map<DateTime, int> totals)  expenseTotalsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Refreshed():
return refreshed();case _PreviousMonthPressed():
return previousMonthPressed();case _NextMonthPressed():
return nextMonthPressed();case _MonthPicked():
return monthPicked(_that.month);case _MonthPickerYearShown():
return monthPickerYearShown(_that.year);case _WalletFilterPicked():
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked():
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked():
return typeFilterPicked(_that.type);case _FiltersCleared():
return filtersCleared();case _LoadMoreRequested():
return loadMoreRequested();case _Selected():
return selected(_that.id);case _DeleteRequested():
return deleteRequested(_that.id);case _TransactionsChanged():
return transactionsChanged(_that.transactions);case _DailyNetsChanged():
return dailyNetsChanged(_that.nets);case _ReportChanged():
return reportChanged(_that.report);case _LookupsChanged():
return lookupsChanged(_that.lookups);case _ExpenseTotalsChanged():
return expenseTotalsChanged(_that.totals);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshed,TResult? Function()?  previousMonthPressed,TResult? Function()?  nextMonthPressed,TResult? Function( DateTime month)?  monthPicked,TResult? Function( int year)?  monthPickerYearShown,TResult? Function( String? walletId)?  walletFilterPicked,TResult? Function( String? categoryId)?  categoryFilterPicked,TResult? Function( TransactionType? type)?  typeFilterPicked,TResult? Function()?  filtersCleared,TResult? Function()?  loadMoreRequested,TResult? Function( String? id)?  selected,TResult? Function( String id)?  deleteRequested,TResult? Function( List<Transaction> transactions)?  transactionsChanged,TResult? Function( Map<DateTime, int> nets)?  dailyNetsChanged,TResult? Function( MonthlyReport? report)?  reportChanged,TResult? Function( TransactionLookups lookups)?  lookupsChanged,TResult? Function( Map<DateTime, int> totals)?  expenseTotalsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refreshed() when refreshed != null:
return refreshed();case _PreviousMonthPressed() when previousMonthPressed != null:
return previousMonthPressed();case _NextMonthPressed() when nextMonthPressed != null:
return nextMonthPressed();case _MonthPicked() when monthPicked != null:
return monthPicked(_that.month);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that.year);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that.type);case _FiltersCleared() when filtersCleared != null:
return filtersCleared();case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _Selected() when selected != null:
return selected(_that.id);case _DeleteRequested() when deleteRequested != null:
return deleteRequested(_that.id);case _TransactionsChanged() when transactionsChanged != null:
return transactionsChanged(_that.transactions);case _DailyNetsChanged() when dailyNetsChanged != null:
return dailyNetsChanged(_that.nets);case _ReportChanged() when reportChanged != null:
return reportChanged(_that.report);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _ExpenseTotalsChanged() when expenseTotalsChanged != null:
return expenseTotalsChanged(_that.totals);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TransactionsEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.started()';
}


}




/// @nodoc


class _Refreshed implements TransactionsEvent {
  const _Refreshed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.refreshed()';
}


}




/// @nodoc


class _PreviousMonthPressed implements TransactionsEvent {
  const _PreviousMonthPressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousMonthPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.previousMonthPressed()';
}


}




/// @nodoc


class _NextMonthPressed implements TransactionsEvent {
  const _NextMonthPressed();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextMonthPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.nextMonthPressed()';
}


}




/// @nodoc


class _MonthPicked implements TransactionsEvent {
  const _MonthPicked(this.month);
  

 final  DateTime month;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthPickedCopyWith<_MonthPicked> get copyWith => __$MonthPickedCopyWithImpl<_MonthPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthPicked&&(identical(other.month, month) || other.month == month));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month);
}

@override
String toString() {
    return 'TransactionsEvent.monthPicked(month: $month)';
}


}

/// @nodoc
abstract mixin class _$MonthPickedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$MonthPickedCopyWith(_MonthPicked value, $Res Function(_MonthPicked) _then) = __$MonthPickedCopyWithImpl;
@useResult
$Res call({
 DateTime month
});




}
/// @nodoc
class __$MonthPickedCopyWithImpl<$Res>
    implements _$MonthPickedCopyWith<$Res> {
  __$MonthPickedCopyWithImpl(this._self, this._then);

  final _MonthPicked _self;
  final $Res Function(_MonthPicked) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? month = null,}) {
  return _then(_MonthPicked(
null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _MonthPickerYearShown implements TransactionsEvent {
  const _MonthPickerYearShown(this.year);
  

 final  int year;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthPickerYearShownCopyWith<_MonthPickerYearShown> get copyWith => __$MonthPickerYearShownCopyWithImpl<_MonthPickerYearShown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthPickerYearShown&&(identical(other.year, year) || other.year == year));
}


@override
int get hashCode {
    return Object.hash(runtimeType,year);
}

@override
String toString() {
    return 'TransactionsEvent.monthPickerYearShown(year: $year)';
}


}

/// @nodoc
abstract mixin class _$MonthPickerYearShownCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$MonthPickerYearShownCopyWith(_MonthPickerYearShown value, $Res Function(_MonthPickerYearShown) _then) = __$MonthPickerYearShownCopyWithImpl;
@useResult
$Res call({
 int year
});




}
/// @nodoc
class __$MonthPickerYearShownCopyWithImpl<$Res>
    implements _$MonthPickerYearShownCopyWith<$Res> {
  __$MonthPickerYearShownCopyWithImpl(this._self, this._then);

  final _MonthPickerYearShown _self;
  final $Res Function(_MonthPickerYearShown) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? year = null,}) {
  return _then(_MonthPickerYearShown(
null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _WalletFilterPicked implements TransactionsEvent {
  const _WalletFilterPicked(this.walletId);
  

 final  String? walletId;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletFilterPickedCopyWith<_WalletFilterPicked> get copyWith => __$WalletFilterPickedCopyWithImpl<_WalletFilterPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletFilterPicked&&(identical(other.walletId, walletId) || other.walletId == walletId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,walletId);
}

@override
String toString() {
    return 'TransactionsEvent.walletFilterPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$WalletFilterPickedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$WalletFilterPickedCopyWith(_WalletFilterPicked value, $Res Function(_WalletFilterPicked) _then) = __$WalletFilterPickedCopyWithImpl;
@useResult
$Res call({
 String? walletId
});




}
/// @nodoc
class __$WalletFilterPickedCopyWithImpl<$Res>
    implements _$WalletFilterPickedCopyWith<$Res> {
  __$WalletFilterPickedCopyWithImpl(this._self, this._then);

  final _WalletFilterPicked _self;
  final $Res Function(_WalletFilterPicked) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = freezed,}) {
  return _then(_WalletFilterPicked(
freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CategoryFilterPicked implements TransactionsEvent {
  const _CategoryFilterPicked(this.categoryId);
  

 final  String? categoryId;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryFilterPickedCopyWith<_CategoryFilterPicked> get copyWith => __$CategoryFilterPickedCopyWithImpl<_CategoryFilterPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryFilterPicked&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,categoryId);
}

@override
String toString() {
    return 'TransactionsEvent.categoryFilterPicked(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryFilterPickedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$CategoryFilterPickedCopyWith(_CategoryFilterPicked value, $Res Function(_CategoryFilterPicked) _then) = __$CategoryFilterPickedCopyWithImpl;
@useResult
$Res call({
 String? categoryId
});




}
/// @nodoc
class __$CategoryFilterPickedCopyWithImpl<$Res>
    implements _$CategoryFilterPickedCopyWith<$Res> {
  __$CategoryFilterPickedCopyWithImpl(this._self, this._then);

  final _CategoryFilterPicked _self;
  final $Res Function(_CategoryFilterPicked) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(_CategoryFilterPicked(
freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TypeFilterPicked implements TransactionsEvent {
  const _TypeFilterPicked(this.type);
  

 final  TransactionType? type;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeFilterPickedCopyWith<_TypeFilterPicked> get copyWith => __$TypeFilterPickedCopyWithImpl<_TypeFilterPicked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeFilterPicked&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type);
}

@override
String toString() {
    return 'TransactionsEvent.typeFilterPicked(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypeFilterPickedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$TypeFilterPickedCopyWith(_TypeFilterPicked value, $Res Function(_TypeFilterPicked) _then) = __$TypeFilterPickedCopyWithImpl;
@useResult
$Res call({
 TransactionType? type
});




}
/// @nodoc
class __$TypeFilterPickedCopyWithImpl<$Res>
    implements _$TypeFilterPickedCopyWith<$Res> {
  __$TypeFilterPickedCopyWithImpl(this._self, this._then);

  final _TypeFilterPicked _self;
  final $Res Function(_TypeFilterPicked) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = freezed,}) {
  return _then(_TypeFilterPicked(
freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,
  ));
}


}

/// @nodoc


class _FiltersCleared implements TransactionsEvent {
  const _FiltersCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiltersCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.filtersCleared()';
}


}




/// @nodoc


class _LoadMoreRequested implements TransactionsEvent {
  const _LoadMoreRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadMoreRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TransactionsEvent.loadMoreRequested()';
}


}




/// @nodoc


class _Selected implements TransactionsEvent {
  const _Selected(this.id);
  

 final  String? id;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedCopyWith<_Selected> get copyWith => __$SelectedCopyWithImpl<_Selected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Selected&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TransactionsEvent.selected(id: $id)';
}


}

/// @nodoc
abstract mixin class _$SelectedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$SelectedCopyWith(_Selected value, $Res Function(_Selected) _then) = __$SelectedCopyWithImpl;
@useResult
$Res call({
 String? id
});




}
/// @nodoc
class __$SelectedCopyWithImpl<$Res>
    implements _$SelectedCopyWith<$Res> {
  __$SelectedCopyWithImpl(this._self, this._then);

  final _Selected _self;
  final $Res Function(_Selected) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = freezed,}) {
  return _then(_Selected(
freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _DeleteRequested implements TransactionsEvent {
  const _DeleteRequested(this.id);
  

 final  String id;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteRequestedCopyWith<_DeleteRequested> get copyWith => __$DeleteRequestedCopyWithImpl<_DeleteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRequested&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'TransactionsEvent.deleteRequested(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeleteRequestedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$DeleteRequestedCopyWith(_DeleteRequested value, $Res Function(_DeleteRequested) _then) = __$DeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$DeleteRequestedCopyWithImpl<$Res>
    implements _$DeleteRequestedCopyWith<$Res> {
  __$DeleteRequestedCopyWithImpl(this._self, this._then);

  final _DeleteRequested _self;
  final $Res Function(_DeleteRequested) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeleteRequested(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _TransactionsChanged implements TransactionsEvent {
  const _TransactionsChanged( List<Transaction> transactions): _transactions = transactions;
  

 final  List<Transaction> _transactions;
 List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsChangedCopyWith<_TransactionsChanged> get copyWith => __$TransactionsChangedCopyWithImpl<_TransactionsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsChanged&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'TransactionsEvent.transactionsChanged(transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$TransactionsChangedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$TransactionsChangedCopyWith(_TransactionsChanged value, $Res Function(_TransactionsChanged) _then) = __$TransactionsChangedCopyWithImpl;
@useResult
$Res call({
 List<Transaction> transactions
});




}
/// @nodoc
class __$TransactionsChangedCopyWithImpl<$Res>
    implements _$TransactionsChangedCopyWith<$Res> {
  __$TransactionsChangedCopyWithImpl(this._self, this._then);

  final _TransactionsChanged _self;
  final $Res Function(_TransactionsChanged) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,}) {
  return _then(_TransactionsChanged(
null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}


}

/// @nodoc


class _DailyNetsChanged implements TransactionsEvent {
  const _DailyNetsChanged( Map<DateTime, int> nets): _nets = nets;
  

 final  Map<DateTime, int> _nets;
 Map<DateTime, int> get nets {
  if (_nets is EqualUnmodifiableMapView) return _nets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nets);
}


/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyNetsChangedCopyWith<_DailyNetsChanged> get copyWith => __$DailyNetsChangedCopyWithImpl<_DailyNetsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyNetsChanged&&const DeepCollectionEquality().equals(other.nets, _nets));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_nets));
}

@override
String toString() {
    return 'TransactionsEvent.dailyNetsChanged(nets: $nets)';
}


}

/// @nodoc
abstract mixin class _$DailyNetsChangedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$DailyNetsChangedCopyWith(_DailyNetsChanged value, $Res Function(_DailyNetsChanged) _then) = __$DailyNetsChangedCopyWithImpl;
@useResult
$Res call({
 Map<DateTime, int> nets
});




}
/// @nodoc
class __$DailyNetsChangedCopyWithImpl<$Res>
    implements _$DailyNetsChangedCopyWith<$Res> {
  __$DailyNetsChangedCopyWithImpl(this._self, this._then);

  final _DailyNetsChanged _self;
  final $Res Function(_DailyNetsChanged) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nets = null,}) {
  return _then(_DailyNetsChanged(
null == nets ? _self._nets : nets // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,
  ));
}


}

/// @nodoc


class _ReportChanged implements TransactionsEvent {
  const _ReportChanged(this.report);
  

 final  MonthlyReport? report;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportChangedCopyWith<_ReportChanged> get copyWith => __$ReportChangedCopyWithImpl<_ReportChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportChanged&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,report);
}

@override
String toString() {
    return 'TransactionsEvent.reportChanged(report: $report)';
}


}

/// @nodoc
abstract mixin class _$ReportChangedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$ReportChangedCopyWith(_ReportChanged value, $Res Function(_ReportChanged) _then) = __$ReportChangedCopyWithImpl;
@useResult
$Res call({
 MonthlyReport? report
});


$MonthlyReportCopyWith<$Res>? get report;

}
/// @nodoc
class __$ReportChangedCopyWithImpl<$Res>
    implements _$ReportChangedCopyWith<$Res> {
  __$ReportChangedCopyWithImpl(this._self, this._then);

  final _ReportChanged _self;
  final $Res Function(_ReportChanged) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = freezed,}) {
  return _then(_ReportChanged(
freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,
  ));
}

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class _LookupsChanged implements TransactionsEvent {
  const _LookupsChanged(this.lookups);
  

 final  TransactionLookups lookups;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LookupsChangedCopyWith<_LookupsChanged> get copyWith => __$LookupsChangedCopyWithImpl<_LookupsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LookupsChanged&&(identical(other.lookups, lookups) || other.lookups == lookups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lookups);
}

@override
String toString() {
    return 'TransactionsEvent.lookupsChanged(lookups: $lookups)';
}


}

/// @nodoc
abstract mixin class _$LookupsChangedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$LookupsChangedCopyWith(_LookupsChanged value, $Res Function(_LookupsChanged) _then) = __$LookupsChangedCopyWithImpl;
@useResult
$Res call({
 TransactionLookups lookups
});


$TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class __$LookupsChangedCopyWithImpl<$Res>
    implements _$LookupsChangedCopyWith<$Res> {
  __$LookupsChangedCopyWithImpl(this._self, this._then);

  final _LookupsChanged _self;
  final $Res Function(_LookupsChanged) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lookups = null,}) {
  return _then(_LookupsChanged(
null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,
  ));
}

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}

/// @nodoc


class _ExpenseTotalsChanged implements TransactionsEvent {
  const _ExpenseTotalsChanged( Map<DateTime, int> totals): _totals = totals;
  

 final  Map<DateTime, int> _totals;
 Map<DateTime, int> get totals {
  if (_totals is EqualUnmodifiableMapView) return _totals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_totals);
}


/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseTotalsChangedCopyWith<_ExpenseTotalsChanged> get copyWith => __$ExpenseTotalsChangedCopyWithImpl<_ExpenseTotalsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseTotalsChanged&&const DeepCollectionEquality().equals(other.totals, _totals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_totals));
}

@override
String toString() {
    return 'TransactionsEvent.expenseTotalsChanged(totals: $totals)';
}


}

/// @nodoc
abstract mixin class _$ExpenseTotalsChangedCopyWith<$Res> implements $TransactionsEventCopyWith<$Res> {
  factory _$ExpenseTotalsChangedCopyWith(_ExpenseTotalsChanged value, $Res Function(_ExpenseTotalsChanged) _then) = __$ExpenseTotalsChangedCopyWithImpl;
@useResult
$Res call({
 Map<DateTime, int> totals
});




}
/// @nodoc
class __$ExpenseTotalsChangedCopyWithImpl<$Res>
    implements _$ExpenseTotalsChangedCopyWith<$Res> {
  __$ExpenseTotalsChangedCopyWithImpl(this._self, this._then);

  final _ExpenseTotalsChanged _self;
  final $Res Function(_ExpenseTotalsChanged) _then;

/// Create a copy of TransactionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totals = null,}) {
  return _then(_ExpenseTotalsChanged(
null == totals ? _self._totals : totals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,
  ));
}


}

/// @nodoc
mixin _$TransactionsState {

 DateTime get month; DateTime get today; UiStatus get status; TransactionFilter get filter; List<Transaction> get transactions;/// Hidden until the cache drops them.
 Set<String> get deletingIds; Map<DateTime, int> get dailyNets; int get limit; bool get hasMore; bool get isLoadingMore; bool get isRefreshing;/// The first page was fetched, so no rows means none match.
 bool get listLoaded; TransactionLookups get lookups; MonthlyReport? get report; Map<DateTime, int> get monthPickerTotals; String? get selectedId; TransactionFailure? get loadFailure; TransactionFailure? get actionFailure;
/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsStateCopyWith<TransactionsState> get copyWith => _$TransactionsStateCopyWithImpl<TransactionsState>(this as TransactionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsState&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.deletingIds, _this.deletingIds)&&const DeepCollectionEquality().equals(other.dailyNets, _this.dailyNets)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.listLoaded, _this.listLoaded) || other.listLoaded == _this.listLoaded)&&(identical(other.lookups, _this.lookups) || other.lookups == _this.lookups)&&(identical(other.report, _this.report) || other.report == _this.report)&&const DeepCollectionEquality().equals(other.monthPickerTotals, _this.monthPickerTotals)&&(identical(other.selectedId, _this.selectedId) || other.selectedId == _this.selectedId)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure));
}


@override
int get hashCode {
  final _this = this as TransactionsState;
  return Object.hash(runtimeType,_this.month,_this.today,_this.status,_this.filter,const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.deletingIds),const DeepCollectionEquality().hash(_this.dailyNets),_this.limit,_this.hasMore,_this.isLoadingMore,_this.isRefreshing,_this.listLoaded,_this.lookups,_this.report,const DeepCollectionEquality().hash(_this.monthPickerTotals),_this.selectedId,_this.loadFailure,_this.actionFailure);
}

@override
String toString() {
  final _this = this as TransactionsState;
  return 'TransactionsState(month: ${_this.month}, today: ${_this.today}, status: ${_this.status}, filter: ${_this.filter}, transactions: ${_this.transactions}, deletingIds: ${_this.deletingIds}, dailyNets: ${_this.dailyNets}, limit: ${_this.limit}, hasMore: ${_this.hasMore}, isLoadingMore: ${_this.isLoadingMore}, isRefreshing: ${_this.isRefreshing}, listLoaded: ${_this.listLoaded}, lookups: ${_this.lookups}, report: ${_this.report}, monthPickerTotals: ${_this.monthPickerTotals}, selectedId: ${_this.selectedId}, loadFailure: ${_this.loadFailure}, actionFailure: ${_this.actionFailure})';
}


}

/// @nodoc
abstract mixin class $TransactionsStateCopyWith<$Res>  {
  factory $TransactionsStateCopyWith(TransactionsState value, $Res Function(TransactionsState) _then) = _$TransactionsStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, DateTime today, UiStatus status, TransactionFilter filter, List<Transaction> transactions, Set<String> deletingIds, Map<DateTime, int> dailyNets, int limit, bool hasMore, bool isLoadingMore, bool isRefreshing, bool listLoaded, TransactionLookups lookups, MonthlyReport? report, Map<DateTime, int> monthPickerTotals, String? selectedId, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


$TransactionFilterCopyWith<$Res> get filter;$TransactionLookupsCopyWith<$Res> get lookups;$MonthlyReportCopyWith<$Res>? get report;

}
/// @nodoc
class _$TransactionsStateCopyWithImpl<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  _$TransactionsStateCopyWithImpl(this._self, this._then);

  final TransactionsState _self;
  final $Res Function(TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? today = null,Object? status = null,Object? filter = null,Object? transactions = null,Object? deletingIds = null,Object? dailyNets = null,Object? limit = null,Object? hasMore = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? listLoaded = null,Object? lookups = null,Object? report = freezed,Object? monthPickerTotals = null,Object? selectedId = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(TransactionsState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionFilter,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,deletingIds: null == deletingIds ? _self.deletingIds : deletingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,dailyNets: null == dailyNets ? _self.dailyNets : dailyNets // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,listLoaded: null == listLoaded ? _self.listLoaded : listLoaded // ignore: cast_nullable_to_non_nullable
as bool,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,monthPickerTotals: null == monthPickerTotals ? _self.monthPickerTotals : monthPickerTotals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}
/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFilterCopyWith<$Res> get filter {
  
  return $TransactionFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionsState].
extension TransactionsStatePatterns on TransactionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  DateTime today,  UiStatus status,  TransactionFilter filter,  List<Transaction> transactions,  Set<String> deletingIds,  Map<DateTime, int> dailyNets,  int limit,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  bool listLoaded,  TransactionLookups lookups,  MonthlyReport? report,  Map<DateTime, int> monthPickerTotals,  String? selectedId,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.month,_that.today,_that.status,_that.filter,_that.transactions,_that.deletingIds,_that.dailyNets,_that.limit,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.listLoaded,_that.lookups,_that.report,_that.monthPickerTotals,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  DateTime today,  UiStatus status,  TransactionFilter filter,  List<Transaction> transactions,  Set<String> deletingIds,  Map<DateTime, int> dailyNets,  int limit,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  bool listLoaded,  TransactionLookups lookups,  MonthlyReport? report,  Map<DateTime, int> monthPickerTotals,  String? selectedId,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that.month,_that.today,_that.status,_that.filter,_that.transactions,_that.deletingIds,_that.dailyNets,_that.limit,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.listLoaded,_that.lookups,_that.report,_that.monthPickerTotals,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  DateTime today,  UiStatus status,  TransactionFilter filter,  List<Transaction> transactions,  Set<String> deletingIds,  Map<DateTime, int> dailyNets,  int limit,  bool hasMore,  bool isLoadingMore,  bool isRefreshing,  bool listLoaded,  TransactionLookups lookups,  MonthlyReport? report,  Map<DateTime, int> monthPickerTotals,  String? selectedId,  TransactionFailure? loadFailure,  TransactionFailure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.month,_that.today,_that.status,_that.filter,_that.transactions,_that.deletingIds,_that.dailyNets,_that.limit,_that.hasMore,_that.isLoadingMore,_that.isRefreshing,_that.listLoaded,_that.lookups,_that.report,_that.monthPickerTotals,_that.selectedId,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsState implements TransactionsState {
  const _TransactionsState({required this.month, required this.today, this.status = UiStatus.initial, this.filter = const TransactionFilter(),  List<Transaction> transactions = const [],  Set<String> deletingIds = const {},  Map<DateTime, int> dailyNets = const {}, this.limit = TransactionRepository.pageSize, this.hasMore = false, this.isLoadingMore = false, this.isRefreshing = false, this.listLoaded = false, this.lookups = const TransactionLookups(), this.report,  Map<DateTime, int> monthPickerTotals = const {}, this.selectedId, this.loadFailure, this.actionFailure}): _transactions = transactions,_deletingIds = deletingIds,_dailyNets = dailyNets,_monthPickerTotals = monthPickerTotals;
  

@override final  DateTime month;
@override final  DateTime today;
@override@JsonKey() final  UiStatus status;
@override@JsonKey() final  TransactionFilter filter;
 final  List<Transaction> _transactions;
@override@JsonKey() List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

/// Hidden until the cache drops them.
 final  Set<String> _deletingIds;
/// Hidden until the cache drops them.
@override@JsonKey() Set<String> get deletingIds {
  if (_deletingIds is EqualUnmodifiableSetView) return _deletingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_deletingIds);
}

 final  Map<DateTime, int> _dailyNets;
@override@JsonKey() Map<DateTime, int> get dailyNets {
  if (_dailyNets is EqualUnmodifiableMapView) return _dailyNets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dailyNets);
}

@override@JsonKey() final  int limit;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool isRefreshing;
/// The first page was fetched, so no rows means none match.
@override@JsonKey() final  bool listLoaded;
@override@JsonKey() final  TransactionLookups lookups;
@override final  MonthlyReport? report;
 final  Map<DateTime, int> _monthPickerTotals;
@override@JsonKey() Map<DateTime, int> get monthPickerTotals {
  if (_monthPickerTotals is EqualUnmodifiableMapView) return _monthPickerTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monthPickerTotals);
}

@override final  String? selectedId;
@override final  TransactionFailure? loadFailure;
@override final  TransactionFailure? actionFailure;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsStateCopyWith<_TransactionsState> get copyWith => __$TransactionsStateCopyWithImpl<_TransactionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsState&&(identical(other.month, month) || other.month == month)&&(identical(other.today, today) || other.today == today)&&(identical(other.status, status) || other.status == status)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.deletingIds, _deletingIds)&&const DeepCollectionEquality().equals(other.dailyNets, _dailyNets)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.listLoaded, listLoaded) || other.listLoaded == listLoaded)&&(identical(other.lookups, lookups) || other.lookups == lookups)&&(identical(other.report, report) || other.report == report)&&const DeepCollectionEquality().equals(other.monthPickerTotals, _monthPickerTotals)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,today,status,filter,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_deletingIds),const DeepCollectionEquality().hash(_dailyNets),limit,hasMore,isLoadingMore,isRefreshing,listLoaded,lookups,report,const DeepCollectionEquality().hash(_monthPickerTotals),selectedId,loadFailure,actionFailure);
}

@override
String toString() {
    return 'TransactionsState(month: $month, today: $today, status: $status, filter: $filter, transactions: $transactions, deletingIds: $deletingIds, dailyNets: $dailyNets, limit: $limit, hasMore: $hasMore, isLoadingMore: $isLoadingMore, isRefreshing: $isRefreshing, listLoaded: $listLoaded, lookups: $lookups, report: $report, monthPickerTotals: $monthPickerTotals, selectedId: $selectedId, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$TransactionsStateCopyWith<$Res> implements $TransactionsStateCopyWith<$Res> {
  factory _$TransactionsStateCopyWith(_TransactionsState value, $Res Function(_TransactionsState) _then) = __$TransactionsStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, DateTime today, UiStatus status, TransactionFilter filter, List<Transaction> transactions, Set<String> deletingIds, Map<DateTime, int> dailyNets, int limit, bool hasMore, bool isLoadingMore, bool isRefreshing, bool listLoaded, TransactionLookups lookups, MonthlyReport? report, Map<DateTime, int> monthPickerTotals, String? selectedId, TransactionFailure? loadFailure, TransactionFailure? actionFailure
});


@override $TransactionFilterCopyWith<$Res> get filter;@override $TransactionLookupsCopyWith<$Res> get lookups;@override $MonthlyReportCopyWith<$Res>? get report;

}
/// @nodoc
class __$TransactionsStateCopyWithImpl<$Res>
    implements _$TransactionsStateCopyWith<$Res> {
  __$TransactionsStateCopyWithImpl(this._self, this._then);

  final _TransactionsState _self;
  final $Res Function(_TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? today = null,Object? status = null,Object? filter = null,Object? transactions = null,Object? deletingIds = null,Object? dailyNets = null,Object? limit = null,Object? hasMore = null,Object? isLoadingMore = null,Object? isRefreshing = null,Object? listLoaded = null,Object? lookups = null,Object? report = freezed,Object? monthPickerTotals = null,Object? selectedId = freezed,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_TransactionsState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionFilter,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,deletingIds: null == deletingIds ? _self._deletingIds : deletingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,dailyNets: null == dailyNets ? _self._dailyNets : dailyNets // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,listLoaded: null == listLoaded ? _self.listLoaded : listLoaded // ignore: cast_nullable_to_non_nullable
as bool,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as MonthlyReport?,monthPickerTotals: null == monthPickerTotals ? _self._monthPickerTotals : monthPickerTotals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFilterCopyWith<$Res> get filter {
  
  return $TransactionFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $MonthlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

// dart format on
