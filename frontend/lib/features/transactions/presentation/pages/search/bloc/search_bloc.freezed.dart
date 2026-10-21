// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent()';
}


}

/// @nodoc
class $SearchEventCopyWith<$Res>  {
$SearchEventCopyWith(SearchEvent _, $Res Function(SearchEvent) __);
}


/// Adds pattern-matching-related methods to [SearchEvent].
extension SearchEventPatterns on SearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _QueryChanged value)?  queryChanged,TResult Function( _Submitted value)?  submitted,TResult Function( _RecentUsed value)?  recentUsed,TResult Function( _AllMonthsToggled value)?  allMonthsToggled,TResult Function( _MonthPicked value)?  monthPicked,TResult Function( _MonthPickerYearShown value)?  monthPickerYearShown,TResult Function( _WalletFilterPicked value)?  walletFilterPicked,TResult Function( _CategoryFilterPicked value)?  categoryFilterPicked,TResult Function( _TypeFilterPicked value)?  typeFilterPicked,TResult Function( _FiltersCleared value)?  filtersCleared,TResult Function( _LoadMoreRequested value)?  loadMoreRequested,TResult Function( _Retried value)?  retried,TResult Function( _CachedResultsChanged value)?  cachedResultsChanged,TResult Function( _LookupsChanged value)?  lookupsChanged,TResult Function( _ExpenseTotalsChanged value)?  expenseTotalsChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _QueryChanged() when queryChanged != null:
return queryChanged(_that);case _Submitted() when submitted != null:
return submitted(_that);case _RecentUsed() when recentUsed != null:
return recentUsed(_that);case _AllMonthsToggled() when allMonthsToggled != null:
return allMonthsToggled(_that);case _MonthPicked() when monthPicked != null:
return monthPicked(_that);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that);case _FiltersCleared() when filtersCleared != null:
return filtersCleared(_that);case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _Retried() when retried != null:
return retried(_that);case _CachedResultsChanged() when cachedResultsChanged != null:
return cachedResultsChanged(_that);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _QueryChanged value)  queryChanged,required TResult Function( _Submitted value)  submitted,required TResult Function( _RecentUsed value)  recentUsed,required TResult Function( _AllMonthsToggled value)  allMonthsToggled,required TResult Function( _MonthPicked value)  monthPicked,required TResult Function( _MonthPickerYearShown value)  monthPickerYearShown,required TResult Function( _WalletFilterPicked value)  walletFilterPicked,required TResult Function( _CategoryFilterPicked value)  categoryFilterPicked,required TResult Function( _TypeFilterPicked value)  typeFilterPicked,required TResult Function( _FiltersCleared value)  filtersCleared,required TResult Function( _LoadMoreRequested value)  loadMoreRequested,required TResult Function( _Retried value)  retried,required TResult Function( _CachedResultsChanged value)  cachedResultsChanged,required TResult Function( _LookupsChanged value)  lookupsChanged,required TResult Function( _ExpenseTotalsChanged value)  expenseTotalsChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _QueryChanged():
return queryChanged(_that);case _Submitted():
return submitted(_that);case _RecentUsed():
return recentUsed(_that);case _AllMonthsToggled():
return allMonthsToggled(_that);case _MonthPicked():
return monthPicked(_that);case _MonthPickerYearShown():
return monthPickerYearShown(_that);case _WalletFilterPicked():
return walletFilterPicked(_that);case _CategoryFilterPicked():
return categoryFilterPicked(_that);case _TypeFilterPicked():
return typeFilterPicked(_that);case _FiltersCleared():
return filtersCleared(_that);case _LoadMoreRequested():
return loadMoreRequested(_that);case _Retried():
return retried(_that);case _CachedResultsChanged():
return cachedResultsChanged(_that);case _LookupsChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _QueryChanged value)?  queryChanged,TResult? Function( _Submitted value)?  submitted,TResult? Function( _RecentUsed value)?  recentUsed,TResult? Function( _AllMonthsToggled value)?  allMonthsToggled,TResult? Function( _MonthPicked value)?  monthPicked,TResult? Function( _MonthPickerYearShown value)?  monthPickerYearShown,TResult? Function( _WalletFilterPicked value)?  walletFilterPicked,TResult? Function( _CategoryFilterPicked value)?  categoryFilterPicked,TResult? Function( _TypeFilterPicked value)?  typeFilterPicked,TResult? Function( _FiltersCleared value)?  filtersCleared,TResult? Function( _LoadMoreRequested value)?  loadMoreRequested,TResult? Function( _Retried value)?  retried,TResult? Function( _CachedResultsChanged value)?  cachedResultsChanged,TResult? Function( _LookupsChanged value)?  lookupsChanged,TResult? Function( _ExpenseTotalsChanged value)?  expenseTotalsChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _QueryChanged() when queryChanged != null:
return queryChanged(_that);case _Submitted() when submitted != null:
return submitted(_that);case _RecentUsed() when recentUsed != null:
return recentUsed(_that);case _AllMonthsToggled() when allMonthsToggled != null:
return allMonthsToggled(_that);case _MonthPicked() when monthPicked != null:
return monthPicked(_that);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that);case _FiltersCleared() when filtersCleared != null:
return filtersCleared(_that);case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _Retried() when retried != null:
return retried(_that);case _CachedResultsChanged() when cachedResultsChanged != null:
return cachedResultsChanged(_that);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String query)?  queryChanged,TResult Function()?  submitted,TResult Function( String query)?  recentUsed,TResult Function( bool allMonths)?  allMonthsToggled,TResult Function( DateTime month)?  monthPicked,TResult Function( int year)?  monthPickerYearShown,TResult Function( String? walletId)?  walletFilterPicked,TResult Function( String? categoryId)?  categoryFilterPicked,TResult Function( TransactionType? type)?  typeFilterPicked,TResult Function()?  filtersCleared,TResult Function()?  loadMoreRequested,TResult Function()?  retried,TResult Function( List<Transaction> results)?  cachedResultsChanged,TResult Function( TransactionLookups lookups)?  lookupsChanged,TResult Function( Map<DateTime, int> totals)?  expenseTotalsChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _Submitted() when submitted != null:
return submitted();case _RecentUsed() when recentUsed != null:
return recentUsed(_that.query);case _AllMonthsToggled() when allMonthsToggled != null:
return allMonthsToggled(_that.allMonths);case _MonthPicked() when monthPicked != null:
return monthPicked(_that.month);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that.year);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that.type);case _FiltersCleared() when filtersCleared != null:
return filtersCleared();case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _Retried() when retried != null:
return retried();case _CachedResultsChanged() when cachedResultsChanged != null:
return cachedResultsChanged(_that.results);case _LookupsChanged() when lookupsChanged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String query)  queryChanged,required TResult Function()  submitted,required TResult Function( String query)  recentUsed,required TResult Function( bool allMonths)  allMonthsToggled,required TResult Function( DateTime month)  monthPicked,required TResult Function( int year)  monthPickerYearShown,required TResult Function( String? walletId)  walletFilterPicked,required TResult Function( String? categoryId)  categoryFilterPicked,required TResult Function( TransactionType? type)  typeFilterPicked,required TResult Function()  filtersCleared,required TResult Function()  loadMoreRequested,required TResult Function()  retried,required TResult Function( List<Transaction> results)  cachedResultsChanged,required TResult Function( TransactionLookups lookups)  lookupsChanged,required TResult Function( Map<DateTime, int> totals)  expenseTotalsChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _QueryChanged():
return queryChanged(_that.query);case _Submitted():
return submitted();case _RecentUsed():
return recentUsed(_that.query);case _AllMonthsToggled():
return allMonthsToggled(_that.allMonths);case _MonthPicked():
return monthPicked(_that.month);case _MonthPickerYearShown():
return monthPickerYearShown(_that.year);case _WalletFilterPicked():
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked():
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked():
return typeFilterPicked(_that.type);case _FiltersCleared():
return filtersCleared();case _LoadMoreRequested():
return loadMoreRequested();case _Retried():
return retried();case _CachedResultsChanged():
return cachedResultsChanged(_that.results);case _LookupsChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String query)?  queryChanged,TResult? Function()?  submitted,TResult? Function( String query)?  recentUsed,TResult? Function( bool allMonths)?  allMonthsToggled,TResult? Function( DateTime month)?  monthPicked,TResult? Function( int year)?  monthPickerYearShown,TResult? Function( String? walletId)?  walletFilterPicked,TResult? Function( String? categoryId)?  categoryFilterPicked,TResult? Function( TransactionType? type)?  typeFilterPicked,TResult? Function()?  filtersCleared,TResult? Function()?  loadMoreRequested,TResult? Function()?  retried,TResult? Function( List<Transaction> results)?  cachedResultsChanged,TResult? Function( TransactionLookups lookups)?  lookupsChanged,TResult? Function( Map<DateTime, int> totals)?  expenseTotalsChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _Submitted() when submitted != null:
return submitted();case _RecentUsed() when recentUsed != null:
return recentUsed(_that.query);case _AllMonthsToggled() when allMonthsToggled != null:
return allMonthsToggled(_that.allMonths);case _MonthPicked() when monthPicked != null:
return monthPicked(_that.month);case _MonthPickerYearShown() when monthPickerYearShown != null:
return monthPickerYearShown(_that.year);case _WalletFilterPicked() when walletFilterPicked != null:
return walletFilterPicked(_that.walletId);case _CategoryFilterPicked() when categoryFilterPicked != null:
return categoryFilterPicked(_that.categoryId);case _TypeFilterPicked() when typeFilterPicked != null:
return typeFilterPicked(_that.type);case _FiltersCleared() when filtersCleared != null:
return filtersCleared();case _LoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _Retried() when retried != null:
return retried();case _CachedResultsChanged() when cachedResultsChanged != null:
return cachedResultsChanged(_that.results);case _LookupsChanged() when lookupsChanged != null:
return lookupsChanged(_that.lookups);case _ExpenseTotalsChanged() when expenseTotalsChanged != null:
return expenseTotalsChanged(_that.totals);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements SearchEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.started()';
}


}




/// @nodoc


class _QueryChanged implements SearchEvent {
  const _QueryChanged(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueryChangedCopyWith<_QueryChanged> get copyWith => __$QueryChangedCopyWithImpl<_QueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class _$QueryChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory _$QueryChangedCopyWith(_QueryChanged value, $Res Function(_QueryChanged) _then) = __$QueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$QueryChangedCopyWithImpl<$Res>
    implements _$QueryChangedCopyWith<$Res> {
  __$QueryChangedCopyWithImpl(this._self, this._then);

  final _QueryChanged _self;
  final $Res Function(_QueryChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_QueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Submitted implements SearchEvent {
  const _Submitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.submitted()';
}


}




/// @nodoc


class _RecentUsed implements SearchEvent {
  const _RecentUsed(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentUsedCopyWith<_RecentUsed> get copyWith => __$RecentUsedCopyWithImpl<_RecentUsed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentUsed&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchEvent.recentUsed(query: $query)';
}


}

/// @nodoc
abstract mixin class _$RecentUsedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory _$RecentUsedCopyWith(_RecentUsed value, $Res Function(_RecentUsed) _then) = __$RecentUsedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$RecentUsedCopyWithImpl<$Res>
    implements _$RecentUsedCopyWith<$Res> {
  __$RecentUsedCopyWithImpl(this._self, this._then);

  final _RecentUsed _self;
  final $Res Function(_RecentUsed) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_RecentUsed(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AllMonthsToggled implements SearchEvent {
  const _AllMonthsToggled({required this.allMonths});
  

 final  bool allMonths;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllMonthsToggledCopyWith<_AllMonthsToggled> get copyWith => __$AllMonthsToggledCopyWithImpl<_AllMonthsToggled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllMonthsToggled&&(identical(other.allMonths, allMonths) || other.allMonths == allMonths));
}


@override
int get hashCode {
    return Object.hash(runtimeType,allMonths);
}

@override
String toString() {
    return 'SearchEvent.allMonthsToggled(allMonths: $allMonths)';
}


}

/// @nodoc
abstract mixin class _$AllMonthsToggledCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory _$AllMonthsToggledCopyWith(_AllMonthsToggled value, $Res Function(_AllMonthsToggled) _then) = __$AllMonthsToggledCopyWithImpl;
@useResult
$Res call({
 bool allMonths
});




}
/// @nodoc
class __$AllMonthsToggledCopyWithImpl<$Res>
    implements _$AllMonthsToggledCopyWith<$Res> {
  __$AllMonthsToggledCopyWithImpl(this._self, this._then);

  final _AllMonthsToggled _self;
  final $Res Function(_AllMonthsToggled) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allMonths = null,}) {
  return _then(_AllMonthsToggled(
allMonths: null == allMonths ? _self.allMonths : allMonths // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _MonthPicked implements SearchEvent {
  const _MonthPicked(this.month);
  

 final  DateTime month;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.monthPicked(month: $month)';
}


}

/// @nodoc
abstract mixin class _$MonthPickedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? month = null,}) {
  return _then(_MonthPicked(
null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _MonthPickerYearShown implements SearchEvent {
  const _MonthPickerYearShown(this.year);
  

 final  int year;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.monthPickerYearShown(year: $year)';
}


}

/// @nodoc
abstract mixin class _$MonthPickerYearShownCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? year = null,}) {
  return _then(_MonthPickerYearShown(
null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _WalletFilterPicked implements SearchEvent {
  const _WalletFilterPicked(this.walletId);
  

 final  String? walletId;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.walletFilterPicked(walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class _$WalletFilterPickedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? walletId = freezed,}) {
  return _then(_WalletFilterPicked(
freezed == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CategoryFilterPicked implements SearchEvent {
  const _CategoryFilterPicked(this.categoryId);
  

 final  String? categoryId;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.categoryFilterPicked(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$CategoryFilterPickedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(_CategoryFilterPicked(
freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TypeFilterPicked implements SearchEvent {
  const _TypeFilterPicked(this.type);
  

 final  TransactionType? type;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.typeFilterPicked(type: $type)';
}


}

/// @nodoc
abstract mixin class _$TypeFilterPickedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = freezed,}) {
  return _then(_TypeFilterPicked(
freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,
  ));
}


}

/// @nodoc


class _FiltersCleared implements SearchEvent {
  const _FiltersCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiltersCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.filtersCleared()';
}


}




/// @nodoc


class _LoadMoreRequested implements SearchEvent {
  const _LoadMoreRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadMoreRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.loadMoreRequested()';
}


}




/// @nodoc


class _Retried implements SearchEvent {
  const _Retried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.retried()';
}


}




/// @nodoc


class _CachedResultsChanged implements SearchEvent {
  const _CachedResultsChanged( List<Transaction> results): _results = results;
  

 final  List<Transaction> _results;
 List<Transaction> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CachedResultsChangedCopyWith<_CachedResultsChanged> get copyWith => __$CachedResultsChangedCopyWithImpl<_CachedResultsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CachedResultsChanged&&const DeepCollectionEquality().equals(other.results, _results));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'SearchEvent.cachedResultsChanged(results: $results)';
}


}

/// @nodoc
abstract mixin class _$CachedResultsChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory _$CachedResultsChangedCopyWith(_CachedResultsChanged value, $Res Function(_CachedResultsChanged) _then) = __$CachedResultsChangedCopyWithImpl;
@useResult
$Res call({
 List<Transaction> results
});




}
/// @nodoc
class __$CachedResultsChangedCopyWithImpl<$Res>
    implements _$CachedResultsChangedCopyWith<$Res> {
  __$CachedResultsChangedCopyWithImpl(this._self, this._then);

  final _CachedResultsChanged _self;
  final $Res Function(_CachedResultsChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_CachedResultsChanged(
null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}


}

/// @nodoc


class _LookupsChanged implements SearchEvent {
  const _LookupsChanged(this.lookups);
  

 final  TransactionLookups lookups;

/// Create a copy of SearchEvent
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
    return 'SearchEvent.lookupsChanged(lookups: $lookups)';
}


}

/// @nodoc
abstract mixin class _$LookupsChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lookups = null,}) {
  return _then(_LookupsChanged(
null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,
  ));
}

/// Create a copy of SearchEvent
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


class _ExpenseTotalsChanged implements SearchEvent {
  const _ExpenseTotalsChanged( Map<DateTime, int> totals): _totals = totals;
  

 final  Map<DateTime, int> _totals;
 Map<DateTime, int> get totals {
  if (_totals is EqualUnmodifiableMapView) return _totals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_totals);
}


/// Create a copy of SearchEvent
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
    return 'SearchEvent.expenseTotalsChanged(totals: $totals)';
}


}

/// @nodoc
abstract mixin class _$ExpenseTotalsChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
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

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totals = null,}) {
  return _then(_ExpenseTotalsChanged(
null == totals ? _self._totals : totals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,
  ));
}


}

/// @nodoc
mixin _$SearchState {

 DateTime get month; DateTime get today; UiStatus get status; String get query; bool get allMonths; TransactionFilter get filter; List<Transaction> get results; String? get nextCursor; int get limit; bool get isLoadingMore; TransactionLookups get lookups; Map<DateTime, int> get monthPickerTotals; List<String> get recentSearches; TransactionFailure? get failure;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.allMonths, _this.allMonths) || other.allMonths == _this.allMonths)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.lookups, _this.lookups) || other.lookups == _this.lookups)&&const DeepCollectionEquality().equals(other.monthPickerTotals, _this.monthPickerTotals)&&const DeepCollectionEquality().equals(other.recentSearches, _this.recentSearches)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as SearchState;
  return Object.hash(runtimeType,_this.month,_this.today,_this.status,_this.query,_this.allMonths,_this.filter,const DeepCollectionEquality().hash(_this.results),_this.nextCursor,_this.limit,_this.isLoadingMore,_this.lookups,const DeepCollectionEquality().hash(_this.monthPickerTotals),const DeepCollectionEquality().hash(_this.recentSearches),_this.failure);
}

@override
String toString() {
  final _this = this as SearchState;
  return 'SearchState(month: ${_this.month}, today: ${_this.today}, status: ${_this.status}, query: ${_this.query}, allMonths: ${_this.allMonths}, filter: ${_this.filter}, results: ${_this.results}, nextCursor: ${_this.nextCursor}, limit: ${_this.limit}, isLoadingMore: ${_this.isLoadingMore}, lookups: ${_this.lookups}, monthPickerTotals: ${_this.monthPickerTotals}, recentSearches: ${_this.recentSearches}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, DateTime today, UiStatus status, String query, bool allMonths, TransactionFilter filter, List<Transaction> results, String? nextCursor, int limit, bool isLoadingMore, TransactionLookups lookups, Map<DateTime, int> monthPickerTotals, List<String> recentSearches, TransactionFailure? failure
});


$TransactionFilterCopyWith<$Res> get filter;$TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? today = null,Object? status = null,Object? query = null,Object? allMonths = null,Object? filter = null,Object? results = null,Object? nextCursor = freezed,Object? limit = null,Object? isLoadingMore = null,Object? lookups = null,Object? monthPickerTotals = null,Object? recentSearches = null,Object? failure = freezed,}) {
  return _then(SearchState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,allMonths: null == allMonths ? _self.allMonths : allMonths // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionFilter,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Transaction>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,monthPickerTotals: null == monthPickerTotals ? _self.monthPickerTotals : monthPickerTotals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,recentSearches: null == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFilterCopyWith<$Res> get filter {
  
  return $TransactionFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  DateTime today,  UiStatus status,  String query,  bool allMonths,  TransactionFilter filter,  List<Transaction> results,  String? nextCursor,  int limit,  bool isLoadingMore,  TransactionLookups lookups,  Map<DateTime, int> monthPickerTotals,  List<String> recentSearches,  TransactionFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.month,_that.today,_that.status,_that.query,_that.allMonths,_that.filter,_that.results,_that.nextCursor,_that.limit,_that.isLoadingMore,_that.lookups,_that.monthPickerTotals,_that.recentSearches,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  DateTime today,  UiStatus status,  String query,  bool allMonths,  TransactionFilter filter,  List<Transaction> results,  String? nextCursor,  int limit,  bool isLoadingMore,  TransactionLookups lookups,  Map<DateTime, int> monthPickerTotals,  List<String> recentSearches,  TransactionFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.month,_that.today,_that.status,_that.query,_that.allMonths,_that.filter,_that.results,_that.nextCursor,_that.limit,_that.isLoadingMore,_that.lookups,_that.monthPickerTotals,_that.recentSearches,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  DateTime today,  UiStatus status,  String query,  bool allMonths,  TransactionFilter filter,  List<Transaction> results,  String? nextCursor,  int limit,  bool isLoadingMore,  TransactionLookups lookups,  Map<DateTime, int> monthPickerTotals,  List<String> recentSearches,  TransactionFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.month,_that.today,_that.status,_that.query,_that.allMonths,_that.filter,_that.results,_that.nextCursor,_that.limit,_that.isLoadingMore,_that.lookups,_that.monthPickerTotals,_that.recentSearches,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({required this.month, required this.today, this.status = UiStatus.initial, this.query = '', this.allMonths = false, this.filter = const TransactionFilter(),  List<Transaction> results = const [], this.nextCursor, this.limit = TransactionRepository.pageSize, this.isLoadingMore = false, this.lookups = const TransactionLookups(),  Map<DateTime, int> monthPickerTotals = const {},  List<String> recentSearches = const [], this.failure}): _results = results,_monthPickerTotals = monthPickerTotals,_recentSearches = recentSearches;
  

@override final  DateTime month;
@override final  DateTime today;
@override@JsonKey() final  UiStatus status;
@override@JsonKey() final  String query;
@override@JsonKey() final  bool allMonths;
@override@JsonKey() final  TransactionFilter filter;
 final  List<Transaction> _results;
@override@JsonKey() List<Transaction> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  String? nextCursor;
@override@JsonKey() final  int limit;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  TransactionLookups lookups;
 final  Map<DateTime, int> _monthPickerTotals;
@override@JsonKey() Map<DateTime, int> get monthPickerTotals {
  if (_monthPickerTotals is EqualUnmodifiableMapView) return _monthPickerTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monthPickerTotals);
}

 final  List<String> _recentSearches;
@override@JsonKey() List<String> get recentSearches {
  if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSearches);
}

@override final  TransactionFailure? failure;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.month, month) || other.month == month)&&(identical(other.today, today) || other.today == today)&&(identical(other.status, status) || other.status == status)&&(identical(other.query, query) || other.query == query)&&(identical(other.allMonths, allMonths) || other.allMonths == allMonths)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.lookups, lookups) || other.lookups == lookups)&&const DeepCollectionEquality().equals(other.monthPickerTotals, _monthPickerTotals)&&const DeepCollectionEquality().equals(other.recentSearches, _recentSearches)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,today,status,query,allMonths,filter,const DeepCollectionEquality().hash(_results),nextCursor,limit,isLoadingMore,lookups,const DeepCollectionEquality().hash(_monthPickerTotals),const DeepCollectionEquality().hash(_recentSearches),failure);
}

@override
String toString() {
    return 'SearchState(month: $month, today: $today, status: $status, query: $query, allMonths: $allMonths, filter: $filter, results: $results, nextCursor: $nextCursor, limit: $limit, isLoadingMore: $isLoadingMore, lookups: $lookups, monthPickerTotals: $monthPickerTotals, recentSearches: $recentSearches, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, DateTime today, UiStatus status, String query, bool allMonths, TransactionFilter filter, List<Transaction> results, String? nextCursor, int limit, bool isLoadingMore, TransactionLookups lookups, Map<DateTime, int> monthPickerTotals, List<String> recentSearches, TransactionFailure? failure
});


@override $TransactionFilterCopyWith<$Res> get filter;@override $TransactionLookupsCopyWith<$Res> get lookups;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? today = null,Object? status = null,Object? query = null,Object? allMonths = null,Object? filter = null,Object? results = null,Object? nextCursor = freezed,Object? limit = null,Object? isLoadingMore = null,Object? lookups = null,Object? monthPickerTotals = null,Object? recentSearches = null,Object? failure = freezed,}) {
  return _then(_SearchState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UiStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,allMonths: null == allMonths ? _self.allMonths : allMonths // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionFilter,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Transaction>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,lookups: null == lookups ? _self.lookups : lookups // ignore: cast_nullable_to_non_nullable
as TransactionLookups,monthPickerTotals: null == monthPickerTotals ? _self._monthPickerTotals : monthPickerTotals // ignore: cast_nullable_to_non_nullable
as Map<DateTime, int>,recentSearches: null == recentSearches ? _self._recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TransactionFailure?,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionFilterCopyWith<$Res> get filter {
  
  return $TransactionFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionLookupsCopyWith<$Res> get lookups {
  
  return $TransactionLookupsCopyWith<$Res>(_self.lookups, (value) {
    return _then(_self.copyWith(lookups: value));
  });
}
}

// dart format on
